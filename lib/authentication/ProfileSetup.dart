import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../home/home.dart';
import '../services/AuthService.dart';
import '../widgets/DailogBox.dart';
import '../services/DatabaseService.dart';
import '../common/global_colors.dart';
import '../common/activitylist.dart';
import '../common/add_location.dart';
import '../data/User.dart';
import '../profile/edit_profile_page.dart';
import 'package:provider/provider.dart';

class ProfileSetup extends StatefulWidget {
  static const routeName = '/Profile-Setup';
  //final String email, password,photoUrl;
  // final AuthCredential creds;
  // ProfileSetup(this.email, this.password, this.creds,this.photoUrl);
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

List<List<String>> selectedActivityList;
List<List<String>> activityList;

class _ProfileSetupState extends State<ProfileSetup> {
  final auth = AuthService();
  @override
  void initState() {
    super.initState();
    selectedActivityList = [];
    ActivityList.getActivityList()
        .then((list) => setState(() => activityList = list));
  }

  File _image;
  String _photo, address;
  bool addressSelected = true;
  Position position;
  final addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final email = routeArgs['email'];
    final password = routeArgs['password'];
    final photoUrl = routeArgs['photoUrl'];
    final creds = routeArgs['creds'];
    final currentUser = Provider.of<User>(context);
    //_photo = CurrentUser.user.photoUrl;
    _photo = photoUrl;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "Profile Setup",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          elevation: 1.0,
          backgroundColor: Color(primary),
        ),
        body: SingleChildScrollView(
            child: Stack(overflow: Overflow.visible, children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    overflow: Overflow.visible,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(primary),
                                ),
                                borderRadius: BorderRadius.circular(6)),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                       "Name",
                                      //currentUser.name,
                                      style: TextStyle(
                                        color: Color(secondary),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                        ),
                                        color: Color(primary),
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EditProfile()));
                                          setState(() {});
                                        }),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                         "Male 22"
                                        //currentUser.gender +" "+ currentUser.age.toString(),
                                        ),
                                    Text("English"),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Text(
                                          "0 Followers",
                                          style: TextStyle(
                                            color: Color(primary),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      onTap: () {},
                                      splashColor: Colors.redAccent.shade50,
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Text(
                                          "0 Following",
                                          style: TextStyle(
                                            color: Color(primary),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      onTap: () {},
                                      splashColor: Colors.redAccent.shade50,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Color(primary)),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(2, 2),
                                    color: Colors.grey,
                                    blurRadius: 5)
                              ]),
                          child: CircleAvatar(
                            radius: 36,
                            backgroundImage: _image != null
                                ? FileImage(_image)
                                : _photo != null ? NetworkImage(_photo) : null,
                            child: (_image != null || _photo != null)
                                ? null
                                : Icon(
                                    Icons.account_circle,
                                    size: 50,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => UserSearchBar())),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search users",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 15.0, top: 15.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Your Location",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(primary),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                    child: TextField(
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        Map result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetLocation(
                              position,
                              zoom: position == null ? 10 : 13,
                              showMarker: position == null ? false : true,
                            ),
                          ),
                        );
                        if (result != null)
                          setState(() {
                            addressController.text = result['location'];
                            position = result['position'];
                            addressSelected = true;
                          });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search for a place",
                        errorText:
                            addressSelected ? null : 'Please Select a Location',
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(primary),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Color(primary),
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 10.0, bottom: 18.0, top: 18.0, right: 30.0),
                        filled: true,
                        fillColor: Color(form1),
                        hintStyle: TextStyle(
                          color: Color(formHint),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Activity Preferences",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(primary),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Select Activities",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(secondary),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllActivity()));
                          setState(() {});
                        },
                        child: Text(
                          "View all",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(primary),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  activityList == null
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          height: 107,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: activityList
                                  .map((activity) => Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: InkWell(
                                          onTap: () {
                                            activity[2] = 'true';
                                            for (var selected
                                                in selectedActivityList) {
                                              if (activity[0] == selected[0] &&
                                                  activity[1] == selected[1]) {
                                                activity[2] = 'false';
                                                break;
                                              }
                                            }
                                            if (activity[2] == 'true')
                                              setState(() {
                                                selectedActivityList.add([
                                                  activity[0],
                                                  activity[1],
                                                ]);
                                              });
                                            else
                                              for (var selected
                                                  in selectedActivityList) {
                                                if (activity[0] ==
                                                        selected[0] &&
                                                    activity[1] ==
                                                        selected[1]) {
                                                  setState(() =>
                                                      selectedActivityList.removeAt(
                                                          selectedActivityList
                                                              .indexOf(
                                                                  selected)));
                                                  break;
                                                }
                                              }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(primary),
                                                ),
                                                color: activity[2] == 'true'
                                                    ? Colors.redAccent.shade100
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            width: 110,
                                            child: Card(
                                              elevation: 5,
                                              shadowColor: Colors.white,
                                              color: activity[2] == 'true'
                                                  ? Colors.redAccent.shade100
                                                  : null,
                                              child: Column(
                                                children: <Widget>[
                                                  Image.network(
                                                    activity[0],
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                  SizedBox(height: 7),
                                                  FittedBox(
                                                    child: Text(
                                                      activity[1],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(secondary),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList()),
                        ),
                  if (selectedActivityList.length != 0)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Your Activities",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(secondary),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (selectedActivityList.length != 0)
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: 107,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: selectedActivityList
                              .map((selected) => Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(primary),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      width: 110,
                                      child: Card(
                                          child: Column(
                                        children: <Widget>[
                                          Image.network(
                                            selected[0],
                                            width: 60,
                                            height: 60,
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              FittedBox(
                                                child: Text(
                                                  selected[1],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(secondary),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                    ),
                                  ))
                              .toList()),
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: FlatButton(
                        color: Color(secondary),
                        padding: EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        onPressed: () =>_handleProfileSetup(email,password,creds),
                        child: Center(
                          child: Text(
                            "Finish",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])));
  }

  _showErrorMessage(String title, String msg) => showDialog(
      context: context,
      builder: (ctx) => DialogBox(
          title: title,
          description: msg,
          buttonText1: "Ok",
          button1Func: () => Navigator.of(context, rootNavigator: true).pop()));

  _handleProfileSetup(String email, String password, AuthCredential creds) async {
    setState(() => addressSelected = addressController.text == null ||
            addressController.text.isEmpty ||
            position.latitude == null ||
            position.longitude == null
        ? false
        : true);
    if (!addressSelected) return;
    if (selectedActivityList.length == 0) {
      _showErrorMessage("Activities", "Atleast Select one activity");
      return;
    }
    // if (_photo == null && _image == null) {
    //   _showErrorMessage("Error", "Please add a profile picture");
    //   return;
    // }
    showDialog(
        builder: (ctx) => Center(child: CircularProgressIndicator()),
        context: context);
    await DataService().completeProfile(email, selectedActivityList, {
      'coordinates': GeoPoint(position.latitude, position.longitude),
      'address': addressController.text
    });
    bool loggedIn = await auth.isUserLoggedIn();
    if (!loggedIn)
      creds != null
          ? await auth.credsSignIn(creds)
          : await auth.signIn(email, password);
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: ((ctx) => WillPopScope(
              onWillPop: () => Future.value(false),
              child: DialogBox(
                  title: "Done !",
                  description: "You've Successfully Signed Up",
                  buttonText1: "Ok",
                  button1Func: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: ((ctx) => MainHome())));
                  }),
            )));
  }
}

class AllActivity extends StatefulWidget {
  @override
  _AllActivityState createState() => _AllActivityState();
}

class _AllActivityState extends State<AllActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Color(secondary),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Done",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        title: Text(
          "All Activities",
          style: TextStyle(
            color: Color(secondary),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white54,
      ),
      body: SafeArea(
        child: Container(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: 3,
            children: <Widget>[
              for (var activity in activityList)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  child: InkWell(
                    onTap: () {
                      activity[2] = 'true';
                      for (var selected in selectedActivityList) {
                        if (activity[0] == selected[0] &&
                            activity[1] == selected[1]) {
                          activity[2] = 'false';
                          break;
                        }
                      }
                      if (activity[2] == 'true')
                        setState(() => selectedActivityList.add([
                              activity[0],
                              activity[1],
                            ]));
                      else
                        for (var selected in selectedActivityList) {
                          if (activity[0] == selected[0] &&
                              activity[1] == selected[1]) {
                            setState(() => selectedActivityList.removeAt(
                                selectedActivityList.indexOf(selected)));
                            break;
                          }
                        }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(primary),
                          ),
                          color: activity[2] == 'true'
                              ? Colors.redAccent.shade100
                              : null,
                          borderRadius: BorderRadius.circular(6)),
                      width: 110,
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.white,
                        color: activity[2] == 'true'
                            ? Colors.redAccent.shade100
                            : null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.network(
                              activity[0],
                              width: 60,
                              height: 60,
                            ),
                            SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FittedBox(
                                  child: Text(
                                    activity[1],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
