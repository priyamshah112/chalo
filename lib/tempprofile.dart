import 'dart:io';

import 'package:chaloapp/services/DatabaseService.dart';
import 'package:chaloapp/widgets/DailogBox.dart';
import 'package:chaloapp/widgets/date_time.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'common/global_colors.dart';

class TempProfilePage extends StatefulWidget {
  @override
  _TempProfilePageState createState() => _TempProfilePageState();
}

class _TempProfilePageState extends State<TempProfilePage> {
  final formKey = GlobalKey<FormState>();

  double progress;
  double progresspercent;

  var _mySpecialization;
  var _currentSelectedSpecialization;

  List _mySkills;
  String _mySkillsResult;

  var _myExperience;
  var _currentSelectedExperience;

  var _employmentStatus;
  var _currentSelectedEmploymentStatus;

  bool field1;
  bool field2;
  bool field3;
  bool field4;
  String email;

//  User user;
  DateTime picked;
  bool checkPassword = false;
  bool _autovalidate = false;
  bool _viewPassword = false;
  String password;

  var _gender = [
    "Male",
    "Female",
    "Other",
    "Prefer Not to Say",
  ];
  var _currentSelectedGenderValue;
  var _purpose = [
    "Developing an idea",
    "Searching for investors/capital",
    "Starting my venture",
    "Managing an existing business",
  ];
  var _currentSelectedPurposeValue;
  Future<void> _initForm;
//  final _stateList = <StateModel>[];
//  final _cityList = <City>[];
//
//  StateModel selectedState;
//  City selectedCity;

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
  }

  @override
  void initState() {
//    user = new User();
    super.initState();
    _getData();
    _initForm = _initStateAsync();

    _mySkills = [];
    _mySkillsResult = '';

    progress = 0.00;
    progresspercent = progress * 100;
    field1 = true;
    field2 = true;
    field3 = true;
    field4 = true;
  }

  Future<void> _initStateAsync() async {
//    _stateList.clear();
//    _stateList.addAll(await fetchStateList());
  }

//  void _onStateSelected(StateModel selectedState) async {
//    try {
//      final cityList = await fetchCityList(selectedState.id);
//      setState(() {
//        this.selectedState = selectedState;
//        selectedCity = null;
//        _cityList.clear();
//        _cityList.addAll(cityList);
//      });
//    } catch (e) {
//      print("catched");
//      print(e);
//    }
//  }
//
//  void _onCitySelected(City selectedCity) {
//    setState(() {
//      this.selectedCity = selectedCity;
//    });
//  }

  void showSuccess(BuildContext context, String email) async {
    showDialog(
        builder: (ctx) => DialogBox(
            title: "Success",
            description: "Profile Updated Successfully!",
            icon: Icons.check,
            iconColor: Color(secondary),
            buttonText1: "",
            button1Func: () {}),
        context: context);
    await Future.delayed(Duration(seconds: 2));
  }

  void showFail(BuildContext context) {
    showDialog(
        builder: (ctx) => DialogBox(
            title: "Failure",
            description: "Profile Update Failed",
            icon: Icons.clear,
            iconColor: Color(secondary),
            buttonText1: "OK",
            button1Func: () =>
                Navigator.of(context, rootNavigator: true).pop()),
        context: context);
  }

//  _saveForm() async {
//    var form = formKey.currentState;
//    if (form.validate()) {
//      form.save();
//      setState(() {
//        _mySpecialization = _currentSelectedSpecialization;
//        _mySkillsResult = _mySkills.toString();
//        _myExperience = _currentSelectedExperience;
//        _employmentStatus = _currentSelectedEmploymentStatus;
//        print(email);
//        print(_mySpecialization);
//        print(_mySkills);
//        print(_myExperience);
//        print(_employmentStatus);
//        print(double.parse((progress).toStringAsFixed(2)));
//      });
//
//      try {
//        await DataService().updateProfileSetup(
//            email, _mySpecialization, _mySkills, _myExperience, _employmentStatus,
//            double.parse((progress).toStringAsFixed(2)));
//
//        showSuccess(context, email);
//      } catch (e) {
//        print(e.toString());
//
//        showFail(context);
//      }
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            color: Colors.white,
            alignment: Alignment.center,
            child: Form(
              key: formKey,
              autovalidate: _autovalidate,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 40,
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 2000,
                    percent: progress,
                    center: Text(
                      "Completed : $progresspercent %",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Color(secondary),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return "Enter a First Name";
                        return null;
                      },
//                      onSaved: (value) => user.setFname(value.trim()),
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "First Name",
                        prefixIcon: Icon(
                          FontAwesomeIcons.userPlus,
                          color: Color(primary),
                          size: 18,
                        ),
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
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return "Enter a Last Name";
                        return null;
                      },
//                      onSaved: (value) => user.setLname(value.trim()),
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(form1),
                        contentPadding: const EdgeInsets.only(
                            left: 30.0, bottom: 18.0, top: 18.0, right: 30.0),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          FontAwesomeIcons.userPlus,
                          color: Color(primary),
                          size: 18,
                        ),
                        hintText: "Last Name",
                        hintStyle: TextStyle(
                          color: Color(formHint),
                        ),
                      ),
                      autofocus: false,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
                    child: DateTimeField(
                      format: DateFormat('d/MM/y'),
                      onShowPicker: (context, _) => DateTimePicker()
                          .presentDatePicker(
                              context, DateTime(1900), DateTime.now()),
                      validator: (value) {
                        String date =
                            DateTime.now().toString().substring(0, 10);
                        if (value == null)
                          return "Select Date of Birth";
                        else if (value.toString().substring(0, 10) == date) {
                          print(value.toString());
                          return "Select Valid Date of Birth";
                        }
                        return null;
                      },
                      onSaved: (value) {
//                        user.setBirthDate(value.toString().substring(0, 10));
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
                          size: 18,
                        ),
                        hintText: "Birth Date",
                        hintStyle: TextStyle(
                          color: Color(formHint),
                        ),
                      ),
                      autofocus: false,
                    ),
                  ),
                  // Gender Dropdown
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
//                                                  decoration: InputDecoration.collapsed(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(form1),
                              labelStyle: TextStyle(
                                  color: Color(form1), fontSize: 10.0),
                              errorStyle: TextStyle(
                                  color: Colors.red[600], fontSize: 12.0),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              contentPadding: const EdgeInsets.only(
                                  left: 30.0,
                                  bottom: 18.0,
                                  top: 18.0,
                                  right: 0.0),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color(primary),
                              ),
                            ),
                            hint: Text(
                              "What's your gender",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            value: _currentSelectedGenderValue,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _currentSelectedGenderValue = newValue;
                                state.didChange(newValue);
                              });
                            },
                            validator: (value) {
                              print("gender");
                              print(value);
                              if (value == null)
                                return "Please select your gender";
                              return null;
                            },
//                            onSaved: (value) => user.setGender(value.trim()),
                            items: _gender.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Purpose Dropdown
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(form1),
                              labelStyle: TextStyle(
                                  color: Color(form1), fontSize: 10.0),
                              errorStyle: TextStyle(
                                  color: Colors.red[600], fontSize: 12.0),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              contentPadding: const EdgeInsets.only(
                                  left: 0.0,
                                  bottom: 18.0,
                                  top: 18.0,
                                  right: 0.0),
                              prefixIcon: Icon(
                                Icons.question_answer,
                                color: Color(primary),
                              ),
                            ),
                            hint: Text(
                              "What you are looking for?",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                            value: _currentSelectedPurposeValue,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _currentSelectedPurposeValue = newValue;
                                state.didChange(newValue);
                              });
                            },
                            validator: (value) {
                              print("Purpose");
                              print(value);
                              if (value == null)
                                return "Please select a purpose";
                              return null;
                            },
//                            onSaved: (value) => user.setPurpose(value.trim()),
                            items: _purpose.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                  // City Country Dropdown
                  SizedBox(height: 5),
                  FutureBuilder<void>(
                    future: _initForm,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return _buildLoading();
                      else if (snapshot.hasError)
                        return _buildError(snapshot.error);
                      else
                        return _buildBody();
                    },
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
                    child: TextFormField(
                      validator: (value) => _validateEmail(value.trim()),
//                      onSaved: (value) => user.setEmail(value.trim()),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email Address",
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Color(primary),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 30.0,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.trim().length < 6)
                          return "Minimum 6 characters";
                        password = value.trim();
                        return null;
                      },
                      obscureText: !_viewPassword,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(form1),
                        contentPadding: const EdgeInsets.only(
                            left: 30.0, bottom: 18.0, top: 18.0, right: 30.0),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(primary),
                        ),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _viewPassword = !_viewPassword;
                              });
                            },
                            child: Icon(
                              !_viewPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(primary),
                            )),
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: Color(formHint),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value != password) return "Passwords need to match";
                        return null;
                      },
//                      onSaved: (value) => user.setPassword(password),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Confirm Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(primary),
                        ),
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

                  SizedBox(
                    height: 5,
                  ),

                  //Q1
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                    child: DropDownFormField(
                      titleText: "What is your field of specialization?",
                      hintText: 'Please choose one option',
                      value: _currentSelectedSpecialization,
                      onSaved: (value) {
                        setState(() {
                          _currentSelectedSpecialization = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          if (progress < 1.0 && field1) {
                            field1 = false;
                            progress = progress + 0.075;
                            progresspercent = double.parse(
                                (progress * 100).toStringAsFixed(2));
                            print(progress);
                          }
                          if (value.length == 0 && field1 == false) {
                            progress = progress - 0.075;
                            progresspercent = double.parse(
                                (progress * 100).toStringAsFixed(2));
                            print(progress);
                            field1 = true;
                          }
                          _currentSelectedSpecialization = value;
                        });
                      },
                      dataSource: [
                        {
                          "display": "Accounting & Finance",
                          "value": "1",
                        },
                        {
                          "display": "Banking & Financial Services",
                          "value": "2",
                        },
                        {
                          "display": "Business Management",
                          "value": "3",
                        },
                        {
                          "display": "Software",
                          "value": "4",
                        },
                        {
                          "display": "Healthcare",
                          "value": "5",
                        },
                        {
                          "display": "Legal Services",
                          "value": "6",
                        },
                        {
                          "display": "Engineering",
                          "value": "7",
                        },
                        {
                          "display": "Craftsmanship",
                          "value": "8",
                        },
                        {
                          "display": "Other",
                          "value": "9",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //Q2
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                    child: MultiSelectFormField(
                      fillColor: Colors.grey[100],
                      autovalidate: false,
                      titleText: "What are your skills?",
                      validator: (value) {
                        if (value == null || value.length == 0)
                          return "Please select one or more options";
                        return null;
                      },
                      dataSource: [
                        {
                          "display": "Digital Marketing",
                          "value": "1",
                        },
                        {
                          "display": "Driving",
                          "value": "2",
                        },
                        {
                          "display": "Online Communication",
                          "value": "3",
                        },
                        {
                          "display": "Analysis",
                          "value": "4",
                        },
                        {
                          "display": "Teaching",
                          "value": "5",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'OK',
                      cancelButtonLabel: 'CANCEL',
                      // required: true,
                      hintText: 'Please choose one or more',
                      initialValue: _mySkills,
                      onSaved: (value) {
                        setState(() {
                          if (progress < 1.0 && field2) {
                            field2 = false;
                            progress = progress + 0.075;
                            progresspercent = double.parse(
                                (progress * 100).toStringAsFixed(2));
                            print(progress);
                          }
                          if (value.length == 0 && field2 == false) {
                            progress = progress - 0.075;
                            progresspercent = double.parse(
                                (progress * 100).toStringAsFixed(2));
                            print(progress);
                            field2 = true;
                          }
                          _mySkills = value;
                        });
                      },
                    ),
                  ),
                  //Q3
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                    child: DropDownFormField(
                      titleText: "Select your experience as an entrepreneur?",
                      hintText: 'Please choose one option',
                      value: _currentSelectedExperience,
                      onSaved: (value) {
                        setState(() {
                          _currentSelectedExperience = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          if (progress < 1.0 && field3) {
                            field3 = false;
                            progress = progress + 0.075;
                            progresspercent = double.parse(
                                (progress * 100).toStringAsFixed(2));
                            print(progress);
                          }
                          if (value.length == 0 && field3 == false) {
                            progress = progress - 0.075;
                            progresspercent = double.parse(
                                (progress * 100).toStringAsFixed(2));
                            print(progress);
                            field3 = true;
                          }
                          _currentSelectedExperience = value;
                        });
                      },
                      dataSource: [
                        {
                          "display": "First venture",
                          "value": "1",
                        },
                        {
                          "display": "1-3 business ventures",
                          "value": "2",
                        },
                        {
                          "display": "4+ business ventures",
                          "value": "3",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  //Q4
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                    child: DropDownFormField(
                      titleText: "What's your employment status",
                      hintText: 'Please choose one option',
                      value: _currentSelectedEmploymentStatus,
                      onSaved: (value) {
                        setState(() {
                          _currentSelectedEmploymentStatus = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          if (progress < 1.0 && field4) {
                            field4 = false;
                            progress = progress + 0.075;
                            progresspercent = double.parse(
                                (progress * 100).toStringAsFixed(2));
                            print(progress);
                          }
                          if (value.length == 0 && field4 == false) {
                            progress = progress - 0.075;
                            progresspercent = double.parse(
                                (progress * 100).toStringAsFixed(2));
                            print(progress);
                            field4 = true;
                          }
                          _currentSelectedEmploymentStatus = value;
                        });
                      },
                      dataSource: [
                        {
                          "display": "Working",
                          "value": "1",
                        },
                        {
                          "display": "Out of Work",
                          "value": "2",
                        },
                        {
                          "display": "Student",
                          "value": "3",
                        },
                        {
                          "display": "Retired",
                          "value": "4",
                        },
                        {
                          "display": "Prefer not to answer",
                          "value": "5",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: RaisedButton(
                      color: Color(primary),
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.white10,

                      child: Text(
                        'Update Profile',
                        style: TextStyle(
                          fontFamily: bodyText,
                          fontSize: 15,
                        ),
                      ),

//                      onPressed: _saveForm,
                    ),
                  ),

//                  Divider(
//                    color: Colors.grey[600],
//                    height: 2,
//                    thickness: 1,
//                    indent: 10.0,
//                    endIndent: 10.0,
//                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => DialogBox(
                            title: 'Warning',
                            description: "Are you sure you want to Sign out ?",
                            buttonText1: "No",
                            button1Func: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(false),
                            buttonText2: "Yes",
//                            button2Func: () async {
//                              SharedPreferences prefs =
//                                  await SharedPreferences.getInstance();
//                              await AuthService()
//                                  .signOut(prefs.getString('type'));
//                              print("Signed out");
//                              Navigator.of(context, rootNavigator: true)
//                                  .pop(true);
//                              Navigator.pushReplacement(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) =>
//                                          HomePage())); // To close the dialog
//                            },
                          ),
                        );
                      },
                      elevation: 1,
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Merriweather',
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.redAccent,
                      mini: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.0))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoActivityIndicator(animating: true),
          SizedBox(height: 10.0),
          Text("Loading Country and Cities"),
        ],
      ),
    );
  }

  Widget _buildError(dynamic error) {
    return Center(
      child: Text("Error occured: $error"),
    );
  }

//  <StateModel>
  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(form1),
                labelStyle: TextStyle(color: Color(form1), fontSize: 10.0),
                errorStyle: TextStyle(color: Colors.red[600], fontSize: 12.0),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                contentPadding: const EdgeInsets.only(
                    left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                prefixIcon: Icon(
                  Icons.place,
                  color: Color(primary),
                ),
              ),
              hint: Text(
                "Country",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              isDense: true,
//              items: _stateList
//                  .map((itm) => DropdownMenuItem(
//                        child: Text(itm.name),
//                        value: itm,
//                      ))
//                  .toList(),
//              value: selectedState,
//              onChanged: _onStateSelected,
              validator: (value) {
                print("Country");
                print(value);
                if (value == null) return "Please select your country";
                return null;
              },
//              onSaved: (value) => user.setCountry(value.id),
            ),
          ),
        ),
        SizedBox(height: 10),
//    <City>
        Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(form1),
                labelStyle: TextStyle(color: Color(form1), fontSize: 10.0),
                errorStyle: TextStyle(color: Colors.red[600], fontSize: 12.0),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                contentPadding: const EdgeInsets.only(
                    left: 30.0, bottom: 18.0, top: 18.0, right: 0.0),
                prefixIcon: Icon(
                  Icons.place,
                  color: Color(primary),
                ),
              ),
              hint: Text(
                "City",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              isDense: true,
//              items: _cityList
//                  .map((itm) => DropdownMenuItem(
//                        child: Text(itm.name),
//                        value: itm,
//                      ))
//                  .toList(),
//              value: selectedCity,
//              onChanged: _onCitySelected,
              validator: (value) {
                print("City");
                print(value);
                if (value == null) return "Please select your city";
                return null;
              },
//              onSaved: (value) => user.setCity(value.id),
            ),
          ),
        ),
      ],
    );
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}
