import 'dart:math';

import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/login.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:chaloapp/widgets/date_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String activityName, activity, note, type = 'Public';
  DateTime pickedDate = DateTime.now();
  DateTime startTime = DateTime.now().add(Duration(minutes: 29));
  DateTime endTime;
  int _peopleCount = 1;
  bool proposeTime = false;
  bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
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
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
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
                                        borderRadius: BorderRadius.circular(6),
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
                                        left: 30.0, bottom: 18.0, top: 18.0),
                                    filled: true,
                                    fillColor: Color(form1),
                                    hintStyle: TextStyle(
                                      color: Color(formHint),
                                    ),
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
                                              padding: EdgeInsets.only(top: 7),
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
                                        borderRadius: BorderRadius.circular(6),
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
                                  onShowPicker: (context, _) => DateTimePicker()
                                      .presentDatePicker(
                                          context,
                                          DateTime.now(),
                                          DateTime.now()
                                              .add(Duration(days: 60))),
                                  validator: (value) {
                                    if (value == null) return "Select Date";
                                    return null;
                                  },
                                  onSaved: (value) => pickedDate = value,
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
                                child: DateTimeField(
                                  onShowPicker:
                                      DateTimePicker().presentTimePicker,
                                  format: DateFormat("hh:mm a"),
                                  validator: (value) {
                                    if (value == null)
                                      return 'Select Start Time';
                                    else {
                                      value = DateTimeField.combine(pickedDate,
                                          TimeOfDay.fromDateTime(value));
                                      if (value.isBefore(pickedDate
                                          .add(Duration(minutes: 29))))
                                        return 'Start time must be atleast 30 minutes later';
                                      else
                                        return null;
                                    }
                                  },
                                  onSaved: (value) => startTime =
                                      DateTimeField.combine(pickedDate,
                                          TimeOfDay.fromDateTime(value)),
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
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1.0, vertical: 10.0),
                                child: DateTimeField(
                                  onShowPicker:
                                      DateTimePicker().presentTimePicker,
                                  format: DateFormat("hh:mm a"),
                                  validator: (value) {
                                    if (value == null)
                                      return 'Select End Time';
                                    else {
                                      value = DateTimeField.combine(pickedDate,
                                          TimeOfDay.fromDateTime(value));
                                      if (value.isBefore(
                                          startTime.add(Duration(minutes: 29))))
                                        return 'Minimum time is 30 minutes';
                                      else
                                        return null;
                                    }
                                  },
                                  onSaved: (value) => endTime =
                                      DateTimeField.combine(pickedDate,
                                          TimeOfDay.fromDateTime(value)),
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
                              radioGroup(),
                              Visibility(
                                  visible: _showDropdown,
                                  child: SelectPeople()),
                              Text(
                                "Privacy",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(primary),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              activityType(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Select Gender",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(primary),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SelectGender(),
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
                                child: TextFormField(
                                  onSaved: (value) => note = value,
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
                        ),
                      ),
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
                              onPressed: () async {
                                _formKey.currentState.save();
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  String user = await UserData.getUser();
                                  Map<String, dynamic> activityDetails = {
                                    'activity_name': activityName,
                                    'activity_type': null,
                                    'admin_id': user,
                                    'participants_id': [user],
                                    'blocked_participant_id': [],
                                    'pending_participant_id': [],
                                    'broadcast_type': type.toLowerCase(),
                                    'max_partcipant': _peopleCount,
                                    'participant_type': selectedGender,
                                    'date': pickedDate,
                                    'activity_start':
                                        Timestamp.fromDate(startTime),
                                    'activity_end': Timestamp.fromDate(endTime),
                                    'description': note,
                                    'group_chat': null,
                                    'location_id': null,
                                    'map_status': type == 'Public'
                                        ? 'active'
                                        : 'inactive',
                                    'status': 'original',
                                    'security_code': Random().nextInt(10000),
                                    'timestamp': Timestamp.now(),
                                  };
                                  print(activityDetails);
                                  showDialogBox().show_Dialog(
                                      context: context,
                                      child: DialogBox(
                                          title: "Success",
                                          description:
                                              "Activity successfully created",
                                          buttonText1: "Ok",
                                          button1Func: () {
                                            Navigator.pop(context);
                                            Navigator.pop(
                                                context, activityDetails);
                                          }));
                                } else
                                  setState(() => _autovalidate = true);
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

  Map<String, String> gender = {
    "Both Boys & Girls": 'mixed',
    "Only Boys": 'male',
    "Only Girls": 'female'
  };
  String selectedGender = "mixed";
  DropdownButton SelectGender() {
    return DropdownButton<String>(
      items: gender.keys.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                option,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(secondary),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                gender[option] == selectedGender ? Icons.check : null,
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedGender = gender[value];
          print(selectedGender);
        });
      },
      underline: Container(),
      hint: Text(
        gender.keys
            .firstWhere((k) => gender[k] == selectedGender, orElse: () => null),
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      elevation: 0,
      isExpanded: true,
    );
  }

  Map<String, int> noOfPeople = makeList();
  static Map<String, int> makeList() {
    Map<String, int> temp = Map<String, int>();
    for (var i = 1; i <= 25; i++) {
      temp['$i people'] = i;
    }
    return temp;
  }

  DropdownButton SelectPeople() {
    // print(noOfPeople);
    return DropdownButton<int>(
      items: noOfPeople.keys.map((count) {
        return DropdownMenuItem(
          value: noOfPeople[count],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                count,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(secondary),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                noOfPeople[count] == _peopleCount ? Icons.check : null,
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _peopleCount = value;
          print(_peopleCount);
        });
      },
      underline: Container(),
      hint: Text(
        noOfPeople.keys.firstWhere((k) => noOfPeople[k] == _peopleCount,
            orElse: () => null),
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      elevation: 0,
      isExpanded: true,
    );
  }

  Widget radioButtons(int count, double size) {
    return Stack(children: <Widget>[
      SizedBox(
        width: size,
      ),
      Radio(
        value: count,
        activeColor: Color(primary),
        groupValue: _peopleCount,
        onChanged: (val) {
          setState(() {
            _peopleCount = count;
            print(_peopleCount);
          });
        },
      ),
      for (var i = 0; i < count; i++)
        Positioned(
          top: 13.0,
          left: 36.0 + 10 * i,
          child: Icon(
            FontAwesomeIcons.male,
            size: 20,
          ),
        )
    ]);
  }

  bool _showDropdown = false;
  Widget radioGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        radioButtons(1, 50.0),
        radioButtons(2, 60.0),
        radioButtons(3, 70.0),
        // radioButtons(4, 80.0),
        Spacer(),
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
            onPressed: () {
              setState(() => _showDropdown = !_showDropdown);
            },
          ),
        ),
      ],
    );
  }

  Widget activityType() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Radio(
                value: 'Public',
                activeColor: Color(primary),
                groupValue: type,
                onChanged: (val) {
                  setState(() {
                    type = val;
                    print(type);
                  });
                },
              ),
              Text(
                "Public",
                style: TextStyle(
                  color: Color(secondary),
                  fontSize: 16,
                ),
              ),
              Radio(
                value: 'Private',
                activeColor: Color(primary),
                groupValue: type,
                onChanged: (val) {
                  setState(() {
                    type = val;
                    print(type);
                  });
                },
              ),
              Text(
                "Private",
                style: TextStyle(
                  color: Color(secondary),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
