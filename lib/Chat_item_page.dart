import 'package:chaloapp/data/Send_menu_items.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/data/chat_item_model.dart';
import 'package:chaloapp/data/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:steel_crypt/PointyCastleN/src/ufixnum.dart';

import 'global_colors.dart';

class ChatItemPage extends StatefulWidget {
  @override
  _ChatItemPageState createState() => _ChatItemPageState();
}

class _ChatItemPageState extends State<ChatItemPage> {
  bool isMe;

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        return;
      },
      onResume: (msg) {
        print(msg);
        return;
      },
    );
    fbm.subscribeToTopic('chat');
  }

  int difference = 0;
  bool displayDate(Timestamp time) {
    DateTime changedDate =
        DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000);
    int diff = DateTime.now().day - changedDate.day;
    if (diff > difference) {
      difference = diff;
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    difference = 0;
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor: Color(primary),
          centerTitle: true,
          title: Center(child: Text("Hiking")),
        ),
        body: FutureBuilder(
            future: UserData.getUser(),
            builder: (context, user) {
              if (!user.hasData)
                return Center(child: CircularProgressIndicator());
              return StreamBuilder(
                  stream: Firestore.instance
                      .collection('group_chat')
                      .document('chatDoc')
                      .collection('chat')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    List<DocumentSnapshot> messages = snapshot.data.documents;
                    int msgs = messages.length;
                    return Column(children: <Widget>[
                      Expanded(
                          child: ListView.builder(
                              reverse: true,
                              itemCount: msgs,
                              itemBuilder: (contex, index) {
                                messages[index]['email'] == user.data['email']
                                    ? isMe = true
                                    : isMe = false;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Column(
                                    children: <Widget>[
                                      if (index == msgs - 1)
                                        MessageDate(
                                            messages: messages, index: index),
                                      ChatBubble(
                                        isMe: isMe,
                                        content: messages[index]['text'],
                                        name: messages[index]['name'],
                                        timestamp: messages[index]['time'],
                                      ),
                                      if (displayDate(messages[index]['time']))
                                        MessageDate(
                                            messages: messages,
                                            index: index - 1),
                                    ],
                                  ),
                                );
                              })),
                      SizedBox(height: 10),
                      MessageInput()
                    ]);
                  });
            }));
  }

//   isFirstMessage(List<ChatItemModel> chatItem, int index) {
//     return (ChatItem[index].senderId !=
//             ChatItem[index - 1 < 0 ? 0 : index - 1].senderId) ||
//         index == 0;
//   }

//   isLastMessage(List<ChatItemModel> chatItem, int index) {
//     int maxItem = ChatItem.length - 1;
//     return (ChatItem[index].senderId !=
//             ChatItem[index + 1 > maxItem ? maxItem : index + 1].senderId) ||
//         index == maxItem;
//   }
}

class ChatBubble extends StatefulWidget {
  const ChatBubble(
      {Key key,
      @required this.isMe,
      @required this.content,
      @required this.name,
      @required this.timestamp})
      : super(key: key);

  final bool isMe;
  final String content, name;
  final Timestamp timestamp;

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool delete = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onLongPress: () {
            print('pressed');
            setState(() => delete = !delete);
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(widget.isMe ? 0 : 15),
                bottomLeft: Radius.circular(!widget.isMe ? 0 : 15),
                topLeft: Radius.circular(15),
              ),
              color: widget.isMe ? Color(primary) : Color(0xfffff3f1),
            ),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (!widget.isMe)
                      Text(
                        widget.name,
                        style: TextStyle(
                          color:
                              widget.isMe ? Color(secondary) : Color(primary),
                          fontSize: 16,
                        ),
                      ),
                    Text(
                      widget.content,
                      style: TextStyle(
                        color: widget.isMe ? Colors.white : Color(secondary),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Text(
                  DateFormat('hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.timestamp.seconds * 1000)),
                  style: TextStyle(
                    color: widget.isMe ? Colors.white : Color(secondary),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MessageDate extends StatefulWidget {
  MessageDate({Key key, @required this.messages, @required this.index})
      : super(key: key);
  final List<DocumentSnapshot> messages;
  final int index;

  @override
  _MessageDateState createState() => _MessageDateState();
}

class _MessageDateState extends State<MessageDate> {
  @override
  Widget build(BuildContext context) {
    return widget.index < widget.messages.length
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              DateFormat('MMM d, yyyy').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      widget.messages[widget.index]['time'].seconds * 1000)),
              style: TextStyle(
                color: Color(secondary),
                fontSize: 12,
              ),
            ),
          )
        : Container();
  }
}

class MessageInput extends StatefulWidget {
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _empty = true;
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(form1),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: false,
              onChanged: (value) {
                if (value.isEmpty)
                  setState(() => _empty = true);
                else
                  setState(() => _empty = false);
              },
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Type something...",
                hintStyle: TextStyle(
                  color: Color(formHint),
                ),
              ),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.add,
                color: Color(primary),
              ),
              onPressed: () => showModal(context)),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _empty ? Colors.grey : Color(primary),
            ),
            onPressed: () => _empty ? null : _send(context),
          ),
        ],
      ),
    );
  }

  void _send(BuildContext ctx) async {
    print('sending');
    final user = await UserData.getUser();
    print(_controller.text);
    try {
      final doc = await Firestore.instance
          .collection('group_chat')
          .document('chatDoc')
          .collection('chat')
          .add({
        'text': _controller.text,
        'name': user['name'],
        'email': user['email'],
        'time': Timestamp.fromDate(DateTime.now())
      });
      print('sent ${doc.documentID}');
      _controller.clear();
      setState(() => _empty = true);
    } catch (e) {
      print('error: $e');
    }
  }

  void showModal(BuildContext context) {
    List<SendMenuItems> menuItems = SendMenuItems.list;
    print(menuItems);
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) {
          return Container(
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.only(top: 10),
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: menuItems[index].colors.shade50,
                          ),
                          height: 40,
                          width: 40,
                          child: Icon(
                            menuItems[index].icon,
                            size: 20,
                            color: menuItems[index].colors.shade400,
                          ),
                        ),
                        title: Text(menuItems[index].text),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
