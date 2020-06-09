import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:toast/toast.dart';

import '../Animation/FadeAnimation.dart';

class Setting extends StatefulWidget {
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
  _SettingState createState() => _SettingState();
}

List<List<String>> ExplorepostList;

class _SettingState extends State<Setting> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Setting",
            style: TextStyle(
              color: Colors.white,
              fontFamily: bodyText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
            onPressed: null,
            child: Text(
              "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: bodyText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        elevation: 1.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonWidget(
                  title: "Invite Friends",
                  buttonFunc: () {},
                ),
                ButtonWidget(
                  title: "Help",
                  buttonFunc: () {},
                ),
                ButtonWidget(
                  title: "Contact Us",
                  buttonFunc: () {},
                ),
                ButtonWidget(
                  title: "Terms and Conditions",
                  buttonFunc: () {},
                ),
                ButtonWidget(
                  title: "Privacy Policy",
                  buttonFunc: () {},
                ),
                ButtonWidget(
                  title: "Log out",
                  buttonFunc: () {},
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {},
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                    ),
                    textColor: Colors.white,
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontFamily: bodyText,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
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

class ButtonWidget extends StatefulWidget {
  final String title;
  final Function buttonFunc;
  const ButtonWidget({
    Key key,
    @required this.title,
    this.buttonFunc,
  }) : super(key: key);
  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 15,
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlineButton(
          onPressed: widget.buttonFunc,
          child: Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: bodyText,
              fontSize: 18,
            ),
          ),
          textColor: Color(primary),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(6.0),
          ),
          borderSide: BorderSide(color: Color(primary)),
          highlightedBorderColor: Color(primary),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        ),
      ),
    );
  }
}
