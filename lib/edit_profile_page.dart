import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:chaloapp/edit_profile_page.dart';
import 'package:chaloapp/home.dart';
import 'package:chaloapp/post_details.dart';
import 'package:chaloapp/services/AuthService.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chaloapp/global_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File _image;

  DateTime picked;
  bool proposeTime = false;

  Future<DateTime> _presentDatePicker(
      BuildContext context, DateTime date) async {
    picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: picked == null ? DateTime.now() : picked,
        lastDate: DateTime.now());
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print("Image Path $_image");
      });
    }

    List<String> GenderList = [
      "Male",
      "Female",
      "Other",
    ];
    String gender = "Select Gender";

    return Scaffold(
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
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Color(primary),
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      margin: EdgeInsets.only(top: 20),
                      width: 65.0,
                      height: 65.0,
                      child: CircleAvatar(
                        foregroundColor: Color(primary),
                        backgroundColor: Color(background1),
                        child: ClipOval(
                          child: SizedBox(
                            height: 65,
                            width: 65,
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "images/bgcover.jpg",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
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
                      hintText: "e.g. Eldon Keck",
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
                      labelText: "Enter Full Name",
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. example@email.com",
                      prefixIcon: Icon(
                        Icons.email,
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
                      labelText: "Email Address",
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
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "e.g. +91 12345 67890",
                      prefixIcon: Icon(
                        Icons.phone,
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
                      labelText: "Enter Contact Number",
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
                      labelText: "Enter Job Title",
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
                      labelText: "Enter Language",
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
                  child: DateTimeField(
                    format: DateFormat('d/MM/y'),
                    onShowPicker: _presentDatePicker,
                    validator: (value) {
                      String date = DateTime.now().toString().substring(0, 10);
                      if (value == null)
                        return "Select Date";
                      else if (value.toString().substring(0, 10) == date) {
                        print(value.toString());
                        return "Select Valid Date";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(form1),
                      contentPadding: const EdgeInsets.only(
                          left: 30.0, bottom: 18.0, top: 18.0, right: 30.0),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        FontAwesomeIcons.calendar,
                        color: Color(primary),
                      ),
                      hintText: "Date of Birth",
                      hintStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                      labelText: "Date of Birth",
                      labelStyle: TextStyle(
                        color: Color(formHint),
                        fontFamily: bodyText,
                      ),
                    ),
                    autofocus: false,
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      color: Color(form1),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButton(
                        icon: Icon(Icons.arrow_downward),
                        iconEnabledColor: Color(primary),
                        items: [
                          for (int i = 0; i < GenderList.length; i++)
                            DropdownMenuItem(
                              value: GenderList[i],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    GenderList[i],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(secondary),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    GenderList[i] == gender
                                        ? Icons.check
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                            print(gender);
                          });
                        },
                        underline: Container(),
                        hint: Text(
                          gender,
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
                      margin: EdgeInsets.only(top: 30.0, left: 15.0),
                      child: Icon(
                        FontAwesomeIcons.restroom,
                        color: Color(primary),
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
                      hintText: "Enter Full Name",
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
                      labelText: "Enter Full Name",
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
                      hintText: "Enter Full Name",
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
                      labelText: "Enter Full Name",
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
                      hintText: "Enter Full Name",
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
                      labelText: "Enter Full Name",
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
                      hintText: "Enter Full Name",
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
                      labelText: "Enter Full Name",
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
                      hintText: "Enter Full Name",
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
                      labelText: "Enter Full Name",
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
                      hintText: "Enter Full Name",
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
                      labelText: "Enter Full Name",
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
                      hintText: "Enter Full Name",
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
                      labelText: "Enter Full Name",
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
