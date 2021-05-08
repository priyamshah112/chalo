import 'package:flutter/material.dart';
import 'google.dart';
import 'facebook.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

void main() => runApp(MyHomePage());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Sign Up Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 180),
            SizedBox(
              width: 360,
              child: SignInButton(
                Buttons.Google,
                onPressed: () {
                  signUpWithFacebook();
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 360,
              child: SignInButton(
                Buttons.Facebook,
                onPressed: () {
                  googleSignUp();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
