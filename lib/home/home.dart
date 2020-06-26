import 'package:chaloapp/Activites/Activity_Detail.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/profile/profile_page.dart';
import 'package:chaloapp/services/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:toast/toast.dart';

import '../Activites/all_activities.dart';
import '../Explore/explore.dart';
import '../authentication/login.dart';
import '../widgets/DailogBox.dart';
import 'package:chaloapp/Boradcast/broadcast.dart';

import 'package:chaloapp/Chat/chats.dart';

import 'notification.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;
  List tabs = [MainMap(), AllActivity(), Broadcast(), Explore(), Chats()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 13),
        color: Colors.white,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 25,
          backgroundColor: Colors.white,
          unselectedItemColor: Color(secondary),
          fixedColor: Color(primary),
          elevation: 0.0,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              title: Text("Map"),
              icon: Icon(
                FontAwesomeIcons.mapMarkerAlt,
              ),
            ),
            BottomNavigationBarItem(
              title: Text("Activities"),
              icon: Icon(
                FontAwesomeIcons.list,
              ),
            ),
            BottomNavigationBarItem(
              title: Text("Broadcast"),
              icon: Icon(
                Icons.wifi_tethering,
              ),
            ),
            BottomNavigationBarItem(
              title: Text("Explore"),
              icon: Icon(
                Icons.dashboard,
              ),
            ),
            BottomNavigationBarItem(
              title: Text("chats"),
              icon: Icon(
                FontAwesomeIcons.commentDots,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainMap extends StatefulWidget {
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  String user, email;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString('name');
      email = prefs.getString('email');
    });
  }

  @override
  void initState() {
    user = email = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getData();
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(Icons.notifications, color: Color(primary)),
          onPressed: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => NotificationList()));
            // _scaffoldKey.currentState.showSnackBar(SnackBar(
            //   content: Text('user: $user\n email: $email'),
            //   duration: Duration(seconds: 2),
            // ));
          }),
      body: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: StreamBuilder<Object>(
                  stream:
                      Firestore.instance.collection('map_activity').snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    return FlutterMap(
                      options: MapOptions(
                          center: LatLng(19.0760, 72.8777), minZoom: 10.0),
                      layers: [
                        TileLayerOptions(
                            urlTemplate:
                                "https://api.mapbox.com/styles/v1/abdulquadir123/ck9kbtkmm0ngc1ipif8vq6qbv/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWJkdWxxdWFkaXIxMjMiLCJhIjoiY2s5a2FmNHM3MDRudTNmbHIxMXJnazljbCJ9.znqRJyK_9-nzvIoPaSrmjw",
                            additionalOptions: {
                              'accessToken':
                                  'pk.eyJ1IjoiYWJkdWxxdWFkaXIxMjMiLCJhIjoiY2s5a2FmNHM3MDRudTNmbHIxMXJnazljbCJ9.znqRJyK_9-nzvIoPaSrmjw',
                              'id': 'mapbox.mapbox-streets-v8'
                            }),
                        if (snapshot.hasData)
                          MarkerLayerOptions(
                              markers: getMarkers(snapshot.data.documents))
                      ],
                    );
                  }),
            ),
            Positioned(
                top: 60.0,
                left: 15.0,
                right: 15.0,
                child: Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 10,
                          spreadRadius: 2)
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, bottom: 5, top: 7),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProfilePage()),
                            );
                          },
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Image.asset(
                                'images/bgcover.jpg',
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: "Search Users",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 11.0, top: 5.0),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.exit_to_app),
                          onPressed: () => signOut(context))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

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

  void signOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => DialogBox(
            title: 'Warning',
            description: "Are you sure you want to Sign out ?",
            btn2Color: Colors.red,
            buttonText1: "No",
            button1Func: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
            buttonText2: "Yes",
            btn1Color: Color(primary),
            button2Func: () async {
              await AuthService().signOut();
              print("Signed out");
              Navigator.of(context, rootNavigator: true).pop(true);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage())); // To close the dialog
            }));
  }

  List<Marker> getMarkers(List<DocumentSnapshot> documents) {
    int count = documents.length;
    return List<Marker>.generate(
      count,
      (index) => Marker(
        width: 60.0,
        height: 60.0,
        point: new LatLng(documents[index].data['location'].latitude,
            documents[index].data['location'].longitude),
        builder: (ctx) => new IconButton(
          icon: Image.network(documents[index].data['activity_logo']),
          onPressed: () {
            _showModal();
            print("marker pressed");
          },
        ),
      ),
    );
  }

  void _showModal() {
    showModalBottomSheet<void>(
      context: context,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 90),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.teal,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6)),
          height: 337,
          child: Card(
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 55.0,
                      height: 55.0,
                      child: CircleAvatar(
//                        foregroundColor: Color(primary),
//                        backgroundColor: Color(secondary),
                        backgroundImage: AssetImage('images/bgcover.jpg'),
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Chats()),
                                );
                              },
                              child: Text(
                                "Activity name",
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
                          onPressed: () {},
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
                      "activity knwkjw",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
//                    Text(
//                      DateFormat('d, MMM').format(start),
//                      style: TextStyle(
//                        color: Color(primary),
//                        fontWeight: FontWeight.bold,
//                        fontSize: 18,
//                      ),
//                    ),
                    Text(
                      "2 May",
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
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    IconText(
//                        text: DateFormat('hh:mm').format(start),
//                        icon: Icons.timer),
//                    IconText(text: count.toString(), icon: Icons.people),
//                    IconText(text: 'Mumbai', icon: Icons.location_on)
//                  ],
//                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconText(text: "3:20 PM", icon: Icons.timer),
                    IconText(text: "5/10", icon: Icons.people),
                    IconText(text: 'Mumbai', icon: Icons.location_on)
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
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {},
                    color: Color(primary),
                    textColor: Colors.white,
                    child: Text(
                      "Join Activity",
                      style: TextStyle(
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: FlatButton(
                    highlightColor: Colors.transparent,
                    child: Text(
                      'Propose a new time',
                      style: TextStyle(
                        color: Color(primary),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
//    future.then((void value) => _closeModal(value));
  }
}

List<Marker> getMarkers(List<DocumentSnapshot> documents) {
  int count = documents.length;
  return List<Marker>.generate(
      count,
      (index) => Marker(
          width: 60.0,
          height: 60.0,
          point: new LatLng(documents[index].data['location'].latitude,
              documents[index].data['location'].longitude),
          builder: (ctx) => new IconButton(
              icon: Image.network(documents[index].data['activity_logo']),
              onPressed: () {})));
}
