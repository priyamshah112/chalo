import 'dart:async';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String fname;
  String lname;
  String email;
  String password;
  String birthDate;
  String gender;
  String phone;
  String uid;
  List activities = [];

  void setActivities(item) => this.activities.add(item);
  void setUid(String uid) => this.uid = uid;
  void setFname(String name) => this.fname = name;
  void setLname(String name) => this.lname = name;
  void setEmail(String email) => this.email = email;
  void setPassword(String password) => this.password = password;
  void setGender(String gender) => this.gender = gender;
  void setBirthDate(String bdate) => this.birthDate = bdate;
  void setPhone(String phone) => this.phone = phone;
}

class CurrentUser {
  static List _followers, _following, _followRequests, _requested;
  static String _name,
      _email,
      profileUrl,
      about,
      job,
      lang,
      country,
      state,
      city,
      facebook,
      insta,
      twitter,
      linkedin,
      website;
  static StreamSubscription<DocumentSnapshot> _userInfo;
  static Future<void> initialize(
      String name, String email, String profilePic) async {
    _name = name;
    _email = email;
    profileUrl = profilePic;
    _userInfo = Firestore.instance
        .collection('additional_info')
        .document(_email)
        .snapshots()
        .listen((snapshot) {
      print('Initializing Data...');
      _following = snapshot.data['following_id'];
      _followers = snapshot.data['followers_id'];
      _followRequests = snapshot.data['follow_requests'];
      _requested = snapshot.data['follow_requested'];
      about = snapshot.data['about'];
      lang = snapshot.data['languages'];
      job = snapshot.data['job'];
      country = snapshot.data['country'];
      state = snapshot.data['state'];
      city = snapshot.data['city'];
      facebook = snapshot.data['facebook_acc'];
      insta = snapshot.data['instagram_acc'];
      linkedin = snapshot.data['linkedin_acc'];
      twitter = snapshot.data['twitter_acc'];
      website = snapshot.data['website'];
    });
  }

  static void discard() {
    _userInfo.cancel();
    _followers = _following = _followRequests = _requested = [];
  }

  static List get followers => _followers;
  static List get following => _following;
  static List get followRequests => _followRequests;
  static List get requested => _requested;
  static String get email => _email;
  static String get name => _name;
  static void setFollowers(List temp) => _followers = temp;
  static void setFollowing(List temp) => _following = temp;
  static void setFollowRequests(List temp) => _followRequests = temp;
  static void setRequested(List temp) => _requested = temp;
}

class UserData {
  Future setData(Map userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', userData['name']);
    prefs.setString('email', userData['email']);
    prefs.setString('phone', userData['mobile_no']);
    prefs.setString('gender', userData['gender']);
    prefs.setString('dob', userData['email']);
    prefs.setString('profile_pic', userData['profile_pic']);
    prefs.setBool('verified', userData['verified']);
    CurrentUser.initialize(userData['name'],userData['email'], userData['profile_pic']);
  }

  Future deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('phone');
    prefs.remove('dob');
    prefs.remove('gender');
    prefs.remove('profile_pic');
    prefs.setBool('verified', false);
    CurrentUser.discard();
  }

  static Future checkVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('verified');
  }

  static Future<Map> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map user = {
      'email': prefs.getString('email'),
      'name': prefs.getString('name')
    };
    return user;
  }
}
