// import 'dart:convert';
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:resize/resize.dart';
// import 'package:santhe/controllers/error_user_fallback.dart';
// import 'package:santhe/controllers/getx/profile_controller.dart';
// import 'package:santhe/core/app_colors.dart';
// import 'package:santhe/core/app_theme.dart';
// import 'package:http/http.dart' as http;
// import 'package:santhe/core/app_url.dart';
// import 'package:santhe/models/chat_model.dart';
// import 'package:santhe/models/user_profile/customer_model.dart';
//
// import '../../controllers/chat_controller.dart';
// import '../../core/app_helpers.dart';
// import '../sent_tab_pages/sent_list_detail_page.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String chatId;
//   final String customerTitle;
//   final String merchantTitle;
//   final String listEventId;
//   const ChatScreen({Key? key, required this.chatId, required this.customerTitle, required this.listEventId, required this.merchantTitle}) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final ChatController _chatController = Get.find();
//   final profileController = Get.find<ProfileController>();
//   late final DatabaseReference _reference = FirebaseDatabase.instance.ref().child('chat');
//   CustomerModel? currentUser;
//   String message = '', token = '', merchantToken = '';
//   bool _sendMessage = true;
//   final TextEditingController _textEditingController = TextEditingController();
//
//   final tokenHandler = Get.find<ProfileController>();
//   late final bearerToken = 'Bearer ${tokenHandler.urlToken}';
//
//   @override
//   void initState() {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//         systemNavigationBarColor: Colors.white,
//         systemNavigationBarIconBrightness: Brightness.dark,
//         statusBarColor: Colors.orange));
//     _chatController.inChatScreen = true;
//     AppHelpers().getToken.then((value) => token = value);
//     currentUser = profileController.customerDetails ?? fallback_error_customer;
//     super.initState();
//   }
//
//   // final NotificationController _notificationController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           splashRadius: 0.1,
//           icon: Icon(
//             Icons.arrow_back_ios_rounded,
//             size: 13.sp,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             if(!_chatController.inOfferScreen){
//               Get.off(() => SentUserListDetailsPage(
//                 listEventId: widget.listEventId,
//                 showOffers: true,
//                 fromChat: true,
//                   ), transition: Transition.fade);
//             }
//             else{
//               Navigator.pop(context);
//             }
//           },
//         ),
//         title: Text('Offer: Rs ${widget.customerTitle}'),
//       ),
//       body: WillPopScope(
//         child: Column(
//           children: [
//             //chat with customer header
//             Container(
//               height: 62.h,
//               width: 390.w,
//               color: AppColors().grey10,
//               child: Center(
//                 child: Text('Chat with Merchant', style: AppTheme().bold700(16, color: AppColors().brandDark),),
//               ),
//             ),
//             //chat
//             Expanded(
//               child: GetBuilder<ChatController>(
//                 id: 'chatList',
//                 builder: (controller){
//                   return StreamBuilder<DatabaseEvent>(
//                       stream: _reference.child(widget.chatId).onValue,
//                       builder: (builder, snapShot){
//                         if(snapShot.hasData){
//
//                           if(snapShot.data == null || snapShot.data?.snapshot.value == null){
//                             return Center(
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 40.sp),
//                                   child: Image.asset('assets/chat_screen_start.png'),) ,
//                             );
//                           }
//
//                           List<ChatModel> messages = [];
//                           Map<dynamic, dynamic> data = snapShot.data!.snapshot.value  as Map<dynamic, dynamic>;
//                           data.forEach((key, value) {
//                             messages.add(
//                                 ChatModel(message: value['message'], isCustomer: value['isCustomer'], messageTime: DateTime.fromMillisecondsSinceEpoch(int.parse(key)).toLocal(), name: value['name'], token: value['token'] ?? '')
//                             );
//                           });
//                           messages.sort((a, b) => a.messageTime.compareTo(b.messageTime));
//                           messages = messages.reversed.toList();
//                           return ListView.builder(
//                               reverse: true,
//                               shrinkWrap: true,
//                               itemCount: messages.length,
//                               padding: EdgeInsets.symmetric(horizontal: 23.w),
//                               itemBuilder: (itemBuilder, index){
//                                 if(!messages[(messages.length - 1) - index].isCustomer){
//                                   merchantToken = messages[(messages.length - 1) - index].token;
//                                 }
//                                 return messages[index].isCustomer ? _customerChat(messages[index]) : _merchantChat(messages[index]);
//                               }
//                           );
//                         }
//
//                         if(snapShot.hasError){
//                           return Center(
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 40.sp),
//                               child: Image.asset('assets/chat_screen_start.png'),) ,
//                           );
//                         }
//
//                         return const Center(
//                           child: CircularProgressIndicator.adaptive(),
//                         );
//                       });
//                 },
//               ),
//             ),
//             //chat text box
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 //chat field
//                 SizedBox(
//                   width: 267.w,
//                   child: TextFormField(
//                     controller: _textEditingController,
//                     decoration: InputDecoration(
//                       hintText: 'Message',
//                       hintStyle: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey.shade500),
//                       focusedBorder: AppTheme().focusedBorderStyle,
//                       border: AppTheme().borderStyle,
//                       enabledBorder: AppTheme().enabledBorderStyle,
//                       errorBorder: AppTheme().errorBorderStyle,
//                     ),
//                     textInputAction: TextInputAction.done,
//                     onChanged: (String? val){
//                       message = val!;
//                       _chatController.messageIsEmpty.value = message.trim().isEmpty;
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 10.w,),
//                 //send button
//                 SizedBox(
//                     height: 55.h,
//                     width: 67.w,
//                     child: Obx(() => ElevatedButton(
//                         onPressed: _chatController.messageIsEmpty.value ? null : () async {
//                           if(_sendMessage){
//                             _sendMessage = false;
//                             _reference.child(widget.chatId).update({
//                               DateTime.now().toUtc().millisecondsSinceEpoch.toString(): {
//                                 'isCustomer' : true,
//                                 'message' : message,
//                                 'name' : currentUser!.customerName,
//                                 'token' : token
//                               }
//                             }).then((value){
//                               if(merchantToken.isNotEmpty){
//                                 sendNotification(message);
//                               }else{
//                                 sendNotificationToAll(message);
//                               }
//                               _textEditingController.clear();
//                               FocusScope.of(context).unfocus();
//                               _chatController.messageIsEmpty.value = true;
//                               _sendMessage = true;
//                             }).catchError((e){
//                               _sendMessage = true;
//                             });
//                           }
//                         },
//                         child: Image.asset('assets/send_icon.png', height: 18.h,)
//                     ))
//                 )
//               ],
//             ),
//             SizedBox(height: 20.h,)
//           ],
//         ),
//         onWillPop: () async{
//           if(!_chatController.inOfferScreen){
//             Get.off(() => SentUserListDetailsPage(
//               listEventId: widget.listEventId,
//               showOffers: true,
//               fromChat: true,
//             ));
//           }
//           else{
//             Navigator.pop(context);
//           }
//           return false;
//         },
//       ),
//     );
//   }
//
//   Widget _customerChat(ChatModel chat) => Padding(
//     padding: EdgeInsets.only(top: 30.h),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               //name
//               SizedBox(height: 7.5.h,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(chat.name, style: AppTheme().bold600(13, color: AppColors().grey80),),
//                 ],
//               ),
//               SizedBox(height: 10.h,),
//               //message text
//               Container(
//                 padding: EdgeInsets.only(left: 13.h, right: 13.h, bottom: 13.h, top: 5.h),
//                 decoration: BoxDecoration(
//                   color: AppColors().brandDark,
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Text(chat.message, style: AppTheme().normal400(13, color: AppColors().white100, height: 2.sp), ),
//               ),
//               SizedBox(height: 10.h,),
//               Text('${DateFormat('jm').format(chat.messageTime)}  ', style: AppTheme().bold600(9, color: AppColors().grey80),),
//             ],
//           ),
//         ),
//         SizedBox(width: 10.w),
//         Image.asset('assets/user_icon.png', height: 34.h,),
//       ],
//     ),
//   );
//
//   Future<void> sendNotification(String content) async {
//     var url = 'https://fcm.googleapis.com/fcm/send';
//     await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'key=${AppUrl.FCMKey}', // FCM Server key
//       },
//       body: jsonEncode(
//         <String, dynamic>{
//           "notification": <String, dynamic>{
//             "body": content,
//             "title": 'New message from customer',
//             "priority": "high",
//             "sound": "slow_spring_board.aiff",
//             "android_channel_id": "santhe_alerts"
//           },
//           //'registration_ids': ['token1', 'token2'], // Multiple id
//           'to': merchantToken, // single id
//           "direct_boot_ok": true,
//           "data": {
//             "landingScreen": 'chat',
//             'chatId': widget.chatId,
//             'title': 'Request',
//             'listEventId': widget.listEventId,
//             'customerTitle': widget.customerTitle,
//             'merchantTitle': widget.merchantTitle,
//           }
//         },
//       ),
//     );
//   }
//
//   void sendNotificationToAll(String content){
//     http.get(Uri.parse('https://us-central1-${AppUrl.envType}.cloudfunctions.net/apis/santhe/v1/app/getNotificationToken?userId=${widget.listEventId.substring(0, 10)}&userType=merchant'), headers: {
//       "authorization": bearerToken
//     }).then((value) async {
//       Map<dynamic, dynamic> pairs = jsonDecode(value.body);
//       var url = 'https://fcm.googleapis.com/fcm/send';
//       await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'key=${AppUrl.FCMKey}', // FCM Server key
//         },
//         body: jsonEncode(
//           <String, dynamic>{
//             "notification": <String, dynamic>{
//               "body": content,
//               "title": 'New message from customer',
//               "priority": "high",
//               "sound": "slow_spring_board.aiff",
//               "android_channel_id": "santhe_alerts"
//             },
//             'registration_ids': pairs['data'].values.toList(), // Multiple id
//             //'to': merchantToken, // single id
//             "direct_boot_ok": true,
//             "data": {
//               "landingScreen": 'chat',
//               'chatId': widget.chatId,
//               'title': 'Request',
//               'listEventId': widget.listEventId,
//               'customerTitle': widget.customerTitle,
//               'merchantTitle': widget.merchantTitle,
//             }
//           },
//         ),
//       );
//     });
//   }
//
//   Widget _merchantChat(ChatModel chat) => Padding(
//     padding: EdgeInsets.only(top: 30.h),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Image.asset('assets/shop_icon.png', height: 34.h,),
//         SizedBox(width: 10.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //name
//               SizedBox(height: 7.5.h,),
//               Row(
//                 children: [
//                   Text(chat.name, style: AppTheme().bold600(13, color: AppColors().grey80),),
//                 ],
//               ),
//               SizedBox(height: 10.h,),
//               //message text
//               Container(
//                 padding: EdgeInsets.only(left: 13.h, right: 13.h, bottom: 13.h, top: 5.h),
//                 decoration: BoxDecoration(
//                   color: AppColors().grey10,
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Text(chat.message, style: AppTheme().normal400(13, color: AppColors().grey100, height: 2.sp), ),
//               ),
//               SizedBox(height: 10.h,),
//               Text('${DateFormat('jm').format(chat.messageTime)}  ', style: AppTheme().bold600(9, color: AppColors().grey80),),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
//
//   @override
//   void dispose() {
//     _chatController.inChatScreen = false;
//     _chatController.messageIsEmpty.value = true;
//     super.dispose();
//   }
// }
