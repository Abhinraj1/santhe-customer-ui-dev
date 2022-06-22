import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/models/offer/customer_offer_response.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:santhe/pages/sent_tab_pages/offers_list_page.dart';

import '../../Models/chat_model.dart';
import '../../controllers/boxes_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../core/app_helpers.dart';
import '../../models/santhe_user_model.dart';
import '../../widgets/sent_tab_widgets/merchant_offer_card.dart';
import '../sent_tab_pages/sent_list_detail_page.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String title;
  final String listEventId;
  const ChatScreen({Key? key, required this.chatId, required this.title, required this.listEventId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late final DatabaseReference _reference = FirebaseDatabase.instance.ref().child('chat');
  final ChatController _chatController = Get.find();
  User currentUser = Boxes.getUser().get('currentUserDetails')!;
  String message = '', token = '', merchantToken = '';
  bool _sendMessage = true;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.orange));
    _chatController.inChatScreen = true;
    AppHelpers().getToken.then((value) => token = value);
    super.initState();
  }

  final NotificationController _notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 0.1,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 13.sp,
            color: Colors.white,
          ),
          onPressed: () {
            if(!_chatController.inOfferScreen){
              Get.off(() => SentUserListDetailsPage(
                listEventId: widget.listEventId,
                showOffers: true,
                fromChat: true,
                  ));
            }
            else{
              Navigator.pop(context);
            }
          },
        ),
        title: Text('Offers: Rs ' + widget.title),
      ),
      body: WillPopScope(
        child: Column(
          children: [
            //chat with customer header
            Container(
              height: 62.h,
              width: 390.w,
              color: AppColors().grey10,
              child: Center(
                child: Text('Chat with Merchant', style: AppTheme().bold700(16, color: AppColors().brandDark),),
              ),
            ),
            //chat
            Expanded(
              child: GetBuilder<ChatController>(
                id: 'chatList',
                builder: (controller){
                  return StreamBuilder<DatabaseEvent>(
                      stream: _reference.child(widget.chatId).onValue,
                      builder: (builder, snapShot){
                        if(snapShot.hasData){

                          if(snapShot.data == null || snapShot.data?.snapshot.value == null){
                            return const Center(
                              child: Text('start a new chat'),
                            );
                          }

                          List<ChatModel> _messages = [];
                          Map<dynamic, dynamic> _data = snapShot.data!.snapshot.value  as Map<dynamic, dynamic>;
                          _data.forEach((key, value) {
                            _messages.add(
                                ChatModel(message: value['message'], isCustomer: value['isCustomer'], messageTime: DateTime.fromMillisecondsSinceEpoch(int.parse(key)).toLocal(), name: value['name'], token: value['token'] ?? '')
                            );
                          });
                          _messages.sort((a, b) => a.messageTime.compareTo(b.messageTime));
                          _messages = _messages.reversed.toList();
                          return ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: _messages.length,
                              padding: EdgeInsets.symmetric(horizontal: 23.w),
                              itemBuilder: (itemBuilder, index){
                                if(!_messages[(_messages.length - 1) - index].isCustomer){
                                  merchantToken = _messages[(_messages.length - 1) - index].token;
                                }
                                return _messages[index].isCustomer ? _customerChat(_messages[index]) : _merchantChat(_messages[index]);
                              }
                          );
                        }

                        if(snapShot.hasError){
                          return const SizedBox();
                        }

                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      });
                },
              ),
            ),
            //chat text box
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //chat field
                SizedBox(
                  width: 267.w,
                  child: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500),
                      focusedBorder: AppTheme().focusedBorderStyle,
                      border: AppTheme().borderStyle,
                      enabledBorder: AppTheme().enabledBorderStyle,
                      errorBorder: AppTheme().errorBorderStyle,
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (String? val){
                      message = val!;
                      _chatController.messageIsEmpty.value = message.trim().isEmpty;
                    },
                  ),
                ),
                SizedBox(width: 10.w,),
                //send button
                SizedBox(
                    height: 55.h,
                    width: 67.w,
                    child: Obx(() => ElevatedButton(
                        onPressed: _chatController.messageIsEmpty.value ? null : () async {
                          /*var url = 'https://fcm.googleapis.com/fcm/send';
                        await http.post(
                          Uri.parse(url),
                          headers: <String, String>{
                            'Content-Type': 'application/json',
                            'Authorization': 'key=AAAAZ54wd8s:APA91bEsDji0lceBsyQ2Dm_c1eerM0N6-Vle3k83ZGH8Q8cKOY-0CGh7aJHC5iMrkxUVurSoUS_WAv4Qez9BHRSAHKgUcDeEuKVX5CevL03KAEpChNCgjz8-mInRCnQXJjORuMUZMbhF', // FCM Server key
                          },
                          body: jsonEncode(
                            <String, dynamic>{
                              "notification": <String, dynamic>{
                                "body": 'title',
                                "title": 'New message from customer',
                              },
                              //'registration_ids': ['token1', 'token2'], // Multiple id
                              'to': 'cLL3-6Y9fEqwhbTum1Sxs3:APA91bEv37mliXz7H1n8R4q7_Bk3BUxBVtoo1Fj2Npc3u64IoKfN3u1n64kJcgfR7H0pi0nkC95ktaCtn7k3yiKls1uhSpjkw_eE2ZVbrqq_tN2qewAWDcPf_GECL6mXrU61k52Icmiz', // single id
                              "direct_boot_ok": true,
                              "data": {
                                "landingScreen": 'chat',
                                'chatId': widget.chatId,
                                'title': 'Offers: Rs ' + widget.title// page navigation arguments
                              }
                            },
                          ),
                        );*/
                          if(_sendMessage){
                            _sendMessage = false;
                            _reference.child(widget.chatId).update({
                              DateTime.now().toUtc().millisecondsSinceEpoch.toString(): {
                                'isCustomer' : true,
                                'message' : message,
                                'name' : currentUser.custName,
                                'token' : token
                              }
                            }).then((value){
                              if(merchantToken.isNotEmpty){
                                sendNotification(message);
                              }else{
                                sendNotificationToAll(message);
                              }
                              _textEditingController.clear();
                              FocusScope.of(context).unfocus();
                              _chatController.messageIsEmpty.value = true;
                              _sendMessage = true;
                            }).catchError((e){
                              _sendMessage = true;
                            });
                          }
                        },
                        child: Image.asset('assets/send_icon.png', height: 18.h,)
                    ))
                )
              ],
            ),
            SizedBox(height: 20.h,)
          ],
        ),
        onWillPop: () async{
          if(!_chatController.inOfferScreen){
            Get.off(() => SentUserListDetailsPage(
              listEventId: widget.listEventId,
              showOffers: true,
              fromChat: true,
            ));
          }
          else{
            Navigator.pop(context);
          }
          return false;
        },
      ),
    );
  }

  Widget _customerChat(ChatModel chat) => Padding(
    padding: EdgeInsets.only(top: 30.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //name
              SizedBox(height: 7.5.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(chat.name, style: AppTheme().bold600(13, color: AppColors().grey80),),
                ],
              ),
              SizedBox(height: 10.h,),
              //message text
              Container(
                padding: EdgeInsets.only(left: 13.h, right: 13.h, bottom: 13.h, top: 5.h),
                decoration: BoxDecoration(
                  color: AppColors().brandDark,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(chat.message, style: AppTheme().normal400(13, color: AppColors().white100, height: 2.sp), ),
              ),
              SizedBox(height: 10.h,),
              Text(DateFormat('jm').format(chat.messageTime) + '  ', style: AppTheme().bold600(9, color: AppColors().grey80),),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Image.asset('assets/user_icon.png', height: 34.h,),
      ],
    ),
  );

  Future<void> sendNotification(String content) async {
    var url = 'https://fcm.googleapis.com/fcm/send';
    await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAZ54wd8s:APA91bEsDji0lceBsyQ2Dm_c1eerM0N6-Vle3k83ZGH8Q8cKOY-0CGh7aJHC5iMrkxUVurSoUS_WAv4Qez9BHRSAHKgUcDeEuKVX5CevL03KAEpChNCgjz8-mInRCnQXJjORuMUZMbhF', // FCM Server key
      },
      body: jsonEncode(
        <String, dynamic>{
          "notification": <String, dynamic>{
            "body": content,
            "title": 'New message from customer',
          },
          //'registration_ids': ['token1', 'token2'], // Multiple id
          'to': merchantToken, // single id
          "direct_boot_ok": true,
          "data": {
            "landingScreen": 'chat',
            'chatId': widget.chatId,
            'title': 'Offers: Rs ' + widget.title,
            'listEventId': widget.listEventId,
          }
        },
      ),
    );
  }

  void sendNotificationToAll(String content){
    http.get(Uri.parse('https://us-central1-santhe-425a8.cloudfunctions.net/apis/santhe/v1/app/getNotificationToken?userId=${widget.listEventId.substring(0, 10)}&userType=merchant')).then((value) async {
      Map<dynamic, dynamic> _pairs = jsonDecode(value.body);
      print(_pairs['data'].values);
      var url = 'https://fcm.googleapis.com/fcm/send';
      await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAZ54wd8s:APA91bEsDji0lceBsyQ2Dm_c1eerM0N6-Vle3k83ZGH8Q8cKOY-0CGh7aJHC5iMrkxUVurSoUS_WAv4Qez9BHRSAHKgUcDeEuKVX5CevL03KAEpChNCgjz8-mInRCnQXJjORuMUZMbhF', // FCM Server key
        },
        body: jsonEncode(
          <String, dynamic>{
            "notification": <String, dynamic>{
              "body": content,
              "title": 'New message from customer',
            },
            'registration_ids': _pairs['data'].values.toList(), // Multiple id
            //'to': merchantToken, // single id
            "direct_boot_ok": true,
            "data": {
              "landingScreen": 'chat',
              'chatId': widget.chatId,
              'title': 'Request',
              'listEventId': widget.listEventId,
              'customerTitle': 'Offers: Rs ' + widget.title
            }
          },
        ),
      );
    });
  }

  Widget _merchantChat(ChatModel chat) => Padding(
    padding: EdgeInsets.only(top: 30.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/shop_icon.png', height: 34.h,),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //name
              SizedBox(height: 7.5.h,),
              Row(
                children: [
                  Text(chat.name, style: AppTheme().bold600(13, color: AppColors().grey80),),
                ],
              ),
              SizedBox(height: 10.h,),
              //message text
              Container(
                padding: EdgeInsets.only(left: 13.h, right: 13.h, bottom: 13.h, top: 5.h),
                decoration: BoxDecoration(
                  color: AppColors().grey10,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(chat.message, style: AppTheme().normal400(13, color: AppColors().grey100, height: 2.sp), ),
              ),
              SizedBox(height: 10.h,),
              Text(DateFormat('jm').format(chat.messageTime) + '  ', style: AppTheme().bold600(9, color: AppColors().grey80),),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  void dispose() {
    _chatController.inChatScreen = false;
    _chatController.messageIsEmpty.value = true;
    super.dispose();
  }
}
