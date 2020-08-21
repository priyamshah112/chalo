import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name;
  String fname;
  String lname;
  String email;
  String password;
  String birthDate;
  String gender;
  String phone;
  String uid;
  String photoUrl;
  int age;
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
  void setPhoto(String url) => this.photoUrl = url;
}

class CurrentUser extends User {
  List _followers, _following, _followRequests, _requested, _posts;
  String about,
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
  static CurrentUser user;
  static StreamSubscription<DocumentSnapshot> _userInfo;
  static Future<void> initialize(SharedPreferences prefs) async {
    user = CurrentUser();
    user.name = prefs.getString('name');
    user.email = prefs.getString('email');
    user.photoUrl = prefs.getString('profile_pic');
    user.gender = prefs.getString('gender');
    user.birthDate = prefs.getString('dob');
    user._followers = user._following = user._followRequests = [];
    user.age = DateTime.now().year - int.parse(user.birthDate.split("/").last);
    print('set basic data');
    _userInfo = Firestore.instance
        .collection('additional_info')
        .document(user.email)
        .snapshots()
        .listen((snapshot) {
      print('Initializing Additional Info...');
      user._following = snapshot.data['following_id'];
      user._followers = snapshot.data['followers_id'];
      user._followRequests = snapshot.data['follow_requests'];
      user._posts = snapshot.data['posts'] ?? [];
      user._requested = snapshot.data['follow_requested'];
      user.about = snapshot.data['about'];
      user.lang = snapshot.data['languages'];
      user.job = snapshot.data['job'];
      user.country = snapshot.data['country'];
      user.state = snapshot.data['state'];
      user.city = snapshot.data['city'];
      user.facebook = snapshot.data['facebook_acc'];
      user.insta = snapshot.data['instagram_acc'];
      user.linkedin = snapshot.data['linkedin_acc'];
      user.twitter = snapshot.data['twitter_acc'];
      user.website = snapshot.data['website'];
    });
  }

  static void discard() {
    _userInfo.cancel();
    user._followers =
        user._following = user._followRequests = user._requested = [];
    user = null;
  }

  static List get followers => user._followers;
  static List get following => user._following;
  static List get followRequests => user._followRequests;
  static List get requested => user._requested;
  static List get posts => user._posts;
  static String get userEmail => user.email;
  static String get username => user.name;
  static void setFollowers(List temp) => user._followers = temp;
  static void setFollowing(List temp) => user._following = temp;
  static void setFollowRequests(List temp) => user._followRequests = temp;
  static void setRequested(List temp) => user._requested = temp;
}

class UserData {
  Future setData(Map userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', userData['name']);
    prefs.setString('email', userData['email']);
    prefs.setString('phone', userData['mobile_no']);
    prefs.setString('gender', userData['gender']);
    prefs.setString('dob', userData['dob']);
    prefs.setString('profile_pic', userData['profile_pic']);
    prefs.setBool('verified', userData['verified']);
    prefs.setBool('profile_setup', userData['profile_setup']);
    CurrentUser.initialize(prefs);
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
    print('user Info Discarded');
  }

  static Future checkVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('verified');
  }

  static Future checkProfileSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('profile_setup');
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
