import 'dart:async';
import 'dart:io';
import 'package:chaloapp/home.dart';
import 'package:flutter/material.dart';
import 'package:chaloapp/login.dart';
import 'package:chaloapp/global_colors.dart';
import 'package:chaloapp/data/activity.dart';

List<List<String>> AllactivityList = [
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
List<List<String>> AllselectedActivityList = [
  ['images/Activities/BirdWatching.png', 'Bird Watching'],
  ['images/Activities/Canoeing.png', 'Caneoing'],
  ['images/Activities/Hiking.png', 'Hiking'],
  ['images/Activities/Kayaking.png', 'Kayaking'],
  ['images/Activities/Museum.png', 'Museum'],
];

class ViewActivity extends StatefulWidget {
  @override
  _ViewActivityState createState() => _ViewActivityState();
}

class _ViewActivityState extends State<ViewActivity> {
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
              for (int i = 0; i < AllactivityList.length; i++)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  child: InkWell(
                    onTap: () {
                      bool contains = false;
                      for (int j = 0; j < AllselectedActivityList.length; j++) {
                        if (AllactivityList[i][0] ==
                                AllselectedActivityList[j][0] &&
                            AllactivityList[i][1] ==
                                AllselectedActivityList[j][1]) {
                          contains = true;
                          break;
                        }
                      }
                      print(contains);
                      if (!contains)
                        setState(() {
                          AllselectedActivityList.add([
                            AllactivityList[i][0],
                            AllactivityList[i][1],
                          ]);
                        });
                      else
                        for (int j = 0;
                            j < AllselectedActivityList.length;
                            j++) {
                          if (AllactivityList[i][0] ==
                                  AllselectedActivityList[j][0] &&
                              AllactivityList[i][1] ==
                                  AllselectedActivityList[j][1]) {
                            AllselectedActivityList.removeAt(j);
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
                              AllactivityList[i][0],
                              width: 60,
                              height: 60,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              AllactivityList[i][1],
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
