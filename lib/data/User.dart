import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name,
      fname,
      lname,
      email,
      password,
      birthDate,
      gender,
      phone,
      address,
      uid,
      photoUrl,
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
  int age, coins, activityCompleted;
  GeoPoint location;
  List activities = [], followers, following, followRequests, requested, posts;

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
  static CurrentUser user;
  static StreamSubscription<DocumentSnapshot> _userInfo;
  static Future<void> initialize(SharedPreferences prefs) async {
    user = CurrentUser();
    user.name = prefs.getString('name');
    user.email = prefs.getString('email');
    user.phone = prefs.getString('phone');
    user.photoUrl = prefs.getString('profile_pic');
    user.gender = prefs.getString('gender');
    user.birthDate = prefs.getString('dob');
    user.address = prefs.getString('address');
    user.coins = prefs.getInt('coins');
    user.activityCompleted = prefs.getInt('activityCompleted');
    user.location = GeoPoint(prefs.getDouble('lat'), prefs.getDouble('long'));
    user.age = ageFromDob(user.birthDate);
    user.followers = user.following = user.followRequests = [];
    print('set basic data');
    _userInfo = Firestore.instance
        .collection('additional_info')
        .document(user.email)
        .snapshots()
        .listen((snapshot) {
      print('Initializing Additional Info...');
      user.following = snapshot.data['following_id'];
      user.followers = snapshot.data['followers_id'];
      user.followRequests = snapshot.data['follow_requests'];
      user.posts = snapshot.data['posts'] ?? [];
      user.requested = snapshot.data['follow_requested'];
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
    user = null;
  }

  // static List get followers => user.followers;
  // static List get following => user.following;
  // static List get followRequests => user.followRequests;
  // static List get requested => user.requested;
  // static List get posts => user.posts;
  static String get userEmail => user.email;
  static String get username => user.name;
  static set setFollowers(List temp) => user.followers = temp;
  static set setFollowing(List temp) => user.following = temp;
  static set setFollowRequests(List temp) => user.followRequests = temp;
  static set setRequested(List temp) => user.requested = temp;
  static int ageFromDob(String dob) =>
      DateTime.now().year - int.parse(dob.split("/").last);
}

class UserData {
  Future setData(Map userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', userData['name']);
    prefs.setString('email', userData['email']);
    prefs.setString('phone', userData['mobile_no']);
    prefs.setString('gender', userData['gender']);
    prefs.setString('dob', userData['dob']);
    prefs.setString('address', userData['address']);
    prefs.setString('profile_pic', userData['profile_pic']);
    prefs.setBool('verified', userData['verified']);
    prefs.setBool('profile_setup', userData['profile_setup']);
    prefs.setInt('activityCompleted', userData['activities_completed']);
    prefs.setInt('coins', userData['coins']);
    GeoPoint coordinates = userData['coordinates'] ?? null;
    prefs.setDouble('lat', coordinates.latitude?? null);
    prefs.setDouble('long', coordinates.longitude?? null);
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
