import 'dart:async';

import 'package:booktokenapp/main.dart';
import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/service/firebase_services/auth_service.dart';
import 'package:booktokenapp/service/firebase_services/fcm_service.dart';
import 'package:booktokenapp/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key}) : super(key: key);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  FirebaseAuthService _firebaseAuthService = getIt.get<FirebaseAuthService>();
  String? phoneNo;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textEditingController = TextEditingController();
  FcmService _fcmService = getIt.get<FcmService>();
  String? otp;
  bool codeSent = false;
  String? verificationCode, uid;
  int? forceResendToken;
  bool errorWhileFirebaseSigning = false;
  User? user;
  bool isFirstOtpSent = false;
  Timer? _timer;

  int _resendOtpTime = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_resendOtpTime == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          print(_resendOtpTime);
          setState(() {
            _resendOtpTime--;
          });
        }
      },
    );
  }

  Future<bool> signinWithFirebase(PhoneAuthCredential phoneAuthCredential) async {
    try {
      UserCredential userCredential = await _firebaseAuthService.firebaseInstance.signInWithCredential(phoneAuthCredential);

      setState(() {
        user = userCredential.user;
      });

      return true;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Signing Failed!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);
    }
    return false;
  }

  PhoneAuthCredential getPhoneCredential() {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationCode!, smsCode: otp!);
    print('credential');
    print(credential);

    return credential;
  }

  sendOtp(String phoneNumber, String dialCode, int? forceResendToken) {
    _firebaseAuthService.firebaseInstance.verifyPhoneNumber(
      phoneNumber: '+$dialCode$phoneNumber',
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        // _textEditingController.text = phoneAuthCredential.smsCode!;

        // signinWithFirebase(phoneAuthCredential);
      },
      verificationFailed: (firebaseAuthException) {
        Fluttertoast.showToast(
            msg: "Verification Failed", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);
      },
      codeSent: (verification, resendToken) {
        verificationCode = verification;
        forceResendToken = forceResendToken;
        codeSent = true;
        isFirstOtpSent = true;
        print('otp sent called');
        _resendOtpTime = 30;
        startTimer();
        Fluttertoast.showToast(msg: "Otp Sent", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);
        setState(() {});
      },
      codeAutoRetrievalTimeout: (value) {
        print('auto retrival');
        print(value);
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) => Form(
          key: _formKey,
          child: !codeSent
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag),
                        SizedBox(
                          width: 5,
                        ),
                        Text('+91'),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                hintText: 'Mobile Number',
                                disabledBorder:
                                    OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  phoneNo = value.trim();
                                });
                              },
                              validator: validateMobile),
                        )
                      ],
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          sendOtp(phoneNo!, '91', forceResendToken);
                        }
                      },
                      child: Text('Sent otp'),
                    )
                  ],
                )
              : Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Otp has been sent to +${91} ${phoneNo}'),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: PinCodeTextField(
                                beforeTextPaste: (String? value) {
                                  return false;
                                },
                                controller: _textEditingController,
                                autoDisposeControllers: false,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                appContext: context,
                                length: 6,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                keyboardType: TextInputType.number,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeFillColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  activeColor: Colors.blue,
                                ),
                                animationDuration: Duration(
                                  milliseconds: 300,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    otp = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty || value.length != 6) {
                                    return 'Enter 6 digit otp';
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var cred = getPhoneCredential();
                                bool isSuccess = await signinWithFirebase(cred);
                                if (isSuccess) {
                                  String? token = await _fcmService.refreshToken();
                                  if (token == null) {
                                    Fluttertoast.showToast(
                                        msg: "Something went wrong!. try again",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 2,
                                        fontSize: 16.0);
                                  }

                                  await userProvider.phoneLogin({"phoneNo": int.parse(phoneNo!), "uid": user!.uid, "fcm": token}, context);
                                }
                              }
                            },
                            child: Text('Sumbit Otp'),
                          ),
                        ),
                        Row(
                          children: [
                            Text('Havent received otp yet?'),
                            TextButton(
                              child: Text(
                                'Resend Otp',
                                style: TextStyle(color: _resendOtpTime == 0 ? Colors.blue : Colors.grey),
                              ),
                              onPressed: () {
                                if (_resendOtpTime == 0) {
                                  sendOtp(phoneNo!, '91', forceResendToken);
                                }
                              },
                            ),
                            if (_resendOtpTime != 0 && isFirstOtpSent)
                              Text(
                                '$_resendOtpTime',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
