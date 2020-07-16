import 'package:chaloapp/Explore/uploadPage.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
class Explore extends StatefulWidget {
  final Future<bool> Function() onBack;
  Explore({@required this.onBack});
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
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => UploadPage())),
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
  List<String> diff;
  int hrs, min, sec;
  DateTime postTime;
  @override
  void initState() {
    super.initState();
    List likes = widget.post['likes'];
    isLiked = likes.contains(CurrentUser.email);
    postTime = DateTime.fromMillisecondsSinceEpoch(
        widget.post['timestamp'].seconds * 1000);
    diff = (postTime.difference(DateTime.now())).toString().split(':');
    hrs = int.parse(diff[0]).abs();
    min = int.parse(diff[1]).abs();
    sec = int.parse(diff[2].substring(0, 2)).abs();
  }

  @override
  Widget build(BuildContext context) {
    String postedTime = getPostedTime;
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
          GestureDetector(
            onDoubleTap: () {
              DataService().likePost(widget.post['post_id']);
              setState(() => isLiked = true);
            },
            child: Image.network(
              widget.post['image_url'],
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
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
                IconButton(
                  onPressed: () {
                    DataService()
                        .likePost(widget.post['post_id'], like: !isLiked);
                    setState(() => isLiked = !isLiked);
                  },
                  icon: Icon(
                    isLiked
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    size: 20,
                    color: isLiked ? Colors.red : Color(secondary),
                  ),
                  splashColor: Colors.red
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  "${widget.post['likes'].length} likes",
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
                  postedTime,
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

  String get getPostedTime {
    if (hrs == 0) {
      if (min == 0)
        return '$sec sec ago';
      else
        return '$min min ago';
    } else {
      if (hrs >= 24) {
        int days = hrs ~/ 24;
        if (days >= 7) {
          int weeks = days ~/ 7;
          if (weeks > 4)
            return DateFormat('d MMM yyyy').format(postTime);
          else
            return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
        } else
          return days == 1 ? 'Yesterday' : '$days days ago';
      } else
        return hrs == 1 ? '1 hr ago' : '$hrs hrs ago';
    }
  }
}

