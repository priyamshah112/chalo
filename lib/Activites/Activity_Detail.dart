//import 'package:chaloapp/forgot.dart';
//import 'package:chaloapp/main.dart';
//import 'package:chaloapp/widgets/DailogBox.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/home/home.dart';
import 'package:chaloapp/profile/profile_page.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Animation/FadeAnimation.dart';
//import 'package:chaloapp/Animation/FadeAnimation.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:chaloapp/signup.dart';
//import 'package:chaloapp/home.dart';

class ActivityDetails extends StatefulWidget {
  final DocumentReference planRef;
  const ActivityDetails({Key key, @required this.planRef}) : super(key: key);
  @override
  _ActivityDetailsState createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  @override
  void initState() {
    super.initState();
  }

  bool requestSent = false;

  Future<Map<String, dynamic>> getData() async {
    // try {
    final snapshot = await widget.planRef.get();
    final user = await UserData.getUser();
    snapshot.data['pending_participant_id'].contains(user['email'])
        ? setState(() => requestSent = true)
        : setState(() => requestSent = false);
    return {'doc': snapshot, 'email': user['email']};
    // } catch (e) {
    //   print(e.toString());
    //   return null;
    // }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool lastScreen = Navigator.of(context).canPop();
        if (lastScreen) return true;
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => MainHome()));
        return false;
      },
      child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()));
            final planDoc = snapshot.data['doc'];
            final email = snapshot.data['email'];
            final List participants = planDoc['participants_id'];
            final start = DateTime.fromMillisecondsSinceEpoch(
                planDoc['activity_start'].seconds * 1000);
            final end = DateTime.fromMillisecondsSinceEpoch(
                planDoc['activity_end'].seconds * 1000);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(primary),
                elevation: 0.0,
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
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
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
                          if(!participants.contains(email))
                          isLoading 
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: requestSent
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.access_time,
                                                      color: Color(primary)),
                                                  SizedBox(width: 10),
                                                  Text('Request Pending',
                                                      style: TextStyle(
                                                          fontFamily: bodyText,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(primary))),
                                                ],
                                              ),
                                            )
                                          : FlatButton(
                                              onPressed: () async {
                                                setState(
                                                    () => isLoading = true);
                                                await DataService().requestJoin(
                                                    widget.planRef,
                                                    email,
                                                    true);
                                                await Future.delayed(
                                                    Duration(seconds: 1));
                                                setState(() {
                                                  isLoading = false;
                                                  requestSent = true;
                                                });
                                              },
                                              color: Color(primary),
                                              textColor: Colors.white,
                                              child: Text(
                                                'Join Activity',
                                                style: TextStyle(
                                                  fontFamily: bodyText,
                                                ),
                                              ),
                                            ),
                                    ),
                                    SizedBox(height: 5),
                                    requestSent
                                        ? FlatButton(
                                            onPressed: () async {
                                              await DataService().requestJoin(
                                                  widget.planRef, email, false);
                                              setState(
                                                  () => requestSent = false);
                                            },
                                            color: Color(primary),
                                            textColor: Colors.white,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(Icons.clear),
                                                SizedBox(width: 10),
                                                Text(
                                                  'Canel Request',
                                                  style: TextStyle(
                                                    fontFamily: bodyText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : FlatButton(
                                            highlightColor: Colors.transparent,
                                            child: Text(
                                              'Propose a new time',
                                              style: TextStyle(
                                                color: Color(primary),
                                              ),
                                            ),
                                            onPressed: () {},
                                          ),
                                  ],
                                ),
                          SizedBox(height: 10),
                          ParticipantList(planDoc: planDoc, current: email),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class ParticipantList extends StatelessWidget {
  const ParticipantList({Key key, @required this.planDoc, @required this.current})
      : super(key: key);

  final DocumentSnapshot planDoc;
  final String current;
  @override
  Widget build(BuildContext context) {
    final List participants = planDoc['participants_id'] as List;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "Participants",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(primary),
            fontFamily: heading,
          ),
        ),
        SizedBox(height: 5),
        ...participants.map(
          (participant) => FutureBuilder(
              future: DataService().getUserDoc(participant),
              builder: (context, snapshot) {
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      color: Color(primary),
                    ),
                  ),
                  child: !snapshot.hasData
                      ? Container()
                      : ListTile(
                          onTap: participant == current
                              ? null
                              : () => showDialog(
                                  context: context,
                                  builder: (ctx) => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ProfileCard(
                                              email: snapshot.data['email'],
                                              username:
                                                  '${snapshot.data['first_name']} ${snapshot.data['last_name']}',
                                              gender: snapshot.data['gender'],
                                              follower: 0,
                                              following: 0,
                                              showFollow: true,
                                            )
                                          ])),
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
                          subtitle: Text('1 Actvity Done'),
                          // trailing: Container(
                          //   width: 100,
                          //   height: 27,
                          //   child: OutlineButton(
                          //     onPressed: () {},
                          //     borderSide: BorderSide(
                          //       color: Color(primary), //Color of the border
                          //       style: BorderStyle.solid, //Style of the border
                          //       width: 0.9, //width of the border
                          //     ),
                          //     color: Color(primary),
                          //     textColor: Color(primary),
                          //     child: Text(
                          //       "follow",
                          //       style: TextStyle(
                          //         fontFamily: bodyText,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                );
              }),
        ),
      ],
    );
  }
}

class ActivityDetailCard extends StatelessWidget {
  const ActivityDetailCard({
    Key key,
    @required this.planDoc,
    @required this.start,
    @required this.end,
  }) : super(key: key);

  final DocumentSnapshot planDoc;
  final DateTime start;
  final DateTime end;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Color(primary), width: 1),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  planDoc['activity_name'],
                  style: TextStyle(
                    color: Color(primary),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: heading,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Detail(
                    icon: Icons.timer,
                    detailHeading: 'Start Time',
                    detailText: DateFormat('hh:mm a').format(start)),
                Detail(
                    icon: Icons.timer,
                    detailHeading: 'End Time',
                    detailText: DateFormat('hh:mm a').format(end))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Detail(
                    icon: Icons.people,
                    detailHeading: 'Participants',
                    detailText:
                        '${planDoc['participants_id'].length}/${planDoc['max_participant']}'),
                Detail(
                    icon: Icons.calendar_today,
                    detailHeading: 'Date',
                    detailText: DateFormat('d, MMM yy').format(start))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Color(secondary),
                        size: 25,
                      ),
                      Flexible(
                        child: Text(
                          planDoc['address'],
                          style: TextStyle(
                              color: Color(secondary),
                              fontSize: 15,
                              fontFamily: bodyText,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "View Map",
                        style: TextStyle(
                          color: Color(primary),
                          fontSize: 15,
                          fontFamily: bodyText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            //loop start
          ],
        ),
      ),
      elevation: 0,
    );
  }
}

class Detail extends StatelessWidget {
  final IconData icon;
  final String detailHeading, detailText;
  const Detail({
    Key key,
    this.icon,
    this.detailHeading,
    this.detailText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: Color(secondary),
          size: 25,
        ),
        SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              detailHeading,
              style: TextStyle(
                  color: Color(secondary),
                  fontSize: 15,
                  fontFamily: bodyText,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              detailText,
              style: TextStyle(
                  color: Color(secondary),
                  fontSize: 15,
                  fontFamily: bodyText,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
