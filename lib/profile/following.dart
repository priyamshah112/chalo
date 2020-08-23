import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/global_colors.dart';
import '../data/User.dart';
import '../services/DatabaseService.dart';
import '../widgets/DailogBox.dart';
import '../Animation/FadeAnimation.dart';

class Following extends StatefulWidget {
  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  bool _search = false;
  bool _isChanged = false;
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
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(_isChanged),
                icon: Icon(Icons.arrow_back)),
            actions: <Widget>[
              if (following.length > 0)
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => setState(() => _search = true))
            ],
            backgroundColor: Color(primary),
            title: Text(
              "Followings",
            ),
            centerTitle: true,
          );
  }

  List following;

  @override
  void initState() {
    super.initState();
    following = CurrentUser.user.following;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_isChanged);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: following.length == 0
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 150,
                      alignment: Alignment.center,
                      child: Text('You have no followers'))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: following.map((user) {
                        return FutureBuilder(
                          future: DataService().getUserDoc(user),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) return Container();
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: Color(primary),
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.account_circle),
                                  // backgroundImage: NetworkImage(),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                title: Text(
                                  '${snapshot.data['first_name']} ${snapshot.data['last_name']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(secondary),
                                  ),
                                ),
                                subtitle: Row(
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
                                      "${0} activities done",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: bodyText,
                                        color: Color(secondary),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  width: 100,
                                  height: 27,
                                  child: OutlineButton(
                                    onPressed: () => _handleUnfollow(user),
                                    borderSide: BorderSide(
                                      color:
                                          Color(primary), //Color of the border
                                      style: BorderStyle
                                          .solid, //Style of the border
                                      width: 0.9, //width of the border
                                    ),
                                    color: Color(primary),
                                    textColor: Color(primary),
                                    child: Text(
                                      "Unfollow",
                                      style: TextStyle(
                                        fontFamily: bodyText,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList()),
            ),
          ),
        ),
      ),
    );
  }

  void _handleUnfollow(String email) async {
    var result = await showDialog(
        context: context,
        builder: (ctx) => DialogBox(
            title: 'Unfollow',
            titleColor: Color(primary),
            description:
                "Are you sure you want to unfollow Abdul Quadir Ansari.",
            buttonText1: "Cancel",
            btn1Color: Color(primary),
            button1Func: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
            buttonText2: "Unfollow",
            btn2Color: Colors.red,
            button2Func: () async {
              DataService().unFollow(email);
              Navigator.of(context, rootNavigator: true).pop(true);
            }));
    bool unfollow = result ?? false;
    setState(() {
      if (unfollow) {
        following.remove(email);
        _isChanged = true;
      }
    });
  }
}
