import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/global_colors.dart';
import '../data/User.dart';
import '../services/DatabaseService.dart';

class EditProfile extends StatefulWidget {
  final String name, profilePic, gender;

  const EditProfile({
    Key key,
    @required this.name,
    @required this.gender,
    this.profilePic,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _name, _gender;
  bool _hideAge = false;
  String _about,
      _lang,
      _job,
      _country,
      _state,
      _city,
      _fb,
      _insta,
      _linkedin,
      _twitter,
      _web;

  File _image;
  Future getImage() async {
    try {
      var image = await ImagePicker().getImage(
          source: ImageSource.gallery,
          maxHeight: 150,
          maxWidth: 150,
          imageQuality: 50);
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
    _name = widget.name;
    _about = CurrentUser.user.about;
    _lang = CurrentUser.user.lang;
    _job = CurrentUser.user.job;
    _country = CurrentUser.user.country;
    _state = CurrentUser.user.state;
    _city = CurrentUser.user.city;
    _fb = CurrentUser.user.facebook;
    _insta = CurrentUser.user.insta;
    _linkedin = CurrentUser.user.linkedin;
    _twitter = CurrentUser.user.twitter;
    _web = CurrentUser.user.website;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(false);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(primary),
          title: Text(
            "Edit Profile",
          ),
          centerTitle: true,
          actions: <Widget>[
            GestureDetector(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Done'),
                )),
                onTap: () => _update(context)),
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
                                child:
                                    _image == null && widget.profilePic == null
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
                    child: TextFormField(
                      initialValue: _about ?? null,
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => _about = value.trim(),
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
                      initialValue: _name,
                      onChanged: (value) => _name = value.trim(),
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
                    child: TextFormField(
                      initialValue: _job ?? null,
                      onChanged: (value) => _job = value.trim(),
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
                    child: TextFormField(
                      initialValue: _lang ?? null,
                      onChanged: (value) => _lang = value.trim(),
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
                          value: _hideAge,
                          onChanged: (bool value) {
                            setState(() {
                              _hideAge = value;
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
                    child: TextFormField(
                      initialValue: _country ?? null,
                      onChanged: (value) => _country = value.trim(),
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
                    child: TextFormField(
                      initialValue: _state ?? null,
                      onChanged: (value) => _state = value.trim(),
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
                    child: TextFormField(
                      initialValue: _city ?? null,
                      onChanged: (value) => _city = value.trim(),
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
                    child: TextFormField(
                      initialValue: _fb ?? null,
                      onChanged: (value) => _fb = value.trim(),
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
                    child: TextFormField(
                      initialValue: _insta ?? null,
                      onChanged: (value) => _insta = value.trim(),
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
                    child: TextFormField(
                      initialValue: _linkedin ?? null,
                      onChanged: (value) => _linkedin = value.trim(),
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
                    child: TextFormField(
                      initialValue: _twitter ?? null,
                      onChanged: (value) => _twitter = value.trim(),
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
                    child: TextFormField(
                      initialValue: _web ?? null,
                      onChanged: (value) => _web = value.trim(),
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
      ),
    );
  }

  void _update(BuildContext context) async {
    FocusScope.of(context).unfocus();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()));
    Map<String, dynamic> info = {
      'about': _about,
      'languages': _lang,
      'job': _job,
      'country': _country,
      'state': _state,
      'city': _city,
      'facebook_acc': _fb,
      'instagram_acc': _insta,
      'linkedin_acc': _linkedin,
      'twitter_acc': _twitter,
      'website': _web
    };
    await DataService().updateUserInfo(info, _name, _gender, _image);
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
    Navigator.of(context).pop(true);
  }
}
