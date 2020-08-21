import 'dart:async';

import 'package:chaloapp/data/screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:toast/toast.dart';
import '../data/User.dart';
import '../common/global_colors.dart';
import '../profile/profile_page.dart';
import '../services/AuthService.dart';
import '../services/dynamicLinking.dart';
import '../Activites/all_activities.dart';
import '../Activites/Activity_Detail.dart';
import '../Explore/explore.dart';
import '../authentication/login.dart';
import '../widgets/DailogBox.dart';
import '../Broadcast/broadcast.dart';
import '../Broadcast/Broadcast_Details.dart';
import '../Chat/chats.dart';
import 'notification.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;
  String profilePic;
  @override
  void initState() {
    super.initState();
    DynamicLinkService.retrieveDynamicLink(context);
  }

  DateTime currentBackPressTime;
  Future<bool> _onWillPop(BuildContext ctx) async {
    if (_currentIndex == 0) {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 1)) {
        currentBackPressTime = now;
        Toast.show("Press back again to exit", ctx);
        return Future.value(false);
      }
      CurrentUser.discard();
      return Future.value(true);
    } else {
      setState(() => _currentIndex = 0);
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            iconSize: 25,
            backgroundColor: Colors.white,
            unselectedItemColor: Color(secondary),
            fixedColor: Color(primary),
            elevation: 10.0,
            onTap: (index) => setState(() => _currentIndex = index),
            items: Screen.pages.map((p) {
              return BottomNavigationBarItem(
                  icon: Icon(p.icon),
                  activeIcon: Column(
                    children: <Widget>[
                      if (_currentIndex == p.index)
                        Container(height: 2, width: 50, color: Color(primary)),
                      SizedBox(height: 5),
                      Icon(p.activeIcon),
                    ],
                  ),
                  title: Text(p.title));
            }).toList()),
        body: SafeArea(
          top: false,
          child: IndexedStack(
              index: _currentIndex,
              children: Screen.pages.map((p) => p.page).toList()),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          heroTag: 'notifications',
          backgroundColor: Colors.white,
          child: Icon(Icons.notifications, color: Color(primary)),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => NotificationList()))),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: StreamBuilder<Object>(
                stream:
                    Firestore.instance.collection('map_activity').snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  return FlutterMap(
                    options:
                        MapOptions(center: LatLng(19.0760, 72.8777), zoom: 13),
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
          UserSearchBar(forHome: true),
        ],
      ),
    );
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
            _showModal(documents[index].documentID);
          },
        ),
      ),
    );
  }

  void _showModal(String planId) {
    showModalBottomSheet<void>(
      context: context,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => MapActivityCard(
          planRef: Firestore.instance.collection('plan').document(planId)),
    );
  }
}

class MapActivityCard extends StatelessWidget {
  final DocumentReference planRef;
  MapActivityCard({@required this.planRef});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: planRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final doc = snapshot.data;
          final start = DateTime.fromMillisecondsSinceEpoch(
              doc['activity_start'].seconds * 1000);
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
            child: Card(
              elevation: 0.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 55.0,
                        height: 55.0,
                        child: Image(
                          image: NetworkImage(doc.data['activity_logo']),
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
                                doc.data['admin_name'],
                                style: TextStyle(
                                  color: Colors.teal,
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
                              final link = await DynamicLinkService.createLink(
                                  doc.data['plan_id'],
                                  doc.data['admin_name']
                                      .toString()
                                      .split(' ')[0]);
                              Share.share('Check  out my activity: $link',
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) &
                                          box.size);
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
                        doc.data['activity_type'],
                        style: TextStyle(
                          color: Colors.teal,
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
                          text: DateFormat('hh:mm').format(start),
                          icon: Icons.timer),
                      IconText(
                          text:
                              '${doc.data['participants_id'].length}/${doc.data['max_participant']}',
                          icon: Icons.people),
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
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                doc.data['admin_id'] == CurrentUser.user.email
                                    ? BroadcastActivityDetails(planDoc: doc)
                                    : ActivityDetails(planDoc: doc)));
                      },
                      color: Color(primary),
                      textColor: Colors.white,
                      child: Text(
                        "View Details",
                        style: TextStyle(
                          fontFamily: bodyText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class UserSearchBar extends StatefulWidget {
  UserSearchBar({this.forHome = false});
  final bool forHome;
  @override
  _UserSearchBarState createState() => _UserSearchBarState();
}

class _UserSearchBarState extends State<UserSearchBar> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  bool _isSearch = false;
  String _query = '';
  Timer _debounce;
  var strFrontCode, strEndCode, startCode, endCode;
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (_searchController.text.isNotEmpty) {
          _query = _searchController.text.toLowerCase();
          //for one word
          _query = _query.length == 1
              ? _query.toUpperCase()
              : _query.substring(0, 1).toUpperCase() + _query.substring(1);
          // for multiple words
          List<String> words = _query.split(' ');
          if (words.length > 1) {
            for (var i = 1; i < words.length; i++)
              words[i] = words[i].length == 1
                  ? words[i].toUpperCase()
                  : words[i].substring(0, 1).toUpperCase() +
                      words[i].substring(1);
            _query = words.join(' ');
          }
        } else {
          _query = '';
          return;
        }
        var len = _query.length;
        strFrontCode = _query.substring(0, len - 1);
        strEndCode = _query.substring(len - 1, len);
        startCode = _query;
        endCode =
            strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (!widget.forHome) _isSearch = true;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    try {
      _debounce.cancel();
    } catch (e) {
      print(e.toString());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (_isSearch)
          Scaffold(
            appBar: AppBar(
              backgroundColor: Color(primary),
              leading: Icon(Icons.search),
              title: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search Users",
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.only(left: 10.0),
                  border: InputBorder.none,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                    if (!widget.forHome)
                      Navigator.of(context).pop();
                    else
                      setState(() => _isSearch = false);
                  },
                )
              ],
            ),
            body: SafeArea(
                child: _query.length == 0
                    ? Center(child: Text('Find Other Chalo Members'))
                    : FutureBuilder(
                        future: Firestore.instance
                            .collection('users')
                            .where('name', isGreaterThanOrEqualTo: startCode)
                            .where('name', isLessThan: endCode)
                            .getDocuments(),
                        builder: (_, snapshot) {
                          if (!snapshot.hasData)
                            return Center(child: CircularProgressIndicator());
                          List<DocumentSnapshot> users =
                              snapshot.data.documents;
                          if (snapshot.data == null || users.length == 0)
                            return Center(
                              child: Text('No such User'),
                            );
                          return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (_, index) {
                                var user = users[index].data;
                                // if (user['email'] == CurrentUser.email)
                                //   return Container();
                                return Card(
                                  child: ListTile(
                                    onTap: () => user['email'] ==
                                            CurrentUser.user.email
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((_) =>
                                                    ProfilePage())))
                                        : showDialog(
                                            context: context,
                                            builder: (ctx) => Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      ProfileCard(
                                                          email: user['email'],
                                                          username:
                                                              '${user['name']}',
                                                          gender:
                                                              user['gender'],
                                                          follower:
                                                              user['followers'],
                                                          following:
                                                              user['following'],
                                                          isCurrent: false),
                                                    ])),
                                    title: Text(user['name']),
                                    subtitle: Text(user['email']),
                                    leading: CircleAvatar(
                                      backgroundImage: user['profile_pic'] ==
                                              null
                                          ? null
                                          : NetworkImage(user['profile_pic']),
                                      child: user['profile_pic'] == null
                                          ? Icon(Icons.account_circle)
                                          : null,
                                    ),
                                  ),
                                );
                              });
                        })),
          ),
        if (!_isSearch)
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ProfilePage()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: CircleAvatar(
                          child: ClipOval(
                            child: CurrentUser.user.photoUrl == null
                                ? Image.asset(
                                    'images/bgcover.jpg',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    CurrentUser.user.photoUrl,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _isSearch = true);
                          FocusScope.of(context).requestFocus(_searchFocus);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text('Search Users'),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () => signOut(context))
                  ],
                ),
              )),
      ],
    );
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
            btn1Color: Colors.green,
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
}
