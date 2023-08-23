import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/controllers/home_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/pages/map_merch.dart';
import '../controllers/connectivity_controller.dart';
import '../controllers/notification_controller.dart';
import 'package:flutter/services.dart' as sv;
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

class _SplashToHomeState extends State<SplashToHome>
    with LogMixin, TickerProviderStateMixin {
  // final AllListController _allListController = Get.find();
  // final ProfileController _profileController = Get.find();
  // final HomeController _homeController = Get.find();
  // final NotificationController _notificationController = Get.find();
  // final APIs apiController = Get.find();
  Future<void> bootHome() async {
    await AppInitialisations().initialiseApplication();
   // await Notifications().fcmInit();
    final ConnectivityController connectivityController = Get.find();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityController.listenConnectivity(result);
    });
    Future.delayed(const Duration(milliseconds: 4000), () {
      connectivityController.checkConnectivityAndMoveInitialPage();
    });
  }

  // Widget getLandingScreen() {
  //   _intialiseToken();
  //   AppHelpers().generateToken();
  // //  final NotificationController notificationController = Get.find();
  // //   if (notificationController.fromNotification) {
  // //     //_notificationController.fromNotification = false;
  // //     if (notificationController.landingScreen == 'new') {
  // //       return const MapMerchant();
  // //     } else if (notificationController.landingScreen == 'answered') {
  // //       return HomePage(
  // //         pageIndex: 1,
  // //         showMap: false,
  // //       );
  // //     } else {
  // //       return ChatScreen(
  // //         chatId: notificationController.notificationData.value.data['chatId'],
  // //         customerTitle: notificationController
  // //             .notificationData.value.data['customerTitle'],
  // //         merchantTitle: notificationController
  // //             .notificationData.value.data['merchantTitle'],
  // //         listEventId:
  // //             notificationController.notificationData.value.data['listEventId'],
  // //       );
  // //     }
  // //   }
  //   // warningLog(
  //   //     'device token on start up being generated ${AppHelpers.newBearerToken}');
  //  // return const MapMerchant();
  // }

  _intialiseToken() async {
    await AppHelpers.bearerToken;
  }

  // initFunction() async {
  //   _homeController.homeTabController =
  //       TabController(length: 3, vsync: this, initialIndex: 0);
  //   sv.SystemChrome.setSystemUIOverlayStyle(const sv.SystemUiOverlayStyle(
  //     systemNavigationBarColor: Colors.white,
  //     systemNavigationBarIconBrightness: Brightness.dark,
  //     statusBarColor: Colors.white,
  //     statusBarBrightness: Brightness.dark,
  //   ));
  //   await _profileController.initialise();
  //   await _profileController.getOperationalStatus();
  //   _allListController.getAllList();
  //   _allListController.checkSubPlan();
  //   /*Connectivity().onConnectivityChanged.listen((ConnectivityResult result) =>
  //       _connectivityController.listenConnectivity(result));*/
  //   APIs().updateDeviceToken(
  //     AppHelpers()
  //         .getPhoneNumberWithoutFoundedCountryCode(AppHelpers().getPhoneNumber),
  //   );
  //   apiController.searchedItemResult('potato');
  //   _notificationController.fromNotification = false;
  // }

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
