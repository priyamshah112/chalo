//import 'package:chaloapp/forgot.dart';
//import 'package:chaloapp/main.dart';
//import 'package:chaloapp/widgets/DailogBox.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:chaloapp/Boradcast/edit_activity.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Animation/FadeAnimation.dart';
//import 'package:chaloapp/Animation/FadeAnimation.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:chaloapp/signup.dart';
//import 'package:chaloapp/home.dart';

class ChatInfo extends StatefulWidget {
  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Chat Info",
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
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (BuildContext context) => EditActivity()),
//              );
            },
            child: IconButton(
              onPressed: (){},
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
            ),
//            Text(
//              "Share",
//              style: TextStyle(
//                color: Colors.white,
//                fontSize: 17,
//                fontFamily: bodyText,
//                fontWeight: FontWeight.bold,
//              ),
//            ),
          ),
        ],
        elevation: 1.0,
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
                      height: 10.0,
                    ),
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
                                        fontFamily: heading,
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
                                                  fontFamily: bodyText,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              " 03:30 PM",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 15,
                                                  fontFamily: bodyText,
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
                                                  fontFamily: bodyText,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              " 03:30 PM",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 15,
                                                  fontFamily: bodyText,
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
                                          " 1/6 people",
                                          style: TextStyle(
                                              color: Color(secondary),
                                              fontSize: 15,
                                              fontFamily: bodyText,
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
                                                  fontFamily: bodyText,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              " 16 Mar 20",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 15,
                                                  fontFamily: bodyText,
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
                                          0.55,
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
                                                  fontFamily: bodyText,
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
                                              fontFamily: bodyText,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 5,
                                ),

                                //loop start
                              ],
                            ),
                          ),
                          elevation: 0,
                        ),
                        Text(
                          "Participants",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(primary),
                            fontFamily: heading,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  width: 1,
                                  color: Color(primary),
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("images/bgcover.jpg"),
                                ),
                                title: Text(
                                  'Name',
                                  style: TextStyle(
                                      fontFamily: bodyText,
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text('1 Actvity Done'),
                                trailing: Container(
                                  width: 100,
                                  height: 27,
                                  child: OutlineButton(
                                    onPressed: () {},
                                    borderSide: BorderSide(
                                      color:
                                          Color(primary), //Color of the border
                                      style: BorderStyle
                                          .solid, //Style of the border
                                      width: 0.9, //width of the border
                                    ),
                                    color: Color(primary),
                                    textColor: Color(primary),
                                    child: Text(
                                      "follow",
                                      style: TextStyle(
                                        fontFamily: bodyText,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  width: 1,
                                  color: Color(primary),
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("images/bgcover.jpg"),
                                ),
                                title: Text(
                                  'Name',
                                  style: TextStyle(
                                      fontFamily: bodyText,
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text('1 Actvity Done'),
                                trailing: Container(
                                  width: 100,
                                  height: 27,
                                  child: OutlineButton(
                                    onPressed: () {},
                                    borderSide: BorderSide(
                                      color:
                                          Color(primary), //Color of the border
                                      style: BorderStyle
                                          .solid, //Style of the border
                                      width: 0.9, //width of the border
                                    ),
                                    color: Color(primary),
                                    textColor: Color(primary),
                                    child: Text(
                                      "follow",
                                      style: TextStyle(
                                        fontFamily: bodyText,
                                      ),
                                    ),
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
