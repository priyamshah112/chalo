import 'dart:io';

import 'package:chaloapp/common/cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_selection/gender_selection.dart';
import '../data/User.dart';
import '../services/DatabaseService.dart';
import '../services/AuthService.dart';
import '../widgets/DailogBox.dart';
import '../widgets/date_time.dart';
import '../Animation/FadeAnimation.dart';
import '../common/global_colors.dart';
import 'phone_verification.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  User user;
  DateTime picked;
  bool _autovalidate = false;
  bool _viewPassword = false;

  @override
  void initState() {
    user = new User();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String password, confirmPassword, gender;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 230,
                child: FadeAnimation(
                    1,
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/loginbg.png'),
                              fit: BoxFit.contain)),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeAnimation(
                      1.5,
                      FittedBox(
                          child: Text(
                        "Tell us your Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(primary),
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            fontFamily: 'Pacifico'),
                      )),
                    ),
                    SizedBox(height: 10),
                    FadeAnimation(
                      1.6,
                      Text(
                        "Signup with",
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
                              onPressed: () => setValues('facebook'),
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
                              onPressed: () => setValues('google'),
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
                    SizedBox(height: 15),
                    FadeAnimation(
                        1.7,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Form(
                            key: _formKey,
                            autovalidate: _autovalidate,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
                                  child: TextFormField(
                                    controller: fnameController,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Enter a First Name";
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        user.setFname(value.trim()),
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    autocorrect: false,
                                    textCapitalization:
                                        TextCapitalization.words,
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
                                    controller: lnameController,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Enter a Last Name";
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        user.setLname(value.trim()),
                                    keyboardType: TextInputType.text,
                                    autocorrect: false,
                                    textCapitalization:
                                        TextCapitalization.words,
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
                                    onShowPicker: (context, initial) =>
                                        DateTimePicker().presentDatePicker(
                                            context,
                                            initial,
                                            DateTime(1900),
                                            DateTime(
                                                DateTime.now().year - 10,
                                                DateTime.now().month,
                                                DateTime.now().day)),
                                    validator: (value) {
                                      DateTime now = DateTime.now();
                                      if (value == null)
                                        return "Select Date of Birth";
                                      else if (value.day == now.day &&
                                          value.month == now.month &&
                                          value.year == now.year) {
                                        print(value.toString());
                                        return "Select Valid Date of Birth";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      user.setBirthDate(
                                          DateFormat('d/MM/y').format(value));
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
                                    controller: emailController,
                                    validator: (value) =>
                                        _validateEmail(value.trim()),
                                    onSaved: (value) =>
                                        user.setEmail(value.trim()),
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
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
                                      ),
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
                                      if (value.trim().length < 6)
                                        return "Minimum 6 characters";
                                      password = value.trim();
                                      return null;
                                    },
                                    obscureText: !_viewPassword,
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
                                      suffixIcon: GestureDetector(
                                          onTap: () => setState(() =>
                                              _viewPassword = !_viewPassword),
                                          child: Icon(
                                            !_viewPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Color(primary),
                                          )),
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
                                      if (value.trim() != password)
                                        return "Passwords need to match";
                                      return null;
                                    },
                                    onChanged: (value) => setState(
                                        () => confirmPassword = value.trim()),
                                    onSaved: (value) =>
                                        user.setPassword(password),
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Confirm Password",
                                      prefixIcon: Icon(
                                        confirmPassword == password &&
                                                password != null
                                            ? Icons.check_circle
                                            : Icons.lock,
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
                                    femaleImage:
                                        AssetImage("images/Female.jpg"),
                                    maleImage: AssetImage("images/Male.jpg"),
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
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                if (gender == null) {
                                  _validateGender(context);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => DialogBox(
                                          title: "Are you Sure ?",
                                          description:
                                              "Make sure all your entered details are correct",
                                          buttonText1: "Check again",
                                          button1Func: () => Navigator.of(
                                                  context,
                                                  rootNavigator: true)
                                              .pop(),
                                          buttonText2: "Yes I'm Sure",
                                          button2Func: () =>
                                              _createUser(context)));
                                }
                              } else
                                setState(() => _autovalidate = true);
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
                            Navigator.pop(context);
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void setValues(String method) async {
    showDialog(
        builder: (ctx) => Center(child: CircularProgressIndicator()),
        context: context);
    Map result = await AuthService().signUp(method);
    if (result['success']) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        emailController.text = result['email'];
        fnameController.text = result['fname'].substring(0, 1).toUpperCase() +
            result['fname'].substring(1);
        lnameController.text = result['lname'].substring(0, 1).toUpperCase() +
            result['lname'].substring(1);
        user.photoUrl = result['photo'];
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
          context: context,
          builder: (ctx) => DialogBox(
              title: "Error :(",
              description: result['msg'],
              buttonText1: "Ok",
              button1Func: () =>
                  Navigator.of(context, rootNavigator: true).pop()));
    }
  }

  void _createUser(BuildContext context) async {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        builder: (ctx) => Center(child: CircularProgressIndicator()),
        context: context);
    Map result = await AuthService()
        .createUser(user.email, user.password, (user.fname + " " + user.lname));
    if (result['success']) {
      user.setUid(result['uid']);
      await DataService().createUser(user);
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
          context: context,
          builder: (ctx) => DialogBox(
              title: "Done !",
              description: "Check your Email for the verification Link",
              buttonText1: "Ok",
              button1Func: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PhoneVerification(
                            email: user.email,
                            password: user.password,
                            photoUrl: user.photoUrl
                          )),
                );
              }));
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
          context: context,
          builder: (ctx) => DialogBox(
              title: "Error :(",
              description: result['error'],
              buttonText1: "Ok",
              button1Func: () =>
                  Navigator.of(context, rootNavigator: true).pop()));
    }
  }
}

void _validateGender(BuildContext context) {
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
                Text("Error", style: TextStyle(color: Color(primary))),
              ],
            ),
            elevation: 5.0,
            content: Text("Please Select a Gender"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK", style: TextStyle(color: Color(primary))),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              )
            ],
          )));
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
