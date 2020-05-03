import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth auth;
  AuthService({@required this.auth});

  Future<bool> signIn(email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Map> createUser(email, password) async {
    try {
      FirebaseUser user = (await auth.createUserWithEmailAndPassword(
          email: email, password: password)).user;
      await user.sendEmailVerification();
        return {'success': true, 'uid': user.uid};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
