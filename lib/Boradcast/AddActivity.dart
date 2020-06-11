import 'dart:math';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:chaloapp/widgets/date_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chaloapp/Animation/FadeAnimation.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../common/add_location.dart';
import '../data/activity.dart';
import 'package:intl/intl.dart';

class AddActivity extends StatefulWidget {
  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final _formKey = GlobalKey<FormState>();
  final activityController = TextEditingController();
  TextEditingController address = TextEditingController();
  String activityName, activity, location, note, type = 'Public';
  Position activityLocation;
  List<String> activities;
  DateTime startTime = DateTime.now().add(Duration(minutes: 29));
  DateTime endTime;
  DateTimePicker start = new DateTimePicker();
  DateTimePicker end = new DateTimePicker();
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
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "Broadcast Activity",
            style: TextStyle(
              color: Colors.white,
              fontFamily: bodyText,
              fontWeight: FontWeight.bold,
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
          elevation: 1.0,
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
                              Text(
                                "Activity Title",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(primary),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1.0, vertical: 10.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Please Enter a title';
                                    else
                                      return null;
                                  },
                                  onSaved: (value) => activityName = value,
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "A name for your Activity",
                                    prefixIcon: Icon(
                                      Icons.directions_bike,
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1.0, vertical: 10.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Please Select an Activity';
                                    else {
                                      bool contains = true;
                                      for (var activity in activities) {
                                        contains =
                                            value == activity ? true : false;
                                        if (contains) break;
                                      }
                                      return contains
                                          ? null
                                          : 'Make sure to select an activity from the list';
                                    }
                                  },
                                  onSaved: (value) => activity = value,
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  onTap: () async {
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewActivity(),
                                      ),
                                    );
                                    if (result == null) return;
                                    activityController.text =
                                        result['selected'];
                                    activities = result['activityList'];
                                    FocusScope.of(context).unfocus();
                                  },
                                  controller: activityController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Select an Activity",
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
                                child: TextFormField(
                                  controller: address,
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  validator: (value) => value.isEmpty
                                      ? 'Please Select a Location'
                                      : null,
                                  onSaved: (value) => location = value,
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    Map result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GetLocation(),
                                      ),
                                    );
                                    if (result != null) {
                                      address.text = result['location'];
                                      activityLocation = result['position'];
                                    }
                                  },
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
                                          child: Icon(
                                            Icons.location_on,
                                            color: Color(primary),
                                          ),
                                        ),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 10.0,
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
                              Text(
                                "Date & Time",
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
                                  onShowPicker: (context, time) =>
                                      start.presentDateTimePicker(
                                          context,
                                          DateTime.now(),
                                          DateTime.now()
                                              .add(Duration(days: 60)),
                                          DateTime.now()
                                              .add(Duration(minutes: 30))),
                                  format: DateFormat("EEE, d MMM yyyy hh:mm a"),
                                  validator: (value) {
                                    if (value == null)
                                      return 'Select Start Time';
                                    else {
                                      if (value.isBefore(DateTime.now()
                                          .add(Duration(minutes: 29))))
                                        return 'Start time must be atleast 30 minutes later';
                                      else
                                        return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    // print('start: ' + value.toString());
                                    startTime = value;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Start Time",
                                    prefixIcon: Icon(
                                      Icons.timer,
                                      color: Color(primary),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                      bottom: 18.0,
                                      top: 18.0,
                                    ),
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
                                  onShowPicker: (context, time) =>
                                      end.presentDateTimePicker(
                                          context,
                                          DateTime.now(),
                                          DateTime.now()
                                              .add(Duration(days: 60)),
                                          DateTime.now()
                                              .add(Duration(minutes: 60))),
                                  format: DateFormat("EEE, d MMM yyyy hh:mm a"),
                                  validator: (value) {
                                    if (value == null)
                                      return 'Select End Time';
                                    else {
                                      bool condition = startTime != null
                                          ? value.isBefore(startTime
                                              .add(Duration(minutes: 29)))
                                          : value.isBefore(DateTime.now()
                                              .add(Duration(minutes: 59)));
                                      if (condition)
                                        return 'Minimum time is 30 minutes';
                                      else
                                        return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    // print('end: ' + value.toString());
                                    endTime = value;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "End Time",
                                    prefixIcon: Icon(
                                      Icons.timer,
                                      color: Color(primary),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 18.0, top: 18.0),
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
                                "Boradcast audience",
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
                                "Boradcast audience Gender",
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
                                    "Description",
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
                              color: Color(primary),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              onPressed: () async {
                                _formKey.currentState.save();
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  final user = await UserData.getUser();
                                  Map<String, dynamic> activityDetails = {
                                    'activity_name': activityName,
                                    'activity_type': activity,
                                    'admin_id': user['email'],
                                    'admin_name': user['name'],
                                    'participants_id': [user['email']],
                                    'blocked_participant_id': [],
                                    'pending_participant_id': [],
                                    'broadcast_type': type.toLowerCase(),
                                    'max_participant': _peopleCount,
                                    'participant_type': selectedGender,
                                    'activity_start':
                                        Timestamp.fromDate(startTime),
                                    'activity_end': Timestamp.fromDate(endTime),
                                    'description': note,
                                    'group_chat': null,
                                    'location_id': null,
                                    'address': location,
                                    'location': GeoPoint(
                                        activityLocation.latitude,
                                        activityLocation.longitude),
                                    'map_status': type == 'Public'
                                        ? 'active'
                                        : 'inactive',
                                    'status': 'original',
                                    'security_code': Random().nextInt(10000),
                                    'timestamp': Timestamp.now(),
                                    'plan_id': ""
                                  };
                                  print(activityDetails);
                                  showDialog(
                                      context: context,
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                  await Future.delayed(Duration(seconds: 1));
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => FadeAnimation(
                                            1,
                                            DialogBox(
                                                title: "Success",
                                                description:
                                                    "Activity successfully created",
                                                buttonText1: "Ok",
                                                button1Func: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(
                                                      context, activityDetails);
                                                }),
                                          ));
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
                value: 'Followers',
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
                "Followers",
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
