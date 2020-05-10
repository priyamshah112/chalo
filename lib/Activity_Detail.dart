//import 'package:chaloapp/forgot.dart';
//import 'package:chaloapp/main.dart';
//import 'package:chaloapp/widgets/DailogBox.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:chaloapp/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'AddActivity.dart';
import 'Animation/FadeAnimation.dart';
//import 'package:chaloapp/Animation/FadeAnimation.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:chaloapp/signup.dart';
//import 'package:chaloapp/home.dart';

class ActivityDetails extends StatefulWidget {
  @override
  _ActivityDetailsState createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(primary),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Activity Name',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
//                    Stack(
//                      children: <Widget>[
//                        Container(
//                          height: 100,
//                          width: MediaQuery.of(context).size.width,
//                          decoration: BoxDecoration(
//                            color: Colors.black,
//                            image: DecorationImage(
//                              image: AssetImage("images/loginbg.png"),
//                              fit: BoxFit.cover,
//                              colorFilter: ColorFilter.mode(
//                                  Colors.black.withOpacity(0.7),
//                                  BlendMode.dstATop),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Color(primary), width: 1),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
//                          decoration: BoxDecoration(
//                              border: Border.all(
//                                color: Color(primary),
//                              ),
//                              borderRadius: BorderRadius.circular(6)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Activity Name",
                                      style: TextStyle(
                                        color: Color(primary),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.timer,
                                          color: Color(secondary),
                                          size: 25,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              " Start Time",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              " 03:30 PM",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.timer,
                                          color: Color(secondary),
                                          size: 25,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              " End Time",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              " 03:30 PM",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.people,
                                          color: Color(secondary),
                                          size: 25,
                                        ),
                                        Text(
                                          " 1/6 people have confirmed",
                                          style: TextStyle(
                                              color: Color(secondary),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.calendar_today,
                                          color: Color(secondary),
                                          size: 25,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              " Date",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              " 16 Mar 20",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            color: Color(secondary),
                                            size: 25,
                                          ),
                                          Flexible(
                                            child: Text(
                                              " 2-95, Jogeshwari - Vikhroli Link Rd. Milind Nagar, Krishna Nagar",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {},
                                          child: Text(
                                            "View Map",
                                            style: TextStyle(
                                                color: Color(primary),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                //loop start
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "Participants List",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(primary),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("images/bgcover.jpg"),
                                ),
                                title: Text('Name'),
                                subtitle: Text('1 Actvity Done'),
                                trailing: OutlineButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Follow",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  textColor: Colors.green,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(color: Colors.green),
                                  highlightedBorderColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("images/bgcover.jpg"),
                                ),
                                title: Text('Name'),
                                subtitle: Text('1 Actvity Done'),
                                trailing: OutlineButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Follow",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  textColor: Colors.green,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(color: Colors.green),
                                  highlightedBorderColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
