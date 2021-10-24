import 'package:booktokenapp/providers/user_provider.dart';
import 'package:booktokenapp/screens/authentication/otp_screens/otp_verification.dart';
import 'package:booktokenapp/screens/authentication/registration_screen.dart';
import 'package:booktokenapp/service/firebase_services/auth_service.dart';
import 'package:booktokenapp/service/firebase_services/firebase_service.dart';
import 'package:booktokenapp/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(width: double.infinity, height: MediaQuery.of(context).size.height * 0.7, color: Colors.blueAccent),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lets get you verified!'),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpVerification()));
                        },
                        child: Form(
                          child: Row(
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
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: 'Mobile Number',
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1, color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
