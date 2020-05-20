import 'package:chaloapp/data/Send_menu_items.dart';
import 'package:chaloapp/data/User.dart';
import 'package:chaloapp/data/chat_item_model.dart';
import 'package:chaloapp/data/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'global_colors.dart';

class ChatItemPage extends StatefulWidget {
  @override
  _ChatItemPageState createState() => _ChatItemPageState();
}

class _ChatItemPageState extends State<ChatItemPage> {
  ChatModel currentChat = ChatModel.list.elementAt(0);
  String currentUser = "1";
  String pairId = "2";
  String pairId1 = "3";
  List<ChatItemModel> ChatItem = ChatItemModel.list;
  bool isMe;

  @override
  Widget build(BuildContext context) {
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
          title: Center(child: Text("${currentChat.activityName}")),
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
                    int count = messages.length;
                    return Column(children: <Widget>[
                      Expanded(
                          child: ListView.builder(
                              reverse: true,
                              itemCount: count,
                              itemBuilder: (contex, index) {
                                messages[index]['email'] == user.data['email']
                                    ? isMe = true
                                    : isMe = false;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Row(
                                    mainAxisAlignment: isMe
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 12),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight:
                                                Radius.circular(isMe ? 0 : 15),
                                            bottomLeft:
                                                Radius.circular(!isMe ? 0 : 15),
                                            topLeft: Radius.circular(15),
                                          ),
                                          color: isMe
                                              ? Color(primary)
                                              : Color(0xfffff3f1),
                                        ),
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.end,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.end,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                if (!isMe)
                                                  Text(
                                                    messages[index]['name'],
                                                    style: TextStyle(
                                                      color: isMe
                                                          ? Color(secondary)
                                                          : Color(primary),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                Text(
                                                  messages[index]['text'],
                                                  style: TextStyle(
                                                    color: isMe
                                                        ? Colors.white
                                                        : Color(secondary),
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              DateFormat('hh:mm a').format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          messages[index]
                                                                      ['time']
                                                                  .seconds *
                                                              1000)),
                                              style: TextStyle(
                                                color: isMe
                                                    ? Colors.white
                                                    : Color(secondary),
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
                                      ),
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

  isFirstMessage(List<ChatItemModel> chatItem, int index) {
    return (ChatItem[index].senderId !=
            ChatItem[index - 1 < 0 ? 0 : index - 1].senderId) ||
        index == 0;
  }

  isLastMessage(List<ChatItemModel> chatItem, int index) {
    int maxItem = ChatItem.length - 1;
    return (ChatItem[index].senderId !=
            ChatItem[index + 1 > maxItem ? maxItem : index + 1].senderId) ||
        index == maxItem;
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
    print(user);
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
      FocusScope.of(ctx).unfocus();
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
