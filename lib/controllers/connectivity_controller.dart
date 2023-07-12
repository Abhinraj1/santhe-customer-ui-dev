import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/pages/error_pages/no_internet_page.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_shophome/hyperlocal_shophome_view.dart';
import 'package:santhe/pages/map_merch.dart';
import 'package:santhe/pages/ondc/ondc_intro/ondc_intro_view.dart';

import '../core/app_shared_preference.dart';
import '../pages/chat/chat_screen.dart';
import '../pages/home_page.dart';
import '../pages/login_pages/phone_number_login_page.dart';
import '../pages/onboarding_page.dart';
import 'notification_controller.dart';

class ConnectivityController extends GetxController with LogMixin {
  bool hasInternet = true;

  bool inInternetErrorScreen = false;

  bool passedInitialScreen = false;

  ConnectivityResult connectivityResult = ConnectivityResult.none;

  // final profileController = Get.find<ProfileController>();

  void listenConnectivity(ConnectivityResult result) {
    connectivityResult = result;

    if (result == ConnectivityResult.none) {
      hasInternet = false;
      Get.to(() => const NoInternetPage(), transition: Transition.fade);
    }

    if ((result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile) &&
        !hasInternet) {
      if (passedInitialScreen) {
        Get.back();
      } else {
        Get.offAll(() => _getLandingScreen(), transition: Transition.fadeIn);
      }
      hasInternet = true;
    }
  }

  void checkConnectivity() {
    if (!hasInternet) {
      Connectivity().checkConnectivity().then((result) {
        if ((result == ConnectivityResult.wifi ||
                result == ConnectivityResult.mobile) &&
            !hasInternet) {
          if (passedInitialScreen) {
            Get.back();
          } else {
            Get.offAll(() => _getLandingScreen(),
                transition: Transition.fadeIn);
          }
          hasInternet = true;
        }
      });
    }
  }

  Future<void> checkConnectivityAndMoveInitialPage() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      hasInternet = false;
      Get.to(() => const NoInternetPage(), transition: Transition.fade);
    } else {
      Get.offAll(() => _getLandingScreen(), transition: Transition.fadeIn);
    }
  }

  Widget _getLandingScreen() {
    passedInitialScreen = true;
    // if (!AppSharedPreference().loadSignUpScreen) {
    //   errorLog('Called LoadSignUp');
    //   return const LoginScreen();
    // }
    if (!AppSharedPreference().checkForLogin) {
      errorLog('Called For checkLogin');
      return const LoginScreen();
    }
   // final NotificationController notificationController = Get.find();
    // if (notificationController.fromNotification) {
    //   //_notificationController.fromNotification = false;
    //   if (notificationController.landingScreen == 'new') {
    //     // return const OndcIntroView();
    //     warningLog(
    //         'Checking for profile controller in connectivity controller${customerModel.lat}');
    //     return const HyperlocalShophomeView();
    //     //!previous
    //     //return const MapMerchant();
    //   } else if (notificationController.landingScreen == 'answered') {
    //     return HomePage(
    //       pageIndex: 1,
    //       showMap: false,
    //     );
    //   } else {
    //     return ChatScreen(
    //       chatId: notificationController.notificationData.value.data['chatId'],
    //       customerTitle: notificationController
    //           .notificationData.value.data['customerTitle'],
    //       merchantTitle: notificationController
    //           .notificationData.value.data['merchantTitle'],
    //       listEventId:
    //           notificationController.notificationData.value.data['listEventId'],
    //     );
    //   }
    // }
     return const OndcIntroView();
    ///! For HyperLocal Deals Home
   // return const HyperlocalShophomeView();
    //!previous
    // return MapMerchant();
  }
}
