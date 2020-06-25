//import 'package:chaloapp/forgot.dart';
//import 'package:chaloapp/main.dart';
//import 'package:chaloapp/widgets/DailogBox.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:chaloapp/Boradcast/edit_activity.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/profile/profile_page.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chaloapp/Activites/Activity_Detail.dart';
import 'package:chaloapp/Animation/FadeAnimation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:chaloapp/signup.dart';
//import 'package:chaloapp/home.dart';

class BroadcardActivityDetails extends StatefulWidget {
  final DocumentReference planRef;
  const BroadcardActivityDetails({Key key, @required this.planRef})
      : super(key: key);
  @override
  _BroadcardActivityDetailsState createState() =>
      _BroadcardActivityDetailsState();
}

class _BroadcardActivityDetailsState extends State<BroadcardActivityDetails> {
  Future<Map<String, dynamic>> getData() async {
    final snapshot = await widget.planRef.get();
    final user = await UserData.getUser();
    return {'doc': snapshot, 'email': user['email']};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()));
          final planDoc = snapshot.data['doc'];
          final email = snapshot.data['email'];
          final start = DateTime.fromMillisecondsSinceEpoch(
              planDoc['activity_start'].seconds * 1000);
          final end = DateTime.fromMillisecondsSinceEpoch(
              planDoc['activity_end'].seconds * 1000);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Center(
                child: Text(
                  planDoc['activity_name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: bodyText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EditActivity()),
                    );
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: bodyText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              elevation: 1.0,
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: FadeAnimation(
                1,
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        ActivityDetailCard(
                            planDoc: planDoc, start: start, end: end),
                        SizedBox(height: 10),
                        if (planDoc['pending_participant_id'].length > 0)
                          JoinRequestList(
                              planId: planDoc['plan_id'],
                              requests: planDoc['pending_participant_id']),
                        if (planDoc['pending_participant_id'].length > 0)
                          SizedBox(height: 10),
                        ParticipantList(planDoc: planDoc)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class JoinRequestList extends StatefulWidget {
  final List<String> requests;
  final String planId;
  JoinRequestList({Key key, @required this.requests, @required this.planId})
      : super(key: key);
  @override
  _JoinRequestListState createState() => _JoinRequestListState();
}

class _JoinRequestListState extends State<JoinRequestList> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Join Requests",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(primary))),
      initiallyExpanded: false,
      children: List<Widget>.generate(
          widget.requests.length,
          (index) => FutureBuilder(
              future: DataService().getUserDoc(widget.requests[index]),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: Text('Loading ...'));
                return ListTile(
                  onTap: () => showDialog(
                      context: context,
                      builder: (ctx) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileCard(
                                  username:
                                      '${snapshot.data['first_name']} ${snapshot.data['last_name']}'),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    responseButton(
                                        true,
                                        widget.planId,
                                        snapshot.data['email'],
                                        snapshot.data['token']),
                                    SizedBox(width: 30),
                                    responseButton(
                                        false,
                                        widget.planId,
                                        snapshot.data['email'],
                                        snapshot.data['token'])
                                  ],
                                ),
                              ),
                            ],
                          )),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("images/bgcover.jpg"),
                  ),
                  title: Text(
                    '${snapshot.data['first_name']} ${snapshot.data['last_name']}',
                    style: TextStyle(
                        fontFamily: bodyText,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                );
              })),
    );
  }

  Widget responseButton(
      bool accept, String planId, String email, String token) {
    return RaisedButton.icon(
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await DataService().joinActivity(accept, planId, email, token);
        setState(() {});
      },
      icon: Icon(
        accept ? FontAwesomeIcons.check : FontAwesomeIcons.times,
        size: 15,
      ),
      label: Text(
        accept ? "Accpet" : "Decline",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      textColor: accept ? Colors.green : Colors.red,
      shape: new RoundedRectangleBorder(
        side: BorderSide(color: accept ? Colors.green : Colors.red),
        borderRadius: new BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30,
      ),
    );
  }
}
