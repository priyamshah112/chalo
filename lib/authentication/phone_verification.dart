import 'package:chaloapp/Animation/FadeAnimation.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/services/AuthService.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'ProfileSetup.dart';
import 'login.dart';

class PhoneVerification extends StatefulWidget {
  final String email, photoUrl;
  const PhoneVerification({@required this.email, this.photoUrl})
      : assert(email != null);
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final auth = AuthService();
  bool _autovalidate = false;
  bool _codeSent = false;
  bool _sendingOTP = false;
  String _verificaionId;
  String _phone;
  String _smsCode;
  int _resendToken;

  Future<bool> onBack() async {
    final user = await auth.currentUser;
    if (user != null) await auth.signOut(flushData: false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: onBack,
      child: Form(
        autovalidate: _autovalidate,
        key: _formKey,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 310,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 45,
                        height: 250,
                        width: width,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/loginbg.png'),
                                      fit: BoxFit.fill)),
                            )),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FadeAnimation(
                          1.5,
                          FittedBox(
                            child: Text(
                              "We need to verify you",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(primary),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  fontFamily: 'Pacifico'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FadeAnimation(
                          1.7,
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.length != 10)
                                        return "Enter 10-digit Phone No";
                                      return null;
                                    },
                                    onSaved: (value) => _phone = value,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Phone Number",
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Color(primary),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 30.0,
                                          bottom: 18.0,
                                          top: 18.0,
                                          right: 30.0),
                                      filled: true,
                                      fillColor: Color(form1),
                                      hintStyle: TextStyle(
                                        color: Color(formHint),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.0, vertical: 10.0),
                                    child: _codeSent
                                        ? TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty && _codeSent)
                                                return "Please Enter OTP";
                                              if (value.length != 6 &&
                                                  _codeSent)
                                                return "Must be 6 Digits";
                                              return null;
                                            },
                                            onSaved: (value) =>
                                                _smsCode = value,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(form1),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 30.0,
                                                      bottom: 18.0,
                                                      top: 18.0,
                                                      right: 30.0),
                                              border: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.lock,
                                                color: Color(primary),
                                              ),
                                              hintText: "Enter 6-digit OTP",
                                              hintStyle: TextStyle(
                                                color: Color(formHint),
                                              ),
                                            ),
                                          )
                                        : SizedBox(height: 0.0))
                              ],
                            ),
                          ),
                        ),
                        // FadeAnimation(
                        //   2,
                        //   Center(
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (BuildContext context) =>
                        //                   SignUp()),
                        //         );
                        //       },
                        //       child: Text(
                        //         "Resend OTP",
                        //         style: TextStyle(
                        //             color: Color(secondary),
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 15),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        _sendingOTP
                            ? CircularProgressIndicator()
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FadeAnimation(
                                      1.9,
                                      Container(
                                        height: 50,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: FlatButton(
                                          color: Color(secondary),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 60.0, vertical: 10.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              FocusScope.of(context).unfocus();
                                              if (!_codeSent)
                                                setState(
                                                    () => _sendingOTP = true);
                                              bool result = await DataService()
                                                  .verifyPhone(_phone);
                                              if (result) {
                                                _codeSent
                                                    ? await signInwithOTP(
                                                        _verificaionId,
                                                        _smsCode,
                                                        _phone,
                                                        widget.email)
                                                    : await sendOTP(
                                                        widget.email, _phone);
                                              } else {
                                                setState(
                                                    () => _sendingOTP = false);
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) => DialogBox(
                                                        title: "Error :(",
                                                        description:
                                                            "This Phone number is already registered and verified \nTry again with another phone number ",
                                                        buttonText1: "OK",
                                                        button1Func: () =>
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop()));
                                              }
                                            } else
                                              setState(
                                                  () => _autovalidate = true);
                                          },
                                          child: Text(
                                            _codeSent ? "Verify" : "Send OTP",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FadeAnimation(
                                    2,
                                    Center(
                                      child: GestureDetector(
                                        onTap: () => onBack(),
                                        child: Text(
                                          "Back",
                                          style: TextStyle(
                                              color: Color(secondary),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                          2.1,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'By continuing you agree to our',
                                style: TextStyle(
                                  color: Color(text3),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FadeAnimation(
                          2.2,
                          FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Color(primary),
                                  child: Text(
                                    'Terms and Conditions ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              HomePage()),
                                    );
                                  },
                                ),
                                Text(
                                  "and",
                                  style: TextStyle(
                                    color: Color(text3),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Color(primary),
                                  child: Text(
                                    ' Privacy Policy',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (BuildContext context) =>
                                    //           HomePage()),
                                    // );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendOTP(String email, String phone, [int resendToken]) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    AuthService authService = AuthService();
    phone = "+91" + phone;
    await auth.verifyPhoneNumber(
        phoneNumber: phone,
        forceResendingToken: resendToken,
        timeout: Duration(seconds: 0),
        verificationCompleted: (AuthCredential creds) async {
          FirebaseUser user = await authService.credsSignIn(creds);
          DataService().verifyUser(email, phone);
          authService.deleteUser(user);
          setState(() => _sendingOTP = false);
          if (isLoading) Navigator.of(context, rootNavigator: true).pop();
          showSuccess(context);
        },
        verificationFailed: (AuthException e) {
          print(e.code + "\n" + e.message);
          setState(() => _sendingOTP = false);
          if (isLoading) Navigator.of(context, rootNavigator: true).pop();
          showFail(context);
        },
        codeSent: (verID, [int forceResend]) async {
          print('code sent');
          setState(() {
            _verificaionId = verID;
            _resendToken = forceResend;
            _codeSent = true;
            _sendingOTP = false;
          });
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: Text('Verification Code Sent'),
            duration: Duration(seconds: 2),
          ));
        },
        codeAutoRetrievalTimeout: (verID) => {});
  }

  bool isLoading = false;
  Future<void> signInwithOTP(verID, smsCode, phone, email) async {
    showDialog(
        context: context,
        builder: (ctx) => Center(child: CircularProgressIndicator()));
    isLoading = true;
    AuthCredential creds = PhoneAuthProvider.getCredential(
        verificationId: verID, smsCode: smsCode);
    AuthService authService = AuthService();
    try {
      FirebaseUser user = await authService.credsSignIn(creds);
      DataService().verifyUser(email, phone);
      authService.deleteUser(user);
      Navigator.of(context, rootNavigator: true).pop();
      showSuccess(context);
    } catch (e) {
      print(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      showFail(context);
    }
  }

  void showSuccess(BuildContext ctx) async {
    isLoading = false;
    showDialog(
      context: ctx,
      builder: (ctx) => DialogBox(
          title: "Verification",
          description: "Phone Verification Successful",
          icon: Icons.check,
          iconColor: Colors.teal,
          buttonText1: "",
          button1Func: () {}),
    );
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(ctx, rootNavigator: true).pop();
    Navigator.of(ctx).pushReplacement(
        MaterialPageRoute(builder: (_) => ProfileSetup(widget.email)));
  }

  void showFail(BuildContext ctx) {
    isLoading = false;
    showDialog(
      context: ctx,
      builder: (ctx) => DialogBox(
          title: "Verification",
          description: "Phone Verification Failed",
          icon: Icons.clear,
          iconColor: Colors.red,
          buttonText1: "OK",
          button1Func: () {
            Navigator.of(ctx, rootNavigator: true).pop();
          }),
    );
  }
}
