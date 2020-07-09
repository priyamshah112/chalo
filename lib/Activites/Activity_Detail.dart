import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/home/home.dart';
import 'package:chaloapp/profile/profile_page.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Animation/FadeAnimation.dart';

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
    try {
      final snapshot = await widget.planRef.get();
      if (snapshot.data == null) return {'doc': null};
      setState(() => requestSent =
          snapshot.data['pending_participant_id'].contains(CurrentUser.email)
              ? true
              : false);
      return {'doc': snapshot, 'email': CurrentUser.email};
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isLoading = false;
  Future<bool> onBackPressed() async {
    if (deleting) return false;
    bool notLastScreen = Navigator.of(context).canPop();
    if (notLastScreen)
      Navigator.of(context).pop();
    else
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MainHome()));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()));
            if (snapshot.data['doc'] == null)
              return Scaffold(
                  body: Center(
                      child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('No Such Actiivity'),
                  SizedBox(height: 10),
                  RaisedButton(
                    onPressed: onBackPressed,
                    color: Color(primary),
                    textColor: Colors.white,
                    child: Text(
                      'Go to Home',
                      style: TextStyle(
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ],
              )));
            final DocumentSnapshot planDoc = snapshot.data['doc'];
            final String email = snapshot.data['email'];
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
                    planDoc.data['activity_name'],
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
                          if (!participants.contains(email))
                            isLoading
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(),
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                            fontFamily:
                                                                bodyText,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                primary))),
                                                  ],
                                                ),
                                              )
                                            : FlatButton(
                                                onPressed: () async {
                                                  setState(
                                                      () => isLoading = true);
                                                  await DataService()
                                                      .requestJoin(
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
                                                    widget.planRef,
                                                    email,
                                                    false);
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
                                              highlightColor:
                                                  Colors.transparent,
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
                          SizedBox(height: 20),
                          ParticipantList(
                              participants: participants,
                              admin: planDoc['admin_name'],
                              adminId: planDoc['admin_id'],
                              planId: planDoc['plan_id'],
                              current: email),
                          if (participants.contains(email))
                            Container(
                              width: double.infinity,
                              child: RaisedButton(
                                  onPressed: () =>
                                      handleLeaveActivity(context, planDoc),
                                  elevation: 2,
                                  textColor: Colors.white,
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    'Leave Activity',
                                    style: TextStyle(
                                      fontFamily: bodyText,
                                    ),
                                  )),
                            ),
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

  bool deleting = false;
  void handleLeaveActivity(
      BuildContext context, DocumentSnapshot planDoc) async {
    bool leaveActivity = await showDialog<bool>(
        context: context,
        builder: (_) => DialogBox(
              title: 'Alert !',
              titleColor: Colors.red,
              description: 'Are you sure you want to leave this activity ?',
              buttonText1: 'Cancel',
              buttonText2: 'Leave',
              btn2Color: Colors.red,
              button1Func: () =>
                  Navigator.of(context, rootNavigator: true).pop(false),
              button2Func: () =>
                  Navigator.of(context, rootNavigator: true).pop(true),
            ));
    if (leaveActivity) {
      deleting = true;
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => Center(
                child: CircularProgressIndicator(),
              ));
      await DataService().leaveActivity(planDoc);
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.of(context, rootNavigator: true).pop();
      deleting = false;
      Navigator.of(context).pop();
    } else
      return;
  }
}

class ParticipantList extends StatefulWidget {
  const ParticipantList(
      {Key key,
      this.showRemove = false,
      @required this.current,
      @required this.participants,
      @required this.admin,
      @required this.adminId,
      @required this.planId})
      : super(key: key);
  final List participants;
  final bool showRemove;
  final String current, admin, adminId, planId;

  @override
  _ParticipantListState createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {

  @override
  Widget build(BuildContext context) {
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
        ...widget.participants.map(
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
                          onTap: participant == widget.current
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
                                              follower:
                                                  snapshot.data['followers'],
                                              following:
                                                  snapshot.data['following'],
                                              isCurrent: false,
                                            ),
                                          ])),
                          leading: CircleAvatar(
                            backgroundImage:
                                snapshot.data['profile_pic'] != null
                                    ? NetworkImage(snapshot.data['profile_pic'])
                                    : AssetImage("images/bgcover.jpg"),
                          ),
                          title: Text(
                            '${snapshot.data['first_name']} ${snapshot.data['last_name']}',
                            style: TextStyle(
                                fontFamily: bodyText,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          subtitle: Text('1 Actvity Done'),
                          trailing: participant == widget.adminId
                              ? Text('Admin',
                                  style: TextStyle(color: Color(primary)))
                              : widget.showRemove
                                  ? GestureDetector(
                                      child:
                                          Icon(Icons.clear, color: Colors.red),
                                      onTap: () => handleRemove(
                                          context,
                                          participant,
                                          snapshot.data['first_name']))
                                  : null,
                        ),
                );
              }),
        ),
        SizedBox(height: 10)
      ],
    );
  }

  void handleRemove(
      BuildContext ctx, String participant, String participantName) async {
    bool remove = await showDialog<bool>(
        context: ctx,
        builder: (_) => DialogBox(
              title: 'Confirm',
              description:
                  'Are you sure you want to remove $participantName from your activity ?',
              buttonText1: 'Cancel',
              buttonText2: 'Remove',
              btn2Color: Colors.red,
              button1Func: () => Navigator.of(ctx).pop(false),
              button2Func: () => Navigator.of(ctx).pop(true),
            ));
    if (remove) {
      await DataService()
          .removeFromActivity(widget.planId, widget.admin, participant);
    }
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
