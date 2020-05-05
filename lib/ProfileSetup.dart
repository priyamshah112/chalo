import 'dart:async';
import 'dart:io';
import 'package:chaloapp/home.dart';
import 'package:chaloapp/services/AuthService.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/User.dart';
import 'data/data.dart';
import 'package:chaloapp/login.dart';
import 'package:chaloapp/global_colors.dart';
import 'package:chaloapp/data/activity.dart';

class ProfileSetup extends StatefulWidget {
  final User user;
  ProfileSetup({this.user});
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
      ['images/activities/Beach.png', 'Beach', 'true'],
      ['images/activities/BirdWatching.png', 'Bird Watching', 'true'],
      ['images/activities/Canoeing.png', 'Caneoing', 'true'],
      ['images/activities/Hiking.png', 'Hiking', 'true'],
      ['images/activities/BeachBBQ.png', 'Beach BBQ', 'true'],
      ['images/activities/Camping.png', 'Camping', 'true'],
      ['images/activities/Cycling.png', 'Cycling', 'true'],
      ['images/activities/DogWalking.png', 'Dog Walking', 'true'],
      ['images/activities/Fishing.png', 'Fishing', 'true'],
      ['images/activities/Gardening.png', 'Gardening', 'true'],
      ['images/activities/Gym.png', 'Gym', 'true'],
      ['images/activities/MountainBiking.png', 'Mountain Biking', 'true'],
      ['images/activities/Picnic.png', 'Picnic', 'true'],
      ['images/activities/Kayaking.png', 'Kayaking', 'true'],
      ['images/activities/Museum.png', 'Museum', 'true'],
    ];
    selectedActivityList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Profile Setup",
          style: TextStyle(
            color: Color(secondary),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
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
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/bgcover.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Abdul Quadir",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(primary),
                              fontSize: 22,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {},
                                child: Text(
                                  "0 \n Following",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(secondary),
                                  ),
                                ),
                              ),
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {},
                                child: Text(
                                  "0 \n Followers",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(secondary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    thickness: 1,
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
                                  builder: (context) => AllActivity()));
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
                                activityList[i][2] = 'false';
                                for (int j = 0;
                                    j < selectedActivityList.length;
                                    j++) {
                                  if (activityList[i][0] ==
                                          selectedActivityList[j][0] &&
                                      activityList[i][1] ==
                                          selectedActivityList[j][1]) {
                                    activityList[i][2] = 'true';
                                    break;
                                  }
                                }
                                print(activityList[i][2]);
                                if (activityList[i][2] == 'false')
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
                                    activityList[i][2] == 'false'
                                        ? Container(color: Color(primary))
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
                  SizedBox(
                    height: 10,
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
                    height: 107,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        for (int i = 0; i < selectedActivityList.length; i++)
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
                  ),
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
                            showDialogBox().show_Dialog(
                                child:
                                    Center(child: CircularProgressIndicator()),
                                context: context);
                            AuthService _auth =
                                AuthService(auth: FirebaseAuth.instance);
                            var result = await _auth.signIn(
                                widget.user.email, widget.user.password);
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: ((ctx) => DialogBox(
                                    title: "Done !",
                                    description:
                                        "You've Successfully Signed Up",
                                    buttonText1: "Ok",
                                    button1Func: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((ctx) => MainHome(
                                                  username: result['username'],
                                                  type: result['type']))));
                                    })));
                          } catch (e) {
                            print(e);
                            Navigator.pop(context);
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AllActivity extends StatefulWidget {
  @override
  _AllActivityState createState() => _AllActivityState();
}

class _AllActivityState extends State<AllActivity> {
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
                      activityList[i][2] = 'false';
                      for (int j = 0; j < selectedActivityList.length; j++) {
                        if (activityList[i][0] == selectedActivityList[j][0] &&
                            activityList[i][1] == selectedActivityList[j][1]) {
                          activityList[i][2] = 'true';
                          break;
                        }
                      }
                      print(activityList[i][2]);
                      if (activityList[i][2] == 'false')
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
                          activityList[i][2] == 'false' ? Container(color: Color(primary)): Text(""),
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
