import 'dart:async';

import 'package:chalo/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Animation/FadeAnimation.dart';
import '../Settings/setting.dart';
import '../data/User.dart';
import '../services/DatabaseService.dart';
import '../common/global_colors.dart';
import '../Explore/explore.dart';
import 'followers.dart';
import 'edit_profile_page.dart';
import 'follow_request.dart';
import 'following.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final String name, userEmail;
  const ProfilePage({this.user, this.userEmail, this.name})
      : assert(user != null || userEmail != null);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

List<List<String>> selectedActivityList;
List<List<String>> activityList;
List<List<String>> postList;

class _ProfilePageState extends State<ProfilePage> {
  CurrentUser currentUser = CurrentUser();
  bool isCurrent;
  String username;
  Future<bool> getUser() async {
    if (widget.user == null) {
      final db = DataService();
      final userDoc = (await db.getUserDoc(widget.userEmail)).data;
      final userInfo = (await db.getUserInfo(widget.userEmail)).data;
      currentUser = CurrentUser();
      currentUser.name = userDoc['name'];
      currentUser.email = userDoc['email'];
      currentUser.gender = userDoc['gender'];
      currentUser.address = userDoc['address'];
      currentUser.photoUrl = userDoc['profile_pic'];
      currentUser.phone = userDoc['mobile_no'];
      currentUser.age = CurrentUser.ageFromDob(userDoc['dob']);
      currentUser.activityCompleted = userDoc['activities_completed'];
      currentUser.following = userInfo['following_id'];
      currentUser.followers = userInfo['followers_id'];
      currentUser.followRequests = userInfo['follow_requests'];
      currentUser.posts = userInfo['posts'] ?? [];
      currentUser.requested = userInfo['follow_requested'];
      currentUser.about = userInfo['about'];
      currentUser.lang = userInfo['languages'];
      currentUser.job = userInfo['job'];
      currentUser.country = userInfo['country'];
      currentUser.state = userInfo['state'];
      currentUser.city = userInfo['city'];
      currentUser.facebook = userInfo['facebook_acc'];
      currentUser.insta = userInfo['instagram_acc'];
      currentUser.linkedin = userInfo['linkedin_acc'];
      currentUser.twitter = userInfo['twitter_acc'];
      currentUser.website = userInfo['website'];
      currentUser.birthDate = userDoc['dob'];
      currentUser.age = DateTime.now().year -
          int.parse(currentUser.birthDate.split('/').last);
    } else
      currentUser = widget.user;
    return true;
  }

  @override
  void initState() {
    super.initState();
    isCurrent = widget.user != null;
    if (!isCurrent) username = widget.name;
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: buildProfileAppBar(context),
      body: FutureBuilder(
          future: getUser(),
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
                          if (currentUser.followRequests.length > 0 &&
                              currentUser.email == CurrentUser.userEmail)
                            buildFollowRequests(context),
                          ProfileCard(
                            isCurrent: isCurrent,
                              email: currentUser.email,
                              username: currentUser.name,
                              gender: currentUser.gender,
                              age: currentUser.age,
                              job: currentUser.job,
                              lang: currentUser.lang,
                              profilePic: currentUser.photoUrl,
                              follower: currentUser.followers.length,
                              following: currentUser.following.length,
                              activities: currentUser.activityCompleted),
                          //buildUserSearch(),
                        ]),
                      ),
                    ];
                  },
                  body: Column(
                    children: <Widget>[
                      //buildUserSearch(),
                      Container(
                        height: 150,
                        child: ProfileSearchBar(forHome: true)
                      ),
                      buildTabBar(),
                      Expanded(
                        child: TabBarView(
                          children: [
                            //Activity Tab
                            buildActivityTab(context),
                            //About Tab
                            buildAboutTab(),
                            //Post Tab
                            buildPostTab()
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

  AppBar buildProfileAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Center(
        child: Text(
          "${isCurrent ? 'My' : username + '\'s'} Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: bodyText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      leading: !isCurrent
          ? null
          : InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Setting()));
              },
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
      actions: !isCurrent
          ? null
          : <Widget>[
              IconButton(
                  tooltip: 'Edit Profile',
                  icon: Icon(
                    Icons.edit,
                  ),
                  onPressed: () async {
                    bool updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => EditProfile()));
                    if (updated) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Profile updated',
                            style: TextStyle(color: Color(primary)),
                          ),
                          duration: Duration(seconds: 2)));
                      setState(() {});
                    }
                  }),
            ],
      elevation: 1.0,
      backgroundColor: Color(primary),
    );
  }

  SingleChildScrollView buildPostTab() {

    return SingleChildScrollView(
      child: Wrap(
        children: (currentUser.posts.length == 0)
            ? [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Text(
                      "You haven't posted anything",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ]
            : currentUser.posts
                .map(
                  (post) => FutureBuilder(
                      future: Firestore.instance
                          .collection("posts")
                          .document(post)
                          .get(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        return Container(
                          height: MediaQuery.of(context).size.width / 3,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                              image: snapshot.hasData
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data.data['image_url']),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: !snapshot.hasData ? Colors.grey : null),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Scaffold(
                                  body: SafeArea(
                                    child: Center(
                                      child: PostCard(
                                        post: snapshot.data.data
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
                .toList(),
      ),
    );
  }

  SingleChildScrollView buildAboutTab() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                child: Text(
                  currentUser.about ?? 'Add about',
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
              if (currentUser.job != null)
                InfoDetail(title: 'Job Title', text: currentUser.job),
              if (currentUser.lang != null)
                InfoDetail(title: 'Language', text: currentUser.lang),
              InfoDetail(title: 'Email', text: currentUser.email),
              InfoDetail(title: 'Contact', text: currentUser.phone),
              InfoDetail(title: 'Gender', text: currentUser.gender),
              InfoDetail(title: 'Birth Date', text: currentUser.birthDate),
              InfoDetail(title: 'Country', text: 'India'),
              InfoDetail(title: 'State', text: 'Maharashtra'),
              InfoDetail(title: 'City', text: 'Mumbai'),
              Divider(
                thickness: 1,
                height: 20.0,
                color: Color(primary),
              ),
              GestureDetector(
                onTap: () {
                  print(currentUser.linkedin);
                },
                child: Text(
                  "Social Information",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(primary),
                    fontFamily: heading,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 5),
              InfoDetail(title: 'Facebook', text: currentUser.facebook),
              InfoDetail(title: 'Instagram', text: currentUser.insta),
              InfoDetail(title: 'LinkedIn', text: currentUser.linkedin),
              InfoDetail(title: 'Twitter', text: currentUser.twitter),
              InfoDetail(title: 'Website/Blog', text: currentUser.website),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildActivityTab(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              builder: (context) => AllActivity()));
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
                    for (int i = 0; i < activityList.length; i++)
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            activityList[i][2] = 'true';
                            for (int j = 0;
                                j < selectedActivityList.length;
                                j++) {
                              if (activityList[i][0] ==
                                      selectedActivityList[j][0] &&
                                  activityList[i][1] ==
                                      selectedActivityList[j][1]) {
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
                              for (int j = 0;
                                  j < selectedActivityList.length;
                                  j++) {
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
                                borderRadius: BorderRadius.circular(6)),
                            width: 110,
                            child: Stack(
                              children: <Widget>[
                                activityList[i][2] == 'true'
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.green.shade100,
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
                                    padding: EdgeInsets.only(top: 7),
                                    child: Text(
                                      activityList[i][1],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: bodyText,
                                        color: Color(secondary),
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
                      margin: EdgeInsets.symmetric(vertical: 10),
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
                      margin: EdgeInsets.only(bottom: 20),
                      height: 107,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          for (int i = 0; i < selectedActivityList.length; i++)
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(primary),
                                    ),
                                    borderRadius: BorderRadius.circular(6)),
                                width: 110,
                                child: ListTile(
                                  title: Image.asset(
                                    selectedActivityList[i][0],
                                    width: 60,
                                    height: 60,
                                  ),
                                  subtitle: Container(
                                    padding: EdgeInsets.only(top: 7),
                                    child: Text(
                                      selectedActivityList[i][1],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: bodyText,
                                        fontWeight: FontWeight.bold,
                                        color: Color(secondary),
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
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.0,
                      style: BorderStyle.solid,
                      color: Color(primary),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: selectRadius(),
                padding: EdgeInsets.symmetric(horizontal: 15),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TabBar buildTabBar() {
    return TabBar(
      labelColor: Color(primary),
      unselectedLabelColor: Color(secondary),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
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
    );
  }

  Padding buildUserSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
              left: 30.0, bottom: 15.0, top: 15.0, right: 0.0),
          filled: true,
          fillColor: Color(form1),
          hintStyle: TextStyle(
            fontFamily: bodyText,
            color: Color(formHint),
          ),
        ),
      ),
    );
  }

  Widget buildFollowRequests(BuildContext context) {
    return Padding(
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            title: Text(
              "You have ${currentUser.followRequests.length} new requests",
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
                            builder: (BuildContext context) => FollowReq(
                                requests: currentUser.followRequests)),
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
      @required this.age,
      @required this.follower,
      @required this.following,
      @required this.activities,
      this.job,
      this.lang,
      this.isCurrent = true,
      this.profilePic})
      : super(key: key);
  final String email, username, job, lang, gender, profilePic;
  final int follower, following, activities, age;
  final bool isCurrent;

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isFollowing, _pending;
  int followers, following;

  @override
  void initState() {
    super.initState();
    if (!widget.isCurrent) {
      _isFollowing =
          CurrentUser.user.following.contains(widget.email) ? true : false;
      _pending =
          CurrentUser.user.requested.contains(widget.email) ? true : false;
    } else
      _update();
    
  }

  void _update() {
    followers = CurrentUser.user.followers.length;
    following = CurrentUser.user.following.length;
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
          child: FutureBuilder(
            future: Firestore.instance
                .collection('users')
                .document(widget.email)
                .get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              return Column(
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
                                    " ${widget.activities} Activities Done",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${widget.gender}, ${widget.age}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: bodyText,
                                  color: Color(secondary),
                                ),
                              ),
                            ],
                          ),
                          if (widget.isCurrent)
                            SizedBox(
                              height: 10,
                            ),
                          if (widget.isCurrent)
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.monetization_on,
                                  color: Colors.amberAccent,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  //" ${CurrentUser.user.coins} coins",
                                  snapshot.data.data['coins'].toString() + " coins",
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
                                        if (widget.isCurrent)
                                          setState(() => _update());
                                      }
                                    : null,
                                splashColor: Color(background1),
                              ),
                            ],
                          ),
                          if (!widget.isCurrent)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 27,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: RaisedButton(
                                    onPressed: () => _isFollowing
                                        ? _handleUnfollow(context)
                                        : _handleFollowRequest(),
                                    elevation: 2,
                                    shape: ContinuousRectangleBorder(
                                        side: BorderSide(
                                      color: Color(primary), //Color of the border
                                      style:
                                          BorderStyle.solid, //Style of the border
                                      width: 0.9, //width of the border
                                    )),
                                    textColor: _isFollowing || _pending
                                        ? Colors.white
                                        : Color(primary),
                                    color: _isFollowing || _pending
                                        ? Color(primary)
                                        : Colors.white,
                                    child: Text(
                                      _isFollowing
                                          ? 'Following'
                                          : _pending ? 'Requested' : 'Follow',
                                      style: TextStyle(
                                        fontFamily: bodyText,
                                      ),
                                    ),
                                    splashColor: Color(primary),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 27,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: RaisedButton(
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => ProfilePage(
                                                userEmail: widget.email,
                                                name: widget.username
                                                    .split(' ')
                                                    .first))),
                                    elevation: 2,
                                    shape: ContinuousRectangleBorder(
                                        side: BorderSide(
                                      color: Color(primary), //Color of the border
                                      style:
                                          BorderStyle.solid, //Style of the border
                                      width: 0.9, //width of the border
                                    )),
                                    textColor: Color(primary),
                                    color: Colors.white,
                                    child: Text(
                                      'View Profile',
                                      style: TextStyle(
                                        fontFamily: bodyText,
                                      ),
                                    ),
                                    splashColor: Color(primary),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
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
    setState(() => _isFollowing = result ?? true);
  }

  _handleFollowRequest() async {
    await DataService().requestFollow(widget.email, !_pending);
    setState(() {
      _pending = !_pending;
    });
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

class ProfileSearchBar extends StatefulWidget {
  ProfileSearchBar({this.forHome = false});
  final bool forHome;
  @override
  _ProfileSearchBarState createState() => _ProfileSearchBarState();
}

class _ProfileSearchBarState extends State<ProfileSearchBar> {
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
          _query =
              _query.length == 1 ? _query.toUpperCase() : capitalize(_query);
          // for multiple words
          List<String> words = _query.split(' ');
          if (words.length > 1) {
            for (var i = 1; i < words.length; i++)
              words[i] = words[i].length == 1
                  ? words[i].toUpperCase()
                  : capitalize(words[i]);
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
    print(_isSearch);
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
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
                                            CurrentUser.userEmail
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((_) => ProfilePage(
                                                    user: CurrentUser.user))))
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
                                                              user['name'],
                                                          profilePic: user[
                                                              'profile_pic'],
                                                          gender:
                                                              user['gender'],
                                                          follower:
                                                              user['followers'],
                                                          following:
                                                              user['following'],
                                                          activities: user[
                                                              'activities_completed'],
                                                          age: CurrentUser
                                                              .ageFromDob(
                                                                  user['dob']),
                                                          isCurrent: false),
                                                    ])),
                                    title: Text(user['name']),
                                    subtitle: Text(user['email']),
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _isSearch = true);
                          FocusScope.of(context).requestFocus(_searchFocus);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text('Search Users'),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
      ],
    );
  }
}
