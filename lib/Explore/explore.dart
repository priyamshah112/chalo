import 'package:chaloapp/Explore/uploadPage.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/data/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chaloapp/home/home.dart';
import 'package:intl/intl.dart';

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

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.onBack,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UploadPage()));
          },
        ),
        appBar: AppBar(
          backgroundColor: Color(primary),
          title: Center(
            child: Text(
              "Social Wall",
            ),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                List<DocumentSnapshot> posts = snapshot.data.documents;
                return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (_, i) {
                      var post = posts[i].data;
                      return PostCard(post: post);
                    });
              }),
        ),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  PostCard({@required this.post});
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked;
  int likeCount;
  DateTime postTime;
  @override
  void initState() {
    super.initState();
    print(widget.post);
    isLiked = false;
    likeCount = 0;
    postTime = DateTime.fromMillisecondsSinceEpoch(
        widget.post['timestamp'].seconds * 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('images/bgcover.jpg'),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            title: Text(
              widget.post['username'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(secondary),
              ),
            ),
            trailing: Text(
              widget.post['activity'],
              style: TextStyle(
                fontFamily: bodyText,
                color: Color(primary),
              ),
            ),
          ),
          Image.network(
            widget.post['image_url'],
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              widget.post['caption'],
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
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLiked = !isLiked;
                      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
                    });
                    print(likeCount);
                  },
                  child: Icon(
                    isLiked
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    size: 17,
                    color: isLiked ? Colors.red : Color(secondary),
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
                  DateFormat('d/M/yy').format(postTime),
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
    );
  }
}
