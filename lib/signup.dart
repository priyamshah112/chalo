import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chaloapp/Animation/FadeAnimation.dart';
import 'package:chaloapp/global_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_selection/gender_selection.dart';
import 'package:chaloapp/ProfileSetup.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'forgot.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  User user;
  DateTime picked;
  bool checkPassword = false;
  bool _autovalidate = false;

  Future<DateTime> _presentDatePicker(
      BuildContext contex, DateTime date) async {
    picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: picked == null ? DateTime.now() : picked,
        lastDate: DateTime.now());
    return picked;
  }

  @override
  void initState() {
    user = new User();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    String password, gender;
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
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
                              color: Color(primary),
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
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Enter a First Name";
                                      return null;
                                    },
                                    onSaved: (value) => user.setFname(value),
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "First Name",
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.userPlus,
                                        color: Color(primary),
                                        size: 18,
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
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Enter a Last Name";
                                      return null;
                                    },
                                    onSaved: (value) => user.setLname(value),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(form1),
                                      contentPadding: const EdgeInsets.only(
                                          left: 30.0,
                                          bottom: 18.0,
                                          top: 18.0,
                                          right: 30.0),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.userPlus,
                                        color: Color(primary),
                                        size: 18,
                                      ),
                                      hintText: "Last Name",
                                      hintStyle: TextStyle(
                                        color: Color(formHint),
                                      ),
                                    ),
                                    autofocus: false,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
                                  child: DateTimeField(
                                    format: DateFormat('d/MM/y'),
                                    onShowPicker: _presentDatePicker,
                                    validator: (value) {
                                      String date = DateTime.now()
                                          .toString()
                                          .substring(0, 10);
                                      if (value == null)
                                        return "Select Date of Birth";
                                      else if (value
                                              .toString()
                                              .substring(0, 10) ==
                                          date) {
                                        print(value.toString());
                                        return "Select Valid Date of Birth";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      user.setBirthDate(
                                          value.toString().substring(0, 10));
                                    },
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(form1),
                                      contentPadding: const EdgeInsets.only(
                                          left: 30.0,
                                          bottom: 18.0,
                                          top: 18.0,
                                          right: 30.0),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.calendar,
                                        color: Color(primary),
                                        size: 18,
                                      ),
                                      hintText: "Birth Date",
                                      hintStyle: TextStyle(
                                        color: Color(formHint),
                                      ),
                                    ),
                                    autofocus: false,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
                                  child: TextFormField(
                                    validator: _validateEmail,
                                    onSaved: (value) => user.setEmail(value),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email Address",
                                      prefixIcon: Icon(
                                        Icons.mail,
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
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.length < 6)
                                        return "Minimum 6 characters";
                                      password = value;
                                      return null;
                                    },
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(form1),
                                      contentPadding: const EdgeInsets.only(
                                          left: 30.0,
                                          bottom: 18.0,
                                          top: 18.0,
                                          right: 30.0),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(primary),
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                        color: Color(formHint),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value != password)
                                        return "Passwords need to match";
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        user.setPassword(password),
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Confirm Password",
                                      prefixIcon: Icon(
                                        Icons.lock,
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
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'Select your Gender',
                                  style: TextStyle(
                                    color: Color(secondary),
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
                                    onChanged: (Gender _gender) {
                                      gender = _gender.toString().substring(7);
                                      user.setGender(gender);
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
                              color: Color(secondary),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  if (gender == null) {
                                    showDialog(
                                        context: context,
                                        builder: ((ctx) => AlertDialog(
                                              title: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.error,
                                                    color: Color(primary),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Error",
                                                      style: TextStyle(
                                                          color:
                                                              Color(primary))),
                                                ],
                                              ),
                                              elevation: 5.0,
                                              content: Text(
                                                  "Please Select a Gender"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("OK",
                                                      style: TextStyle(
                                                          color:
                                                              Color(primary))),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                )
                                              ],
                                            )));
                                  } else {
                                    print(user.fname);
                                    print(user.lname);
                                    print(user.birthDate);
                                    print(user.email);
                                    print(user.password);
                                    print(user.gender);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              NextPage(user: user)),
                                    );
                                  }
                                } else {
                                  setState(() {
                                    _autovalidate = true;
                                  });
                                }
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
                                  color: Color(secondary),
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
  final User user;
  const NextPage({Key key, this.user}) : super(key: key);
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Form(
      autovalidate: _autovalidate,
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
                              color: Color(primary),
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
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.length != 10)
                                      return "Enter 10-digit Phone No";
                                    return null;
                                  },
                                  onSaved: (value) =>
                                      widget.user.setPhone(value),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Contact Number",
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
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(form1),
                                    contentPadding: const EdgeInsets.only(
                                        left: 30.0,
                                        bottom: 18.0,
                                        top: 18.0,
                                        right: 30.0),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Color(primary),
                                    ),
                                    hintText: "Enter OTP",
                                    hintStyle: TextStyle(
                                      color: Color(formHint),
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
                                  color: Color(secondary),
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
                              color: Color(secondary),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  print(widget.user.phone);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileSetup(user: widget.user)),
                                  );
                                } else {
                                  setState(() {
                                    _autovalidate = true;
                                  });
                                }
                              },
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
                                  color: Color(secondary),
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
                        Row(
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

String _validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}
