import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import '../data/User.dart';
import 'DatabaseService.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future<Map> googleSignIn() async {
    final GoogleSignIn googleSignIn = new GoogleSignIn();
    GoogleSignInAccount googleUser;
    GoogleSignInAuthentication googleAuth;
    AuthCredential credential;
    try {
      try {
        googleUser = await googleSignIn.signIn();
        googleAuth = await googleUser.authentication;
        credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } catch (e) {
        print(e.toString());
        return {"success": false, 'msg': 'Please select an account'};
      }
      final userDoc = await DataService().getUserDoc(googleUser.email);
      if (userDoc != null) {
        FirebaseUser user = await credsSignIn(credential);
        await UserData().setData(userDoc.data);
        DataService().updateToken(true);
        return {
          "success": true,
          'credentials': credential,
          'email': user.email
        };
      } else {
        googleSignIn.signOut();
        return {"success": false, 'msg': 'Unregistered Email'};
      }
    } catch (e) {
      googleSignIn.signOut();
      print(e.toString());
      return {"success": false, 'msg': e.toString()};
    }
  }

  Future<Map> facebookSignIn() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
    final result = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        String token = result.accessToken.token;
        String url =
            'https://graph.facebook.com/v7.0/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=';
        Response response = await get(url + token);
        Map profile = jsonDecode(response.body);
        final userDoc = await DataService().getUserDoc(profile['email']);
        if (userDoc == null) {
          await facebookLogin.logOut();
          return {"success": false, 'msg': 'Unregistered Email or password'};
        }
        try {
          final credentials = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);
          final user = await credsSignIn(credentials);
          await UserData().setData(userDoc.data);
          DataService().updateToken(true);
          return {
            'success': true,
            'credentials': credentials,
            'email': user.email
          };
        } on PlatformException catch (e) {
          print(e.toString());
          if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
            return {
              'success': false,
              'msg':
                  'Unable to perform Facebook Signin. Try other Signin Methods'
            };
          }
        } catch (e) {
          print(e.toString());
          return {
            'success': false,
            'msg': 'Something went wrong. Try again later'
          };
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        return {'success': false, 'msg': 'Login was Cancelled'};
        break;
      case FacebookLoginStatus.error:
        return {'success': false, 'msg': result.errorMessage};
        break;
    }
    return {'success': false, 'msg': 'Something went wrong. Try again later'};
  }

  Future<Map> signIn(email, password) async {
    DocumentSnapshot doc;
    print('Signing in...');
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      doc = await DataService().getUserDoc(email);
      await UserData().setData(doc.data);
      DataService().updateToken(true);
      return {"success": true, 'email': email, 'password': password};
    } catch (e) {
      print(e.toString());
      return e.code == 'ERROR_WRONG_PASSWORD'
          ? {
              "success": false,
              'msg': "Please use your social media Login \"Google or Facebook\""
            }
          : {"success": false, 'msg': "Unregistered Email or Password"};
    }
  }

  Future<FirebaseUser> credsSignIn(AuthCredential creds) async {
    FirebaseUser user = (await auth.signInWithCredential(creds)).user;
    return user;
  }

  Future<bool> signOut() async {
    DataService().updateToken(false);
    try {
      await UserData().deleteData();
      await GoogleSignIn().signOut();
      await FacebookLogin().logOut();
      await auth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<FirebaseUser> isUserLoggedIn() async {
    final user = await auth.currentUser();
    return user;
  }

  Future<Map> createUser(email, password, name) async {
    try {
      FirebaseUser user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      UserUpdateInfo userinfo = new UserUpdateInfo();
      userinfo.displayName = name;
      user.updateProfile(userinfo);
      await user.sendEmailVerification();
      return {'success': true, 'uid': user.uid};
    } catch (e) {
      String msg;
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE')
        msg =
            "A user with this email already exists \nTry using a differernt email";
      else
        msg = e.toString();
      return {'success': false, 'error': msg};
    }
  }

  Future<Map> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return {'success': true};
    } catch (e) {
      if (e.code == 'ERROR_USER_NOT_FOUND')
        return {
          'success': false,
          'msg':
              "No user exists with this email \nPlease enter a registered email"
        };
      return {'success': false, 'msg': e.toString()};
    }
  }

  Future<void> deleteUser(FirebaseUser user) async {
    try {
      user.delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
