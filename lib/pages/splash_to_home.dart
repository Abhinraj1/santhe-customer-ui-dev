import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:santhe/pages/map_merch.dart';
import '../controllers/connectivity_controller.dart';
import '../controllers/notification_controller.dart';
import '../core/app_initialisations.dart';
import 'chat/chat_screen.dart';
import 'home_page.dart';
import 'login_pages/phone_number_login_page.dart';
import 'onboarding_page.dart';

class SplashToHome extends StatefulWidget {
  const SplashToHome({Key? key}) : super(key: key);

  @override
  State<SplashToHome> createState() => _SplashToHomeState();
}

class _SplashToHomeState extends State<SplashToHome> {
  Future<void> bootHome() async {
    await AppInitialisations().initialiseApplication();
    await Notifications().fcmInit();
    final ConnectivityController connectivityController = Get.find();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityController.listenConnectivity(result);
    });
    Future.delayed(const Duration(milliseconds: 4000), () {
      connectivityController.checkConnectivityAndMoveInitialPage();
    });
  }

  Widget getLandingScreen() {
    final NotificationController notificationController = Get.find();
    if (notificationController.fromNotification) {
      //_notificationController.fromNotification = false;
      if (notificationController.landingScreen == 'new') {
        return const MapMerchant();
      } else if (notificationController.landingScreen == 'answered') {
        return HomePage(
          pageIndex: 1,
          showMap: false,
        );
      } else {
        return ChatScreen(
          chatId: notificationController.notificationData.value.data['chatId'],
          customerTitle: notificationController
              .notificationData.value.data['customerTitle'],
          merchantTitle: notificationController
              .notificationData.value.data['merchantTitle'],
          listEventId:
              notificationController.notificationData.value.data['listEventId'],
        );
      }
    }
    return const MapMerchant();
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.orange,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.orange,
      statusBarBrightness: Brightness.dark,
    ));
    bootHome();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child:
            Image.asset('assets/app_splash_anim.gif', gaplessPlayback: false),
      ),
    );
  }
}
