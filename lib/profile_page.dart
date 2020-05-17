import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:chaloapp/edit_profile_page.dart';
import 'package:chaloapp/home.dart';
import 'package:chaloapp/post_details.dart';
import 'package:chaloapp/services/AuthService.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'data/User.dart';

import 'package:chaloapp/global_colors.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage({this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

List<List<String>> selectedActivityList;
List<List<String>> activityList;
List<List<String>> postList;
final String username = "Abdul Quadir Ansari";
final String userDp = "images/bgcover.jpg";

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    activityList = [
      ['images/activities/Beach.png', 'Beach', 'false'],
      ['images/activities/BirdWatching.png', 'Bird Watching', 'false'],
      ['images/activities/Canoeing.png', 'Caneoing', 'false'],
      ['images/activities/Hiking.png', 'Hiking', 'false'],
      ['images/activities/BeachBBQ.png', 'Beach BBQ', 'false'],
      ['images/activities/Camping.png', 'Camping', 'false'],
      ['images/activities/Cycling.png', 'Cycling', 'false'],
      ['images/activities/DogWalking.png', 'Dog Walking', 'false'],
      ['images/activities/Fishing.png', 'Fishing', 'false'],
      ['images/activities/Gardening.png', 'Gardening', 'false'],
      ['images/activities/Gym.png', 'Gym', 'false'],
      ['images/activities/MountainBiking.png', 'Mountain Biking', 'false'],
      ['images/activities/Picnic.png', 'Picnic', 'false'],
      ['images/activities/Kayaking.png', 'Kayaking', 'false'],
      ['images/activities/Museum.png', 'Museum', 'false'],
    ];
    selectedActivityList = [];

    postList = [
      ['images/post/1.png', "Beach BBQ", 'Caption 1', "30 min ago"],
      ['images/post/2.jpeg', "Camping", 'Caption 2', "2 day ago"],
      ['images/post/3.png', "Cycling", 'Caption 3', '2 PM'],
      ['images/post/4.png', "Fishing", 'Caption 4', '2 PM'],
      ['images/post/5.png', "Hiking", 'Caption 5', '2 PM'],
      ['images/post/6.png', "Long Drive", 'Caption 6', '2 PM'],
      ['images/post/7.png', "Museum", 'Caption 7', '2 PM'],
      ['images/post/8.png', "Cricket", 'Caption 8', '2 PM'],
      ['images/post/9.png', "Running", 'Caption 9', '2 PM'],
      ['images/post/10.jpg', "Skiing", 'Caption 10', '2 PM'],
      ['images/post/11.jpg', "Walking", 'Caption 11', '2 PM'],
      ['images/post/12.jpg', "City Tour", 'Caption 12', '2 PM'],
    ];
  }

  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print("Image Path $_image");
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "My Profile",
            style: TextStyle(
              color: Colors.white,
              fontFamily: bodyText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 1.0,
        backgroundColor: Color(primary),
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate([
                  Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(primary),
                                      ),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Abdul Quadir Ansari",
                                            style: TextStyle(
                                              color: Color(primary),
                                              fontSize: 18,
                                              fontFamily: heading,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              size: 18,
                                            ),
                                            color: Color(primary),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        EditProfile()),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.trophy,
                                                color: Colors.amberAccent,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                " 0 activities Done",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: bodyText,
                                                  color: Color(secondary),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Male, 22",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: bodyText,
                                              color: Color(secondary),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Job Title",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: bodyText,
                                                  color: Color(primary),
                                                ),
                                              ),
                                              Text(
                                                "Web Developer",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: bodyText,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Language",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: bodyText,
                                                  color: Color(primary),
                                                ),
                                              ),
                                              Text(
                                                "English",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: bodyText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 5),
                                              child: Text(
                                                "0 Followers",
                                                style: TextStyle(
                                                  fontFamily: bodyText,
                                                  color: Color(primary),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            onTap: () {},
                                            splashColor: Color(background1),
                                          ),
                                          InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 5),
                                              child: Text(
                                                "0 Following",
                                                style: TextStyle(
                                                  color: Color(primary),
                                                  fontFamily: bodyText,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            onTap: () {},
                                            splashColor: Color(background1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                //obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search users",
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(primary),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 30.0,
                                      bottom: 15.0,
                                      top: 15.0,
                                      right: 0.0),
                                  filled: true,
                                  fillColor: Color(form1),
                                  hintStyle: TextStyle(
                                    fontFamily: bodyText,
                                    color: Color(formHint),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.5,
                                color: Color(primary),
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            margin: EdgeInsets.only(top: 20),
                            width: 55.0,
                            height: 55.0,
                            child: CircleAvatar(
                              foregroundColor: Color(primary),
                              backgroundColor: Color(background1),
                              backgroundImage: AssetImage('images/bgcover.jpg'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ]),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              TabBar(
                labelColor: Color(primary),
                unselectedLabelColor: Color(secondary),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    color: Color(background1)),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Activity",
                        style: TextStyle(
                          fontFamily: heading,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "About",
                        style: TextStyle(
                          fontFamily: heading,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Post",
                        style: TextStyle(
                          fontFamily: heading,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    //Activity Tab
                    SingleChildScrollView(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Activity Preferences",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(primary),
                                  fontFamily: heading,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Select Activities",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: heading,
                                      color: Color(secondary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  allActivity()));
                                    },
                                    child: Text(
                                      "View all",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(primary),
                                        fontFamily: heading,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 107,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    for (int i = 0;
                                        i < activityList.length;
                                        i++)
                                      Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: InkWell(
                                          onTap: () {
                                            activityList[i][2] = 'true';
                                            for (int j = 0;
                                                j < selectedActivityList.length;
                                                j++) {
                                              if (activityList[i][0] ==
                                                      selectedActivityList[j]
                                                          [0] &&
                                                  activityList[i][1] ==
                                                      selectedActivityList[j]
                                                          [1]) {
                                                activityList[i][2] = 'false';
                                                break;
                                              }
                                            }
                                            print(activityList[i][2]);
                                            if (activityList[i][2] == 'true')
                                              setState(() {
                                                selectedActivityList.add([
                                                  activityList[i][0],
                                                  activityList[i][1],
                                                ]);
                                              });
                                            else
                                              for (int j = 0;
                                                  j <
                                                      selectedActivityList
                                                          .length;
                                                  j++) {
                                                if (activityList[i][0] ==
                                                        selectedActivityList[j]
                                                            [0] &&
                                                    activityList[i][1] ==
                                                        selectedActivityList[j]
                                                            [1]) {
                                                  selectedActivityList
                                                      .removeAt(j);
                                                  break;
                                                }
                                              }
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(primary),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            width: 110,
                                            child: Stack(
                                              children: <Widget>[
                                                activityList[i][2] == 'true'
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: Colors
                                                              .green.shade100,
                                                        ),
                                                      )
                                                    : Text(''),
                                                ListTile(
                                                  title: Image.asset(
                                                    activityList[i][0],
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                  subtitle: Container(
                                                    padding:
                                                        EdgeInsets.only(top: 7),
                                                    child: Text(
                                                      activityList[i][1],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: bodyText,
                                                        color: Color(secondary),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              selectedActivityList.length != 0
                                  ? Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        "Your Activities",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(secondary),
                                          fontFamily: heading,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : Text(""),
                              selectedActivityList.length != 0
                                  ? Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      height: 107,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          for (int i = 0;
                                              i < selectedActivityList.length;
                                              i++)
                                            Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color(primary),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                width: 110,
                                                child: ListTile(
                                                  title: Image.asset(
                                                    selectedActivityList[i][0],
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                  subtitle: Container(
                                                    padding:
                                                        EdgeInsets.only(top: 7),
                                                    child: Text(
                                                      selectedActivityList[i]
                                                          [1],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontFamily: bodyText,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(secondary),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              Text(
                                "Invite Recieve Radius",
                                style: TextStyle(
                                  color: Color(primary),
                                  fontFamily: heading,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                      color: Color(primary),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: SelectRadius(),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //About Tab
                    SingleChildScrollView(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "About Me",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(primary),
                                  fontFamily: heading,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Hello! I’m Abdul Quadir Ansari. Web Developer specializing in front end development. Experienced with all stages of the development cycle for dynamic web projects. Well-versed in numerous programming languages including JavaScript, SQL, and C. Strong background in project management and customer relations.also I am good at wordpress.",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: bodyText,
                                  color: Color(secondary),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Job Title",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Web Developer",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Languages",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "English",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Gender",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Male",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Contact",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "+91 7738413265",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "abdulquadir.a@somaiya.edu",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Country",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "India",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "State",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Maharashtra",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "City",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Mumbai",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Social Information",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(primary),
                                  fontFamily: heading,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Facebook",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "facebook.com",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Instagram",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "instagram.com",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Linkedin",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "linkedin.com",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Twitter",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "twitter.com",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Website/blog",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: heading,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "abdulquadir.co",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //Post Tab
                    ListView(
                      children: <Widget>[
                        Container(
                          child: Wrap(
                            children: <Widget>[
                              for (int i = 0; i < postList.length; i++)
                                Container(
                                  height: MediaQuery.of(context).size.width / 3,
                                  width: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(postList[i][0]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PostItem(
                                            dp: userDp,
                                            name: username,
                                            img: postList[i][0],
                                            activityName: postList[i][1],
                                            caption: postList[i][2],
                                            time: postList[i][3],
                                          ),
                                        ),
                                      );
                                    },
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
            ],
          ),
        ),
      ),
    );
  }

  List<String> RadiusListItems = [
    "Less than 5 kilometers",
    "Less than 10 kilometers",
    "Less than 15 kilometers",
    "Less than 20 kilometers",
    "Less than 25 kilometers",
    "Less than 50 kilometers",
    "Less than 100 kilometers"
  ];
  String radius = "Less than 5 kilometers";
  DropdownButton SelectRadius() => DropdownButton<String>(
        items: [
          for (int i = 0; i < RadiusListItems.length; i++)
            DropdownMenuItem(
              value: RadiusListItems[i],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    RadiusListItems[i],
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(secondary),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    RadiusListItems[i] == radius ? Icons.check : null,
                  ),
                ],
              ),
            ),
        ],
        onChanged: (value) {
          setState(() {
            radius = value;
            print(radius);
          });
        },
        icon: Icon(Icons.arrow_downward),
        iconSize: 20.0,
        iconEnabledColor: Color(primary),
        underline: Container(),
        hint: Text(
          radius,
          style: TextStyle(
            color: Colors.black,
            fontFamily: bodyText,
          ),
        ),
        elevation: 0,
        isExpanded: true,
      );
}

class allActivity extends StatefulWidget {
  @override
  _allActivityState createState() => _allActivityState();
}

class _allActivityState extends State<allActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: bodyText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        title: Center(
          child: Text(
            "All Activities",
            style: TextStyle(
              color: Colors.white,
              fontFamily: bodyText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 1.0,
        backgroundColor: Color(primary),
      ),
      body: SafeArea(
        child: Container(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: 3,
            children: <Widget>[
              for (int i = 0; i < activityList.length; i++)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  child: InkWell(
                    onTap: () {
                      activityList[i][2] = 'true';
                      for (int j = 0; j < selectedActivityList.length; j++) {
                        if (activityList[i][0] == selectedActivityList[j][0] &&
                            activityList[i][1] == selectedActivityList[j][1]) {
                          activityList[i][2] = 'false';
                          break;
                        }
                      }
                      print(activityList[i][2]);
                      if (activityList[i][2] == 'true')
                        setState(() {
                          selectedActivityList.add([
                            activityList[i][0],
                            activityList[i][1],
                          ]);
                        });
                      else
                        for (int j = 0; j < selectedActivityList.length; j++) {
                          if (activityList[i][0] ==
                                  selectedActivityList[j][0] &&
                              activityList[i][1] ==
                                  selectedActivityList[j][1]) {
                            selectedActivityList.removeAt(j);
                            break;
                          }
                        }
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(primary),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Stack(
                        children: <Widget>[
                          activityList[i][2] == 'true'
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.green.shade100,
                                  ),
                                )
                              : Text(""),
                          Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                Image.asset(
                                  activityList[i][0],
                                  width: 60,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FittedBox(
                                  child: Text(
                                    activityList[i][1],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: bodyText,
                                      fontWeight: FontWeight.bold,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
