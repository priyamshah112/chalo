import 'package:chalo/authentication/login.dart';
import 'package:chalo/services/AuthService.dart';

import '../Settings/contactus.dart';
import '../Settings/help.dart';
import '../Settings/terms_and_conditions.dart';
import '../common/global_colors.dart';
import '../widgets/DailogBox.dart';
import 'package:flutter/material.dart';


class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

List<List<String>> explorepostList;

class _SettingState extends State<Setting> {
  DateTime currentBackPressTime;

  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;

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
                  buttonFunc: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Help(),
                      ),
                    );
                  },
                ),
                ButtonWidget(
                  title: "Contact Us",
                  buttonFunc: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactUs(),
                      ),
                    );
                  },
                ),
                ButtonWidget(
                  title: "Terms and Conditions",
                  buttonFunc: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TnC(),
                      ),
                    );
                  },
                ),
                ButtonWidget(
                  title: "Privacy Policy",
                  buttonFunc: () {},
                ),
                ButtonWidget(
                  title: "Log out",
                  buttonFunc: () =>  signOut(context),
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
