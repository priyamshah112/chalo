import 'package:chaloapp/login.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chaloapp/Animation/FadeAnimation.dart';
import 'package:chaloapp/global_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_selection/gender_selection.dart';
import 'package:chaloapp/ProfileSetup.dart';
import 'data/activity.dart';

class AddActivity extends StatefulWidget {
  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(primary),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Broadcast Activity',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      hintText: "Search for an Activities",
                                      prefixIcon: Icon(
                                        Icons.search,
                                      ),
                                      suffixIcon: Material(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewActivity(),
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.format_list_bulleted,
                                            color: Color(primary),
                                          ),
                                        ),
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
                                Text(
                                  "Your Activities",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(secondary),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 109,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      for (int i = 0;
                                          i < AllselectedActivityList.length;
                                          i++)
                                        Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(primary),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            width: 110,
                                            child: ListTile(
                                              title: Image.asset(
                                                AllselectedActivityList[i][0],
                                                width: 60,
                                                height: 60,
                                              ),
                                              subtitle: Container(
                                                padding:
                                                    EdgeInsets.only(top: 7),
                                                child: Text(
                                                  AllselectedActivityList[i][1],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(secondary),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    //obscureText: true,
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
                              color: Color(secondary),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              onPressed: () {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (BuildContext context) =>
//                                          NextPage()),
//                                );
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
