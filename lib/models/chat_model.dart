class ChatModel{

  String message;
  bool isCustomer;
  String name;
  DateTime messageTime;
  String token;

  ChatModel({
    required this.message,
    required this.isCustomer,
    required this.messageTime,
    required this.name,
    required this.token,
  });
}