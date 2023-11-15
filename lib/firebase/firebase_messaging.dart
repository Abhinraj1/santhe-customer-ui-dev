


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';

import '../pages/hyperlocal/hyperlocal_orderdetail/hyperlocal_orderdetail_view.dart';


class FCM{

  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // getFirebaseMessagingToken() async{
  //
  //   final fcmToken = await FirebaseMessaging.instance.getToken();

  //   // if(merchantModel.customer != null) {
  //   //   merchantModel.customer!.fbiid = fcmToken.toString();
  //   // }
  //   // if(merchantModel.customer == null){
  //   //   merchantModel.customer = Customer(
  //   //       fbiid: fcmToken.toString()
  //   //   );
  //   // }
  //
  // }

  firebaseMessageInit() async{

    messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

   // const androidSetting = AndroidInitializationSettings('mipmap');


    NotificationSettings settings = await messaging.getNotificationSettings();


   if(settings.authorizationStatus == AuthorizationStatus.authorized){
     messaging.getNotificationSettings();
    }else{
     settings = await messaging.requestPermission(
       alert: true,
       announcement: false,
       badge: true,
       carPlay: false,
       criticalAlert: false,
       provisional: false,
       sound: true,
     );
   }
    //await FirebaseMessaging.instance.setDeliveryMetricsExportToBigQuery(true);


    _notificationsInIt();
    setupInteractedMessage();

  }

  Future<void> setupInteractedMessage() async {

    RemoteMessage? initialMessage =
    await messaging.getInitialMessage();

    print("INITIAL MESSSAGE ======== $initialMessage");

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleMessage);

  }

  void _handleMessage(RemoteMessage message) {

    if(message.data["type"] == "customer_order"){

      if(Get.currentRoute.toString().contains("HyperlocalOrderdetailView")){
          Get.close(1);
      }
      Get.to(()=>HyperlocalOrderdetailView(
        orderId: message.data["orderId"].toString() != "null" &&
            message.data["orderId"] != "" ?
        message.data["orderId"].toString() : "",
       // storeDescriptionId: '',
      ));

    }
  }


  _notificationsInIt(){

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: darwinInitializationSettings
        );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        "notifications", "Notifications",
    description: "THIS IS THE DESCRIPTION",
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
    ledColor: Color(0xFFF89522));

    _createChannel(channel);

    localNotificationsPlugin.initialize(initializationSettings);

    listen(channel);
  }

  _createChannel(AndroidNotificationChannel channel)async{

    final FlutterLocalNotificationsPlugin plugin =
        FlutterLocalNotificationsPlugin();

    await plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>() ?.
    createNotificationChannel(channel);

  }


  listen(AndroidNotificationChannel channel){

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {

        final notification = message.notification;

        localNotificationsPlugin.show(
            notification.hashCode,
            notification!.title.toString(),
            notification.body.toString(),
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  colorized: true,
                    styleInformation: const BigTextStyleInformation(''),
                  channelDescription: channel.description,
                  sound: const RawResourceAndroidNotificationSound('slow_spring_board'),
                  playSound: true,
                  color: AppColors().brandDark,
                  icon: "@mipmap/ic_launcher"
                )
            ));

        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}


