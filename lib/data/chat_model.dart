import '../data/contact_model.dart';

class ChatModel {
  final bool isTyping;
  final bool isRemoved;
  final bool isPending;
  final String activityName;
  final String activityDate;
  final String lastMessage;
  final String lastMessageTime;
  final ContactModel contact;

  ChatModel({
    this.isRemoved,
    this.isPending,
    this.isTyping,
    this.activityName,
    this.activityDate,
    this.lastMessage,
    this.lastMessageTime,
    this.contact,
  });

  static List<ChatModel> list = [
    ChatModel(
      isTyping: true,
      isPending: false,
      isRemoved: false,
      activityName: "Hiking",
      activityDate: "Fri 21 Feb",
      lastMessage: "hello!",
      lastMessageTime: "2d",
      contact: ContactModel(name: "Abdul Quadir"),
    ),
    ChatModel(
      isTyping: false,
      isPending: true,
      isRemoved: false,
      activityName: "BBQ Beach",
      activityDate: "Fri 23 Feb",
      lastMessage: "q",
      lastMessageTime: "",
      contact: ContactModel(name: "Ali Asgar"),
    ),
    ChatModel(
      isTyping: false,
      isPending: false,
      isRemoved: true,
      activityName: "Biking",
      activityDate: "Mon 28 Jan",
      lastMessage: "Abdul Quadir removed you from the group",
      lastMessageTime: "q",
      contact: ContactModel(name: "Sohil Luhar"),
    ),
    ChatModel(
      isTyping: false,
      isPending: false,
      isRemoved: false,
      activityName: "Hiking with Dog",
      activityDate: "Mon 28 Jan",
      lastMessage: "Hello",
      lastMessageTime: "",
      contact: ContactModel(name: "Jumaid Khatri"),
    ),
    ChatModel(
      isTyping: false,
      isPending: false,
      isRemoved: false,
      activityName: "Fishing",
      activityDate: "Mon 28 Jan",
      lastMessage: "Bring Fishig Rod",
      lastMessageTime: "",
      contact: ContactModel(name: "Mohammad Athania"),
    ),
  ];
}
