import 'dart:math';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/authentication/login.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:chaloapp/widgets/date_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chaloapp/Animation/FadeAnimation.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/add_location.dart';
import '../data/activity.dart';
import 'package:intl/intl.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  String message;
  bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "Contact Us",
              style: TextStyle(
                color: Colors.white,
                fontFamily: bodyText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: null,
              child: Text(
                "",
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: FadeAnimation(
                    1.7,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Type your message",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(primary),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                " (Optional)",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(secondary),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.0, vertical: 10.0),
                            child: TextFormField(
                              onSaved: (value) => message = value,
                              maxLines: 5,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
//                                border: InputBorder.none,
                                hintText: "",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Color(primary))),
                                contentPadding: const EdgeInsets.only(
                                    left: 30.0,
                                    bottom: 18.0,
                                    top: 18.0,
                                    right: 30.0),
                                filled: true,
                                fillColor: Color(form1),
                                hintStyle: TextStyle(
                                  color: Color(formHint),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                              onPressed: () {},
                              color: Color(primary),
                              textColor: Colors.white,
                              child: Text(
                                "Send",
                                style: TextStyle(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
