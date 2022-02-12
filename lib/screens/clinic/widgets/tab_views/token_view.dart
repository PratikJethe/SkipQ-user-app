import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:skipq/config/app_config.dart';
import 'package:skipq/constants/globals.dart';
import 'package:skipq/models/api_response_model.dart';
import 'package:skipq/models/service_model.dart/clinic/clinic_model.dart';
import 'package:skipq/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:skipq/providers/clinic/clinic_provider.dart';
import 'package:skipq/providers/user_provider.dart';
import 'package:skipq/resources/resources.dart';
import 'package:skipq/screens/clinic/widgets/token_widget.dart';
import 'package:skipq/screens/my_tokens/clinic_user_tokens.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';

class ClinicTokenView extends StatefulWidget {
  final Clinic clinic;
  const ClinicTokenView({Key? key, required this.clinic}) : super(key: key);

  @override
  _ClinicTokenViewState createState() => _ClinicTokenViewState();
}

class _ClinicTokenViewState extends State<ClinicTokenView> {
  late Clinic clinic;
  Timer? timer;
  AppConfig _appConfig = getIt.get<AppConfig>();

  late AdmobInterstitial _interstitial;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinic = widget.clinic;
    _interstitial = AdmobInterstitial(adUnitId: _appConfig.interstitialADId);
    _interstitial.load();
    print('inititialted');
    if (clinic.hasClinicStarted) {
      if (!clinic.hasTokenError) {
        clinic.getPendingTokens(showLoading: true);
        WidgetsBinding.instance?.addPostFrameCallback((_) => Provider.of<ClinicProvider>(context, listen: false).getUserToken());
      }
    }

    timer = Timer.periodic(Duration(seconds: 120), (timer) {
      if (clinic.hasClinicStarted) {
        print('calling');
        clinic.getPendingTokens(showLoading: false);
        Provider.of<ClinicProvider>(context, listen: false).getUserToken();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _interstitial.dispose();
    timer?.cancel();
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
                  ? Center(
                      child: Image.asset(
                      'assets/images/closed.png',
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                    ))
                  : clinic.isLoadingTokens
                      ? Center(
                          child: CircularProgressIndicator(
                            color: R.color.primaryL1,
                          ),
                        )
                      : clinic.hasTokenError
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Something Went Wrong!..Try again',
                                    style: R.styles.fz18Fw500,
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(R.color.primary),
                                        ),
                                        onPressed: () async {
                                          clinic.getPendingTokens(showLoading: true);
                                        },
                                        child: Text(
                                          'Retry',
                                          style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                                        ),
                                      ))
                                ],
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: clinic.clinicPendingTokenList.length != 0
                                      ? RefreshIndicator(
                                          // color: R.color.primaryL1,
                                          // strokeWidth: 2,
                                          onRefresh: () async {
                                            var response1 = await clinicProvider.getUserToken();
                                            await clinic.getPendingTokens(showLoading: true);

                                            if (response1.apiResponse.error) {
                                              Fluttertoast.showToast(
                                                  msg: "${response1.apiResponse.errMsg}",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 2,
                                                  fontSize: 16.0);
                                              return;
                                            }
                                          },
                                          child: SingleChildScrollView(
                                            physics: AlwaysScrollableScrollPhysics(),
                                            child: Container(
                                              width: double.infinity,
                                              child: Wrap(key: new Key(DateTime.now().toString()), children: [
                                                for (int i = 0; i < clinic.clinicPendingTokenList.length; i++)
                                                  TokenWidget(
                                                    clinicToken: clinic.clinicPendingTokenList[i], index: i)
                                              ]),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '0 patients in queue',
                                                  style: R.styles.fz18Fw500,
                                                ),
                                                SizedBox(height: 20),
                                                SizedBox(
                                                    height: 40,
                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                    child: TextButton(
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all(R.color.primary),
                                                      ),
                                                      onPressed: () async {
                                                        clinic.getPendingTokens(showLoading: true);
                                                      },
                                                      child: Text(
                                                        'Reload',
                                                        style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primary)),
                                      onPressed: () async {
                                        userProvider.setShowModalLoading = true;
                                        ServiceResponse serviceResponse = await clinicProvider.getUserToken();

                                        if (serviceResponse.apiResponse.error) {
                                          userProvider.setShowModalLoading = false;
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

                                          showAlertBoxTokenAction('Are you sure you want to request token?', "Proceed", () async {
                                            await requestToken(clinicProvider: clinicProvider, clinic: clinic);
                                            userProvider.setShowModalLoading = false;
                                            try {
                                              _interstitial.show();
                                            } catch (e) {}

                                            return;
                                          }, context);

                                          userProvider.setShowModalLoading = false;

                                          // await requestToken(clinicProvider: clinicProvider, clinic: clinic);
                                          // userProvider.setShowModalLoading = false;
                                          // return;
                                        }
                                        if (buttonState == TokenActionButtonState.CANCEL_REQUEST) {
                                          print('here2');

                                          // if (serviceResponse.data.isNotEmpty && serviceResponse.data.first.tokenStatus == TokenStatus.REQUESTED) {

                                          showAlertBoxTokenAction('Are you sure you want to cancel request?', "Proceed", () async {
                                            if (data.isNotEmpty && data.first.tokenStatus == TokenStatus.REQUESTED) {
                                              await cancelRequest(clinicProvider: clinicProvider, clinic: clinic, token: data.first);
                                            }
                                            userProvider.setShowModalLoading = false;
                                            return;
                                          }, context);

                                          userProvider.setShowModalLoading = false;
                                        }
                                        if (buttonState == TokenActionButtonState.CANCEL_TOKEN) {
                                          print('here3');

                                          showAlertBoxTokenAction('Are you sure you want to cancel token?', "Proceed", () async {
                                            if (data.isNotEmpty && data.first.tokenStatus == TokenStatus.PENDING_TOKEN) {
                                              await cancelToken(clinicProvider: clinicProvider, clinic: clinic, token: data.first);
                                              await clinic.getPendingTokens();
                                            }
                                            userProvider.setShowModalLoading = false;
                                            return;
                                          }, context);

                                          userProvider.setShowModalLoading = false;
                                        }
                                        if (buttonState == TokenActionButtonState.ERROR) {
                                          // print('here4');

                                          // await requestToken(clinicProvider: clinicProvider, clinic: clinic);
                                          // return;

                                          await clinicProvider.getUserToken();
                                          userProvider.setShowModalLoading = false;
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
    msg: 'Token cancelled',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    fontSize: 16.0,
  );
}

showAlertBoxTokenAction(String title, String buttontText, Function callback, BuildContext context) {
  print('alert dialog');
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            actions: [
              TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primary)),
                  onPressed: () {
                    callback();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    buttontText,
                    style: R.styles.fontColorWhite,
                  )),
              TextButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'))
            ],
          ));
}
