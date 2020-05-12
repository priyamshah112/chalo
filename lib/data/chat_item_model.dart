class ChatItemModel {
  final String senderId;
  final String message;
  final String userName;

  ChatItemModel({this.senderId, this.message, this.userName});

  static List<ChatItemModel> list = [
    ChatItemModel(
      userName: "Sohil Luhar",
      senderId: "1",
      message: "Hi Abdul!, do you have already reported?",
    ),
    ChatItemModel(
      userName: "Sohil Luhar",
      senderId: "1",
      message: "Sure we can talk Tomorrow",
    ),
    ChatItemModel(
      userName: "Sohil Luhar",
      senderId: "1",
      message: "Hi Abdul",
    ),
    ChatItemModel(
      userName: "Abdul Quadir",
      senderId: "2",
      message: "I'd like to discuss about reports for kate",
    ),
    ChatItemModel(
      userName: "Abdul Quadir",
      senderId: "2",
      message: "Are you availabe tomorrow at 3PM ?",
    ),
    ChatItemModel(
      userName: "Abdul Quadir",
      senderId: "2",
      message: "Hi Sohil",
    ),
    ChatItemModel(
      userName: "Ali Asgar",
      senderId: "3",
      message: "I'd like to discuss about reports for kate",
    ),
    ChatItemModel(
      userName: "Ali Asgar",
      senderId: "3",
      message: "Are you availabe tomorrow at 3PM ?",
    ),
    ChatItemModel(
      userName: "Ali Asgar",
      senderId: "3",
      message: "Hi Sohil",
    ),
  ];
}
