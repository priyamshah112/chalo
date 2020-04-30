import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'data/data.dart';
import 'package:chaloapp/login.dart';
import 'package:chaloapp/global_colors.dart';
import 'package:chaloapp/data/activity.dart';

class ProfileSetup extends StatefulWidget {
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

List<List<String>> activityList = [
  ['images/Activities/Beach.png', 'Beach'],
  ['images/Activities/BirdWatching.png', 'Bird Watching'],
  ['images/Activities/Canoeing.png', 'Caneoing'],
  ['images/Activities/Hiking.png', 'Hiking'],
  ['images/Activities/BeachBBQ.png', 'Beach BBQ'],
  ['images/Activities/Camping.png', 'Camping'],
  ['images/Activities/Cycling.png', 'Cycling'],
  ['images/Activities/DogWalking.png', 'Dog Walking'],
  ['images/Activities/Fishing.png', 'Fishing'],
  ['images/Activities/Gardening.png', 'Gardening'],
  ['images/Activities/Gym.png', 'Gym'],
  ['images/Activities/MountainBiking.png', 'Mountain Biking'],
  ['images/Activities/Picnic.png', 'Picnic'],
  ['images/Activities/Kayaking.png', 'Kayaking'],
  ['images/Activities/Museum.png', 'Museum'],
  ['images/Activities/Beach.png', 'Beach'],
  ['images/Activities/BirdWatching.png', 'Bird Watching'],
  ['images/Activities/Canoeing.png', 'Caneoing'],
  ['images/Activities/Hiking.png', 'Hiking'],
  ['images/Activities/BeachBBQ.png', 'Beach BBQ'],
  ['images/Activities/Camping.png', 'Camping'],
  ['images/Activities/Cycling.png', 'Cycling'],
  ['images/Activities/DogWalking.png', 'Dog Walking'],
  ['images/Activities/Fishing.png', 'Fishing'],
  ['images/Activities/Gardening.png', 'Gardening'],
  ['images/Activities/Gym.png', 'Gym'],
  ['images/Activities/MountainBiking.png', 'Mountain Biking'],
  ['images/Activities/Picnic.png', 'Picnic'],
  ['images/Activities/Kayaking.png', 'Kayaking'],
  ['images/Activities/Museum.png', 'Museum'],
];
List<List<String>> selectedActivityList = [];

class _ProfileSetupState extends State<ProfileSetup> {
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
                                  "0 Followings",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(secondary),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {},
                                child: Text(
                                  "0 Followers",
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
                                bool contains = false;
                                for (int j = 0;
                                    j < selectedActivityList.length;
                                    j++) {
                                  if (activityList[i][0] ==
                                          selectedActivityList[j][0] &&
                                      activityList[i][1] ==
                                          selectedActivityList[j][1]) {
                                    contains = true;
                                    break;
                                  }
                                }
                                print(contains);
                                if (!contains)
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
                                child: ListTile(
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileSetup()),
                          );
                        },
                        child: Center(
                          child: Text(
                            "Finish",
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
                      bool contains = false;
                      for (int j = 0; j < selectedActivityList.length; j++) {
                        if (activityList[i][0] == selectedActivityList[j][0] &&
                            activityList[i][1] == selectedActivityList[j][1]) {
                          contains = true;
                          break;
                        }
                      }
                      print(contains);
                      if (!contains)
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
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              activityList[i][0],
                              width: 60,
                              height: 60,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              activityList[i][1],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(secondary),
                              ),
                            ),
                          ],
                        ),
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
