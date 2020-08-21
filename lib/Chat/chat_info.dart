import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Activites/Activity_Detail.dart';
import '../Broadcast/Broadcast_Details.dart';
import '../data/User.dart';

class ChatInfo extends StatefulWidget {
  final DocumentReference planRef;
  ChatInfo({Key key, @required this.planRef}) : super(key: key);
  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.planRef.get(),
        builder: (_, snapshot) {
          if (!snapshot.hasData)
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            );
          return snapshot.data['admin_id'] == CurrentUser.user.email
              ? BroadcastActivityDetails(planDoc: snapshot.data)
              : ActivityDetails(planDoc: snapshot.data);
        });
  }
}
