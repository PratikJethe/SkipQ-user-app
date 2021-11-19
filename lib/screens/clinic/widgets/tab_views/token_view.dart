import 'package:booktokenapp/constants/globals.dart';
import 'package:booktokenapp/models/api_response_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_model.dart';
import 'package:booktokenapp/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:booktokenapp/providers/clinic/clinic_provider.dart';
import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/resources/resources.dart';
import 'package:booktokenapp/screens/clinic/widgets/token_widget.dart';
import 'package:booktokenapp/screens/my_tokens/clinic_user_tokens.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ClinicTokenView extends StatefulWidget {
  final Clinic clinic;
  const ClinicTokenView({Key? key, required this.clinic}) : super(key: key);

  @override
  _ClinicTokenViewState createState() => _ClinicTokenViewState();
}

class _ClinicTokenViewState extends State<ClinicTokenView> {
  late Clinic clinic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinic = widget.clinic;
    
    print('inititialted');
    if (clinic.hasClinicStarted) {
      clinic.getPendingTokens();
      WidgetsBinding.instance?.addPostFrameCallback((_) => Provider.of<ClinicProvider>(context, listen: false).getUserToken());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          // horizontal: MediaQuery.of(context).size.width * 0.025,
          ),
      child: ChangeNotifierProvider.value(
        value: clinic,
        child: Consumer3<Clinic, ClinicProvider, UserProvider>(
          builder: (context, clinic, clinicProvider, userProvider, _) {
            String buttonText = '';
            TokenActionButtonState buttonState = TokenActionButtonState.LOADING;

            if (clinicProvider.isUserTokenLoading) {
              print('Loading');
              buttonText = 'Loading..';
              buttonState = TokenActionButtonState.LOADING;
            } else {
              if (clinicProvider.hasErrorUserTokenLoading) {
                buttonText = 'Retry';
                buttonState = TokenActionButtonState.ERROR;

                print('Retry');
              } else {
                if (clinicProvider.userTokenList.isEmpty) {
                  buttonText = "Request";
                  buttonState = TokenActionButtonState.REQUEST;

                  print('Request');
                } else {
                  if (clinicProvider.userTokenList[0].tokenStatus == TokenStatus.REQUESTED) {
                    if (clinicProvider.userTokenList[0].clinic.id == clinic.id) {
                      buttonText = "Cancel My Request";
                      buttonState = TokenActionButtonState.CANCEL_REQUEST;

                      print('Cancel Request');
                    } else {
                      buttonText = "You already have a token requested";
                      buttonState = TokenActionButtonState.NAVIGATE;

                      print('you already have a token requested');
                    }
                  }
                  if (clinicProvider.userTokenList[0].tokenStatus == TokenStatus.PENDING_TOKEN) {
                    if (clinicProvider.userTokenList[0].clinic.id == clinic.id) {
                      buttonText = "Cancel My token";
                      buttonState = TokenActionButtonState.CANCEL_TOKEN;

                      print('Cancel token');
                    } else {
                      buttonText = "You already have a token pending";
                      buttonState = TokenActionButtonState.NAVIGATE;

                      print('you already have a token requested');
                    }
                  }
                }
              }
            }

            return Container(
              child: !clinic.hasClinicStarted
                  ? Center(child: Text('Closed'))
                  : clinic.isLoadingTokens
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  child: Wrap(children: [
                                    for (int i = 0; i < clinic.clinicPendingTokenList.length; i++)
                                      TokenWidget(clinicToken: clinic.clinicPendingTokenList[i], index: i)
                                  ]),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primary)),
                                  onPressed: () async {
                                    ServiceResponse serviceResponse = await clinicProvider.getUserToken();

                                    if (serviceResponse.apiResponse.error) {
                                      Fluttertoast.showToast(
                                          msg: 'something went wrong...try again!',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 2,
                                          fontSize: 16.0);

                                      return;
                                    }
                                    List<ClinicToken> data = serviceResponse.data.toList();

                                    if (buttonState == TokenActionButtonState.REQUEST) {
                                      print('here1');

                                      await requestToken(clinicProvider: clinicProvider, clinic: clinic);
                                      return;
                                    }
                                    if (buttonState == TokenActionButtonState.CANCEL_REQUEST) {
                                      print('here2');

                                      // if (serviceResponse.data.isNotEmpty && serviceResponse.data.first.tokenStatus == TokenStatus.REQUESTED) {
                                      if (data.isNotEmpty && data.first.tokenStatus == TokenStatus.REQUESTED) {
                                        await cancelRequest(clinicProvider: clinicProvider, clinic: clinic, token: data.first);
                                      }

                                      return;
                                    }
                                    if (buttonState == TokenActionButtonState.CANCEL_TOKEN) {
                                      print('here3');

                                      if (data.isNotEmpty && data.first.tokenStatus == TokenStatus.PENDING_TOKEN) {
                                        await cancelToken(clinicProvider: clinicProvider, clinic: clinic, token: data.first);
                                        await clinic.getPendingTokens();
                                      }
                                      return;
                                    }
                                    if (buttonState == TokenActionButtonState.ERROR) {
                                      // print('here4');

                                      // await requestToken(clinicProvider: clinicProvider, clinic: clinic);
                                      // return;
                                    }
                                    if (buttonState == TokenActionButtonState.NAVIGATE) {
                                      print('here5');
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ClinicUserToken(showAppbar: false)));

                                      return;
                                    }
                                  },
                                  child: Text(
                                    '$buttonText',
                                    style: R.styles.fz16Fw700.merge(TextStyle(color: Colors.white)),
                                  ),
                                ))
                          ],
                        ),
            );
          },
        ),
      ),
    );
  }
}

requestToken({
  required ClinicProvider clinicProvider,
  required Clinic clinic,
}) async {
  ServiceResponse response = await clinic.requestToken();

  if (response.apiResponse.error) {
    Fluttertoast.showToast(
      msg: response.apiResponse.errMsg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      fontSize: 16.0,
    );
    return;
  }

  await clinicProvider.getUserToken();
  Fluttertoast.showToast(
    msg: 'Request sent succesfully',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    fontSize: 16.0,
  );
}

cancelRequest({required ClinicProvider clinicProvider, required Clinic clinic, required ClinicToken token}) async {
  ServiceResponse response = await clinic.cancelRequest(token.id);

  if (response.apiResponse.error) {
    Fluttertoast.showToast(
      msg: response.apiResponse.errMsg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      fontSize: 16.0,
    );
    return;
  }

  await clinicProvider.getUserToken();
  Fluttertoast.showToast(
    msg: 'Token request cancelled',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    fontSize: 16.0,
  );
}

cancelToken({required ClinicProvider clinicProvider, required Clinic clinic, required ClinicToken token}) async {
  ServiceResponse response = await clinic.cancelToken(token.id);

  if (response.apiResponse.error) {
    Fluttertoast.showToast(
      msg: response.apiResponse.errMsg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      fontSize: 16.0,
    );
    return;
  }

  await clinicProvider.getUserToken();
  Fluttertoast.showToast(
    msg: 'Token request cancelled',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    fontSize: 16.0,
  );
}
