import 'dart:io';
import 'package:flutter/foundation.dart';

class Post {
  final String email, username, caption, activityType;
  final DateTime timestamp;
  final int likes;
  final File image;

  Post(
      {
       @required this.email,
       @required this.username,
       @required this.caption,
       @required this.activityType,
       @required this.image,
       @required this.timestamp,
       @required this.likes});
}
