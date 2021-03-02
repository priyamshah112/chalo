import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final storage = FirebaseStorage.instance.ref();
  static Future<String> updateProfilePic(String email, File image) async {
    final ref = storage.child('users').child(email).child('profile_pic.jpg');
    await ref.putFile(image).onComplete;
    final url = await ref.getDownloadURL();
    return url;
  }

  static Future<String> uploadPostPic(
      String current, String postname, File image) async {
    final ref = storage
        .child('users')
        .child(current)
        .child('posts')
        .child('$postname.jpg');
    await ref.putFile(image).onComplete;
    final url = await ref.getDownloadURL();
    return url;
  }
}
