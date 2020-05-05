import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth;
  AuthService({@required this.auth});

  Future<Map> googleSignIn(email, password) async {
    try {
      GoogleSignIn googleSignIn = new GoogleSignIn();
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      FirebaseUser user = (await auth.signInWithCredential(credential)).user;
      // print(user.displayName + " Signed In");
      return {"success": true, 'username': user.email, 'type': 'google'};
    } catch (e) {
      print(e.toString());
      return {"success": false, 'msg': e.toString()};
    }
  }

  Future<Map> signIn(email, password) async {
    try {
      FirebaseUser user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      // print(user.displayName + " Signed In");
      return {"success": true, 'username': user.email, 'type': 'email'};
    } catch (e) {
      print(e.toString());
      return {"success": false, 'msg': e.toString()};
    }
  }

  Future<bool> signOut(String type) async {
    try {
      if (type == 'email')
        await auth.signOut();
      else {
        GoogleSignIn googleAcc = new GoogleSignIn();
        googleAcc.signOut();
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Map> createUser(email, password, name) async {
    String msg;
    try {
      FirebaseUser user;
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((AuthResult result) {
        user = result.user;
        UserUpdateInfo userinfo = new UserUpdateInfo();
        userinfo.displayName = name;
        user.updateProfile(userinfo);
      });
      await user.sendEmailVerification();
      return {'success': true, 'uid': user.uid};
    } catch (e) {
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
}
