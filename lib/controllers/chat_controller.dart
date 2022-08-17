import 'package:get/get.dart';

class ChatController extends GetxController{
  RxBool messageIsEmpty = true.obs;

  bool inChatScreen = false;

  bool inOfferScreen = false;
}