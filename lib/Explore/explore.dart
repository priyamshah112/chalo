import 'package:chaloapp/common/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chaloapp/home/home.dart';

class Explore extends StatefulWidget {
  final Future<bool> Function() onBack;
  Explore({@required this.onBack});
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
  _ExploreState createState() => _ExploreState();
}

List<List<String>> ExplorepostList;

class _ExploreState extends State<Explore> {
  int likeCount = 9;
  bool isLikeTap = false;

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

    return WillPopScope(
      onWillPop: widget.onBack,
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(primary),
          title: Center(
            child: Text(
              "Social Wall",
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
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
                                Text(
                                  ExplorepostList[i][2],
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
                              ],
                            ),
                          ),
                          Image.asset(
                            ExplorepostList[i][3],
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                            child: Text(
                              ExplorepostList[i][4],
                              style: TextStyle(
                                fontFamily: bodyText,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
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
                                    color:
                                        isLikeTap ? Colors.red : Color(secondary),
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
                                Icon(
                                  FontAwesomeIcons.comment,
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "67 comments",
                                  style: TextStyle(
                                    fontFamily: bodyText,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  ExplorepostList[i][5],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
