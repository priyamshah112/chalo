import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/global_colors.dart';

class PostItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;
  final String caption;
  final String activityName;

  PostItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.img,
    @required this.caption,
    @required this.activityName,
  }) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  int likeCount = 9;
  bool isLikeTap = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(primary),
        title: Center(
          child: Text(
            "Post Detail",
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    "${widget.dp}",
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(secondary),
                      ),
                    ),
                    Text(
                      "${widget.activityName}",
                      style: TextStyle(
                        fontFamily: bodyText,
                        color: Color(primary),
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 25,
                      child: Center(
                        child: RaisedButton(
                          onPressed: () {},
                          color: Color(primary),
                          textColor: Colors.white,
                          elevation: 0,
                          child: Text(
                            'Follow',
                            style: TextStyle(
                              fontFamily: bodyText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                "${widget.img}",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isLikeTap) {
                            likeCount = likeCount - 1;
                            isLikeTap = false;
                          } else if (isLikeTap == false) {
                            likeCount = likeCount + 1;
                            isLikeTap = true;
                          }
                        });
                      },
                      child: Icon(
                        isLikeTap
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        size: 17,
                        color: isLikeTap ? Colors.red : Color(secondary),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      "$likeCount likes",
                      style: TextStyle(
                        fontFamily: bodyText,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${widget.time}",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.share,
                    size: 17,
                    color: Color(secondary),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
