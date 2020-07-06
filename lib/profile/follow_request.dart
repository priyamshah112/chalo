import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:toast/toast.dart';

import '../Animation/FadeAnimation.dart';

class FollowReq extends StatefulWidget {
  final List requests;
  FollowReq({@required this.requests});
  @override
  _FollowReqState createState() => _FollowReqState();
}

class _FollowReqState extends State<FollowReq> {
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
              "Follow Requests",
            ),
            centerTitle: true,
          );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
                mainAxisAlignment: widget.requests.length == 0
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: widget.requests.length == 0
                    ? [Center(child: Text('No new requests :('))]
                    : widget.requests
                        .map(
                          (req) => FutureBuilder(
                            future: DataService().getUserDoc(req),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              return Container(
                                child: !snapshot.hasData
                                    ? null
                                    : ListTile(
                                      leading: CircleAvatar(
                                        child: Icon(Icons.account_circle),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          top: 8,
                                          left: 15,
                                          right: 5,
                                          bottom: 8),
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
                                      trailing: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                                width: 100,
                                                height: 27,
                                                child: OutlineButton(
                                                  onPressed: () async {
                                                    await DataService()
                                                        .acceptFollow(
                                                            req, true);
                                                    setState(() => widget
                                                        .requests
                                                        .remove(req));
                                                  },
                                                  borderSide: BorderSide(
                                                    color: Color(
                                                        primary), //Color of the border
                                                    style: BorderStyle
                                                        .solid, //Style of the border
                                                    width:
                                                        0.9, //width of the border
                                                  ),
                                                  color: Color(primary),
                                                  textColor:
                                                      Color(primary),
                                                  child: Text(
                                                    "Accept",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          bodyText,
                                                    ),
                                                  ),
                                                )),
                                            IconButton(
                                              onPressed: () async {
                                                await DataService()
                                                    .acceptFollow(
                                                        req, false);
                                                setState(() => widget
                                                    .requests
                                                    .remove(req));
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors
                                                    .redAccent.shade200,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              );
                            },
                          ),
                        )
                        .toList()),
          ),
        ),
      ),
    );
  }
}
