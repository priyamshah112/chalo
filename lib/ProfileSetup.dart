import 'dart:async';
import 'dart:io';
import 'package:chaloapp/home.dart';
import 'package:chaloapp/services/AuthService.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'data/User.dart';
import 'data/data.dart';
import 'package:chaloapp/login.dart';
import 'package:chaloapp/global_colors.dart';
import 'package:chaloapp/data/activity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileSetup extends StatefulWidget {
  final String email, password;
  final AuthCredential creds;
  ProfileSetup({this.email, this.password, this.creds});
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

List<List<String>> selectedActivityList;
List<List<String>> activityList;

class _ProfileSetupState extends State<ProfileSetup> {
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
  }

  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      try {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _image = image;
          print("Image Path $_image");
        });
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "Profile Setup",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          elevation: 1.0,
          backgroundColor: Color(primary),
        ),
        body: SingleChildScrollView(
            child: Stack(overflow: Overflow.visible, children: <Widget>[
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
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Abdul Quadir",
                                style: TextStyle(
                                  color: Color(secondary),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                ),
                                color: Color(primary),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Male, 22"),
                              Text("English"),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Text(
                                    "0 Followers",
                                    style: TextStyle(
                                      color: Color(primary),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                onTap: () {},
                                splashColor: Colors.redAccent.shade50,
                              ),
                              InkWell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Text(
                                    "0 Following",
                                    style: TextStyle(
                                      color: Color(primary),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                onTap: () {},
                                splashColor: Colors.redAccent.shade50,
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
                          left: 30.0, bottom: 15.0, top: 15.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Activity Preferences",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(primary),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Select Activities",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(secondary),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => allActivity()));
                        },
                        child: Text(
                          "View all",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(primary),
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
                        for (int i = 0; i < activityList.length; i++)
                          Padding(
                            padding: EdgeInsets.all(2.0),
                            child: InkWell(
                              onTap: () {
                                activityList[i][2] = 'true';
                                for (int j = 0;
                                    j < selectedActivityList.length;
                                    j++) {
                                  if (activityList[i][0] ==
                                          selectedActivityList[j][0] &&
                                      activityList[i][1] ==
                                          selectedActivityList[j][1]) {
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
                                      j < selectedActivityList.length;
                                      j++) {
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
                                    borderRadius: BorderRadius.circular(6)),
                                width: 110,
                                child: Stack(
                                  children: <Widget>[
                                    activityList[i][2] == 'true'
                                        ? Container(
                                            color: Colors.redAccent.shade100)
                                        : Text(''),
                                    ListTile(
                                      title: Image.asset(
                                        activityList[i][0],
                                        width: 60,
                                        height: 60,
                                      ),
                                      subtitle: Container(
                                        padding: EdgeInsets.only(top: 7),
                                        child: Text(
                                          activityList[i][1],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      selectedActivityList.length != 0 ? "Your Activities" : "",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(secondary),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
                                        borderRadius: BorderRadius.circular(6)),
                                    width: 110,
                                    child: ListTile(
                                      title: Image.asset(
                                        selectedActivityList[i][0],
                                        width: 60,
                                        height: 60,
                                      ),
                                      subtitle: Container(
                                        padding: EdgeInsets.only(top: 7),
                                        child: Text(
                                          selectedActivityList[i][1],
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
                        )
                      : Container(),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      child: FlatButton(
                        color: Color(secondary),
                        padding: EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        onPressed: () async {
                          try {
                            showDialog(
                                builder: (ctx) =>
                                    Center(child: CircularProgressIndicator()),
                                context: context);
                            final _auth =
                                AuthService(auth: FirebaseAuth.instance);
                            widget.creds != null
                                ? FirebaseAuth.instance
                                    .signInWithCredential(widget.creds)
                                : _auth.signIn(widget.email, widget.password);
                            await Future.delayed(Duration(seconds: 2));
                            Navigator.of(context, rootNavigator: true).pop();
                            showDialog(
                                context: context,
                                builder: ((ctx) => DialogBox(
                                    title: "Done !",
                                    description:
                                        "You've Successfully Signed Up",
                                    buttonText1: "Ok",
                                    button1Func: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((ctx) => MainHome())));
                                    })));
                          } catch (e) {
                            print(e);
                            Navigator.of(context,rootNavigator: true).pop();
                          }
                        },
                        child: Center(
                          child: Text(
                            selectedActivityList.length == 0
                                ? "Skip & Finish"
                                : "Finish",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
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
                        radius: 100,
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                                : Icon(
                                    Icons.person,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])));
  }
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
            color: Color(secondary),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Done",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        title: Text(
          "All Activities",
          style: TextStyle(
            color: Color(secondary),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
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
                              ? Container(color: Colors.redAccent.shade100)
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
