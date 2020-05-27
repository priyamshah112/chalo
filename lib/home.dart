import 'package:chaloapp/ProfileSetup.dart';
import 'package:chaloapp/global_colors.dart';
import 'package:chaloapp/profile_page.dart';
import 'package:chaloapp/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:toast/toast.dart';
import 'login.dart';
import 'widgets/DailogBox.dart';
import 'package:chaloapp/broadcast.dart';
import 'package:chaloapp/all_activities.dart';
import 'package:chaloapp/chats.dart';
import 'package:chaloapp/explore.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;
  List tabs = [
    MainMap(),
    AllActivity(),
    Broadcast(),
    ProfilePage(),
    Chats()
  ];

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
      floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('user: $user\n email: $email'),
                  duration: Duration(seconds: 2),
                ));
              })),
      body: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: FlutterMap(
                options: new MapOptions(
                    center: new LatLng(19.0760, 72.8777), minZoom: 10.0),
                layers: [
                  new TileLayerOptions(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/abdulquadir123/ck9kbtkmm0ngc1ipif8vq6qbv/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWJkdWxxdWFkaXIxMjMiLCJhIjoiY2s5a2FmNHM3MDRudTNmbHIxMXJnazljbCJ9.znqRJyK_9-nzvIoPaSrmjw",
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1IjoiYWJkdWxxdWFkaXIxMjMiLCJhIjoiY2s5a2FmNHM3MDRudTNmbHIxMXJnazljbCJ9.znqRJyK_9-nzvIoPaSrmjw',
                        'id': 'mapbox.mapbox-streets-v8'
                      }),
                ],
              ),
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
            buttonText1: "No",
            button1Func: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
            buttonText2: "Yes",
            button2Func: () async {
              AuthService _auth = new AuthService(auth: FirebaseAuth.instance);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await _auth.signOut(prefs.getString('type'));
              print("Signed out");
              Navigator.of(context, rootNavigator: true).pop(true);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage())); // To close the dialog
            }));
  }
}
