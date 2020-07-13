import 'dart:io';

import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/data/post.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import '../common/activitylist.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _uploading = false, _isActivitySelected = true;
  String _caption, _activity = 'Select Activity';
  List<List<String>> allActivities = [];

  @override
  void initState() {
    super.initState();
    ActivityList.getActivityList()
        .then((list) => setState(() => allActivities = list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "New Post",
          style: TextStyle(
            color: Colors.white,
            fontFamily: bodyText,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (file == null) {
                showDialog(
                    context: context,
                    builder: (_) => DialogBox(
                          title: 'Error',
                          description: 'No image was selected',
                          buttonText1: 'OK',
                          button1Func: () => Navigator.of(context).pop(),
                        ));
                return;
              }
              setState(() => _isActivitySelected =
                  _activity == 'Select Activity' ? false : true);
              if (!_isActivitySelected) return;
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => WillPopScope(
                      onWillPop: () {
                        if (_uploading)
                          Toast.show("Please wait, uploading...", context);
                        return _uploading
                            ? Future.value(false)
                            : Future.value(true);
                      },
                      child: Center(child: CircularProgressIndicator())));
              setState(() => _uploading = true);
              Post post = Post(
                  email: CurrentUser.email,
                  username: CurrentUser.name,
                  activityType: _activity,
                  caption: _caption ?? '',
                  image: file,
                  likes: 0,
                  timestamp: DateTime.now());
              await DataService().uploadPost(post);
              setState(() => _uploading = false);
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
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
          GestureDetector(
            onTap: () => takeImage(context),
            child: AspectRatio(
              aspectRatio: 4/3,
              child: Container(
                  decoration: BoxDecoration(
                      image: file == null
                          ? null
                          : DecorationImage(
                              image: FileImage(file),
                              fit: BoxFit.contain,
                            ),
                      color: file == null ? Colors.grey : null),
                  child: file == null
                      ? Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 50,
                          ),
                        )
                      : null),
            ),
          ),
          SizedBox(height: 15),
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
              child: TextField(
                keyboardType: TextInputType.text,
                onChanged: (value) => _caption = value.trim(),
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
                child: activityMenu(),
              ),
            ),
          ),
          if (!_isActivitySelected)
            Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text('Please select a Activity',
                    style: TextStyle(color: Colors.red)))
        ],
      ),
    );
  }

  DropdownButton activityMenu() => DropdownButton<String>(
        focusColor: Colors.redAccent,
        items: allActivities
            .map((activity) => DropdownMenuItem(
                  value: activity[1],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        activity[1],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(secondary),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.network(
                        activity[0],
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ))
            .toList(),
        onChanged: (value) => setState(() {
          _isActivitySelected = true;
          _activity = value;
        }),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 20.0,
        iconEnabledColor: Color(primary),
        underline: Container(),
        hint: Text(
          _activity,
          style: TextStyle(color: Colors.black),
        ),
        isExpanded: true,
      );

  Future takeImage(mContext) {
    return showModalBottomSheet(
      context: mContext,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Open Camera'),
                    leading: Icon(Icons.camera_alt, color: Color(primary)),
                    onTap: () {
                      Navigator.of(mContext, rootNavigator: true).pop();
                      getImage(isCamera: true);
                    },
                  ),
                  ListTile(
                    title: Text('Select from Gallery'),
                    leading: Icon(Icons.photo_library, color: Color(primary)),
                    onTap: () {
                      Navigator.of(mContext, rootNavigator: true).pop();
                      getImage();
                    },
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ));
      },
    );
  }

  File file;
  void getImage({bool isCamera = false}) async {
    File imageFile = File((await ImagePicker().getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
    ))
        .path);
    if (mounted)
      setState(() {
        this.file = imageFile;
      });
  }
}
