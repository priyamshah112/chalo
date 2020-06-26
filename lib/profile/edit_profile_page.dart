import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  final String name,
      profilePic,
      job,
      about,
      lang,
      city,
      state,
      country,
      fb,
      twitter,
      insta,
      linkedin,
      web,
      gender;

  const EditProfile(
      {Key key,
      @required this.name,
      @required this.gender,
      this.profilePic,
      this.job,
      this.about,
      this.lang,
      this.city,
      this.state,
      this.country,
      this.fb,
      this.twitter,
      this.insta,
      this.linkedin,
      this.web})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _gender = 'Selecct Gender';
  bool proposeTime = false;

  File _image;
  Future getImage() async {
    try {
      var image = await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _gender = widget.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(primary),
        title: Center(
          child: Text(
            "Edit Profile",
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: getImage,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Color(primary),
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      margin: EdgeInsets.only(top: 20),
                      width: 70.0,
                      height: 70.0,
                      child: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          CircleAvatar(
                              radius: 35,
                              foregroundColor: Color(primary),
                              backgroundColor: Color(background1),
                              backgroundImage: _image != null
                                  ? FileImage(
                                      _image,
                                    )
                                  : widget.profilePic != null
                                      ? NetworkImage(
                                          widget.profilePic,
                                        )
                                      : null,
                              child: _image == null && widget.profilePic == null
                                  ? Icon(
                                      Icons.account_circle,
                                      size: 60,
                                    )
                                  : null),
                          Positioned(
                              bottom: -5,
                              right: -7,
                              child: CircleAvatar(
                                  backgroundColor: Color(primary),
                                  radius: 13,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                    size: 18,
                                  )))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "About Me",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(primary),
                    fontFamily: heading,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    maxLines: 5,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tell us about yourself....",
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 30.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextFormField(
                    initialValue: widget.name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Your Good Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "Full Name",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. App Developer",
                      prefixIcon: Icon(
                        Icons.work,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "Job Title",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. English",
                      prefixIcon: Icon(
                        Icons.translate,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "Language",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Checkbox(
                        activeColor: Color(primary),
                        value: proposeTime,
                        onChanged: (bool value) {
                          setState(() {
                            proposeTime = value;
                          });
                        },
                      ),
                      Positioned(
                        top: 15,
                        left: 40,
                        child: Text(
                          "Hide Age",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(primary),
                            fontFamily: heading,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      color: Color(form1),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButton(
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconEnabledColor: Color(primary),
                        items: ['Male', 'Female', 'Others']
                            .map(
                              (gender) => DropdownMenuItem(
                                value: gender,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      gender,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(secondary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      _gender == gender ? Icons.check : null,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        underline: Container(),
                        hint: Text(
                          _gender,
                          style: TextStyle(
                            color: Color(secondary),
                            fontFamily: bodyText,
                          ),
                        ),
                        elevation: 0,
                        isExpanded: true,
                      ),
                      padding: EdgeInsets.only(
                          right: 15, top: 10, bottom: 10, left: 50),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 28.0, left: 15.0),
                      child: Icon(
                        FontAwesomeIcons.restroom,
                        color: Color(primary),
                        size: 18,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. India",
                      prefixIcon: Icon(
                        Icons.language,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "Country",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. Maharashtra",
                      prefixIcon: Icon(
                        Icons.place,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "State",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. Mumbai",
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "City",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Social Media Links",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(primary),
                    fontFamily: heading,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. facebook.com/username",
                      prefixIcon: Icon(
                        FontAwesomeIcons.facebook,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "Facebook",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. instagram.com/username",
                      prefixIcon: Icon(
                        FontAwesomeIcons.instagram,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "Instagram",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. linkedin.com/username",
                      prefixIcon: Icon(
                        FontAwesomeIcons.linkedin,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "Linkedin",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. twitter.com/username",
                      prefixIcon: Icon(
                        FontAwesomeIcons.twitter,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "Twitter",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. website.com",
                      prefixIcon: Icon(
                        FontAwesomeIcons.globe,
                        color: Color(primary),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                      filled: true,
                      fillColor: Color(form1),
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "Website/Blog",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
