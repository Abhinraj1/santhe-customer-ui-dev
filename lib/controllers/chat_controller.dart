import 'package:get/get.dart';
import 'package:santhe/Models/chat_model.dart';

class ChatController extends GetxController{
  RxBool messageIsEmpty = true.obs;

  bool inChatScreen = false;

  bool inOfferScreen = false;

  List<ChatModel> currentChat = [];
}