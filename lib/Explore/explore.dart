import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/global_colors.dart';
import '../data/User.dart';
import '../services/DatabaseService.dart';
import 'uploadPage.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          bool refresh = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => UploadPage()));
          if (refresh) setState(() {});
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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {});
        },
        child: SafeArea(
          child: FutureBuilder(
              future: Firestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .getDocuments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                List<DocumentSnapshot> posts = snapshot.data.documents;
                return posts.length == 0
                    ? Center(child: Text('Nothing to show :('))
                    : ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (_, i) {
                          DocumentSnapshot post = posts[i];
                          return PostCard(post: post.data);
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
  bool wasLiked = false, isLiked = false, _loading = true;
  List<String> diff;
  int hrs, min, sec;
  DateTime postTime;
  Image _image;
  List likedBy;
  int likes;
  @override
  void initState() {
    super.initState();
    likedBy = widget.post['likes'];
    likes = likedBy.length;
    wasLiked = isLiked = likedBy.contains(CurrentUser.user.email);
    postTime = DateTime.fromMillisecondsSinceEpoch(
        widget.post['timestamp'].seconds * 1000);
    diff = (postTime.difference(DateTime.now())).toString().split(':');
    hrs = int.parse(diff[0]).abs();
    min = int.parse(diff[1]).abs();
    sec = int.parse(diff[2].substring(0, 2)).abs();
    _image = Image.network(
      widget.post['image_url'],
      fit: BoxFit.cover,
    );
    _image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((info, call) {
      if (mounted) setState(() => _loading = false);
    }));
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
              setState(() {
                isLiked = true;
                if (!wasLiked) {
                  likes++;
                  wasLiked = true;
                }
              });
            },
            child: AspectRatio(
                aspectRatio: 1,
                child: _loading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Container(
                          color: Colors.white,
                        ),
                      )
                    : _image),
          ),
          SizedBox(
            height: 10,
          ),
          if (widget.post['caption'] != null)
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
                      setState(() {
                        isLiked = !isLiked;
                        if (wasLiked) {
                          if (!isLiked) {
                            likes--;
                            wasLiked = false;
                          }
                        } else if (isLiked) {
                          likes++;
                          wasLiked = true;
                        }
                      });
                    },
                    icon: Icon(
                      isLiked
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      size: 20,
                      color: isLiked ? Colors.red : Color(secondary),
                    ),
                    splashColor: Colors.red),
                SizedBox(
                  width: 7,
                ),
                Text(
                  "$likes likes",
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
