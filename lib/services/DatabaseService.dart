import 'dart:io';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:steel_crypt/steel_crypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home.dart';
import '../data/post.dart';
import '../data/User.dart';
import 'StorageService.dart';
import 'CloudMessaging.dart';
//import 'Hashing.dart';

class DataService {
  static final database = Firestore.instance;
  Future<Map<String, dynamic>> createUser(User user) async {
    String name = capitalize(user.fname) + ' ' + capitalize(user.lname);
    Map<String, dynamic> userData = {
      'name': name,
      'first_name': user.fname,
      'last_name': user.lname,
      'email': user.email,
      'password': HashCrypt('SHA-3/512').hash(user.password),
      'dob': user.birthDate,
      'gender': user.gender,
      'mobile_no': null,
      'uid': user.uid,
      'timestamp': Timestamp.now(),
      'verified': false,
      'profile_setup': false,
      'profile_pic': user.photoUrl,
      'followers': 0,
      'following': 0,
      'coins': 10,
      'coordinates': null,
      'activities_completed': 0,
      'address': null,
      'addCoinsOn': DateTime.now().add(Duration(days: 7))
    };
    Map<String, dynamic> userPlan = {
      'cancelled_plans': [],
      'completed_plans': [],
      'current_plans': [],
      'requested_plans': [],
      'your_adminplans': []
    };
    Map<String, dynamic> userInfo = {
      'following_id': [],
      'followers_id': [],
      'follow_requests': [],
      'follow_requested': [],
      'posts': [],
      'facebook_acc': "",
      'instagram_acc': "",
      'linkedin_acc': "",
      'twitter_acc': "",
      'website': "",
      'profile_pic': null,
      'interested_activity': []
    };
    Map<String, dynamic> userRep = {
      'behaviour': 0,
      'activity_completed': 0,
      'activity_last_month': 0,
      'followers': 0,
      'following': 0,
      'payment': 0,
      'punctuality': 0
    };
    await database.collection('users').document(user.email).setData(userData);
    await database
        .collection('user_plans')
        .document(user.email)
        .setData(userPlan);
    await database
        .collection('additional_info')
        .document(user.email)
        .setData(userInfo);
    await database
        .collection('user_reputation')
        .document(user.email)
        .setData(userRep);
    return userData;
  }

  Future updateUserInfo(Map<String, dynamic> additionalInfo, String name,
      String gender, File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profilePic;
    if (image != null)
      profilePic = await StorageService.updateProfilePic(
          prefs.getString('email'), image);
    await database.runTransaction((transaction) async {
      if (profilePic != null) additionalInfo['profile_pic'] = profilePic;
      await transaction.update(
          database
              .collection('additional_info')
              .document(prefs.getString('email')),
          additionalInfo);
    });
    await database.runTransaction((transaction) async {
      await transaction.update(
          database.collection('users').document(prefs.getString('email')), {
        'first_name': name.split(' ').first,
        'last_name': name.split(' ').last,
        'gender': gender,
        if (profilePic != null) 'profile_pic': profilePic
      });
    });
    prefs.setString('name', name);
    prefs.setString('fname', name.split(' ').first);
    prefs.setString('lname', name.split(' ').last);
    prefs.setString('gender', gender);
    if (profilePic != null) {
      prefs.setString('profile_pic', profilePic);
      CurrentUser.user.photoUrl = profilePic;
    }
  }
  Future updateActivityStatus(Map details, DocumentSnapshot plandoc) async {
    try{
       await database.runTransaction((transaction) async {
        await transaction.update(
          database.collection('plan').document(plandoc.documentID), {
          'activity_status': details['activity_status'],
          'activity_rating': details['activity_rating'],
          });
       }); 
    }catch (e) {
      print(e.toString());
    }
  }

  Future updateUserPlan(Map details, DocumentSnapshot plandoc) async {
    try {
      await database.runTransaction((transaction) async {
        await transaction.update(
          database.collection('plan').document(plandoc.documentID), {
          'max_participant': details['max_participant'],
          'participant_type': details['participant_type'],
          'activity_start': details['activity_start'],
          'activity_end': details['activity_end'],
          'description': details['description'],
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future createPlan(Map details) async {
    try {
      Map user = await UserData.getUser();
      DocumentReference plandoc =
          await database.collection('plan').add(details);
      await database.runTransaction((transaction) async {
        await transaction.update(
            database.collection('user_plans').document(details['admin_id']), {
          'current_plans': FieldValue.arrayUnion([plandoc.documentID]),
          'your_adminplans': FieldValue.arrayUnion([plandoc.documentID])
        });
      });
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
      final activity = await database
          .collection('chalo_activity')
          .where('name', isEqualTo: details['activity_type'])
          .limit(1)
          .getDocuments();
      if (details['broadcast_type'] == 'public') {
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
      // print(plandoc.documentID);
      // print(groupchatdoc.documentID);
      // print(locationdoc.documentID);
      await database.runTransaction((transaction) async {
        await transaction.update(plandoc, {
          'group_chat': groupchatdoc,
          'location_id': locationdoc,
          'plan_id': plandoc.documentID,
          'activity_logo': activity.documents[0].data['logo']
        });
      });
      final doc = await database.collection('users').document(CurrentUser.userEmail).get();
      await database.runTransaction((transaction) async {
        await transaction.update(database.collection('users').document(CurrentUser.userEmail), {
          'coins': doc.data['coins'] - 3,
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

  Future<DocumentSnapshot> getUserInfo(String email) async {
    final doc =
        await database.collection('additional_info').document(email).get();
    return doc;
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

  Future verifyUser(String email, String phone) async {
    await database.runTransaction((transaction) async {
      final DocumentReference doc =
          database.collection('users').document(email);
      await transaction.update(doc, {'mobile_no': phone, 'verified': true});
    });
  }

  Future completeProfile(
      String email, List activities, Map<String, dynamic> details) async {
    activities = List<String>.generate(
        activities.length, (index) => activities[index][1]);
    await database.runTransaction((transaction) async {
      await transaction.update(
          database.collection('additional_info').document(email),
          {'interested_activities': activities});
      details['profile_setup'] = true;
      await transaction.update(
          database.collection('users').document(email), details);
    });
  }

  Future updateToken(bool update) async {
    final email = CurrentUser.user.email;
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

  Future<bool> setRatingList(DocumentReference planRef, double rating, String email) async{
    try{
      await database.runTransaction((transaction) async {
        await transaction.update(planRef, {
          'rating_list': FieldValue.arrayUnion([rating]),
          'participants_rated': FieldValue.arrayUnion([email]),
        });
      });
      return true;
    } catch(e){
      print(e.toString());
      return false;
    }
  }

  Future<bool> requestPresent(DocumentReference planRef, String email) async{
    try{
      await database.runTransaction((transaction) async {
        await transaction.update(planRef, {
          'participants_present': FieldValue.arrayUnion([email])
        });
      });
      return true;
    } catch(e){
      print(e.toString());
      return false;
    }
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
    final batch = database.batch();
    final user = await UserData.getUser();
    final current = user['email'];
    final userInfo = database.collection('additional_info').document(email);
    final currentinfo =
        database.collection('additional_info').document(current);
    final userSnap = await database.collection('users').document(email).get();
    final currentUser = database.collection('users').document(current);
    try {
      batch.updateData(userInfo, {
        if (accept) 'following_id': FieldValue.arrayUnion([current]),
        'follow_requested': FieldValue.arrayRemove([current])
      });
      batch.updateData(currentinfo, {
        if (accept) 'followers_id': FieldValue.arrayUnion([email]),
        'follow_requests': FieldValue.arrayRemove([email])
      });
      if (accept) {
        batch.updateData(
            currentUser, {'followers': CurrentUser.user.followers.length + 1});
        batch.updateData(
            userSnap.reference, {'following': userSnap.data['following'] + 1});
      }
      await batch.commit();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> unFollow(String email) async {
    final batch = database.batch();
    final user = await UserData.getUser();
    final current = user['email'];
    final userInfo = database.collection('additional_info').document(email);
    final currentInfo =
        database.collection('additional_info').document(current);
    final userSnap = await database.collection('users').document(email).get();
    final currentUser = database.collection('users').document(current);
    try {
      batch.updateData(userInfo, {
        'followers_id': FieldValue.arrayRemove([current]),
      });
      batch.updateData(currentInfo, {
        'following_id': FieldValue.arrayRemove([email]),
      });
      batch.updateData(
          userSnap.reference, {'followers': userSnap.data['followers'] - 1});
      batch.updateData(
          currentUser, {'following': CurrentUser.user.following.length - 1});
      await batch.commit();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future joinActivity(bool accept, String planId, String userEmail,
      String token, String admin) async {
    try {
      final planRef = database.collection('plan').document(planId);
      final batch = database.batch();
      batch.updateData(planRef, {
        'pending_participant_id': FieldValue.arrayRemove([userEmail])
      });
      if (accept) {
      final doc = await database.collection('users').document(CurrentUser.userEmail).get();
      await database.runTransaction((transaction) async {
        await transaction.update(database.collection('users').document(userEmail), {
          'coins': doc.data['coins'] - 2,
        });
      });
        batch.updateData(planRef, {
          'participants_id': FieldValue.arrayUnion([userEmail])
        });
        final userplanRef =
            database.collection('user_plans').document(userEmail);
        batch.updateData(userplanRef, {
          'current_plans': FieldValue.arrayUnion([planId]),
          'requested_plans': FieldValue.arrayRemove([planId])
        });
        final groupchatSnap =
            await database.collection('group_chat').document(planId).get();
        Map messengers = groupchatSnap.data['messenger_id'];
        messengers[userEmail] = token;
        batch.updateData(groupchatSnap.reference, {'messenger_id': messengers});
        await notifyUser(
            userEmail, 'You have been accepted in $admin\'s Activity');
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

  Future leaveActivity(DocumentSnapshot planDoc, {bool delete = false}) async {
    final batch = database.batch();
    final current = CurrentUser.user.email;
    final planId = planDoc['plan_id'];
    final groupchatRef = database.collection('group_chat').document(planId);
    if (delete) {
      List participants = planDoc['participants_id'];
      participants.forEach((participant) {
        batch.updateData(
            database.collection('user_plans').document(participant), {
          'current_plans': FieldValue.arrayRemove([planId]),
          if (participant == current)
            'your_adminplans': FieldValue.arrayRemove([planId])
        });
        if (participant != current)
          notifyUser(participant,
              'You were removed from ${planDoc['admin_name']}\'s Activity since it was deleted');
      });
      batch.delete(planDoc.reference);
    } else {
      batch.updateData(planDoc.reference, {
        'participants_id': FieldValue.arrayRemove([current])
      });
      batch.updateData(database.collection('user_plans').document(current), {
        'current_plans': FieldValue.arrayRemove([planId]),
      });
    }
    if (delete) {
      final msgs = (await groupchatRef
              .collection('chat')
              .orderBy('timestamp')
              .getDocuments())
          .documents;
      msgs.forEach((msg) => batch.delete(msg.reference));
      if (planDoc['broadcast_type'] == 'public')
        batch.delete(database.collection('map_activity').document(planId));
      batch.delete(groupchatRef);
    } else {
      final groupchatSnap = await groupchatRef.get();
      Map messengers = groupchatSnap.data['messenger_id'];
      messengers.remove(current);
      batch.updateData(groupchatRef, {'messenger_id': messengers});
    }
    await batch.commit();
  }

  Future<void> removeFromActivity(
      String planId, String admin, String user) async {
    await database.runTransaction((transaction) async {
      await transaction.update(database.collection('plan').document(planId), {
        'participants_id': FieldValue.arrayRemove([user]),
        'participants_present': FieldValue.arrayRemove([user])
      });
      await transaction
          .update(database.collection('user_plans').document(user), {
        'current_plans': FieldValue.arrayRemove([planId])
      });
      final groupchatSnap =
          await database.collection('group_chat').document(planId).get();
      Map messengers = groupchatSnap.data['messenger_id'];
      messengers.remove(user);
      await transaction
          .update(groupchatSnap.reference, {'messenger_id': messengers});
    });
    await notifyUser(user, 'You were removed from $admin\'s Activity');
  }

  Future<void> notifyUser(String user, String msg) async {
    await database
        .collection('users')
        .document(user)
        .collection('activity_notifications')
        .add({'msg': msg, 'created_at': Timestamp.now()});
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

  Future uploadPost(Post post) async {
    final email = CurrentUser.user.email;
    final postName = DateFormat('yyyyMMdd_HHmmss').format(post.timestamp);
    final imageUrl =
        await StorageService.uploadPostPic(email, postName, post.image);
    final ref = await database.collection('posts').add({
      'user': post.email,
      'username': post.username,
      'caption': post.caption,
      'likes': post.likes,
      'activity': post.activityType,
      'timestamp': post.timestamp,
      'image_url': imageUrl
    });
    await database.runTransaction((transaction) async {
      await transaction.update(ref, {'post_id': ref.documentID});
      await transaction
          .update(database.collection('additional_info').document(email), {
        'posts': FieldValue.arrayUnion([ref.documentID])
      });
    });
  }

  Future likePost(String postId, {bool like = true}) async {
    final ref = database.collection('posts').document(postId);
    await database.runTransaction((transaction) async {
      await transaction.update(ref, {
        'likes': like
            ? FieldValue.arrayUnion([CurrentUser.user.email])
            : FieldValue.arrayRemove([CurrentUser.user.email])
      });
    });
  }

  Future addCoins(String email, int coins, int additional) async {
    await database.runTransaction((transaction) async {
      await transaction
          .update(database.collection('users').document(email), {
            'coins': coins + additional
          });
    });
  }
}
