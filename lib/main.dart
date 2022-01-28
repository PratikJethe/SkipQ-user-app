// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
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
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerLazySingleton(() => FirebaseAuthService());
  getIt.registerLazySingleton(() => FcmService());
  getIt.registerSingleton(AppConfig());
  await getIt.get<AppConfig>().loadAppConfig();
  await getIt.get<ApiService>().addCookieInceptor();

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [NotificationChannelGroup(channelGroupkey: 'basic_channel_group', channelGroupName: 'Basic group')],
      debug: true);

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
          title: 'BookToken',
          theme: ThemeData(
            fontFamily: 'Lato',
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
        ));
  }
}
