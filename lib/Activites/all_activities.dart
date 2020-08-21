import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/User.dart';
import '../services/dynamicLinking.dart';
import '../common/global_colors.dart';
import 'Activity_Detail.dart';

class AllActivity extends StatefulWidget {
  @override
  _AllActivityState createState() => _AllActivityState();
}

//_value1.isNotEmpty ? _value1 : null
class _AllActivityState extends State<AllActivity> {
  List<List<String>> AllactivityListItems = [
    ['images/activities/Beach.png', 'Beach'],
    ['images/activities/BirdWatching.png', 'Bird Watching'],
    ['images/activities/Canoeing.png', 'Caneoing'],
    ['images/activities/Hiking.png', 'Hiking'],
    ['images/activities/BeachBBQ.png', 'Beach BBQ'],
    ['images/activities/Camping.png', 'Camping'],
    ['images/activities/Cycling.png', 'Cycling'],
    ['images/activities/DogWalking.png', 'Dog Walking'],
    ['images/activities/Fishing.png', 'Fishing'],
    ['images/activities/Gardening.png', 'Gardening'],
    ['images/activities/Gym.png', 'Gym'],
    ['images/activities/MountainBiking.png', 'Mountain Biking'],
    ['images/activities/Picnic.png', 'Picnic'],
    ['images/activities/Kayaking.png', 'Kayaking'],
    ['images/activities/Museum.png', 'Museum'],
    ['images/activities/Beach.png', 'Beach'],
    ['images/activities/BirdWatching.png', 'Bird Watching'],
    ['images/activities/Canoeing.png', 'Caneoing'],
    ['images/activities/Hiking.png', 'Hiking'],
    ['images/activities/BeachBBQ.png', 'Beach BBQ'],
    ['images/activities/Camping.png', 'Camping'],
    ['images/activities/Cycling.png', 'Cycling'],
    ['images/activities/DogWalking.png', 'Dog Walking'],
    ['images/activities/Fishing.png', 'Fishing'],
    ['images/activities/Gardening.png', 'Gardening'],
    ['images/activities/Gym.png', 'Gym'],
    ['images/activities/MountainBiking.png', 'Mountain Biking'],
    ['images/activities/Picnic.png', 'Picnic'],
    ['images/activities/Kayaking.png', 'Kayaking'],
    ['images/activities/Museum.png', 'Museum'],
  ];
  String _value = "All Activity";
  DropdownButton FilterByActivity() => DropdownButton<String>(
        items: [
          for (int i = 0; i < AllactivityListItems.length; i++)
            DropdownMenuItem(
              value: AllactivityListItems[i][1],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AllactivityListItems[i][1],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(secondary),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    AllactivityListItems[i][0],
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
            ),
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
            print(_value);
          });
        },
        icon: Icon(Icons.arrow_downward),
        iconSize: 20.0,
        iconEnabledColor: Color(primary),
        underline: Container(),
        hint: Text(
          _value,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        isExpanded: true,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(primary),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'All Activity',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white70,
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.0),
                Text(
                  "Sort By Activity",
                  style: TextStyle(
                      color: Color(primary),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                FilterByActivity(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "All Broadcasted Activities",
                  style: TextStyle(
                      color: Color(primary),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Activities(
                  stream: Firestore.instance
                      .collection('plan')
                      .where('broadcast_type', isEqualTo: "public")
                      .orderBy('activity_start', descending: true)
                      .snapshots(),
                  onTapGoto: (doc) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: 'Activity'),
                        builder: (BuildContext context) =>
                            ActivityDetails(planDoc: doc)),
                  ),
                )),
              ],
            ),
          ),
        ));
  }
}

class Activities extends StatefulWidget {
  final Stream stream;
  final bool showUserActivities;
  final Function(DocumentSnapshot planDoc) onTapGoto;
  Activities(
      {@required this.stream,
      @required this.onTapGoto,
      this.showUserActivities = false});
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          List<DocumentSnapshot> plans = snapshot.data.documents;
          int count = plans.length;
          return ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                return !widget.showUserActivities &&
                        plans[index]['admin_id'] == CurrentUser.userEmail
                    ? Container()
                    : ActivityCard(
                        planDoc: plans[index],
                        activityDetails: () => widget.onTapGoto(plans[index]),
                      );
              });
        });
  }
}

class ActivityCard extends StatelessWidget {
  final DocumentSnapshot planDoc;
  final Function activityDetails;
  const ActivityCard(
      {Key key, @required this.planDoc, @required this.activityDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final start = DateTime.fromMillisecondsSinceEpoch(
        planDoc['activity_start'].seconds * 1000);
    return Card(
      child: GestureDetector(
        onTap: activityDetails,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
              border: Border.all(
                color: Color(primary),
              ),
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 55.0,
                    height: 55.0,
                    child: Image(
                      image: planDoc.data['activity_logo'] != null
                          ? NetworkImage(planDoc.data['activity_logo'])
                          : AssetImage('images/bgcover.jpg'),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FittedBox(
                          child: Text(
                            planDoc['admin_name'],
                            style: TextStyle(
                              color: Color(primary),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.trophy,
                              color: Colors.amberAccent,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(" 0 activities Done"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: IconButton(
                        icon: Icon(Icons.share),
                        color: Colors.green,
                        onPressed: () async {
                          final RenderBox box = context.findRenderObject();
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  Center(child: CircularProgressIndicator()));
                          final link = await DynamicLinkService.createLink(
                              planDoc['plan_id'],
                              planDoc['admin_name'].toString().split(' ')[0]);
                          Navigator.of(context, rootNavigator: true).pop();
                          Share.share('Check  out my activity: $link',
                              sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) & box.size);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Male, Mumbai"),
                  Text("0.00 km away"),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    planDoc['activity_type'],
                    style: TextStyle(
                      color: Color(primary),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    DateFormat('d, MMM').format(start),
                    style: TextStyle(
                      color: Color(primary),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                  IconText(
                      text: DateFormat('hh:mm a').format(start),
                      icon: Icons.timer),
                  IconText(
                      text: planDoc['max_participant'].toString(),
                      icon: Icons.people),
                  IconText(text: 'Mumbai', icon: Icons.location_on)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconText extends StatelessWidget {
  final String text;
  final IconData icon;
  const IconText({Key key, @required this.text, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: Color(primary),
          size: 20,
        ),
        SizedBox(width: 3.0),
        Text(
          text,
          style: TextStyle(
              color: Color(secondary),
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// void storeActivity() async {
//   final activity = "Gym";
//   final Storageref =
//       FirebaseStorage.instance.ref().child('activities').child('$activity.png');
//   final url = await Storageref.getDownloadURL();
//   await Firestore.instance
//       .collection('chalo_activity')
//       .document(activity)
//       .setData({
//     'collaborator_id': [],
//     'description': 'Activtiy description goes here',
//     'logo': url,
//     'name': activity
//   });
//   print(url);
// }
