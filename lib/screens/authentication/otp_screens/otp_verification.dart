import 'dart:async';

import 'package:skipq/main.dart';
import 'package:skipq/providers/user_provider.dart';
import 'package:skipq/resources/resources.dart';
import 'package:skipq/screens/modal-screen/modal_loading_screen.dart';
import 'package:skipq/screens/privarcy/privarcy_policy.dart';
import 'package:skipq/service/firebase_services/auth_service.dart';
import 'package:skipq/service/firebase_services/fcm_service.dart';
import 'package:skipq/utils/validators.dart';
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
            Fluttertoast.showToast(msg: "Sending OTP...", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);

    _firebaseAuthService.firebaseInstance.verifyPhoneNumber(
      phoneNumber: '+$dialCode$phoneNumber',
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        // _textEditingController.text = phoneAuthCredential.smsCode!;

        // signinWithFirebase(phoneAuthCredential);
      },
      verificationFailed: (firebaseAuthException) {
        print(firebaseAuthException.message);
        print(firebaseAuthException.code);
        print(firebaseAuthException.stackTrace);
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
    return ModalLoadingScreen(
      child: Scaffold(
        body: Consumer<UserProvider>(
          builder: (context, userProvider, _) => Form(
            key: _formKey,
            child: !codeSent
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.85, child: Text('Enter your mobile number', style: R.styles.fz20Fw500)),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // height: 50,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextFormField(
                                  style: R.styles.fz18Fw700,
                                  autofocus: true,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: R.color.black, width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: R.color.black, width: 1.0),
                                    ),
                                    prefixIconConstraints: BoxConstraints(minHeight: 30, maxWidth: 60, maxHeight: 30),
                                    prefixIcon: Container(
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          border: Border(right: BorderSide(color: R.color.black, width: 2)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          '+91',
                                          style: R.styles.fz18Fw700,
                                        ))),
                                    hintText: 'Enter Mobile Number',
                                    hintStyle: R.styles.fz16Fw500,
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.red),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.red),
                                    ),
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Text('By proceeding, you agree to our', style: R.styles.fz14FontColorGrey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivarcyPolicy()));
                          },
                          child: AbsorbPointer(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Text('Terms & Conditions', style: R.styles.fz16FontColorPrimary),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                sendOtp(phoneNo!, '91', forceResendToken);
                              }
                            },
                            child: Container(
                              color: _formKey.currentState != null && _formKey.currentState!.validate() ? R.color.primary : Colors.grey,
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 40,
                              child: Center(
                                child: Text(
                                  'Send OTP',
                                  style: R.styles.fz18Fw700.merge(R.styles.fontColorWhite),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(text: 'OTP sent to ', style: R.styles.fz16FontColorBlack.merge(R.styles.fw500)),
                            TextSpan(text: '+${91} ${phoneNo}', style: R.styles.fz16FontColorPrimaryL1.merge(R.styles.fw500)),
                          ])),
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
                                  cursorColor: R.color.primary,
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
                                    selectedColor: R.color.primary,
                                    activeFillColor: Colors.white,
                                    inactiveColor: Colors.grey,
                                    activeColor: R.color.primary,
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
                                      return 'Enter 6 digit OTP';
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  userProvider.setShowModalLoading = true;
                                  var cred = getPhoneCredential();
                                  bool isSuccess = await signinWithFirebase(cred);
                                  if (isSuccess) {
                                    String? token = await _fcmService.refreshToken();
                                    if (token == null) {
                                      userProvider.setShowModalLoading = false;
                                      Fluttertoast.showToast(
                                          msg: "Something went wrong!. try again",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 2,
                                          fontSize: 16.0);
                                      return;
                                    }

                                    await userProvider.phoneLogin({"phoneNo": int.parse(phoneNo!), "uid": user!.uid, "fcm": token}, context);
                                    userProvider.setShowModalLoading = false;
                                  }
                                  userProvider.setShowModalLoading = false;
                                }
                              },
                              child: Container(
                                color: _formKey.currentState != null && _formKey.currentState!.validate() ? R.color.primary : Colors.grey,
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    'Submit OTP',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Havent received otp yet?',
                                style: R.styles.fz14Fw500,
                              ),
                              TextButton(
                                child: Text(
                                  'Resend Otp',
                                  style: TextStyle(color: _resendOtpTime == 0 ? R.color.primary : Colors.grey).merge(R.styles.fz16Fw700),
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
      ),
    );
  }
}
