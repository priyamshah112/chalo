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
                          ExpansionTile(
                            title: Text("Join Requests",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(primary))),
                            initiallyExpanded: false,
                            children: List<Widget>.generate(
                                planDoc['pending_participant_id'].length,
                                (index) => FutureBuilder(
                                    future: DataService().getUserDoc(
                                        planDoc['pending_participant_id']
                                            [index]),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return Center(
                                            child: Text('Loading ...'));
                                      return ListTile(
                                        onTap: () => showDialog(
                                            context: context,
                                            builder: (ctx) => Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    ProfileCard(
                                                        username:
                                                            '${snapshot.data['first_name']} ${snapshot.data['last_name']}'),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          RaisedButton.icon(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                              await DataService().joinActivity(
                                                                  true,
                                                                  planDoc[
                                                                      'plan_id'],
                                                                  snapshot.data[
                                                                      'email'],
                                                                  snapshot.data[
                                                                      'token']);
                                                              setState(() {});
                                                            },
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .check,
                                                              size: 15,
                                                            ),
                                                            label: Text(
                                                              "Accpet",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            textColor:
                                                                Colors.green,
                                                            shape:
                                                                new RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .green),
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      10.0),
                                                            ),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 30,
                                                            ),
                                                          ),
                                                          SizedBox(width: 30),
                                                          RaisedButton.icon(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                              await DataService().joinActivity(
                                                                  false,
                                                                  planDoc[
                                                                      'plan_id'],
                                                                  snapshot.data[
                                                                      'email'],
                                                                  snapshot.data[
                                                                      'token']);
                                                              setState(() {});
                                                            },
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .times,
                                                              size: 15,
                                                            ),
                                                            label: Text(
                                                              "Decline",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            textColor:
                                                                Colors.red,
                                                            shape: new RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        10.0),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .red)),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 30,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              AssetImage("images/bgcover.jpg"),
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
                          ),
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
