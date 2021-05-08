import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> signUpWithFacebook() async {
  try {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin.logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken.token,
      );
      final User user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      print('signed in ' + user.displayName);
      return user;
    }
  } catch (e) {
    print(e.message);
  }
}
