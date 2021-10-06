import 'package:booktokenapp/service/firebase_services/auth_service.dart';
import 'package:booktokenapp/utils/validators.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? number;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  onSaved() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image.network(
                          'https://image.shutterstock.com/shutterstock/photos/1532267915/display_1500/stock-vector-mobile-otp-secure-verification-method-1532267915.jpg')),
                  Text('OTP Verifivation'),
                  Text(
                    'we will send you one time password on this mobile number',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Enter Mobile Number',
                    textAlign: TextAlign.center,
                  ),
                  Form(
                    child: TextFormField(
                        keyboardType: TextInputType.phone,
                        key: _formKey,
                        onChanged: (value) {
                          setState(() {
                            number = value;
                          });
                        },
                        validator: (value) => validateMobile(value)),
                  ),
                  MaterialButton(
                      child: Text('press'),
                      onPressed: () {
                        // onSaved();
                        if(number != null){

                        Firebase_Auth_Service().sendOtp(number!);
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
