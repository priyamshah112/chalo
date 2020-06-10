import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:toast/toast.dart';

import '../Animation/FadeAnimation.dart';

class Follower extends StatefulWidget {
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
  _FollowerState createState() => _FollowerState();
}

List<List<String>> ExplorepostList;

class _FollowerState extends State<Follower> {
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
                "Followers",
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
  void initState() {
    // TODO: implement initState
    super.initState();
    ExplorepostList = [
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "10",
        "true",
        "false",
        "false",
      ],
      [
        "images/bgcover.jpg",
        "Ali Asgar",
        "3",
        "false",
        "true",
        "false",
      ],
      [
        "images/bgcover.jpg",
        "Sohil Luhar",
        "8",
        "false",
        "false",
        "true",
      ],
      [
        "images/bgcover.jpg",
        "Harsh Gupta",
        "1",
        "true",
        "false",
        "false",
      ],
      [
        "images/bgcover.jpg",
        "Mohammad Athania",
        "9",
        "false",
        "false",
        "true",
      ],
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "6",
        "false",
        "false",
        "true",
      ],
      [
        "images/bgcover.jpg",
        "Sohil Luhar",
        "4",
        "false",
        "false",
        "true",
      ],
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "6",
        "false",
        "false",
        "true",
      ],
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "3",
        "false",
        "false",
        "true",
      ],
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "1",
        "false",
        "false",
        "true",
      ],
      [
        "images/bgcover.jpg",
        "Abdul Quadir Ansari",
        "1",
        "false",
        "false",
        "true",
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                          contentPadding: EdgeInsets.only(
                              top: 8, left: 15, right: 5, bottom: 8),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                ExplorepostList[i][1],
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
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
                                    "${ExplorepostList[i][2]} activities done",
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
                          trailing: FittedBox(
                            fit: BoxFit.fill,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      height: 27,
                                      child: ExplorepostList[i][3] == "true"
                                          ? OutlineButton(
                                              onPressed: () {
                                                followbtn();
                                                setState(() {
                                                  ExplorepostList[i][4] =
                                                      "true";
                                                  ExplorepostList[i][3] =
                                                      "false";
                                                  ExplorepostList[i][5] =
                                                      "false";
                                                  print(ExplorepostList[i][3]);
                                                });
                                                print(ExplorepostList[i][3]);
                                              },
                                              borderSide: BorderSide(
                                                color: Color(
                                                    primary), //Color of the border
                                                style: BorderStyle
                                                    .solid, //Style of the border
                                                width:
                                                    0.9, //width of the border
                                              ),
                                              color: Color(primary),
                                              textColor: Color(primary),
                                              child: Text(
                                                "follow",
                                                style: TextStyle(
                                                  fontFamily: bodyText,
                                                ),
                                              ),
                                            )
                                          : ExplorepostList[i][4] == "true"
                                              ? FlatButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      ExplorepostList[i][3] =
                                                          "true";
                                                      ExplorepostList[i][4] =
                                                          "false";
                                                      ExplorepostList[i][5] =
                                                          "false";
                                                    });
                                                  },
                                                  color: Color(primary),
                                                  textColor: Colors.white,
                                                  child: Text(
                                                    "Requested",
                                                    style: TextStyle(
                                                      fontFamily: bodyText,
                                                    ),
                                                  ),
                                                )
                                              : FlatButton(
                                                  onPressed: () {
                                                    unfollow();
                                                    setState(() {
                                                      ExplorepostList[i][4] =
                                                          "false";
                                                      ExplorepostList[i][3] =
                                                          "true";
                                                      ExplorepostList[i][5] =
                                                          "false";
                                                    });
                                                  },
                                                  color: Color(primary),
                                                  textColor: Colors.white,
                                                  child: Text(
                                                    "Following",
                                                    style: TextStyle(
                                                      fontFamily: bodyText,
                                                    ),
                                                  ),
                                                ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: (){},
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent.shade200,
                                  ),
                                ),
                              ],
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
    );
  }

  void followbtn() {
    showDialog(
      context: context,
      builder: (ctx) => DialogBox(
        title: 'Follow',
        titleColor: Color(primary),
        description: "Your request to follow this user hase been sent",
        buttonText1: "Done",
        btn1Color: Color(primary),
        button1Func: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }

  void unfollow() {
    showDialog(
        context: context,
        builder: (ctx) => DialogBox(
            title: 'Unfollow',
            titleColor: Color(primary),
            description:
                "Are you sure you want to unfollow Abdul Quadir Ansari.",
            buttonText1: "Cancel",
            btn1Color: Color(primary),
            button1Func: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            buttonText2: "Unfollow",
            btn2Color: Colors.red,
            button2Func: () async {
              Navigator.of(context, rootNavigator: true).pop();
              // To close the dialog
            }));
  }
}
