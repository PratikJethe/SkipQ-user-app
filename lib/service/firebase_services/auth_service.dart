import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth firebaseInstance = FirebaseAuth.instance;

  sendOtp(String phoneNumber,String dialCode) {
    firebaseInstance.verifyPhoneNumber(
        phoneNumber:'+$dialCode$phoneNumber',
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
