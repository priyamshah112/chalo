import 'package:chaloapp/data/Send_menu_items.dart';
import 'package:chaloapp/data/chat_item_model.dart';
import 'package:chaloapp/data/chat_model.dart';
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
  List<SendMenuItems> menuItems = SendMenuItems.list;

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
//            height: MediaQuery.of(context).size.height / 2,
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
                      return Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: ListTile(
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
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: ChatItem.length,
              reverse: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: ChatItem[index].senderId == currentUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      isFirstMessage(ChatItem, index) &&
                              ChatItem[index].senderId != currentUser
                          ? Container(
                              width: 35,
                              height: 35,
                              child: CircleAvatar(
                                foregroundColor: Color(primary),
                                backgroundColor: Color(secondary),
                                backgroundImage:
                                    AssetImage('images/bgcover.jpg'),
                              ),
                            )
                          : Container(
                              width: 35,
                              height: 35,
                            ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        margin:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(
                                isLastMessage(ChatItem, index) ? 0 : 15),
                            topLeft: Radius.circular(
                                isFirstMessage(ChatItem, index) ? 0 : 15),
                          ),
                          color: ChatItem[index].senderId == currentUser
                              ? Color(primary)
                              : Color(0xfffff3f1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${ChatItem[index].userName}",
                              style: TextStyle(
                                color: ChatItem[index].senderId == currentUser
                                    ? Colors.white
                                    : Color(primary),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "${ChatItem[index].message}",
                              style: TextStyle(
                                color: ChatItem[index].senderId == currentUser
                                    ? Colors.white
                                    : Color(secondary),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (currentChat.isTyping)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SpinKitThreeBounce(
                        color: Color(primary),
                        size: 20.0,
                      ),
                    ],
                  ),
                  Text(
                    "${currentChat.contact.name} is typing...",
                    style: TextStyle(
                      color: Color(secondary),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildInput(),
    );
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

  Widget _buildInput() {
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
            onPressed: () {
              showModal();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Color(primary),
            ),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
