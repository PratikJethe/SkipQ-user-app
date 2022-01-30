import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConfig {
  late Map<String, dynamic> _jsonContent;

  String get endPoint => _jsonContent["ENDPOINT"];
  String get baseUrl => _jsonContent["BASE_URL"];
  String get googleMapApiKeys => _jsonContent["GOOGLE_MAP_API_KEYS"];
  String get enviroment => _jsonContent["ENVIROMENT"];
  String get interstitialADId => _jsonContent["INTERSTITIAL_ANDROID_AD_MOB_ID"];
  bool get isProd => _jsonContent["ENVIROMENT"] == "PROD";
  Future<bool> loadAppConfig() async {
    try {
      final contents = await rootBundle.loadString(
        'config/config.json',
      );
      print(contents);
      _jsonContent = jsonDecode(contents);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
