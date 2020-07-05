import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/profile/profile_page.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Animation/FadeAnimation.dart';

class Follower extends StatefulWidget {
  @override
  _FollowerState createState() => _FollowerState();
}

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
            title: Text(
              "Followers",
            ),
            centerTitle: true,
          );
  }

  List followers;

  @override
  void initState() {
    super.initState();
    followers = CurrentUser.followers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: followers
                    .map(
                      (follower) => FutureBuilder(
                          future: DataService().getUserDoc(follower),
                          builder: (context, snapshot) {
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: Color(primary),
                                ),
                              ),
                              child: !snapshot.hasData
                                  ? Container()
                                  : ListTile(
                                      onTap: () => showDialog(
                                          context: context,
                                          builder: (ctx) => Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    ProfileCard(
                                                      email: snapshot
                                                          .data['email'],
                                                      username:
                                                          '${snapshot.data['first_name']} ${snapshot.data['last_name']}',
                                                      gender: snapshot
                                                          .data['gender'],
                                                      follower: 0,
                                                      following: 0,
                                                      isCurrent: false,
                                                    )
                                                  ])),
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            AssetImage("images/bgcover.jpg"),
                                      ),
                                      title: Text(
                                        '${snapshot.data['first_name']} ${snapshot.data['last_name']}',
                                        style: TextStyle(
                                            fontFamily: bodyText,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      subtitle: Text('1 Actvity Done'),
                                    ),
                            );
                          }),
                    )
                    .toList()),
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
