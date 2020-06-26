import 'package:chaloapp/services/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void setActivities(item) {
    this.activities.add(item);
  }

  void setUid(String uid) {
    this.uid = uid;
  }

  void setFname(String name) {
    this.fname = name;
  }

  void setLname(String name) {
    this.lname = name;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void setGender(String gender) {
    this.gender = gender;
  }

  void setBirthDate(String bdate) {
    this.birthDate = bdate;
  }

  void setPhone(String phone) {
    this.phone = phone;
  }
}

class UserData {
  Future setData(Map userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userInfo = await DataService().getUserInfo(userData['email']);
    prefs.setString(
        'name', userData['first_name'] + " " + userData['last_name']);
    prefs.setString('fname', userData['first_name']);
    prefs.setString('lname', userData['last_name']);
    prefs.setString('email', userData['email']);
    prefs.setString('gender', userData['gender']);
    prefs.setString('phone', userData['mobile_no']);
    prefs.setString('dob', userData['dob']);
    prefs.setString('profile_pic', userData['profile_pic']);
    prefs.setBool('verified', userData['verified']);
    prefs.setString('about', userInfo['about']);
    prefs.setString('job', userInfo['job']);
    prefs.setString('lang', userInfo['languages']);
    prefs.setString('country', userInfo['country']);
    prefs.setString('state', userInfo['state']);
    prefs.setString('city', userInfo['city']);
    prefs.setString('facebook', userInfo['facebook_acc']);
    prefs.setString('twitter', userInfo['twitter_acc']);
    prefs.setString('instagram', userInfo['instagram_acc']);
    prefs.setString('linkedin', userInfo['linkedin_acc']);
    prefs.setString('website', userInfo['website']);
    prefs.setInt('followers',
        userInfo['followers_id'] == null ? 0 : userInfo['followers_id'].length);
    prefs.setInt('following',
        userInfo['following_id'] == null ? 0 : userInfo['following_id'].length);
  }

  Future deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('fname');
    prefs.remove('lname');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('type');
  }

  static Future checkVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('verified');
  }

  static Future<String> checkType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('type');
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
