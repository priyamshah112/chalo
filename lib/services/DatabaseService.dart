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
      'mobile_no': "",
      'uid': user.uid,
      'timestamp': Timestamp.now(),
      'verified': false
    });
  }

  Future createPlan(Map details) async {
    Firestore database = Firestore.instance;
    final CollectionReference plan = database.collection('plan');
    final CollectionReference groupchat = database.collection('group_chat');
    try {
      DocumentReference plandoc = await plan.add(details);
      DocumentReference groupchatdoc =
          await groupchat.add({'messages_id': [], 'plan_id': plandoc});
      DocumentReference locationdoc =
          await database.collection('location').add({
        'city': 'Mumbai',
        'country': 'India',
        'pincode': '400060',
        'point': GeoPoint(52.0, 41.0),
        'street': 'Mohammad ALi Road'
      });
      if (details['broadcast_type'] == 'public')
        await database
            .collection('map_activity')
            .document(plandoc.documentID)
            .setData({
          'activity_logo': 'url',
          'activity_type': 'abc',
          'date': Timestamp.now(),
          'location': GeoPoint(52.0, 41.0),
          'participant_type': details['participant_type']
        });
      print(plandoc.documentID);
      print(groupchatdoc.documentID);
      print(locationdoc.documentID);
      database.runTransaction((transaction) async {
        await transaction.update(
            plandoc, {'group_chat': groupchatdoc, 'location_id': locationdoc});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void verifyUser(String email, String phone) {
    Firestore.instance.runTransaction((transaction) async {
      final DocumentReference doc =
          Firestore.instance.collection('users').document(email);
      await transaction.update(doc, {'mobile_no': phone, 'verified': true});
    });
  }
}
