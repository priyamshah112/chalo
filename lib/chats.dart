//import 'package:chaloapp/forgot.dart';
//import 'package:chaloapp/main.dart';
//import 'package:chaloapp/widgets/DailogBox.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:chaloapp/Chat_item_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'data/chat_model.dart';
import 'global_colors.dart';
//import 'package:chaloapp/Animation/FadeAnimation.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:chaloapp/signup.dart';
//import 'package:chaloapp/home.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<ChatModel> list = ChatModel.list;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(primary),
            bottom: TabBar(
              labelColor: Color(primary),
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("ACTIVE"),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("COMPLETED"),
                  ),
                ),
              ],
            ),
            title: Center(child: Text('My Chats')),
          ),
          body: TabBarView(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                          color: Color(primary),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          //obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            prefixIcon: Icon(
                              Icons.search,
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
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 0),
                                margin: EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(primary),
                                    ),
                                    borderRadius: BorderRadius.circular(6)),
                                child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ChatItemPage()),
                                      );
                                    },
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 55.0,
                                          height: 55.0,
                                          child: CircleAvatar(
                                            foregroundColor: Color(primary),
                                            backgroundColor: Color(secondary),
                                            backgroundImage: AssetImage(
                                                'images/bgcover.jpg'),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              list[index].activityName,
                                              style: TextStyle(
                                                color: Color(primary),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (list[index].isRemoved)
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  list[index].lastMessage,
                                                  style: TextStyle(
                                                    color: Color(secondary),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )
                                            else if (list[index].isPending)
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  "",
                                                ),
                                              )
                                            else
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  list[index].lastMessage,
                                                  style: TextStyle(
                                                    color: Color(secondary),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 30),
                                          child: FittedBox(
                                            child: Text(
                                              list[index].activityDate,
                                              style: TextStyle(
                                                color: Color(secondary),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: list[index].isPending
                                        ? Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  "Request to join pending",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  "Once they accept, we'll open chat for your new group",
                                                  style: TextStyle(
                                                    color: Color(secondary),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : list[index].isRemoved
                                            ? Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      "You were removed fron this activity",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      "Swipe left to delete this activity from your activity list",
                                                      style: TextStyle(
                                                        color: Color(secondary),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : null),
                              );
                            }),
                      ),
//                        Column(
//                          mainAxisSize: MainAxisSize.min,
//                          children: <Widget>[

//                        Card(
//                          shape: RoundedRectangleBorder(
//                              borderRadius:
//                              BorderRadius.circular(10.0)),
//                          child: Container(
//                            width: MediaQuery.of(context).size.width,
//                            padding: EdgeInsets.symmetric(
//                                vertical: 20, horizontal: 20),
//                            decoration: BoxDecoration(
//                                border: Border.all(
//                                  color: Color(primary),
//                                ),
//                                borderRadius:
//                                BorderRadius.circular(6)),
//                            child: Column(
//                              crossAxisAlignment:
//                              CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Row(
//                                  crossAxisAlignment:
//                                  CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Container(
//                                      width: 55.0,
//                                      height: 55.0,
//                                      child: CircleAvatar(
//                                        foregroundColor:
//                                        Color(primary),
//                                        backgroundColor:
//                                        Color(secondary),
//                                        backgroundImage: AssetImage(
//                                            'images/bgcover.jpg'),
//                                      ),
//                                    ),
//                                    SizedBox(
//                                      width: 10.0,
//                                    ),
//                                    Column(
//                                      crossAxisAlignment:
//                                      CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        Text(
//                                          "Activity Name",
//                                          style: TextStyle(
//                                            color: Color(primary),
//                                            fontSize: 18,
//                                            fontWeight:
//                                            FontWeight.bold,
//                                          ),
//                                        ),
//                                        SizedBox(
//                                          height: 5,
//                                        ),
//                                        Container(
//                                          width:
//                                          MediaQuery.of(context)
//                                              .size
//                                              .width *
//                                              0.45,
//                                          child: Text(
//                                            "Admin name removed User name from the group",
//                                            style: TextStyle(
//                                              color: Color(secondary),
//                                              fontSize: 13,
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                    Spacer(),
//                                    Container(
//                                      child: Text(
//                                        "Fri 21 Feb",
//                                        style: TextStyle(
//                                          color: Color(secondary),
//                                          fontSize: 12,
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                                SizedBox(
//                                  height: 5,
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                            Card(
//                              shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(10.0)),
//                              child: Container(
//                                width: MediaQuery.of(context).size.width,
//                                padding: EdgeInsets.symmetric(
//                                    vertical: 20, horizontal: 20),
//                                decoration: BoxDecoration(
//                                    border: Border.all(
//                                      color: Color(primary),
//                                    ),
//                                    borderRadius: BorderRadius.circular(6)),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Row(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        Container(
//                                          width: 55.0,
//                                          height: 55.0,
//                                          child: CircleAvatar(
//                                            foregroundColor: Color(primary),
//                                            backgroundColor: Color(secondary),
//                                            backgroundImage: AssetImage(
//                                                'images/bgcover.jpg'),
//                                          ),
//                                        ),
//                                        SizedBox(
//                                          width: 10.0,
//                                        ),
//                                        Column(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
//                                          children: <Widget>[
//                                            Text(
//                                              "Activity Name",
//                                              style: TextStyle(
//                                                color: Color(primary),
//                                                fontSize: 18,
//                                                fontWeight: FontWeight.bold,
//                                              ),
//                                            ),
//                                            SizedBox(
//                                              height: 5,
//                                            ),
//                                            Container(
//                                              width: MediaQuery.of(context)
//                                                      .size
//                                                      .width *
//                                                  0.45,
//                                              child: Text(
//                                                "Admin name removed User name from the group",
//                                                style: TextStyle(
//                                                  color: Color(secondary),
//                                                  fontSize: 13,
//                                                ),
//                                              ),
//                                            ),
//                                          ],
//                                        ),
//                                        Spacer(),
//                                        Container(
//                                          child: Text(
//                                            "Fri 21 Feb",
//                                            style: TextStyle(
//                                              color: Color(secondary),
//                                              fontSize: 12,
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                    SizedBox(
//                                      height: 5,
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ),
//                            Card(
//                              shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(10.0)),
//                              child: Container(
//                                width: MediaQuery.of(context).size.width,
//                                padding: EdgeInsets.symmetric(
//                                    vertical: 20, horizontal: 20),
//                                decoration: BoxDecoration(
//                                    border: Border.all(
//                                      color: Color(primary),
//                                    ),
//                                    borderRadius: BorderRadius.circular(6)),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Row(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        Container(
//                                          width: 55.0,
//                                          height: 55.0,
//                                          child: CircleAvatar(
//                                            foregroundColor: Color(primary),
//                                            backgroundColor: Color(secondary),
//                                            backgroundImage: AssetImage(
//                                                'images/bgcover.jpg'),
//                                          ),
//                                        ),
//                                        SizedBox(
//                                          width: 10.0,
//                                        ),
//                                        Column(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
//                                          children: <Widget>[
//                                            Text(
//                                              "Activity Name",
//                                              style: TextStyle(
//                                                color: Color(primary),
//                                                fontSize: 18,
//                                                fontWeight: FontWeight.bold,
//                                              ),
//                                            ),
//                                            SizedBox(
//                                              height: 5,
//                                            ),
//                                            Container(
//                                              width: MediaQuery.of(context)
//                                                      .size
//                                                      .width *
//                                                  0.45,
//                                              child: Text(
//                                                "Admin name removed User name from the group",
//                                                style: TextStyle(
//                                                  color: Color(secondary),
//                                                  fontSize: 13,
//                                                ),
//                                              ),
//                                            ),
//                                          ],
//                                        ),
//                                        Spacer(),
//                                        Container(
//                                          child: Text(
//                                            "Fri 21 Feb",
//                                            style: TextStyle(
//                                              color: Color(secondary),
//                                              fontSize: 12,
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                    SizedBox(
//                                      height: 5,
//                                    ),
//                                    Divider(
//                                      thickness: 1,
//                                    ),
//                                    SizedBox(
//                                      height: 5,
//                                    ),
//                                    Container(
//                                      width: MediaQuery.of(context).size.width,
//                                      child: Text(
//                                        "You were removed from this activity",
//                                        style: TextStyle(
//                                          color: Colors.red,
//                                          fontSize: 15,
//                                          fontWeight: FontWeight.bold,
//                                        ),
//                                      ),
//                                    ),
//                                    SizedBox(
//                                      height: 5,
//                                    ),
//                                    Container(
//                                      width: MediaQuery.of(context).size.width,
//                                      child: Text(
//                                        "Swipe left to delete this activity from your activity list",
//                                        style: TextStyle(
//                                          color: Color(secondary),
//                                          fontSize: 13,
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ),
//                            Card(
//                              shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(10.0)),
//                              child: Container(
//                                width: MediaQuery.of(context).size.width,
//                                padding: EdgeInsets.symmetric(
//                                    vertical: 20, horizontal: 20),
//                                decoration: BoxDecoration(
//                                    border: Border.all(
//                                      color: Color(primary),
//                                    ),
//                                    borderRadius: BorderRadius.circular(6)),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Row(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        Container(
//                                          width: 55.0,
//                                          height: 55.0,
//                                          child: CircleAvatar(
//                                            foregroundColor: Color(primary),
//                                            backgroundColor: Color(secondary),
//                                            backgroundImage: AssetImage(
//                                                'images/bgcover.jpg'),
//                                          ),
//                                        ),
//                                        SizedBox(
//                                          width: 10.0,
//                                        ),
//                                        Column(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
//                                          children: <Widget>[
//                                            Text(
//                                              "Activity Name",
//                                              style: TextStyle(
//                                                color: Color(primary),
//                                                fontSize: 18,
//                                                fontWeight: FontWeight.bold,
//                                              ),
//                                            ),
//                                            SizedBox(
//                                              height: 5,
//                                            ),
//                                            Container(
//                                              width: MediaQuery.of(context)
//                                                      .size
//                                                      .width *
//                                                  0.45,
//                                              child: Text(
//                                                "Admin name removed User name from the group",
//                                                style: TextStyle(
//                                                  color: Color(secondary),
//                                                  fontSize: 13,
//                                                ),
//                                              ),
//                                            ),
//                                          ],
//                                        ),
//                                        Spacer(),
//                                        Container(
//                                          child: Text(
//                                            "Fri 21 Feb",
//                                            style: TextStyle(
//                                              color: Color(secondary),
//                                              fontSize: 12,
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                    SizedBox(
//                                      height: 5,
//                                    ),
//                                    Divider(
//                                      thickness: 1,
//                                    ),
//                                    SizedBox(
//                                      height: 5,
//                                    ),
//                                    Container(
//                                      width: MediaQuery.of(context).size.width,
//                                      child: Text(
//                                        "Request to join pending",
//                                        style: TextStyle(
//                                          color: Colors.green,
//                                          fontSize: 15,
//                                          fontWeight: FontWeight.bold,
//                                        ),
//                                      ),
//                                    ),
//                                    SizedBox(
//                                      height: 5,
//                                    ),
//                                    Container(
//                                      width: MediaQuery.of(context).size.width,
//                                      child: Text(
//                                        "Once they accept, we'll open chat for your new group",
//                                        style: TextStyle(
//                                          color: Color(secondary),
//                                          fontSize: 13,
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
                    ],
                  ),
                ),
              ),
              //**************Completed Section**********
              SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(primary),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  color: Color(bg2),
                                ),
                                child: Column(
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
                                        Text(
                                          "10, May",
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
                                              size: 20,
                                            ),
                                            Text(
                                              " 03:30 PM",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.people,
                                              color: Color(secondary),
                                              size: 20,
                                            ),
                                            Text(
                                              " 2/11",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              color: Color(secondary),
                                              size: 18,
                                            ),
                                            Text(
                                              " Address",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    Container(
                                      height: 90,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: Container(
                                                  width: 60.0,
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 0),
                                                    title: Container(
                                                      width: 43,
                                                      height: 60,
                                                      child: CircleAvatar(
                                                        foregroundColor:
                                                            Color(primary),
                                                        backgroundColor:
                                                            Color(secondary),
                                                        backgroundImage: AssetImage(
                                                            'images/bgcover.jpg'),
                                                      ),
                                                    ),
                                                    subtitle: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                        "You",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(secondary),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 43,
                                                top: 40,
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    child: Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: Container(
                                                  width: 60.0,
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 0),
                                                    title: Container(
                                                      width: 43,
                                                      height: 60,
                                                      child: CircleAvatar(
                                                        foregroundColor:
                                                            Color(primary),
                                                        backgroundColor:
                                                            Color(secondary),
                                                        backgroundImage: AssetImage(
                                                            'images/bgcover.jpg'),
                                                      ),
                                                    ),
                                                    subtitle: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                        "Abdul Quadir",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(secondary),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(primary),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  color: Color(bg2),
                                ),
                                child: Column(
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
                                        Text(
                                          "10, May",
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
                                              size: 20,
                                            ),
                                            Text(
                                              " 03:30 PM",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.people,
                                              color: Color(secondary),
                                              size: 20,
                                            ),
                                            Text(
                                              " 2/11",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              color: Color(secondary),
                                              size: 18,
                                            ),
                                            Text(
                                              " Address",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    Container(
                                      height: 90,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: Container(
                                                  width: 60.0,
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 0),
                                                    title: Container(
                                                      width: 43,
                                                      height: 60,
                                                      child: CircleAvatar(
                                                        foregroundColor:
                                                            Color(primary),
                                                        backgroundColor:
                                                            Color(secondary),
                                                        backgroundImage: AssetImage(
                                                            'images/bgcover.jpg'),
                                                      ),
                                                    ),
                                                    subtitle: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                        "You",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(secondary),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 43,
                                                top: 40,
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    child: Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: Container(
                                                  width: 60.0,
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 0),
                                                    title: Container(
                                                      width: 43,
                                                      height: 60,
                                                      child: CircleAvatar(
                                                        foregroundColor:
                                                            Color(primary),
                                                        backgroundColor:
                                                            Color(secondary),
                                                        backgroundImage: AssetImage(
                                                            'images/bgcover.jpg'),
                                                      ),
                                                    ),
                                                    subtitle: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                        "Abdul Quadir",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(secondary),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(primary),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  color: Color(bg2),
                                ),
                                child: Column(
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
                                        Text(
                                          "10, May",
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
                                              size: 20,
                                            ),
                                            Text(
                                              " 03:30 PM",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.people,
                                              color: Color(secondary),
                                              size: 20,
                                            ),
                                            Text(
                                              " 2/11",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              color: Color(secondary),
                                              size: 18,
                                            ),
                                            Text(
                                              " Address",
                                              style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    Container(
                                      height: 90,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: Container(
                                                  width: 60.0,
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 0),
                                                    title: Container(
                                                      width: 43,
                                                      height: 60,
                                                      child: CircleAvatar(
                                                        foregroundColor:
                                                            Color(primary),
                                                        backgroundColor:
                                                            Color(secondary),
                                                        backgroundImage: AssetImage(
                                                            'images/bgcover.jpg'),
                                                      ),
                                                    ),
                                                    subtitle: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                        "You",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(secondary),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 43,
                                                top: 40,
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    child: Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: Container(
                                                  width: 60.0,
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 0),
                                                    title: Container(
                                                      width: 43,
                                                      height: 60,
                                                      child: CircleAvatar(
                                                        foregroundColor:
                                                            Color(primary),
                                                        backgroundColor:
                                                            Color(secondary),
                                                        backgroundImage: AssetImage(
                                                            'images/bgcover.jpg'),
                                                      ),
                                                    ),
                                                    subtitle: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                        "Abdul Quadir",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(secondary),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
