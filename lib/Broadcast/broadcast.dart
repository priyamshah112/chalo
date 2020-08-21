import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Activites/all_activities.dart';
import '../common/global_colors.dart';
import '../data/User.dart';
import '../services/DatabaseService.dart';
import 'AddActivity.dart';
import 'Broadcast_Details.dart';

class Broadcast extends StatefulWidget {
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
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
                      showUserActivities: true,
                      onTapGoto: (planRef) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BroadcastActivityDetails(planRef: planRef)),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
