import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
    // FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  inittializeFirebase() async {
    FirebaseApp _firebaseApp = await Firebase.initializeApp();

    return _firebaseApp;
  }

  
}
