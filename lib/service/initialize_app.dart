import 'package:admob_flutter/admob_flutter.dart';
import 'package:booktokenapp/service/firebase_services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';

//All initialization goes here

class InitializeApp {
  Future<bool> initialze(context) async {
    try {
      print('here');
      FirebaseApp _firebaseApp = await FirebaseService().inittializeFirebase();
      Admob.initialize();
      

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
