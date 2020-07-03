import 'dart:async';
import 'dart:io';
import 'package:chaloapp/Animation/FadeAnimation.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/profile/edit_profile_page.dart';
import 'package:chaloapp/profile/follow_request.dart';
import 'package:chaloapp/profile/following.dart';
import 'package:chaloapp/Explore/post_details.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'followers.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

List<List<String>> selectedActivityList;
List<List<String>> activityList;
List<List<String>> postList;

class _ProfilePageState extends State<ProfilePage> {
  String _name,
      _email,
      _phone,
      _dob,
      _job,
      _about,
      _lang,
      _city,
      _state,
      _country,
      _profile_pic,
      _fb,
      _twitter,
      _insta,
      _linkedin,
      _web,
      _gender;
  Future<bool> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name');
    _email = prefs.getString('email');
    _gender = prefs.getString('gender');
    _phone = prefs.getString('phone');
    _dob = prefs.getString('dob');
    _profile_pic = prefs.getString('profile_pic');
    _about = prefs.getString('about');
    _job = prefs.getString('job');
    _lang = prefs.getString('lang');
    _country = prefs.getString('country');
    _state = prefs.getString('state');
    _city = prefs.getString('city');
    _fb = prefs.getString('facebook');
    _twitter = prefs.getString('twitter');
    _insta = prefs.getString('instagram');
    _linkedin = prefs.getString('linkedin');
    _web = prefs.getString('website');
    return true;
  }

  @override
  void initState() {
    super.initState();
    activityList = [
      ['images/activities/Beach.png', 'Beach', 'false'],
      ['images/activities/BirdWatching.png', 'Bird Watching', 'false'],
      ['images/activities/Canoeing.png', 'Caneoing', 'false'],
      ['images/activities/Hiking.png', 'Hiking', 'false'],
      ['images/activities/BeachBBQ.png', 'Beach BBQ', 'false'],
      ['images/activities/Camping.png', 'Camping', 'false'],
      ['images/activities/Cycling.png', 'Cycling', 'false'],
      ['images/activities/DogWalking.png', 'Dog Walking', 'false'],
      ['images/activities/Fishing.png', 'Fishing', 'false'],
      ['images/activities/Gardening.png', 'Gardening', 'false'],
      ['images/activities/Gym.png', 'Gym', 'false'],
      ['images/activities/MountainBiking.png', 'Mountain Biking', 'false'],
      ['images/activities/Picnic.png', 'Picnic', 'false'],
      ['images/activities/Kayaking.png', 'Kayaking', 'false'],
      ['images/activities/Museum.png', 'Museum', 'false'],
    ];
    selectedActivityList = [];

    postList = [
      ['images/post/1.png', "Beach BBQ", 'Caption 1', "30 min ago"],
      ['images/post/2.jpeg', "Camping", 'Caption 2', "2 day ago"],
      ['images/post/3.png', "Cycling", 'Caption 3', '2 PM'],
      ['images/post/4.png', "Fishing", 'Caption 4', '2 PM'],
      ['images/post/5.png', "Hiking", 'Caption 5', '2 PM'],
      ['images/post/6.png', "Long Drive", 'Caption 6', '2 PM'],
      ['images/post/7.png', "Museum", 'Caption 7', '2 PM'],
      ['images/post/8.png', "Cricket", 'Caption 8', '2 PM'],
      ['images/post/9.png', "Running", 'Caption 9', '2 PM'],
      ['images/post/10.jpg', "Skiing", 'Caption 10', '2 PM'],
      ['images/post/11.jpg', "Walking", 'Caption 11', '2 PM'],
      ['images/post/12.jpg', "City Tour", 'Caption 12', '2 PM'],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "My Profile",
            style: TextStyle(
              color: Colors.white,
              fontFamily: bodyText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: InkWell(
          onTap: () {},
          child: Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Edit Profile',
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      EditProfile(name: _name, gender: _gender)),
            ),
          ),
        ],
        elevation: 1.0,
        backgroundColor: Color(primary),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return FadeAnimation(
              1.5,
              DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          if (Followers.followRequests.length > 0)
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(primary),
                                      ),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.person_add,
                                      color: Color(primary),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 8),
                                    title: Text(
                                      "You have ${Followers.followRequests.length} new requests",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Color(primary),
                                      ),
                                    ),
                                    trailing: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Container(
                                          width: 90,
                                          height: 27,
                                          child: RaisedButton(
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        FollowReq(
                                                            requests: Followers
                                                                .followRequests)),
                                              );
                                              setState(() {});
                                            },
                                            color: Color(primary),
                                            textColor: Colors.white,
                                            child: Text(
                                              "See all",
                                              style: TextStyle(
                                                fontFamily: bodyText,
                                              ),
                                            ),
                                          )),
                                    ),
                                  )),
                            ),
                          ProfileCard(
                            email: _email,
                            username: _name,
                            gender: _gender,
                            job: _job,
                            lang: _lang,
                            profilePic: _profile_pic,
                            follower: Followers.followers.length,
                            following: Followers.following.length,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search users",
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(primary),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 30.0,
                                    bottom: 15.0,
                                    top: 15.0,
                                    right: 0.0),
                                filled: true,
                                fillColor: Color(form1),
                                hintStyle: TextStyle(
                                  fontFamily: bodyText,
                                  color: Color(formHint),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ];
                  },
                  body: Column(
                    children: <Widget>[
                      TabBar(
                        labelColor: Color(primary),
                        unselectedLabelColor: Color(secondary),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            color: Color(background1)),
                        tabs: [
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Activity",
                                style: TextStyle(
                                  fontFamily: heading,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "About",
                                style: TextStyle(
                                  fontFamily: heading,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Post",
                                style: TextStyle(
                                  fontFamily: heading,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            //Activity Tab
                            SingleChildScrollView(
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        "Activity Preferences",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(primary),
                                          fontFamily: heading,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Select Activities",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: heading,
                                              color: Color(secondary),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          allActivity()));
                                            },
                                            child: Text(
                                              "View all",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Color(primary),
                                                fontFamily: heading,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 107,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: <Widget>[
                                            for (int i = 0;
                                                i < activityList.length;
                                                i++)
                                              Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    activityList[i][2] = 'true';
                                                    for (int j = 0;
                                                        j <
                                                            selectedActivityList
                                                                .length;
                                                        j++) {
                                                      if (activityList[i][0] ==
                                                              selectedActivityList[
                                                                  j][0] &&
                                                          activityList[i][1] ==
                                                              selectedActivityList[
                                                                  j][1]) {
                                                        activityList[i][2] =
                                                            'false';
                                                        break;
                                                      }
                                                    }
                                                    print(activityList[i][2]);
                                                    if (activityList[i][2] ==
                                                        'true')
                                                      setState(() {
                                                        selectedActivityList
                                                            .add([
                                                          activityList[i][0],
                                                          activityList[i][1],
                                                        ]);
                                                      });
                                                    else
                                                      for (int j = 0;
                                                          j <
                                                              selectedActivityList
                                                                  .length;
                                                          j++) {
                                                        if (activityList[i]
                                                                    [0] ==
                                                                selectedActivityList[
                                                                    j][0] &&
                                                            activityList[i]
                                                                    [1] ==
                                                                selectedActivityList[
                                                                    j][1]) {
                                                          selectedActivityList
                                                              .removeAt(j);
                                                          break;
                                                        }
                                                      }
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Color(primary),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
                                                    width: 110,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        activityList[i][2] ==
                                                                'true'
                                                            ? Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  color: Colors
                                                                      .green
                                                                      .shade100,
                                                                ),
                                                              )
                                                            : Text(''),
                                                        ListTile(
                                                          title: Image.asset(
                                                            activityList[i][0],
                                                            width: 60,
                                                            height: 60,
                                                          ),
                                                          subtitle: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 7),
                                                            child: Text(
                                                              activityList[i]
                                                                  [1],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    bodyText,
                                                                color: Color(
                                                                    secondary),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      selectedActivityList.length != 0
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                "Your Activities",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color(secondary),
                                                  fontFamily: heading,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          : Text(""),
                                      selectedActivityList.length != 0
                                          ? Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              height: 107,
                                              child: ListView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: <Widget>[
                                                  for (int i = 0;
                                                      i <
                                                          selectedActivityList
                                                              .length;
                                                      i++)
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(2.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Color(
                                                                      primary),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                        width: 110,
                                                        child: ListTile(
                                                          title: Image.asset(
                                                            selectedActivityList[
                                                                i][0],
                                                            width: 60,
                                                            height: 60,
                                                          ),
                                                          subtitle: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 7),
                                                            child: Text(
                                                              selectedActivityList[
                                                                  i][1],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    bodyText,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    secondary),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      Text(
                                        "Invite Recieve Radius",
                                        style: TextStyle(
                                          color: Color(primary),
                                          fontFamily: heading,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1.0,
                                              style: BorderStyle.solid,
                                              color: Color(primary),
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                          ),
                                        ),
                                        child: selectRadius(),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //About Tab
                            SingleChildScrollView(
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        "About Me",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(primary),
                                          fontFamily: heading,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 10.0, bottom: 5.0),
                                        child: Text(
                                          _about ?? 'Add about',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: bodyText,
                                            color: Color(secondary),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      if (_job != null)
                                        InfoDetail(
                                            title: 'Job Title', text: _job),
                                      if (_lang != null)
                                        InfoDetail(
                                            title: 'Language', text: _lang),
                                      InfoDetail(title: 'Email', text: _email),
                                      InfoDetail(
                                          title: 'Contact', text: _phone),
                                      InfoDetail(
                                          title: 'Gender', text: _gender),
                                      InfoDetail(
                                          title: 'Birth Date', text: _dob),
                                      InfoDetail(
                                          title: 'Country', text: 'India'),
                                      InfoDetail(
                                          title: 'State', text: 'Maharashtra'),
                                      InfoDetail(title: 'City', text: 'Mumbai'),
                                      Divider(
                                        thickness: 1,
                                        height: 20.0,
                                        color: Color(primary),
                                      ),
                                      Text(
                                        "Social Information",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(primary),
                                          fontFamily: heading,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      InfoDetail(title: 'Facebook', text: _fb),
                                      InfoDetail(
                                          title: 'Instagram', text: _insta),
                                      InfoDetail(title: 'LinkedIn', text: ''),
                                      InfoDetail(title: 'Twitter', text: ''),
                                      InfoDetail(
                                          title: 'Website/Blog', text: ''),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //Post Tab
                            ListView(
                              children: <Widget>[
                                Container(
                                  child: Wrap(
                                    children: <Widget>[
                                      for (int i = 0; i < postList.length; i++)
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(postList[i][0]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          PostItem(
                                                    dp: 'images/bgcover.jpg',
                                                    name: _name,
                                                    img: postList[i][0],
                                                    activityName: postList[i]
                                                        [1],
                                                    caption: postList[i][2],
                                                    time: postList[i][3],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  int _radius = 5;
  DropdownButton selectRadius() => DropdownButton<int>(
        items: [5, 10, 15, 20, 25, 50, 100]
            .map((radius) => DropdownMenuItem<int>(
                  value: radius,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Less than $radius kilometers',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(secondary),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        _radius == radius ? Icons.check : null,
                      ),
                    ],
                  ),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _radius = value;
          });
        },
        icon: Icon(Icons.arrow_downward),
        iconSize: 20.0,
        iconEnabledColor: Color(primary),
        underline: Container(),
        hint: Text(
          'Less than $_radius kilometers',
          style: TextStyle(
            color: Colors.black,
            fontFamily: bodyText,
          ),
        ),
        elevation: 0,
        isExpanded: true,
      );
}

class InfoDetail extends StatelessWidget {
  const InfoDetail({Key key, @required this.title, @required this.text})
      : super(key: key);
  final String title, text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontFamily: heading,
              color: Color(primary),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontFamily: bodyText,
              color: Color(secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard(
      {Key key,
      @required this.email,
      @required this.username,
      @required this.gender,
      @required this.follower,
      @required this.following,
      this.job,
      this.lang,
      this.isCurrent = true,
      this.profilePic})
      : super(key: key);
  final String email, username, job, lang, gender, profilePic;
  final int follower, following;
  final bool isCurrent;

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _following, _pending;
  int followers, following;

  @override
  void initState() {
    super.initState();
    if (!widget.isCurrent) {
      _following = Followers.following.contains(widget.email) ? true : false;
      _pending = Followers.requested.contains(widget.email) ? true : false;
    } else
      _update();
  }

  void _update() {
    followers = Followers.followers.length;
    following = Followers.following.length;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
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
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.username,
                            style: TextStyle(
                              color: Color(primary),
                              fontSize: 18,
                              fontFamily: heading,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.trophy,
                                color: Colors.amberAccent,
                                size: 12,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                " 0 activities Done",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: bodyText,
                                  color: Color(secondary),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${widget.gender}, 22",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: bodyText,
                              color: Color(secondary),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          if (widget.job != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Job Title",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: bodyText,
                                    color: Color(primary),
                                  ),
                                ),
                                Text(
                                  widget.job,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: bodyText,
                                  ),
                                ),
                              ],
                            ),
                          Spacer(),
                          if (widget.lang != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Language",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: bodyText,
                                    color: Color(primary),
                                  ),
                                ),
                                Text(
                                  widget.lang,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: bodyText,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Text(
                                "${!widget.isCurrent ? widget.follower : followers} Followers",
                                style: TextStyle(
                                  fontFamily: bodyText,
                                  color: Color(primary),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            onTap: widget.isCurrent
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Follower(),
                                      ),
                                    );
                                  }
                                : null,
                            splashColor: Color(background1),
                          ),
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Text(
                                "${!widget.isCurrent ? widget.following : following} Following",
                                style: TextStyle(
                                  color: Color(primary),
                                  fontFamily: bodyText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            onTap: widget.isCurrent
                                ? () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Following(),
                                      ),
                                    );
                                    await Future.delayed(
                                        Duration(milliseconds: 500));
                                    setState(() => _update());
                                  }
                                : null,
                            splashColor: Color(background1),
                          ),
                        ],
                      ),
                      if (!widget.isCurrent)
                        Container(
                          width: double.infinity,
                          height: 27,
                          margin: const EdgeInsets.only(top: 10),
                          child: RaisedButton(
                            onPressed: () => _following
                                ? _handleUnfollow(context)
                                : _handleFollowRequest(),
                            elevation: 2,
                            shape: ContinuousRectangleBorder(
                                side: BorderSide(
                              color: Color(primary), //Color of the border
                              style: BorderStyle.solid, //Style of the border
                              width: 0.9, //width of the border
                            )),
                            textColor: _following || _pending
                                ? Colors.white
                                : Color(primary),
                            color: _following || _pending
                                ? Color(primary)
                                : Colors.white,
                            child: Text(
                              _following
                                  ? 'Following'
                                  : _pending ? 'Requested' : 'Follow',
                              style: TextStyle(
                                fontFamily: bodyText,
                              ),
                            ),
                            splashColor: Color(primary),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1.5,
                  color: Color(primary),
                ),
                shape: BoxShape.circle),
            margin: EdgeInsets.only(top: 20),
            width: 55.0,
            height: 55.0,
            child: CircleAvatar(
                radius: 27.5,
                foregroundColor: Color(primary),
                backgroundColor: Color(background1),
                backgroundImage: widget.profilePic != null
                    ? NetworkImage(widget.profilePic)
                    : null,
                child: widget.profilePic == null
                    ? Icon(
                        Icons.account_circle,
                        size: 50,
                      )
                    : null),
          ),
        ),
      ],
    );
  }

  _handleUnfollow(BuildContext context) async {
    var result = await showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                onTap: () async {
                  DataService().unFollow(widget.email);
                  Navigator.of(context).pop(false);
                },
                leading: Icon(Icons.cancel, color: Colors.redAccent),
                title: Text(
                  'Unfollow',
                  style: TextStyle(color: Colors.redAccent),
                )),
          ],
        ),
      ),
    );
    setState(() => _following = result ?? true);
  }

  _handleFollowRequest() async {
    await DataService().requestFollow(widget.email, !_pending);
    setState(() {
      _pending = !_pending;
    });
  }
}

class allActivity extends StatefulWidget {
  @override
  _allActivityState createState() => _allActivityState();
}

class _allActivityState extends State<allActivity> {
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
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: bodyText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        title: Center(
          child: Text(
            "All Activities",
            style: TextStyle(
              color: Colors.white,
              fontFamily: bodyText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 1.0,
        backgroundColor: Color(primary),
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
              for (int i = 0; i < activityList.length; i++)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  child: InkWell(
                    onTap: () {
                      activityList[i][2] = 'true';
                      for (int j = 0; j < selectedActivityList.length; j++) {
                        if (activityList[i][0] == selectedActivityList[j][0] &&
                            activityList[i][1] == selectedActivityList[j][1]) {
                          activityList[i][2] = 'false';
                          break;
                        }
                      }
                      print(activityList[i][2]);
                      if (activityList[i][2] == 'true')
                        setState(() {
                          selectedActivityList.add([
                            activityList[i][0],
                            activityList[i][1],
                          ]);
                        });
                      else
                        for (int j = 0; j < selectedActivityList.length; j++) {
                          if (activityList[i][0] ==
                                  selectedActivityList[j][0] &&
                              activityList[i][1] ==
                                  selectedActivityList[j][1]) {
                            selectedActivityList.removeAt(j);
                            break;
                          }
                        }
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(primary),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Stack(
                        children: <Widget>[
                          activityList[i][2] == 'true'
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.green.shade100,
                                  ),
                                )
                              : Text(""),
                          Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                Image.asset(
                                  activityList[i][0],
                                  width: 60,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FittedBox(
                                  child: Text(
                                    activityList[i][1],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: bodyText,
                                      fontWeight: FontWeight.bold,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
