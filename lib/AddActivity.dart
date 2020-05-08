import 'package:chaloapp/login.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chaloapp/Animation/FadeAnimation.dart';
import 'package:chaloapp/global_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_selection/gender_selection.dart';
import 'data/activity.dart';
import 'package:intl/intl.dart';

class AddActivity extends StatefulWidget {
  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final _formKey = GlobalKey<FormState>();
  DateTime picked;
  bool proposeTime = false;

  Future<DateTime> _presentDatePicker(
      BuildContext contex, DateTime date) async {
    picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: picked == null ? DateTime.now() : picked,
        lastDate: DateTime.now());
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(primary),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Broadcast Activity',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.7,
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                    bottom: BorderSide(
//                                      color: Colors.grey[200],
//                                    ),
//                                  ),
//                                ),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search for an Activities",
                                      prefixIcon: Icon(
                                        Icons.search,
                                      ),
                                      suffixIcon: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(primary),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Material(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30.0),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewActivity(),
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.format_list_bulleted,
                                              color: Color(primary),
                                            ),
                                          ),
                                        ),
                                      ),
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
//                                    focusedBorder: OutlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.white),
//                                    ),
//                                    enabledBorder: UnderlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.indigo),
//                                    ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Your Activities",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(primary),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 109,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      for (int i = 0;
                                          i < AllselectedActivityList.length;
                                          i++)
                                        Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(primary),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            width: 110,
                                            child: ListTile(
                                              title: Image.asset(
                                                AllselectedActivityList[i][0],
                                                width: 60,
                                                height: 60,
                                              ),
                                              subtitle: Container(
                                                padding:
                                                    EdgeInsets.only(top: 7),
                                                child: Text(
                                                  AllselectedActivityList[i][1],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(secondary),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Activity Location",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(primary),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                    bottom: BorderSide(
//                                      color: Colors.grey[200],
//                                    ),
//                                  ),
//                                ),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search for a place",
                                      suffixIcon: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(primary),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Material(
                                          elevation: 1,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewActivity(),
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.location_on,
                                              color: Color(primary),
                                            ),
                                          ),
                                        ),
                                      ),
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
//                                    focusedBorder: OutlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.white),
//                                    ),
//                                    enabledBorder: UnderlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.indigo),
//                                    ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Date",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(primary),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
                                  child: DateTimeField(
                                    format: DateFormat('d/MM/y'),
                                    onShowPicker: _presentDatePicker,
                                    validator: (value) {
                                      String date = DateTime.now()
                                          .toString()
                                          .substring(0, 10);
                                      if (value == null)
                                        return "Select Date";
                                      else if (value
                                              .toString()
                                              .substring(0, 10) ==
                                          date) {
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
                                          left: 30.0,
                                          bottom: 18.0,
                                          top: 18.0,
                                          right: 30.0),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.calendar,
                                        color: Color(primary),
                                        size: 18,
                                      ),
                                      hintText: "DD/MM/YYYY",
                                      hintStyle: TextStyle(
                                        color: Color(formHint),
                                      ),
                                    ),
                                    autofocus: false,
                                  ),
                                ),
                                Text(
                                  "Time",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(primary),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                    bottom: BorderSide(
//                                      color: Colors.grey[200],
//                                    ),
//                                  ),
//                                ),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Start Time",
                                      prefixIcon: Icon(
                                        Icons.timer,
                                        color: Color(primary),
                                      ),
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
//                                    focusedBorder: OutlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.white),
//                                    ),
//                                    enabledBorder: UnderlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.indigo),
//                                    ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                    bottom: BorderSide(
//                                      color: Colors.grey[200],
//                                    ),
//                                  ),
//                                ),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "End Time",
                                      prefixIcon: Icon(
                                        Icons.timer,
                                        color: Color(primary),
                                      ),
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
//                                    focusedBorder: OutlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.white),
//                                    ),
//                                    enabledBorder: UnderlineInputBorder(
//                                      borderSide:
//                                          BorderSide(color: Colors.indigo),
//                                    ),
                                    ),
                                  ),
                                ),
                                Row(
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
                                    Text(
                                      "Let others propose time changes",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(primary),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "No. of peoples you'd like to join",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(primary),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RadioGroup(),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Note",
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
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 10.0),
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                    bottom: BorderSide(
//                                      color: Colors.grey[200],
//                                    ),
//                                  ),
//                                ),
                                  child: TextField(
                                    maxLines: 5,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          "e.g. Looks like it'sgoing to be hot today, bring lots of water , Meet at Edit D of the subway....",
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
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.9,
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: FlatButton(
                              color: Color(secondary),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              onPressed: () {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (BuildContext context) =>
//                                          NextPage()),
//                                );
                              },
                              child: Center(
                                child: Text(
                                  "Broadcast Activity",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: Platform.isIOS ? 10 : 40,
                      ),
                    ],
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

class RadioGroup extends StatefulWidget {
  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}

class RadioGroupWidget extends State {
  int id = 1;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Radio(
                value: 1,
                activeColor: Color(primary),
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    id = 1;
                    print(id);
                  });
                },
              ),
              Icon(
                FontAwesomeIcons.male,
                size: 20,
              ),
              Radio(
                value: 2,
                activeColor: Color(primary),
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    id = 2;
                  });
                },
              ),
              Icon(
                FontAwesomeIcons.male,
                size: 20,
              ),
              Icon(
                FontAwesomeIcons.male,
                size: 20,
              ),
              Radio(
                value: 3,
                activeColor: Color(primary),
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    id = 3;
                  });
                },
              ),
              Icon(
                FontAwesomeIcons.male,
                size: 20,
              ),
              Icon(
                FontAwesomeIcons.male,
                size: 20,
              ),
              Icon(
                FontAwesomeIcons.male,
                size: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(primary),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.ellipsisH,
                  ),
                  color: Color(primary),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
