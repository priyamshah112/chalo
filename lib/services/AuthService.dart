import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/services/Hashing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'DatabaseService.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future<Map> googleSignIn() async {
    try {
      GoogleSignIn googleSignIn = new GoogleSignIn();
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      FirebaseUser user = await credsSignIn(credential);
      final userDoc = await DataService().getUserDoc(user.email);
      if (userDoc != null) {
        await UserData().setData(userDoc.data, 'google');
        return {
          "success": true,
          'credentials': credential,
          'email': user.email
        };
      } else {
        googleSignIn.signOut();
        deleteUser(user);
        return {"success": false, 'msg': 'Unregistered Email'};
      }
    } catch (e) {
      print(e.toString());
      return {"success": false, 'msg': e.toString()};
    }
  }

  Future<Map> signIn(email, password) async {
    DocumentSnapshot doc;
    print('Signing in...');
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      doc = await DataService().getUserDoc(email);
      await UserData().setData(doc.data, 'email');
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

  Future<bool> signOut(String type) async {
    try {
      await UserData().deleteData();
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

  Future<bool> isUserLoggedIn() async {
    final user = await auth.currentUser();
    return user == null ? false : true;
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
