import 'package:admob_flutter/admob_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:skipq/config/app_config.dart';
import 'package:skipq/main.dart';
import 'package:skipq/service/api_service.dart';
import 'package:skipq/service/firebase_services/auth_service.dart';
import 'package:skipq/service/firebase_services/fcm_service.dart';
import 'package:skipq/service/firebase_services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';

//All initialization goes here

class InitializeApp {
  Future<bool> initialze(context) async {
    try {
      print('here');
      FirebaseApp _firebaseApp = await FirebaseService().inittializeFirebase();
      Admob.initialize();
      // await Firebase.initializeApp();
      getIt.registerLazySingleton(() => ApiService());
      getIt.registerLazySingleton(() => FirebaseAuthService());
      getIt.registerLazySingleton(() => FcmService());
      getIt.registerLazySingleton(() => AppConfig());
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
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
