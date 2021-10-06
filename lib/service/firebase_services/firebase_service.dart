import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  inittializeFirebase() async {
    FirebaseApp _firebaseApp = await Firebase.initializeApp();
    return _firebaseApp;
  }
}
