import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Activites/all_activities.dart';
import '../common/global_colors.dart';
import '../data/User.dart';
import 'AddActivity.dart';
import 'Broadcast_Details.dart';

class Broadcast extends StatefulWidget {
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  String curr;

  @override
  void initState() {
    super.initState();
    curr = CurrentUser.userEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
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
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => AddActivity()),
                    ),
                    color: Colors.teal,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
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
              Expanded(
                      child: Activities(
                      value: "All Activity",
                      stream: Firestore.instance
                          .collection('plan')
                          .where('admin_id', isEqualTo: curr)
                          .snapshots(),
                      showUserActivities: true,
                      onTapGoto: (doc) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BroadcastActivityDetails(planDoc: doc)),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
