import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/home.dart';
import 'package:chaloapp/login.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:chaloapp/widgets/date_time.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'services/AuthService.dart';
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
  bool _viewPassword = false;

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
                                    onShowPicker: (context, _) =>
                                        DateTimePicker().presentDatePicker(
                                            context,
                                            DateTime(1900),
                                            DateTime.now()),
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
                                          onTap: () {
                                            setState(() {
                                              _viewPassword = !_viewPassword;
                                            });
                                          },
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
                                    showDialogBox().show_Dialog(
                                        context: context,
                                        child: DialogBox(
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _createUser(BuildContext context) async {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        builder: (ctx) => Center(child: CircularProgressIndicator()),
        context: context);
    AuthService _auth = AuthService(auth: FirebaseAuth.instance);
    Map result = await _auth.createUser(
        user.email, user.password, (user.fname + " " + user.lname));
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

class PhoneVerification extends StatefulWidget {
  final AuthCredential creds;
  final String email, password;
  const PhoneVerification(
      {Key key, @required this.email, this.creds, this.password})
      : super(key: key);
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autovalidate = false;
  bool _codeSent = false;
  String _verificaionId;
  String _phone;
  String _smsCode;

  Future<bool> onBack() async {
    final user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      AuthService _auth = AuthService(auth: FirebaseAuth.instance);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await _auth.signOut(prefs.getString('type'));
    }
    await Navigator.pushReplacement(
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
                                              else
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
                        FadeAnimation(
                            1.9,
                            Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: FlatButton(
                                color: Color(secondary),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 60.0, vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0)),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    FocusScope.of(context).unfocus();
                                    showDialog(
                                        builder: (ctx) => Center(
                                            child: CircularProgressIndicator()),
                                        context: context);
                                    AuthService _auth = AuthService(
                                        auth: FirebaseAuth.instance);
                                    bool result =
                                        await _auth.verifyPhone(_phone);
                                    if (result) {
                                      _codeSent
                                          ? await signInwithOTP(_verificaionId,
                                              _smsCode, _phone, widget.email)
                                          : await verifyOTP(
                                              widget.email, _phone);
                                    } else {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => DialogBox(
                                              title: "Error :(",
                                              description:
                                                  "This Phone number is already registered and verified \nTry again with another phone number ",
                                              buttonText1: "OK",
                                              button1Func: () => Navigator.of(
                                                      context,
                                                      rootNavigator: true)
                                                  .pop()));
                                    }
                                  } else {
                                    setState(() {
                                      _autovalidate = true;
                                    });
                                  }
                                },
                                child: Text(
                                  _codeSent ? "Verify" : "Send OTP",
                                  style: TextStyle(color: Colors.white),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyOTP(String email, String phone) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    phone = "+91" + phone;
    await auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential creds) async {
          FirebaseUser user = (await auth.signInWithCredential(creds)).user;
          DataService().verifyUser(email, phone);
          AuthService(auth: FirebaseAuth.instance).deleteUser(user);
          Navigator.of(context, rootNavigator: true).pop();
          showSuccess(context, email, widget.password, widget.creds);
        },
        verificationFailed: (AuthException e) {
          print(e.code + "\n" + e.message);
          Navigator.of(context, rootNavigator: true).pop();
          showFail(context);
        },
        codeSent: (verID, [int forceResend]) async {
          print('code sent');
          setState(() {
            _verificaionId = verID;
            _codeSent = true;
          });
          Navigator.of(context, rootNavigator: true).pop();
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: Text('Verification Code Sent'),
            duration: Duration(seconds: 2),
          ));
        },
        codeAutoRetrievalTimeout: (verID) => {});
  }

  Future<void> signInwithOTP(verID, smsCode, phone, email) async {
    showDialog(
        context: context,
        builder: (ctx) => Center(child: CircularProgressIndicator()));
    AuthCredential creds = PhoneAuthProvider.getCredential(
        verificationId: verID, smsCode: smsCode);
    try {
      FirebaseUser user =
          (await FirebaseAuth.instance.signInWithCredential(creds)).user;
      DataService().verifyUser(email, phone);
      AuthService(auth: FirebaseAuth.instance).deleteUser(user);
      Navigator.of(context, rootNavigator: true).pop();
      showSuccess(context, email, widget.password, widget.creds);
    } catch (e) {
      print(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      showFail(context);
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

void showSuccess(BuildContext context, String email, String password,
    AuthCredential creds) async {
  showDialog(
      builder: (ctx) => DialogBox(
          title: "Verification",
          description: "Phone Verification Successful",
          icon: Icons.check,
          iconColor: Colors.teal,
          buttonText1: "",
          button1Func: () {}),
      context: context);
  await Future.delayed(Duration(seconds: 2));
  Navigator.of(context, rootNavigator: true).pop();
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (contex) =>
              ProfileSetup(email: email, password: password, creds: creds)));
}

void showFail(BuildContext context) {
  showDialog(
      builder: (ctx) => DialogBox(
          title: "Verification",
          description: "Phone Verification Failed",
          icon: Icons.clear,
          iconColor: Colors.red,
          buttonText1: "OK",
          button1Func: () => Navigator.of(context, rootNavigator: true).pop()),
      context: context);
}
