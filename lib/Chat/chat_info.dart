//import 'package:chaloapp/forgot.dart';
//import 'package:chaloapp/main.dart';
//import 'package:chaloapp/widgets/DailogBox.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:chaloapp/Activites/Activity_Detail.dart';
import 'package:chaloapp/Boradcast/Broadcast_Details.dart';
import 'package:chaloapp/Boradcast/edit_activity.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/data/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          return snapshot.data['admin_id'] == CurrentUser.email
              ? BroadcardActivityDetails(planRef: widget.planRef)
              : ActivityDetails(planRef: widget.planRef);
        });
  }
}
