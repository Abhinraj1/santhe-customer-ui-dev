import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/pages/error_pages/no_internet_page.dart';
import 'package:santhe/pages/login_pages/phone_number_login_page.dart';
import 'package:santhe/pages/onboarding_page.dart';

import '../controllers/api_service_controller.dart';

class SplashToOnboarding extends StatefulWidget {
  const SplashToOnboarding({Key? key}) : super(key: key);

  @override
  State<SplashToOnboarding> createState() => _SplashToOnboardingState();
}

class _SplashToOnboardingState extends State<SplashToOnboarding> {
  final apiController = Get.find<APIs>();

  void bootHome() {
    Future.delayed(const Duration(milliseconds: 4000), () {
      Get.off(() => const OnBoardingPage(), transition: Transition.fadeIn);
      log('called!');
    });
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

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.orange,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.orange,
      statusBarBrightness: Brightness.dark,
    ));

    timer = Timer.periodic(const Duration(seconds: 4), (_) => checkNet());
    checkNet();

    super.initState();
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
