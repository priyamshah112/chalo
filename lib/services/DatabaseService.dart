import 'package:chaloapp/services/Hashing.dart';
import '../data/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  static final database = Firestore.instance;
  Future createUser(User user) async {
    await database.collection('users').document(user.email).setData({
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
    await database.collection('user_plans').document(user.email).setData({
      'cancelled_plans': [],
      'completed_plans': [],
      'current_plans': [],
      'requested_plans': [],
      'your_adminplans': []
    });
    await database.collection('user_reputation').document(user.email).setData({
      'behaviour': 0,
      'activity_completed': 0,
      'activity_last_month': 0,
      'followers': 0,
      'following': 0,
      'payment': 0,
      'punctuality': 0
    });
    await database.collection('additional_info').document(user.email).setData({
      'folloing_id': [],
      'followers_id': [],
      'facebook_acc': "",
      'instagram_acc': "",
      'profile_pic': "",
      'interested_activity': []
    });
  }

  Future createPlan(Map details) async {
    try {
      DocumentReference plandoc =
          await database.collection('plan').add(details);
      DocumentReference groupchatdoc =
          database.collection('group_chat').document(plandoc.documentID);
      await groupchatdoc.setData({'messages_id': [], 'plan_id': plandoc});
      DocumentReference locationdoc =
          database.collection('location').document(plandoc.documentID);
      await locationdoc.setData({
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
      await database.runTransaction((transaction) async {
        await transaction.update(plandoc, {
          'group_chat': groupchatdoc,
          'location_id': locationdoc,
          'plan_id': plandoc.documentID
        });
      });
      await database
          .collection('user_plans')
          .document(details['admin_id'])
          .updateData({
        'current_plans': FieldValue.arrayUnion([plandoc])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<DocumentSnapshot> getUserDoc(String email) async {
    DocumentSnapshot userDoc;
    await database
        .collection('users')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        if (email == doc.data['email']) userDoc = doc;
      });
    });
    return userDoc;
  }

  Future userActivities(String email, List activities) async {
    activities = List<String>.generate(
        activities.length, (index) => activities[index][1]);
    database.runTransaction((transaction) async {
      final docRef = database.collection('additional_info').document(email);
      await transaction.update(docRef, {'interested_activities': activities});
    });
  }

  Future<bool> verifyPhone(phone) async {
    bool contains = false;
    phone = '+91' + phone;
    await database
        .collection('users')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        if (phone == doc.data['mobile_no']) {
          contains = true;
        }
      });
    });
    return !contains;
  }

  void verifyUser(String email, String phone) {
    database.runTransaction((transaction) async {
      final DocumentReference doc =
          database.collection('users').document(email);
      await transaction.update(doc, {'mobile_no': phone, 'verified': true});
    });
  }
}
