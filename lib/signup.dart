import 'package:chaloapp/login.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chaloapp/Animation/FadeAnimation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_selection/gender_selection.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Scaffold(
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
                        Text(
                          "Tell us your Details",
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
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                    bottom: BorderSide(
//                                      color: Colors.grey[200],
//                                    ),
//                                  ),
//                                ),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "First Name",
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.userPlus,
                                        color: Color(0xfffFE4A49),
                                        size: 18,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 30.0,
                                          bottom: 18.0,
                                          top: 18.0,
                                          right: 30.0),
                                      filled: true,
                                      fillColor: Color(0xffffaf4ff),
                                      hintStyle: TextStyle(
                                        color: Color(0xfff001730),
                                      ),
//                                    focusedBorder: OutlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.white),
//                                    ),
//                                    enabledBorder: UnderlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.indigo),
//                                    ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
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
                                        FontAwesomeIcons.userPlus,
                                        color: Color(0xfffFE4A49),
                                        size: 18,
                                      ),
                                      hintText: "Last Name",
                                      hintStyle: TextStyle(
                                        color: Color(0xfff001730),
                                      ),
                                    ),
                                    autofocus: false,
                                    //obscureText: true,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                    bottom: BorderSide(
//                                      color: Colors.grey[200],
//                                    ),
//                                  ),
//                                ),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
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
                                          right: 30.0),
                                      filled: true,
                                      fillColor: Color(0xffffaf4ff),
                                      hintStyle: TextStyle(
                                        color: Color(0xfff001730),
                                      ),
//                                    focusedBorder: OutlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.white),
//                                    ),
//                                    enabledBorder: UnderlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.indigo),
//                                    ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
                                  child: TextField(
                                    obscureText: true,
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
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                    bottom: BorderSide(
//                                      color: Colors.grey[200],
//                                    ),
//                                  ),
//                                ),
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Confirm Password",
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Color(0xfffFE4A49),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 30.0,
                                          bottom: 18.0,
                                          top: 18.0,
                                          right: 30.0),
                                      filled: true,
                                      fillColor: Color(0xffffaf4ff),
                                      hintStyle: TextStyle(
                                        color: Color(0xfff001730),
                                      ),
//                                    focusedBorder: OutlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.white),
//                                    ),
//                                    enabledBorder: UnderlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.indigo),
//                                    ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'Select your Gender',
                                  style: TextStyle(
                                    color: Color(0xfff001730),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
                                  child: GenderSelection(
                                    femaleImage: NetworkImage(
                                        "https://cdn1.iconfinder.com/data/icons/website-internet/48/website_-_female_user-512.png"),
                                    maleImage: NetworkImage(
                                        "https://icon-library.net/images/avatar-icon/avatar-icon-4.jpg"),
                                    selectedGenderTextStyle: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),

                                    maleText: "Male", //default Male
                                    femaleText: "Female", //default Female

                                    selectedGenderIconBackgroundColor:
                                        Colors.indigo, // default red
                                    checkIconAlignment: Alignment
                                        .bottomCenter, // default bottomRight
                                    selectedGenderCheckIcon:
                                        Icons.check, // default Icons.check
                                    onChanged: (Gender gender) {
                                      Icon(FontAwesomeIcons.male);
                                      print(gender);
                                    },
                                    equallyAligned: true,
                                    animationDuration:
                                        Duration(milliseconds: 400),
                                    isCircular: true, // default : true,
                                    isSelectedGenderIconCircular: true,
                                    opacityOfGradient: 0.6,
                                    padding: const EdgeInsets.all(3),
                                    size: 120, //default : 120
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20,
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          NextPage()),
                                );
                              },
                              child: Center(
                                child: Text(
                                  "Next",
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
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        WelcomeScreen()),
                              );
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(
                                  color: Color(0xfff001730),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Platform.isIOS ? 10 : 40,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
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
                        Text(
                          "We need to verify you",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xffFE4A49),
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              fontFamily: 'Pacifico'),
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
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                    bottom: BorderSide(
//                                      color: Colors.grey[200],
//                                    ),
//                                  ),
//                                ),
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Contact Number",
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Color(0xfffFE4A49),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 30.0,
                                        bottom: 18.0,
                                        top: 18.0,
                                        right: 30.0),
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
                                child: TextField(
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
                                    hintText: "Enter OTP",
                                    hintStyle: TextStyle(
                                      color: Color(0xfff001730),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      FadeAnimation(
                        2,
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignUp()),
                              );
                            },
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                  color: Color(0xfff001730),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.9,
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 60),
                            child: FlatButton(
                              color: Color(0xfffFE4A49),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              onPressed: () {},
                              child: Center(
                                child: Text(
                                  "Verify",
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
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignUp()),
                              );
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(
                                  color: Color(0xfff001730),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
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
                                color: Color(0xfff003854),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FadeAnimation(
                        2.2,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              textColor: Colors.red,
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
                                color: Color(0xfff003854),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              textColor: Colors.red,
                              child: Text(
                                ' Privacy Policy',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
