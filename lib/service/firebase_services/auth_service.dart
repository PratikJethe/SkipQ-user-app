import 'package:firebase_auth/firebase_auth.dart';

class Firebase_Auth_Service {
  FirebaseAuth firebaseInstance = FirebaseAuth.instance;

  sendOtp(String phoneNumber) {
    firebaseInstance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          print(phoneAuthCredential);
        },
        verificationFailed: (firebaseAuthException) {
          print(firebaseAuthException);
        },
        codeSent: (value1, value2) {
          print(value1);
          print(value2);
        },
        codeAutoRetrievalTimeout: (value) {
          print(value);
        });
  }
}
