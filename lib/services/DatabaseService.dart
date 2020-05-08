import 'package:chaloapp/services/Hashing.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  Future createUser(User user) async {
    final CollectionReference userCollection =
        Firestore.instance.collection('users');
    await userCollection.document(user.email).setData({
      'first_name': user.fname,
      'last_name': user.lname,
      'email': user.email,
      'password': Hashing.encrypt(user.password),
      'dob': user.birthDate,
      'gender': user.gender,
      'mobile_no': null,
      'uid': user.uid,
      'timestamp': Timestamp.now(),
      'verified': false
    });

  }

  Future verifyUser(FirebaseUser user, String phone) async {
    final CollectionReference userCollection =
        Firestore.instance.collection('users');
    await userCollection
        .document(user.email)
        .setData({'mobile_no': phone, 'verified': true});
  }
}
