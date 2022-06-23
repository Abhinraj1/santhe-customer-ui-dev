import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:santhe/pages/home_page.dart';

import '../pages/chat/chat_screen.dart';
import 'chat_controller.dart';

class NotificationController extends GetxController {
  static NotificationController instance = Get.find();
  bool fromNotification = false;
  String landingScreen = 'new';
  Rx<RemoteMessage> notificationData = const RemoteMessage().obs;
}

class Notifications {
  late AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final NotificationController _notificationController =
      NotificationController.instance;

  fcmInit() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        _notificationController.notificationData.value = message;
        _notificationController.fromNotification = true;
        await navigateNotification(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      //new notification
      if (message.data['notification_type'] != 'chat') {

      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: '@mipmap/ic_launcher',
                styleInformation: const BigTextStyleInformation(''),
              ),
              iOS: const IOSNotificationDetails()),
        );
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

        IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
          onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
              ) async {

          },
        );

        InitializationSettings initializationSettings = InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

        await flutterLocalNotificationsPlugin.initialize(initializationSettings,
            onSelectNotification: (String? payload) async {
              if (payload != null) {
                await navigateNotification(message);
              }
            });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      _notificationController.notificationData.value = message;
      await navigateNotification(message);
    });
  }

  Future<void> initialiseNotificationChannel(RemoteMessage message) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
          ) async {},
    );

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            _notificationController.fromNotification = true;
            await navigateNotification(message);
          }
        });
    _notificationController.notificationData.value = message;
  }

  navigateNotification(RemoteMessage message) async {
    NavigateNotifications().toScreen(message.data);
  }

  void onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}
}

class NavigateNotifications {
  final NotificationController _notificationController = NotificationController.instance;
  final ChatController _chatController = Get.find();
  void toScreen(Map<String, dynamic> data) {
    if (data['screen'] == 'new'){
      _notificationController.landingScreen = 'new';
      if(!_notificationController.fromNotification){
        Get.offAll(const HomePage(pageIndex: 0));
      }
    }
    if (data['screen'] == 'answered'){
      _notificationController.landingScreen = 'answered';
      if(!_notificationController.fromNotification){
        Get.offAll(const HomePage(pageIndex: 1));
      }
    }
    if(data['landingScreen'] == 'chat'){
      _notificationController.landingScreen = 'chat';
      if((!_chatController.inChatScreen && !_notificationController.fromNotification) || (_chatController.inOfferScreen && _notificationController.fromNotification)) {
        Get.to(ChatScreen(chatId: data['chatId'], customerTitle: data['customerTitle'], listEventId: data['listEventId'], merchantTitle: data['merchantTitle'],));
      }
    }
  }
}
