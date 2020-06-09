import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/main.dart';
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

  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Notification Preferences",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(primary),
                    fontFamily: heading,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Notification for my broadcasts",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(secondary),
                        fontFamily: bodyText,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Center(
                      child: Switch(
                        value: isSwitched1,
                        onChanged: (value) {
                          setState(() {
                            isSwitched1 = value;
                            print(isSwitched1);
                          });
                        },
                        activeTrackColor: Color(primary),
                        activeColor: Colors.white,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Notifications for my Invites",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(secondary),
                        fontFamily: bodyText,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Center(
                      child: Switch(
                        value: isSwitched2,
                        onChanged: (value) {
                          setState(() {
                            isSwitched2 = value;
                            print(isSwitched2);
                          });
                        },
                        activeTrackColor: Color(primary),
                        activeColor: Colors.white,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Notification for my broadcasts",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(secondary),
                        fontFamily: bodyText,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Center(
                      child: Switch(
                        value: isSwitched3,
                        onChanged: (value) {
                          setState(() {
                            isSwitched3 = value;
                            print(isSwitched3);
                          });
                        },
                        activeTrackColor: Color(primary),
                        activeColor: Colors.white,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
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
