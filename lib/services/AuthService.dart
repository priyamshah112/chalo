import 'package:chaloapp/services/Hashing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService({@required this.auth});
  final FirebaseAuth auth;
  CollectionReference userCollection = Firestore.instance.collection('users');
  Future<Map> googleSignIn(email, password) async {
    try {
      // await signOut('google');
      GoogleSignIn googleSignIn = new GoogleSignIn();
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      FirebaseUser user = (await auth.signInWithCredential(credential)).user;
      bool contains = false;
      await this.userCollection.getDocuments().then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((doc) {
          if (user.email == doc.data['email']) {
            contains = true;
          }
        });
      });
      return contains
          ? {"success": true, 'username': user.email, 'type': 'google'}
          : {"success": false, 'username': user.email, 'type': 'google'};
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
      return {"success": true, 'username': email, 'type': 'email'};
    } catch (e) {
      bool flag = false;
      DocumentSnapshot doc = await this.userCollection.document(email).get();
      String hashedPassword = doc.data['password'];
      print(e.toString());
      if (e.code == 'ERROR_WRONG_PASSWORD') {
        print(hashedPassword);
        print(Hashing.encrypt(password));
        if (hashedPassword == Hashing.encrypt(password)) flag = true;
      }
      return flag
          ? {"success": true, 'username': email, 'type': 'email'}
          : {"success": false, 'msg': "Unregistered Email or Password"};
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

  Future deleteUser() async {
    FirebaseUser user = await auth.currentUser();
    user.delete();
  }
}
