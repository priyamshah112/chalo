import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/global_colors.dart';
import '../data/User.dart';
import '../profile/profile_page.dart';
import '../services/DatabaseService.dart';
import '../widgets/DailogBox.dart';
import '../Activites/Activity_Detail.dart';
import 'edit_activity.dart';

class BroadcastActivityDetails extends StatefulWidget {
  final DocumentSnapshot planDoc;
  BroadcastActivityDetails({Key key, @required this.planDoc}) : super(key: key);
  @override
  _BroadcastActivityDetailsState createState() =>
      _BroadcastActivityDetailsState();
}

class _BroadcastActivityDetailsState extends State<BroadcastActivityDetails> {
  double rating = 3.5;
  //List participants;
  Widget build(BuildContext context) {
    return deleting
        ? Material(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Deleting...')
            ],
          ))
        : StreamBuilder<DocumentSnapshot>(
            initialData: widget.planDoc,
            stream: Firestore.instance
                .collection('plan')
                .document(widget.planDoc.documentID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                    color: Colors.white,
                    child: Center(child: CircularProgressIndicator()));
              final DocumentSnapshot planDoc = snapshot.data;
              final String email = CurrentUser.user.email;
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
                      planDoc['activity_type'],
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
                    planDoc['activity_status'] == 'Completed'
                        ? FlatButton(
                            onPressed: () {},
                            child: Text(""),
                          )
                        : FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditActivity(plandocu: planDoc)),
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
                            admin: planDoc['admin_name'],
                            requests: planDoc['pending_participant_id'],
                          ),
                        SizedBox(height: 10),
                        ParticipantList(
                            planDoc: planDoc,
                            presentList: planDoc['participants_present'],
                            participants: planDoc['participants_id'],
                            admin: planDoc['admin_name'],
                            adminId: planDoc['admin_id'],
                            planId: planDoc['plan_id'],
                            current: email,
                            showRemove: true),
                        planDoc['activity_status'] == 'Completed'
                            ? Container()
                            : (planDoc['activity_status'] == 'Started')
                                ? (planDoc['participants_rated']
                                        .contains(email))
                                    ? Container()
                                    : DateTime.now().isBefore(planDoc['activity_end'].toDate().subtract(Duration(minutes: 15)))
                                        ? Container()
                                        : Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "Rating",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Color(primary),
                                                    //fontFamily: heading,
                                                  ),
                                                ),
                                                StarRating(
                                                  rating: rating,
                                                  onRatingChanged: (rating) =>
                                                      setState(() =>
                                                          this.rating = rating),
                                                ),
                                                RaisedButton(
                                                  child: Text(
                                                    'Submit Rating',
                                                    style: TextStyle(
                                                      fontFamily: bodyText,
                                                    ),
                                                  ),
                                                  elevation: 2,
                                                  textColor: Colors.white,
                                                  color: Colors.green,
                                                  onPressed: () async {
                                                    await DataService()
                                                        .setRatingList(
                                                            planDoc.reference,
                                                            rating,
                                                            email);
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                : Container(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        Map<String, dynamic> activityDetails = {
                                          'activity_status': 'Started',
                                        };
                                        await DataService()
                                            .updateActivityStatus(
                                                activityDetails,
                                                widget.planDoc);
                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        setState(() {});
                                      },
                                      elevation: 2,
                                      textColor: Colors.white,
                                      color: Color(primary),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        'Start Activity',
                                        style: TextStyle(
                                          fontFamily: bodyText,
                                        ),
                                      ),
                                    ),
                                  ),
                        SizedBox(height: 10),
                        (planDoc['activity_status'] == 'Completed' || planDoc['activity_status'] == 'Created')
                            ? (planDoc['activity_status'] == 'Completed')
                                ? Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Rating  ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color(primary),
                                              fontFamily: heading,
                                            )),
                                        Text("${planDoc['activity_rating']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color(primary),
                                              fontFamily: heading,
                                            )),
                                        Icon(
                                          Icons.star_outlined,
                                          color: Color(primary),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container()
                            : DateTime.now().isBefore(planDoc['activity_end'].toDate().subtract(Duration(minutes: 15)))
                                ? Container()
                                  : Container(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        List ratinglist =
                                            planDoc['rating_list'];
                                        double sum = 0;
                                        for (double x in ratinglist) {
                                          sum += x;
                                        }
                                        sum = sum / ratinglist.length;
                                        Map<String, dynamic> activityDetails = {
                                          'activity_status': 'Completed',
                                          'activity_rating': sum,
                                        };
                                        await DataService()
                                            .updateActivityStatus(
                                                activityDetails,
                                                widget.planDoc);
                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        setState(() {});
                                      },
                                      elevation: 2,
                                      textColor: Colors.white,
                                      color: Color(primary),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        'End Activity',
                                        style: TextStyle(
                                          fontFamily: bodyText,
                                        ),
                                      ),
                                    ),
                                  ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () =>
                                handleDeleteActivity(context, planDoc),
                            elevation: 2,
                            textColor: Colors.white,
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Delete Activity',
                              style: TextStyle(
                                fontFamily: bodyText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
  }

  bool deleting = false;
  void handleDeleteActivity(
      BuildContext context, DocumentSnapshot planDoc) async {
    bool deleteActivity = await showDialog<bool>(
        context: context,
        builder: (_) => DialogBox(
              title: 'Alert !',
              titleColor: Colors.red,
              description: 'Are you sure you want to Delete this activity ?',
              buttonText1: 'Cancel',
              buttonText2: 'Delete',
              btn2Color: Colors.red,
              button1Func: () =>
                  Navigator.of(context, rootNavigator: true).pop(false),
              button2Func: () =>
                  Navigator.of(context, rootNavigator: true).pop(true),
            ));
    if (deleteActivity)
      _deletePlan(planDoc);
    else
      return;
  }

  void _deletePlan(DocumentSnapshot plan) async {
    setState(() => deleting = true);
    await Future.delayed(Duration(seconds: 1));
    await DataService().leaveActivity(plan, delete: true);
    Navigator.of(context).pop();
  }
}

class JoinRequestList extends StatefulWidget {
  final List requests;
  final String planId, admin;
  JoinRequestList(
      {Key key,
      @required this.requests,
      @required this.admin,
      @required this.planId})
      : super(key: key);
  @override
  _JoinRequestListState createState() => _JoinRequestListState();
}

class _JoinRequestListState extends State<JoinRequestList> {
  @override
  Widget build(BuildContext context) {
    return widget.requests.length == 0
        ? Container()
        : ExpansionTile(
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
                                      email: snapshot.data['email'],
                                      username: snapshot.data['name'],
                                      profilePic: snapshot.data['profile_pic'],
                                      gender: snapshot.data['gender'],
                                      follower: snapshot.data['followers'],
                                      following: snapshot.data['following'],
                                      activities:
                                          snapshot.data['activities_completed'],
                                      age: CurrentUser.ageFromDob(
                                          snapshot.data['dob']),
                                      isCurrent: false,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
        setState(() => widget.requests.remove(email));
        await DataService()
            .joinActivity(accept, planId, email, token, widget.admin);
      },
      icon: Icon(
        accept ? FontAwesomeIcons.check : FontAwesomeIcons.times,
        size: 15,
      ),
      label: Text(
        accept ? "Accept" : "Decline",
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

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating(
      {this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            new List.generate(starCount, (index) => buildStar(context, index)));
  }
}
