//import 'package:chaloapp/forgot.dart';
//import 'package:chaloapp/main.dart';
//import 'package:chaloapp/widgets/DailogBox.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import 'package:chaloapp/Activites/all_activities.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'AddActivity.dart';
import '../Animation/FadeAnimation.dart';
//import 'package:chaloapp/Animation/FadeAnimation.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:chaloapp/signup.dart';
//import 'package:chaloapp/home.dart';
import '../data/activity.dart';
import 'Broadcast_Details.dart';

class Broadcast extends StatefulWidget {
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  DateTime currentBackPressTime;
  Future<bool> _onWillPop(BuildContext context) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      Toast.show("Press back again to exit", context);
      return Future.value(false);
    }
    return Future.value(true);
  }

  String email;

  Future getdata() async {
    try {
      final user = await UserData.getUser();
      await Future.delayed(Duration(seconds: 1));
      setState(() => email = user['email']);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(primary),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "Broadcast Activity",
              style: TextStyle(
                color: Colors.white,
                fontFamily: bodyText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          elevation: 1.0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          Map<String, dynamic> result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddActivity()),
                          );
                          if (result != null) DataService().createPlan(result);
                        },
                        color: Colors.teal,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 14.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.plus,
                              size: 20,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            Text(
                              "Broadcast new Activity",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Text(
                    "Broadcasted Activities",
                    style: TextStyle(
                      color: Color(primary),
                      fontWeight: FontWeight.bold,
                      fontFamily: heading,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  email == null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Expanded(
                          child: Activities(
                          stream: Firestore.instance
                              .collection('plan')
                              .where('admin_id', isEqualTo: email)
                              .snapshots(),
                          onTapGoto: (planRef) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BroadcardActivityDetails(planRef: planRef)),
                          ),
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
