import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:skipq/providers/user_provider.dart';
import 'package:skipq/screens/authentication/registration_screen.dart';
import 'package:skipq/service/initialize_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool initializeError = false;

  @override
  void initState() {
    super.initState();
    //initialize all requirements
    InitializeApp().initialze(context).then((value) {
      print(value);
      if (!value) {
        initializeError = true;
        if (mounted) {
          setState(() {});
        }
        return;
      }
      Provider.of<UserProvider>(context, listen: false).getUser(context);
    }).catchError((e) {
      initializeError = true;
      if (mounted) {
        setState(() {});
      }
    });
    //if fetch user and navigate a  ccording to it
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return !initializeError
              ?
              // RegistrationScreen(uid: 'djdjdj', mobileNumber: 9090909090)

              Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Book Token',
                          style: TextStyle(color: Colors.blueAccent, fontSize: 60, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                )
              : Text('something went wrong'); // TODO create proper error code
        },
      ),
    );
  }
}
