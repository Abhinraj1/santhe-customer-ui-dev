import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/pages/error_pages/no_internet_page.dart';

import '../controllers/api_service_controller.dart';
import '../controllers/notification_controller.dart';
import '../core/app_initialisations.dart';
import '../core/app_shared_preference.dart';
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
    Future.delayed(const Duration(milliseconds: 3000), () {
      Widget screen = !AppSharedPreference().loadSignUpScreen
          ? const OnboardingPage()
          : AppSharedPreference().checkForLogin
          ? getLandingScreen()
          : const LoginScreen();
      Get.offAll(() => screen, transition: Transition.fadeIn);
    });
  }

  Widget getLandingScreen(){
    final NotificationController notificationController = Get.find();
    if(notificationController.fromNotification){
      //_notificationController.fromNotification = false;
      if(notificationController.landingScreen == 'new') {
        return const HomePage(pageIndex: 0,);
      } else if(notificationController.landingScreen == 'answered'){
        return const HomePage(pageIndex: 1,);
      }else {
        return ChatScreen(
          chatId: notificationController.notificationData.value.data['chatId'],
          customerTitle: notificationController.notificationData.value.data['customerTitle'],
          merchantTitle: notificationController.notificationData.value.data['merchantTitle'],
          listEventId: notificationController.notificationData.value.data['listEventId'],
        );
      }
    }
    return const HomePage(pageIndex: 0,);
  }

  @override
  void initState(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
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
