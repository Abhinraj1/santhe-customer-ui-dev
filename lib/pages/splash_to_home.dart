import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/pages/error_pages/no_internet_page.dart';

import '../controllers/api_service_controller.dart';
import '../controllers/notification_controller.dart';
import 'chat/chat_screen.dart';
import 'home_page.dart';

class SplashToHome extends StatefulWidget {
  const SplashToHome({Key? key}) : super(key: key);

  @override
  State<SplashToHome> createState() => _SplashToHomeState();
}

class _SplashToHomeState extends State<SplashToHome> {
  final apiController = Get.find<APIs>();

  void bootHome() {
    Future.delayed(const Duration(milliseconds: 4000), () {
      Get.off(() => getLandingScreen(), transition: Transition.fadeIn);
    });
  }

  Widget getLandingScreen(){
    final NotificationController _notificationController = Get.find();
    if(_notificationController.fromNotification){
      //_notificationController.fromNotification = false;
      if(_notificationController.landingScreen == 'new') {
        return const HomePage(pageIndex: 0,);
      } else if(_notificationController.landingScreen == 'answered'){
        return const HomePage(pageIndex: 1,);
      }else {
        return ChatScreen(
          chatId: _notificationController.notificationData.value.data['chatId'],
          customerTitle: _notificationController.notificationData.value.data['customerTitle'],
          merchantTitle: _notificationController.notificationData.value.data['merchantTitle'],
          listEventId: _notificationController.notificationData.value.data['listEventId'],
        );
      }
    }
    return const HomePage(pageIndex: 0,);
  }

  @override
  void initState(){
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.orange,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.orange,
      statusBarBrightness: Brightness.dark,
    ));
    checkNet();
    timer = Timer.periodic(const Duration(seconds: 4), (_) => checkNet());
    super.initState();
  }

  void checkNet() async {
    final hasNet = await AppHelpers.checkConnection();
    if (hasNet) {
      timer.cancel();
      bootHome();
    } else {
      Get.to(
            () => const NoInternetPage(),
        transition: Transition.fade,
      );
    }
  }

  late final Timer timer;

  @override
  void dispose() {
    timer.cancel();
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
