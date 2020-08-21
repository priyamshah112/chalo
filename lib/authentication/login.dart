import 'package:chaloapp/authentication/phone_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/AuthService.dart';
import '../widgets/DailogBox.dart';
import '../Animation/FadeAnimation.dart';
import '../home/home.dart';
import '../data/User.dart';
import 'ProfileSetup.dart';
import 'forgot.dart';
import 'signup.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var myImage;
  @override
  void initState() {
    super.initState();
    myImage = 'images/bgcover.jpg';
  }

  Future<bool> _onWillPop() {
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage(myImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.dstATop),
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 140.0,
                        ),
                        Text(
                          'Chalo!!!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                        FlatButton(
                          onPressed: () => {},
                          color: Colors.indigo,
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                              ),
                              Text(
                                "Signup using Facebook",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "We don't Post Anything to Facebook",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FlatButton(
                          onPressed: () => {},
                          color: Colors.deepOrangeAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                              ),
                              Text(
                                "Signup using Google",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FlatButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SignUp()),
                            )
                          },
                          color: Color(0xfff001730),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.userPlus,
                                color: Colors.white,
                                size: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                              ),
                              Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FittedBox(
                                    child: Text(
                                      'Already have an account ?',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((ctx) => HomePage())));
                                    },
                                    child: FittedBox(
                                      child: Text(
                                        'Sign in',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: FittedBox(
                                  child: Text(
                                    'By continuing you agree to our',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((ctx) =>
                                                    HomePage()))),
                                        child: FittedBox(
                                          child: Text(
                                            'Terms and Conditions',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "  and  ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        // onTap: () => Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: ((ctx) =>
                                        //             ProfileSetup()))),
                                        child: FittedBox(
                                          child: Text(
                                            'Privacy Policy',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password;
  bool _autovalidate = false;
  TextEditingController _emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: _autovalidate,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FadeAnimation(
                        1.5,
                        Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xffFE4A49),
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              fontFamily: 'Pacifico'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                        1.6,
                        Text(
                          "login with",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff003854),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      FadeAnimation(
                        1.7,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: ((ctx) => Center(
                                          child: CircularProgressIndicator())));
                                  final result =
                                      await AuthService().facebookSignIn();
                                  login(result);
                                },
                                color: Colors.indigo,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.facebook,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        child: Text(
                                          "Facebook",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Expanded(
                              child: FlatButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: ((ctx) => Center(
                                          child: CircularProgressIndicator())));
                                  final result =
                                      await AuthService().googleSignIn();
                                  login(result);
                                },
                                color: Colors.deepOrangeAccent,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.google,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        child: Text(
                                          "Google",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      FadeAnimation(
                        1.7,
                        Text(
                          "or",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff003854),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
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
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) =>
                                        _validateEmail(value.trim()),
                                    onSaved: (value) => email = value.trim(),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email Address",
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Color(0xfffFE4A49),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 30.0,
                                          bottom: 18.0,
                                          top: 18.0,
                                          right: 0.0),
                                      filled: true,
                                      fillColor: Color(0xffffaf4ff),
                                      hintStyle: TextStyle(
                                        color: Color(0xfff001730),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.length < 6)
                                        return "Minimum 6 characters";
                                      else
                                        return null;
                                    },
                                    onSaved: (value) => password = value,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xffffaf4ff),
                                      contentPadding: const EdgeInsets.only(
                                          left: 30.0,
                                          bottom: 18.0,
                                          top: 18.0,
                                          right: 30.0),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(0xfffFE4A49),
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                        color: Color(0xfff001730),
                                      ),
                                    ),
                                    obscureText: true,
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                        1.7,
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForgotPage(
                                            email: _emailController.text)),
                              );
                            },
                            child: Text(
                              "Forgot password ?",
                              style: TextStyle(
                                  color: Color(0xfff001730),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          1.9,
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 60),
                            child: FlatButton(
                              color: Color(0xfff003854),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  FocusScope.of(_scaffoldKey.currentContext)
                                      .unfocus();
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => Center(
                                          child: CircularProgressIndicator()));
                                  final result = await AuthService()
                                      .signIn(email, password);
                                  login(result);
                                } else {
                                  setState(() {
                                    _autovalidate = true;
                                  });
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        2,
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SignUp()),
                            );
                          },
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                color: Color(0xfff001730),
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(Map result) async {
    if (result['success']) {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
          context: context,
          builder: ((ctx) => DialogBox(
              icon: Icons.verified_user,
              title: "Login Successful",
              description: "",
              buttonText1: "",
              button1Func: () {})));
      await Future.delayed(Duration(seconds: 2));
      bool verified = await UserData.checkVerified();
      bool completed = await UserData.checkProfileSetup();
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushReplacement(
        _scaffoldKey.currentContext,
        MaterialPageRoute(
          builder: (BuildContext context) => verified
              ? completed ? MainHome() : ProfileSetup(result['email'])
              : PhoneVerification(creds: result.containsKey('credentials')
                          ? result['credentials']
                          : null,
                      password: result.containsKey('password')
                          ? result['password']
                          : null,
                      email: result['email']
),
        ),
      );
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
          context: context,
          builder: (ctx) => DialogBox(
                title: "Login Failed :(",
                description: result['msg'],
                buttonText1: "OK",
                button1Func: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              ));
    }
  }
}

String _validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}
