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
        FirebaseUser user = await credsSignIn(credential, userDoc);
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
        .logIn(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        String token = result.accessToken.token;
        String url =
            'https://graph.facebook.com/v7.0/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=';
        Response response = await get(url + token);
        Map profile = jsonDecode(response.body);
        if (profile['email'] == null)
          return {
            "success": false,
            'msg': 'Your facebook email is neede for login'
          };
        final userDoc = await DataService().getUserDoc(profile['email']);
        if (userDoc == null) {
          await facebookLogin.logOut();
          return {"success": false, 'msg': 'Unregistered Email or password'};
        }
        try {
          final credentials = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);
          final user = await credsSignIn(credentials, userDoc);
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

  Future<FirebaseUser> credsSignIn(AuthCredential creds,
      [DocumentSnapshot userDoc]) async {
    FirebaseUser user = (await auth.signInWithCredential(creds)).user;
    if (userDoc != null) await UserData().setData(userDoc.data);
    return user;
  }

  Future<bool> signOut({bool flushData = true}) async {
    if (flushData) DataService().updateToken(false);
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

  Future<bool> isUserLoggedIn() async {
    final user = await currentUser;
    return user != null;
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

  Future<Map> signUp(String method) async {
    try {
      String email, fname, lname, photoURL;
      AuthCredential creds;
      switch (method) {
        case 'google':
          final GoogleSignIn googleSignIn = new GoogleSignIn();
          GoogleSignInAccount googleUser;
          GoogleSignInAuthentication googleAuth;
          try {
            googleUser = await googleSignIn.signIn();
            googleAuth = await googleUser.authentication;
          } catch (e) {
            print(e.toString());
            print(e.runtimeType);
            if (e.code == "sign_in_failed")
              return {"success": false, 'msg': 'Google Signin Cancelled'};
            if (e.code == "network_error")
              return {
                "success": false,
                'msg':
                    'Network Error occured, make sure you internet connection is stable'
              };
            return {"success": false, 'msg': 'Unknown error occured'};
          }
          final userDoc = await DataService().getUserDoc(googleUser.email);
          if (userDoc != null) {
            print('useer already exists with this email');
            await googleSignIn.signOut();
            return {
              "success": false,
              'msg':
                  'This email is already in use by another account.\nTry with another email'
            };
          }
          try {
            email = googleUser.email;
            fname = googleUser.displayName.split(" ").first;
            lname = googleUser.displayName.split(" ").last;
            photoURL = googleUser.photoUrl;
            creds = GoogleAuthProvider.getCredential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            print('fetched details from google');
          } catch (e) {
            print(e.toString());
            await googleSignIn.signOut();
            return {
              'success': false,
              'msg': 'Something went wrong. Try again later'
            };
          }
          break;
        case 'facebook':
          final facebookLogin = FacebookLogin();
          facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
          final result = await facebookLogin.logIn(['email', 'public_profile']);
          switch (result.status) {
            case FacebookLoginStatus.loggedIn:
              print('login successful, getting details...');
              Response graphResponse = await get(
                  'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${result.accessToken.token}');
              Map profile = jsonDecode(graphResponse.body);
              if (profile['email'] == null)
                return {
                  "success": false,
                  'msg': 'Your facebook email is neede for login'
                };
              final userDoc = await DataService().getUserDoc(profile['email']);
              if (userDoc != null) {
                print('user already exists with this email');
                await facebookLogin.logOut();
                return {
                  "success": false,
                  'msg':
                      'This email is already in use by another account.\nTry with another email'
                };
              }
              try {
                email = profile['email'];
                fname = profile['first_name'];
                lname = profile['last_name'];
                photoURL = profile['picture']['data']['url'];
                creds = FacebookAuthProvider.getCredential(
                    accessToken: result.accessToken.token);
                print('fetched deatils from facebook');
              } catch (e) {
                print(e.toString());
                await facebookLogin.logOut();
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
            default:
          }
          break;
        default:
      }
      return {
        "success": true,
        'creds': creds,
        'email': email,
        'fname': fname,
        'lname': lname,
        'photo': photoURL,
        'type': method
      };
    } catch (e) {
      print(e.toString());
      await signOut();
      return {"success": false, 'msg': 'Something went wrong. Try again Later'};
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

  Future<FirebaseUser> get currentUser async => await auth.currentUser();
}
