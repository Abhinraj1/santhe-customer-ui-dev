// import 'dart:developer';
// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'
//     as noti;
// import 'package:get/get.dart';
// import 'package:santhe/core/loggers.dart';
// import 'package:santhe/pages/home_page.dart';
// import 'package:santhe/pages/map_merch.dart';
//
// import '../pages/chat/chat_screen.dart';
// import 'chat_controller.dart';
//
// class NotificationController extends GetxController {
//   static NotificationController instance = Get.find();
//   bool fromNotification = false;
//   String landingScreen = 'new';
//   Rx<RemoteMessage> notificationData = const RemoteMessage().obs;
// }
//
// class Notifications with LogMixin {
//   late noti.AndroidNotificationChannel channel =
//       const noti.AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     importance: noti.Importance.max,
//   );
//
//   late noti.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       noti.FlutterLocalNotificationsPlugin();
//
//   final NotificationController _notificationController =
//       NotificationController.instance;
//
//   //! Custom Android NOtification Channel creation
//   final MethodChannel _channel =
//       const MethodChannel('com.santhe.customer/channel_alert');
//
//   Map<String, String> channelMap = {
//     "id": "santhe_alerts",
//     "name": "Alerts",
//     "description": "Alert notifications",
//   };
//
//   void _createNewChannel() async {
//     try {
//       await _channel.invokeMethod('createNotificationChannel', channelMap);
//       log('custom channel created $channelMap');
//     } on PlatformException catch (e) {
//       // _statusText = _error;
//       print(e);
//     }
//   }
//
//   //! END
//
//   fcmInit() async {
//     if (Platform.isAndroid) {
//       _createNewChannel();
//     }
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) async {
//       if (message != null) {
//         //new notification
//         warningLog('checking for notification message$message');
//         _notificationController.notificationData.value = message;
//         _notificationController.fromNotification = true;
//         await navigateNotification(message);
//       }
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       //new notification
//       if (message.data['notification_type'] != 'chat') {}
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         warningLog('notification of $notification');
//         _showNotificationCustomSound(notification);
//         /*flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 icon: '@mipmap/ic_launcher',
//                 importance: Importance.max,
//                 priority: Priority.max,
//                 sound: const RawResourceAndroidNotificationSound('subtle'),
//                 //playSound: true,
//                 styleInformation: const BigTextStyleInformation(''),
//               ),
//               iOS: const IOSNotificationDetails()),
//         );*/
//         await flutterLocalNotificationsPlugin
//             .resolvePlatformSpecificImplementation<
//                 noti.AndroidFlutterLocalNotificationsPlugin>()
//             ?.createNotificationChannel(channel);
//
//         await FirebaseMessaging.instance
//             .setForegroundNotificationPresentationOptions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//
//         const noti.AndroidInitializationSettings initializationSettingsAndroid =
//             noti.AndroidInitializationSettings('@mipmap/ic_launcher');
//
//         noti.DarwinInitializationSettings initializationSettingsIOS =
//             noti.DarwinInitializationSettings(
//           requestSoundPermission: true,
//           requestBadgePermission: true,
//           requestAlertPermission: true,
//           defaultPresentAlert: true,
//           defaultPresentBadge: true,
//           defaultPresentSound: true,
//           onDidReceiveLocalNotification: (
//             int id,
//             String? title,
//             String? body,
//             String? payload,
//           ) async {},
//         );
//
//         noti.InitializationSettings initializationSettings =
//             noti.InitializationSettings(
//                 android: initializationSettingsAndroid,
//                 iOS: initializationSettingsIOS);
//
//         await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//             onDidReceiveNotificationResponse: (payload) async {
//           if (payload != null) {
//             warningLog('payload $payload');
//             await navigateNotification(message);
//           }
//         });
//       }
//     });
//
//     FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//         alert: true, badge: true, sound: true);
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       _notificationController.notificationData.value = message;
//       await navigateNotification(message);
//     });
//   }
//
//   Future<void> _showNotificationCustomSound(
//       RemoteNotification notification) async {
//     const noti.AndroidNotificationDetails androidPlatformChannelSpecifics =
//         noti.AndroidNotificationDetails(
//       'your other channel id',
//       'your other channel name',
//       icon: '@mipmap/ic_launcher',
//       importance: noti.Importance.max,
//       priority: noti.Priority.max,
//       sound: noti.RawResourceAndroidNotificationSound('slow_spring_board'),
//       //playSound: true,
//     );
//     const noti.DarwinNotificationDetails iOSPlatformChannelSpecifics =
//         noti.DarwinNotificationDetails(
//             sound: 'slow_spring_board.aiff', presentSound: true);
//     const noti.NotificationDetails platformChannelSpecifics =
//         noti.NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       notification.title,
//       notification.body,
//       platformChannelSpecifics,
//     );
//   }
//
//   Future<void> initialiseNotificationChannel(RemoteMessage message) async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             noti.AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     const noti.AndroidInitializationSettings initializationSettingsAndroid =
//         noti.AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     noti.DarwinInitializationSettings initializationSettingsIOS =
//         noti.DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//       defaultPresentAlert: true,
//       defaultPresentBadge: true,
//       defaultPresentSound: true,
//       onDidReceiveLocalNotification: (
//         int id,
//         String? title,
//         String? body,
//         String? payload,
//       ) async {},
//     );
//
//     noti.InitializationSettings initializationSettings =
//         noti.InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (payload) async {
//       if (payload != null) {
//         _notificationController.fromNotification = true;
//         await navigateNotification(message);
//       }
//     });
//     _notificationController.notificationData.value = message;
//   }
//
//   navigateNotification(RemoteMessage message) async {
//     NavigateNotifications().toScreen(message.data);
//   }
//
//   void onDidReceiveLocalNotification(
//       int id, String title, String body, String payload) async {}
// }
//
// class NavigateNotifications {
//   final NotificationController _notificationController =
//       NotificationController.instance;
//   final ChatController _chatController = Get.find();
//   void toScreen(Map<String, dynamic> data) {
//     if (data['screen'] == 'new') {
//       _notificationController.landingScreen = 'new';
//       if (!_notificationController.fromNotification) {
//         Get.offAll(
//           const MapMerchant(),
//         );
//       }
//     }
//     if (data['screen'] == 'answered') {
//       _notificationController.landingScreen = 'answered';
//       if (!_notificationController.fromNotification) {
//         Get.offAll(HomePage(
//           pageIndex: 1,
//           showMap: false,
//         ));
//       }
//     }
//     if (data['landingScreen'] == 'chat') {
//       log(data.toString());
//       _notificationController.landingScreen = 'chat';
//       if ((!_chatController.inChatScreen &&
//               !_notificationController.fromNotification) ||
//           (_chatController.inOfferScreen &&
//               _notificationController.fromNotification)) {
//         Get.to(ChatScreen(
//           chatId: data['chatId'],
//           customerTitle: data['customerTitle'],
//           listEventId: data['listEventId'],
//           merchantTitle: data['merchantTitle'],
//         ));
//       }
//     }
//   }
// }
