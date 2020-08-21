import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Animation/FadeAnimation.dart';
import '../data/chat_model.dart';
import '../common/global_colors.dart';
import '../data/User.dart';
import 'Chat_item_page.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with SingleTickerProviderStateMixin {
  List<ChatModel> list = ChatModel.list;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final user = await UserData.getUser();
    setState(() {
      email = user['email'];
      name = user['name'];
    });
  }

  bool _search = false;
  String email, name;

  Widget appbar() {
    return _search
        ? AppBar(
            leading: Align(
                alignment: Alignment.centerRight, child: Icon(Icons.search)),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => setState(() => _search = false))
            ],
            backgroundColor: Color(primary),
            title: FadeAnimation(
              0.3,
              TextField(
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                keyboardType: TextInputType.text,
                autofocus: true,
                cursorColor: Colors.white,
                cursorWidth: 2,
                decoration: InputDecoration(
                  hintText: " Search",
                  contentPadding: const EdgeInsets.only(
                    bottom: 18.0,
                    top: 18.0,
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ))
        : AppBar(
            leading: Container(),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => setState(() => _search = true))
            ],
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
            title: Center(child: Text('My Chats')));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar(),
        body: TabBarView(
          children: [
            email == null && name == null
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder(
                    stream: Firestore.instance
                        .collection('user_plans')
                        .document(email)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState ==
                              ConnectionState.waiting ||
                          !snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      List plans = snapshot.data['current_plans'];
                      if (plans.length == 0)
                        return Center(
                            child: Text('No Current Plans to show!'));
                      return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          itemCount: plans.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: Firestore.instance
                                    .collection('plan')
                                    .document(plans[index])
                                    .get(),
                                builder: (ctx,
                                    AsyncSnapshot<DocumentSnapshot>
                                        snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.connectionState ==
                                          ConnectionState.waiting)
                                    return Center(
                                        child: CircularProgressIndicator());
                                  final DocumentSnapshot planSnap =
                                      snapshot.data;
                                  return FadeAnimation(
                                    index - 8.0,
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 0),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 4),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(primary),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: ListTile(
                                          onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ChatItemPage(
                                                            planId: planSnap
                                                                    .data[
                                                                'plan_id'],
                                                            chatTitle: planSnap
                                                                    .data[
                                                                'activity_name'])),
                                              ),
                                          leading: Container(
                                            width: 55.0,
                                            height: 55.0,
                                            child: CircleAvatar(
                                              foregroundColor: Color(primary),
                                              radius: 5,
                                              backgroundColor: Colors.white,
                                              backgroundImage: planSnap.data[
                                                          'activity_logo'] !=
                                                      null
                                                  ? NetworkImage(planSnap
                                                      .data['activity_logo'])
                                                  : AssetImage(
                                                      'images/bgcover.jpg'),
                                            ),
                                          ),
                                          title: Text(
                                            planSnap.data['activity_name'],
                                            style: TextStyle(
                                              color: Color(primary),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          trailing: Container(
                                            margin:
                                                EdgeInsets.only(bottom: 30),
                                            child: FittedBox(
                                              child: Text(
                                                DateFormat('MMM d').format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        planSnap
                                                                .data[
                                                                    'activity_start']
                                                                .seconds *
                                                            1000)),
                                                style: TextStyle(
                                                  color: Color(secondary),
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                          subtitle: StreamBuilder(
                                              stream: Firestore.instance
                                                  .collection(
                                                      'group_chat/${plans[index]}/chat')
                                                  .orderBy('timestamp',
                                                      descending: true)
                                                  .limit(1)
                                                  .snapshots(),
                                              builder: (ctx, message) {
                                                if (!message.hasData ||
                                                    message.hasError)
                                                  return Container();
                                                return message.data.documents
                                                            .length ==
                                                        1
                                                    ? Row(
                                                        children: <Widget>[
                                                          message.data.documents[
                                                                          0][
                                                                      'sender_name'] ==
                                                                  name
                                                              ? Text('You:')
                                                              : Text(message
                                                                      .data
                                                                      .documents[
                                                                          0][
                                                                          'sender_name']
                                                                      .toString()
                                                                      .split(
                                                                          " ")[0] +
                                                                  ':'),
                                                          SizedBox(width: 5),
                                                          Flexible(
                                                            child: Text(
                                                              message
                                                                  .data
                                                                  .documents[
                                                                      0][
                                                                      'message_content']
                                                                  .toString()
                                                                  .split(
                                                                      "\n")[0],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : Text('Start Chatting');
                                              })),
                                    ),
                                  );
                                });
                          });
                    }),
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
    );
  }
}
