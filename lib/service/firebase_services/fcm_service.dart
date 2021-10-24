import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  get token async => await _firebaseMessaging.getToken();

  Future<String?> refreshToken() async {
    await _firebaseMessaging.deleteToken();
    String? token = await _firebaseMessaging.getToken();
    return token;
  }
}
