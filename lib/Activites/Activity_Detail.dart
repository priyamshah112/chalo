import 'package:chaloapp/Broadcast/Broadcast_Details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/global_colors.dart';
import '../data/User.dart';
import '../home/home.dart';
import '../profile/profile_page.dart';
import '../services/DatabaseService.dart';
import '../widgets/DailogBox.dart';
import '../Animation/FadeAnimation.dart';

class ActivityDetails extends StatefulWidget {
  final DocumentSnapshot planDoc;
  const ActivityDetails({Key key, @required this.planDoc}) : super(key: key);
  @override
  _ActivityDetailsState createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  @override
  void initState() {
    super.initState();
    plan = widget.planDoc;
  }

  bool requestSent = false;
  DocumentSnapshot plan;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isLoading = false;

  Widget buildActivityDetails(BuildContext context) {
    final String email = CurrentUser.userEmail;
    final List participants = plan['participants_id'];
    final start = DateTime.fromMillisecondsSinceEpoch(
        plan['activity_start'].seconds * 1000);
    final end = DateTime.fromMillisecondsSinceEpoch(
        plan['activity_end'].seconds * 1000);
    if (plan['pending_participant_id'].contains(email))
      setState(() => requestSent = true);
    return WillPopScope(
        onWillPop: () =>
            deleting ? Future.value(false) : onBackPressed(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(primary),
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Text(
              plan.data['admin_name'].toString().split(" ").first + "'s Activity",
              style: TextStyle(
                color: Colors.white,
                fontFamily: bodyText,
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
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
                            planDoc: plan, start: start, end: end),
                        if (!participants.contains(email) &&
                            participants.length < plan.data['max_participant'])
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
                                                    plan.reference,
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
                                                  plan.reference, email, false);
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
                        SizedBox(height: 20),
                        ParticipantList(
                            participants: participants,
                            admin: plan['admin_name'],
                            adminId: plan['admin_id'],
                            planId: plan['plan_id'],
                            current: email),
                        if (participants.contains(email))
                          Container(
                            width: double.infinity,
                            child: RaisedButton(
                                onPressed: () =>
                                    handleLeaveActivity(context, plan),
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
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return buildActivityDetails(context);
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
                  planDoc['activity_type'],
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

class ActivityLink extends StatelessWidget {
  final DocumentSnapshot activity;
  const ActivityLink({Key key, @required this.activity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (activity.data == null) return activityNotFoundPage(context);
    return activity.data['admin_id'] == CurrentUser.userEmail
        ? BroadcastActivityDetails(planDoc: activity)
        : ActivityDetails(planDoc: activity);
  }

  Widget activityNotFoundPage(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
          body: Center(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('No Such Actiivity'),
          SizedBox(height: 10),
          RaisedButton(
            onPressed: () => onBackPressed(context),
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
      ))),
    );
  }
}

Future<bool> onBackPressed(BuildContext context) async {
  bool notLastScreen = Navigator.of(context).canPop();
  if (notLastScreen)
    Navigator.of(context).pop();
  else
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => MainHome()));
  return true;
}
