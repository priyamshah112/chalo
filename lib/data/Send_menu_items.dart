import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SendMenuItems {
  String text;
  IconData icon;
  MaterialColor colors;

  SendMenuItems(
      {@required this.text, @required this.icon, @required this.colors});

  static List<SendMenuItems> list = [
    SendMenuItems(
      text: "Photos and Videos",
      icon: Icons.image,
      colors: Colors.amber,
    ),
    SendMenuItems(
      text: "Documents",
      icon: Icons.insert_drive_file,
      colors: Colors.blue,
    ),
    SendMenuItems(
      text: "Audio",
      icon: Icons.music_note,
      colors: Colors.orange,
    ),
    SendMenuItems(
      text: "Location",
      icon: Icons.location_on,
      colors: Colors.green,
    ),
    SendMenuItems(
      text: "Contact",
      icon: Icons.person,
      colors: Colors.purple,
    ),
  ];
}
