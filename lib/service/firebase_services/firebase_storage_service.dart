import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static Future<String> uploadImage(File file, String id) async {
    Reference reference = _firebaseStorage.ref().child("user/profilepic/$id");
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;

    return await taskSnapshot.ref.getDownloadURL();
  }
}
