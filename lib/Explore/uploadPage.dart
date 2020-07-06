import 'dart:io';

import 'package:chaloapp/common/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPage extends StatefulWidget {
//  final String gCurrentUser;
//  UploadPage(this.gCurrentUser);
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  void initState() {
    super.initState();
  }

  List<List<String>> AllactivityListItems = [
    ['images/activities/Beach.png', 'Beach'],
    ['images/activities/BirdWatching.png', 'Bird Watching'],
    ['images/activities/Canoeing.png', 'Caneoing'],
    ['images/activities/Hiking.png', 'Hiking'],
    ['images/activities/BeachBBQ.png', 'Beach BBQ'],
    ['images/activities/Camping.png', 'Camping'],
    ['images/activities/Cycling.png', 'Cycling'],
    ['images/activities/DogWalking.png', 'Dog Walking'],
    ['images/activities/Fishing.png', 'Fishing'],
    ['images/activities/Gardening.png', 'Gardening'],
    ['images/activities/Gym.png', 'Gym'],
    ['images/activities/MountainBiking.png', 'Mountain Biking'],
    ['images/activities/Picnic.png', 'Picnic'],
    ['images/activities/Kayaking.png', 'Kayaking'],
    ['images/activities/Museum.png', 'Museum'],
    ['images/activities/Beach.png', 'Beach'],
    ['images/activities/BirdWatching.png', 'Bird Watching'],
    ['images/activities/Canoeing.png', 'Caneoing'],
    ['images/activities/Hiking.png', 'Hiking'],
    ['images/activities/BeachBBQ.png', 'Beach BBQ'],
    ['images/activities/Camping.png', 'Camping'],
    ['images/activities/Cycling.png', 'Cycling'],
    ['images/activities/DogWalking.png', 'Dog Walking'],
    ['images/activities/Fishing.png', 'Fishing'],
    ['images/activities/Gardening.png', 'Gardening'],
    ['images/activities/Gym.png', 'Gym'],
    ['images/activities/MountainBiking.png', 'Mountain Biking'],
    ['images/activities/Picnic.png', 'Picnic'],
    ['images/activities/Kayaking.png', 'Kayaking'],
    ['images/activities/Museum.png', 'Museum'],
  ];
  String _value = "Select Activity";

  DropdownButton FilterByActivity() => DropdownButton<String>(
        focusColor: Colors.redAccent,
        items: [
          for (int i = 0; i < AllactivityListItems.length; i++)
            DropdownMenuItem(
              value: AllactivityListItems[i][1],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AllactivityListItems[i][1],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(secondary),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    AllactivityListItems[i][0],
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
            ),
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
            print(_value);
          });
        },
        icon: Icon(Icons.arrow_downward),
        iconSize: 20.0,
        iconEnabledColor: Color(primary),
        underline: Container(),
        hint: Text(
          _value,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        isExpanded: true,
      );

  File file;
  TextEditingController CaptionText = TextEditingController();

  CaptureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 970,
      maxHeight: 680,
    );
    if (mounted)
      setState(() {
        this.file = imageFile;
      });
  }

  PickImageFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (mounted)
      setState(() {
        this.file = imageFile;
      });
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "New Post",
            style: TextStyle(
              color: Color(primary),
              fontWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(
                "Capture Image with Camera",
                style: TextStyle(
                  color: Color(secondary),
                ),
              ),
              onPressed: () => CaptureImageWithCamera(),
            ),
            SimpleDialogOption(
              child: Text(
                "Select Image from Gallery",
                style: TextStyle(
                  color: Color(secondary),
                ),
              ),
              onPressed: () => PickImageFromGallery(),
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color(secondary),
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  DisplayUploadScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add_photo_alternate,
            color: Color(primary),
            size: 200.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                "Uplaod Images",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              color: Color(primary),
              onPressed: () => takeImage(context),
            ),
          ),
        ],
      ),
    );
  }

  removeImage() {
    setState(() {
      file = null;
    });
  }

  DisplayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => removeImage(),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "New Post",
            style: TextStyle(
              color: Colors.white,
              fontFamily: bodyText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text(
              "Share",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: bodyText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        elevation: 1.0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            title: Text(
              "Write Caption",
              style: TextStyle(
                color: Color(primary),
                fontWeight: FontWeight.bold,
                fontFamily: bodyText,
                fontSize: 16,
              ),
            ),
            subtitle: Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: TextFormField(
                controller: CaptionText,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Say Something about Image...",
                  contentPadding: const EdgeInsets.only(
                      left: 20.0, bottom: 20.0, top: 20.0),
                  filled: true,
                  fillColor: Color(form1),
                  hintStyle: TextStyle(
                    color: Color(formHint),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Select Activity",
              style: TextStyle(
                color: Color(primary),
                fontWeight: FontWeight.bold,
                fontFamily: bodyText,
                fontSize: 16,
              ),
            ),
            subtitle: Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Container(
                padding: EdgeInsets.only(
                  left: 20.0,
                  bottom: 6.0,
                  top: 6.0,
                  right: 20,
                ),
                color: Color(form1),
                child: FilterByActivity(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? DisplayUploadScreen() : DisplayUploadFormScreen();
  }
}
