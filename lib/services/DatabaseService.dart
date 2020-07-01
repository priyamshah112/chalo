import 'CloudMessaging.dart';
import 'Hashing.dart';
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
      'mobile_no': null,
      'uid': user.uid,
      'timestamp': Timestamp.now(),
      'verified': false,
      'photo_url': null,
      'followers': 0,
      'following': 0
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
      'follwoing_id': [],
      'followers_id': [],
      'follow_requests': [],
      'follow_requested': [],
      'facebook_acc': "",
      'instagram_acc': "",
      'profile_pic': "",
      'interested_activity': []
    });
  }

  Future createPlan(Map details) async {
    try {
      Map user = await UserData.getUser();
      DocumentReference plandoc =
          await database.collection('plan').add(details);
      DocumentReference groupchatdoc =
          database.collection('group_chat').document(plandoc.documentID);
      await groupchatdoc.setData({
        'messenger_id': {user['email']: await CloudMessaging.getToken()},
        'plan_id': plandoc
      });
      DocumentReference locationdoc =
          database.collection('location').document(plandoc.documentID);
      await locationdoc.setData({
        'address': details['address'],
        'location': details['location'],
      });
      if (details['broadcast_type'] == 'public') {
        final activity = await database
            .collection('chalo_activity')
            .where('name', isEqualTo: details['activity_type'])
            .limit(1)
            .getDocuments();
        await database
            .collection('map_activity')
            .document(plandoc.documentID)
            .setData({
          'activity_logo': activity.documents[0].data['logo'],
          'activity_type': details['activity_type'],
          'date': details['activity_start'],
          'location': details['location'],
          'participant_type': details['participant_type']
        });
      }
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
      await database.runTransaction((transaction) async {
        await transaction.update(
            database.collection('user_plans').document(details['admin_id']), {
          'current_plans': FieldValue.arrayUnion([plandoc.documentID])
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<DocumentSnapshot> getUserDoc(String email) async {
    DocumentSnapshot userDoc;
    CollectionReference users = database.collection('users');
    await users
        .where('email', isEqualTo: email)
        .limit(1)
        .getDocuments()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.documents.length == 0) return null;
      userDoc = snapshot.documents[0];
      String userToken = await CloudMessaging.getToken();
      if (!userDoc.data.containsKey('token') ||
          userDoc.data['token'] != userToken)
        database.runTransaction((transaction) async {
          final docRef = users.document(email);
          transaction.update(docRef, {'token': userToken});
        });
    });
    return userDoc;
  }

  Future<Map<String, dynamic>> getUserInfo(String email) async {
    final doc =
        await database.collection('additional_info').document(email).get();
    return doc.data;
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

  void updateToken(bool update) async {
    Map user = await UserData.getUser();
    final email = user['email'];
    final userplan =
        await database.collection('user_plans').document(email).get();
    List plans = userplan.data['current_plans'];
    if (plans.length == 0) return;
    final batch = database.batch();
    String token = await CloudMessaging.getToken();
    print('updating: $update');
    for (var i = 0; i < plans.length; i++) {
      DocumentReference ref =
          database.collection('group_chat').document(plans[i]);
      DocumentSnapshot snap = await ref.get();
      Map tokens = snap.data['messenger_id'];
      if (update)
        tokens[email] = token;
      else
        tokens[email] = null;
      batch.updateData(ref, {'messenger_id': tokens});
    }
    batch.commit();
  }

  Future<bool> requestJoin(
      DocumentReference planRef, String email, bool join) async {
    try {
      await database.runTransaction((transaction) async {
        await transaction.update(planRef, {
          'pending_participant_id': join
              ? FieldValue.arrayUnion([email])
              : FieldValue.arrayRemove([email])
        });
        await transaction
            .update(database.collection('user_plans').document(email), {
          'requested_plans': join
              ? FieldValue.arrayUnion([planRef.documentID])
              : FieldValue.arrayRemove([planRef.documentID])
        });
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> requestFollow(String email, bool follow) async {
    final user = await UserData.getUser();
    final current = user['email'];
    final userRef1 = database.collection('additional_info').document(email);
    final userRef2 = database.collection('additional_info').document(current);
    try {
      await database.runTransaction((transaction) async {
        await transaction.update(userRef1, {
          'follow_requests': follow
              ? FieldValue.arrayUnion([current])
              : FieldValue.arrayRemove([current])
        });
        await transaction.update(userRef2, {
          'follow_requested': follow
              ? FieldValue.arrayUnion([email])
              : FieldValue.arrayRemove([email])
        });
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> acceptFollow(String email, bool accept) async {
    final user = await UserData.getUser();
    final current = user['email'];
    final userRef1 = database.collection('additional_info').document(email);
    final userRef2 = database.collection('additional_info').document(current);
    try {
      await database.runTransaction((transaction) async {
        await transaction.update(userRef1, {
          if (accept) 'following_id': FieldValue.arrayUnion([current]),
          'follow_requested': FieldValue.arrayRemove([current])
        });
        await transaction.update(userRef2, {
          if (accept) 'followers_id': FieldValue.arrayUnion([email]),
          'follow_requests': FieldValue.arrayRemove([email])
        });
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> unFollow(String email) async {
    final user = await UserData.getUser();
    final current = user['email'];
    final userRef1 = database.collection('additional_info').document(email);
    final userRef2 = database.collection('additional_info').document(current);
    try {
      await database.runTransaction((transaction) async {
        await transaction.update(userRef1, {
          'followers_id': FieldValue.arrayRemove([current]),
        });
        await transaction.update(userRef2, {
          'following_id': FieldValue.arrayRemove([email]),
        });
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future joinActivity(
      bool accept, String planId, String userEmail, String token) async {
    try {
      final planRef = database.collection('plan').document(planId);
      final planDoc = await planRef.get();
      final batch = database.batch();
      batch.updateData(planRef, {
        'pending_participant_id': FieldValue.arrayRemove([userEmail])
      });
      if (accept) {
        batch.updateData(planRef, {
          'participants_id': FieldValue.arrayUnion([userEmail])
        });
        final userplanRef =
            database.collection('user_plans').document(userEmail);
        batch.updateData(userplanRef, {
          'current_plans': FieldValue.arrayUnion([planId])
        });
        final groupchatSnap =
            await database.collection('group_chat').document(planId).get();
        Map messengers = groupchatSnap.data['messenger_id'];
        messengers[userEmail] = token;
        batch.updateData(groupchatSnap.reference, {'messenger_id': messengers});
        await database
            .collection('users')
            .document(userEmail)
            .collection('activity_notifications')
            .add({
          'msg':
              'You have been accepted in ${planDoc.data['admin_name']}\'s Activity',
          'created_at': Timestamp.now()
        });
      } else {
        batch.updateData(planRef, {
          'blocked_participant_id': FieldValue.arrayUnion([userEmail])
        });
      }
      await batch.commit();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<DocumentSnapshot>> getNotification() async {
    final user = await UserData.getUser();
    final notifications = await database
        .collection('users')
        .document(user['email'])
        .collection('activity_notifications')
        .orderBy('created_at', descending: true)
        .getDocuments();
    return notifications.documents.length == 0 ? null : notifications.documents;
  }
}
