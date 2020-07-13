import 'dart:io';

import 'package:chaloapp/common/global_colors.dart';
import 'package:chaloapp/data/post.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import '../common/activitylist.dart';

class UploadPage extends StatefulWidget {
//  final String gCurrentUser;
//  UploadPage(this.gCurrentUser);
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  
  File file;

  getImage({bool isCamera = false}) async {
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

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (_) {
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
              onPressed: () {
                Navigator.of(mContext, rootNavigator: true).pop();
                getImage(isCamera: true);
              },
            ),
            SimpleDialogOption(
              child: Text(
                "Select Image from Gallery",
                style: TextStyle(
                  color: Color(secondary),
                ),
              ),
              onPressed: () {
                Navigator.of(mContext, rootNavigator: true).pop();
                getImage();
              },
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color(secondary),
                ),
              ),
              onPressed: () =>
                  Navigator.of(mContext, rootNavigator: true).pop(),
            ),
          ],
        );
      },
    );
  }

  removeImage() {
    setState(() {
      file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? UploadScreen(takeImage: takeImage) : PostCreationScreen();
  }
}

class PostCreationScreen extends StatefulWidget {
  @override
  _PostCreationScreenState createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  List<List<String>> AllactivityListItems;
  @override
  void initState() {
    super.initState();
    ActivityList.getActivityList().then((list) => AllactivityListItems = list);
  }

  String _activity = "Select Activity";

  DropdownButton activityMenu() => DropdownButton<String>(
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
                  Image.network(
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
            _activity = value;
          });
        },
        icon: Icon(Icons.arrow_downward),
        iconSize: 20.0,
        iconEnabledColor: Color(primary),
        underline: Container(),
        hint: Text(
          _activity,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        isExpanded: true,
      );
 bool _uploading = false;
  @override
  Widget build(BuildContext context) {
    return return WillPopScope(
      onWillPop: () {
        if (_uploading) Toast.show("Please wait, uploading...", context);
        _uploading ? Future.value(false) : Future.value(true);
      },
      child: Scaffold(
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
              onPressed: () async {
                FocusScope.of(context).unfocus();
                setState(() => _isActivitySelected =
                    _activity == 'Select Activity' ? false : true);
                print(CaptionText.text);
                if (!_isActivitySelected) return;
                // setState(() => _uploading = true);
                // showDialog(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (_) => Center(child: CircularProgressIndicator()));
                // Post post = Post(
                //     email: CurrentUser.email,
                //     username: CurrentUser.name,
                //     activityType: _activity,
                //     caption: caption ?? '',
                //     image: file,
                //     likes: 0,
                //     timestamp: DateTime.now());
                // await DataService().uploadPost(post);
                // setState(() => _uploading = false);
                // Navigator.of(context, rootNavigator: true).pop();
                // Navigator.of(context, rootNavigator: true).pop();
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
                child: TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) => caption = value.trim(),
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
            if (!_isActivitySelected)
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('Please select a Activity',
                      style: TextStyle(color: Colors.red)))
          ],
        ),
      ),
    );
  }
}

class UploadScreen extends StatelessWidget {
  final Function(BuildContext) takeImage;
  UploadScreen({@required this.takeImage});
  @override
  Widget build(BuildContext context) {
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
}
