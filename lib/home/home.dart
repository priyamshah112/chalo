import 'dart:async';

import 'package:chaloapp/Activites/Activity_Detail.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/profile/profile_page.dart';
import 'package:chaloapp/services/AuthService.dart';
import 'package:chaloapp/services/dynamicLinking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:toast/toast.dart';
import 'package:chaloapp/data/User.dart';
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
  List tabs;
  String profilePic;
  @override
  void initState() {
    super.initState();
    DynamicLinkService.retrieveDynamicLink(context);
    tabs = [
      MainMap(onBack: _onWillPop),
      AllActivity(onBack: onBack),
      Broadcast(onBack: onBack),
      Explore(onBack: onBack),
      Chats(onBack: onBack)
    ];
  }

  Future<bool> onBack() async {
    setState(() => _currentIndex = 0);
    return Future.value(false);
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
    CurrentUser.discard();
    return Future.value(true);
  }

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
  final Future<bool> Function(BuildContext context) onBack;
  MainMap({@required this.onBack});
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
        onWillPop: () => widget.onBack(context),
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
                          center: LatLng(19.0760, 72.8777), zoom: 13),
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
            UserSearchBar()
          ],
        ),
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
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (BuildContext context) =>
                                //           Chats(onBack: onack,)),
                                // );
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

class UserSearchBar extends StatefulWidget {
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
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (_isSearch)
          Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search Users",
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.only(left: 10.0),
                  border: InputBorder.none
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
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
                                            CurrentUser.email
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
                            child: CurrentUser.profileUrl == null
                                ? Image.asset(
                                    'images/bgcover.jpg',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    CurrentUser.profileUrl,
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
