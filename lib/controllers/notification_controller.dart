import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController instance = Get.find();

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
        //new notification
        if (message.data['notification_type'] != 'chat') {

        }
        _notificationController.notificationData.value = message;
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
            await navigateNotification(message);
          }
        });
    _notificationController.notificationData.value = message;
  }

  navigateNotification(RemoteMessage message) async {
    print('notification data ${message.data}');
    NavigateNotifications().toScreen(message.data);
  }

  void onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}
}

class NavigateNotifications {
  void toScreen(Map<String, dynamic> data) {
    if (data['notification_type'] == 'chat'){
    }
    }
}
