import 'package:chalo/services/DatabaseService.dart';
import 'package:chalo/widgets/DailogBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../Animation/FadeAnimation.dart';
import '../common/global_colors.dart';
import '../widgets/date_time.dart';

class EditActivity extends StatefulWidget {
  final DocumentSnapshot plandocu;
  EditActivity({@required this.plandocu});
  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final _formKey = GlobalKey<FormState>();
  final activityController = TextEditingController();
  String activityName, activity, note, type = 'Public';
  TextEditingController address = TextEditingController();
  List<String> activities;
  DateTime startTime = DateTime.now().add(Duration(minutes: 29));
  DateTime endTime;
  DateTimePicker start = new DateTimePicker();
  DateTimePicker end = new DateTimePicker();
  int _peopleCount = 1;
  bool proposeTime = false;
  //bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "Edit Activity",
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
              onPressed: () {
              //  Navigator.push(
              //    context,
              //    MaterialPageRoute(
              //        builder: (BuildContext context) => EditActivity()),
              //  );
              },
              child: Text(
                "Update",
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
                                "Date & Time",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(primary),
                                  fontFamily: bodyText,
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
                              Text(
                                "No. of peoples you'd like to join",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(primary),
                                  fontFamily: bodyText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              radioGroup(),
                              Visibility(
                                  visible: _showDropdown,
                                  child: selectPeople()),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Select Gender",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(primary),
                                  fontFamily: bodyText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              selectGender(),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: bodyText,
                                      color: Color(primary),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    " (Optional)",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(secondary),
                                      fontFamily: bodyText,
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
                                      fontFamily: bodyText,
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
                                  Map<String, dynamic> activityDetails = {  
                                    'max_participant': _peopleCount + 1,
                                    'participant_type': selectedGender,
                                    'activity_start':
                                        Timestamp.fromDate(startTime),
                                    'activity_end': Timestamp.fromDate(endTime),
                                    'description': note,
                                  };
                                  // print(activityDetails);
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => Center(
                                          child: CircularProgressIndicator()));
                                  await DataService()
                                      .updateUserPlan(activityDetails, widget.plandocu);
                                  await Future.delayed(Duration(seconds: 1));
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => FadeAnimation(
                                            1,
                                            DialogBox(
                                                title: "Success",
                                                description:
                                                    "Activity successfully updated",
                                                buttonText1: "Ok",
                                                button1Func: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                }),
                                          ));
                                } //else
                                  //setState(() => _autovalidate = true);
                              },
                              child: Center(
                                child: Text(
                                  "Update Activity",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          )),
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
  DropdownButton selectGender() {
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

  DropdownButton selectPeople() {
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
