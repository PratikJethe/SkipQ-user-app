import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class AppConfig {
  FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;

  String get endPoint => firebaseRemoteConfig.getString("ENDPOINT");
  String get baseUrl => firebaseRemoteConfig.getString("BASE_URL");
  String get googleMapApiKeys => firebaseRemoteConfig.getString("GOOGLE_MAP_API_KEYS");
  String get enviroment => firebaseRemoteConfig.getString("ENVIROMENT");
  String get interstitialADId => firebaseRemoteConfig.getString("INTERSTITIAL_ANDROID_AD_MOB_ID");
  String get helpEmail => firebaseRemoteConfig.getString("HELP_EMAIL");
  String get androidAppId => firebaseRemoteConfig.getString("USER_ANDROID_APP_ID");
  bool get isProd => firebaseRemoteConfig.getString("ENVIROMENT") == "PROD";
  Future<bool> loadAppConfig() async {
    try {
      await firebaseRemoteConfig
          .setConfigSettings(RemoteConfigSettings(fetchTimeout: Duration(seconds: 60), minimumFetchInterval: Duration(seconds: 0)));
      await firebaseRemoteConfig.ensureInitialized();
      await firebaseRemoteConfig.fetchAndActivate();
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> isUpdateRequired() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await firebaseRemoteConfig.ensureInitialized();
    await firebaseRemoteConfig.fetchAndActivate();
    print(packageInfo.version);
    print(firebaseRemoteConfig.getString('ANDROID_USER_APP_MIN_STABLE_VERSION'));
    Version appVersion = Version.parse(packageInfo.version);
    Version minStableVersion = Version.parse(firebaseRemoteConfig.getString('ANDROID_USER_APP_MIN_STABLE_VERSION'));
    print(minStableVersion);
    print(appVersion);
    print('appVersion < minStableVersion');
    print(appVersion < minStableVersion);
    if (appVersion < minStableVersion) {
      return true;
    }

    return false;
  }
}
