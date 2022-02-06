// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skipq/config/app_config.dart';
import 'package:skipq/providers/clinic/clinic_provider.dart';
import 'package:skipq/providers/user_provider.dart';
import 'package:skipq/screens/splash_screen/splash_screen.dart';
import 'package:skipq/service/api_service.dart';
import 'package:skipq/service/firebase_services/auth_service.dart';
import 'package:skipq/service/firebase_services/fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ClinicProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SkipQ',
          theme: ThemeData(
            fontFamily: 'Lato',
            // primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
        ));
  }
}
