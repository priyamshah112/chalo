import 'package:chaloapp/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:toast/toast.dart';

import 'Animation/FadeAnimation.dart';

class Following extends StatefulWidget {
//  final String dp;
//  final String name;
//  final String time;
//  final String img;
//  final String caption;
//  final String activityName;
//
//  Explore({
//    Key key,
//    @required this.dp,
//    @required this.name,
//    @required this.time,
//    @required this.img,
//    @required this.caption,
//    @required this.activityName,
//  }) : super(key: key);
  @override
  _FollowingState createState() => _FollowingState();
}

List<List<String>> ExplorepostList;

class _FollowingState extends State<Following> {
  int likeCount = 9;
  bool isLikeTap = false;
  bool _search = false;

  Widget appbar() {
    return _search
        ? AppBar(
            leading: Align(
                alignment: Alignment.centerRight, child: Icon(Icons.search)),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => setState(() => _search = false))
            ],
            backgroundColor: Color(primary),
            title: FadeAnimation(
              0.3,
              TextField(
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                keyboardType: TextInputType.text,
                autofocus: true,
                cursorColor: Colors.white,
                cursorWidth: 2,
                decoration: InputDecoration(
                  hintText: " Search",
                  contentPadding: const EdgeInsets.only(
                    bottom: 18.0,
                    top: 18.0,
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ))
        : AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => setState(() => _search = true))
            ],
            backgroundColor: Color(primary),
            title: Center(
              child: Text(
                "Followings",
                style: TextStyle(
//              color: Color(secondary),
                    ),
              ),
            ),
            centerTitle: true,
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

  @override
  Widget build(BuildContext context) {
    ExplorepostList = [
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "Beach BBQ",
        'images/post/1.png',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        "30 min ago",
        "19",
        "20"
      ],
      [
        "images/bgcover.jpg",
        "Ali Asgar",
        "Camping",
        'images/post/2.jpeg',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        "2 day ago",
        "25",
        "40"
      ],
      [
        "images/bgcover.jpg",
        "Sohail Luhar",
        "Cycling",
        'images/post/3.png',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        '2 PM',
        "15",
        "19"
      ],
      [
        "images/bgcover.jpg",
        "Harsh Gupta",
        "Fishing",
        'images/post/4.png',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        '2 PM',
        "98",
        "89"
      ],
      [
        "images/bgcover.jpg",
        "Mohammad Athania",
        "Hiking",
        'images/post/5.png',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        '2 PM',
        "34",
        "54"
      ],
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "Long Drive",
        'images/post/6.png',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        '2 PM',
        "64",
        "44"
      ],
      [
        "images/bgcover.jpg",
        "Sohil Luhar",
        "Cricket",
        'images/post/8.png',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        '2 PM',
        "19",
        "20"
      ],
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "Running",
        'images/post/9.png',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        '2 PM',
        "9",
        "23"
      ],
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "Skiing",
        'images/post/10.jpg',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        '2 PM',
        "10",
        "3"
      ],
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "Walking",
        'images/post/11.jpg',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        '2 PM',
        "19",
        "20"
      ],
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "City Tour",
        'images/post/12.jpg',
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pretium posuere tellus, ut congue lectus dignissim eu",
        '2 PM',
        "5",
        "10"
      ],
    ];
    bool isFollowing = true;
    return Scaffold(
      appBar: appbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < ExplorepostList.length; i++)
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                              ExplorepostList[i][0],
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                ExplorepostList[i][1],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(secondary),
                                ),
                              ),
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
                                    ExplorepostList[i][2],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: bodyText,
                                      color: Color(secondary),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: isFollowing ? 100 : 100,
                                height: 27,
                                child: RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isFollowing) {
                                        isFollowing = false;
                                      } else if (isFollowing == false) {
                                        isFollowing = true;
                                      }
                                    });
                                    print(isFollowing);
                                  },
                                  color: Color(primary),
                                  textColor: Colors.white,
                                  elevation: 0,
                                  child: Text(
                                    isFollowing ? "Following" : "Requested",
                                    style: TextStyle(
                                      fontFamily: bodyText,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}
