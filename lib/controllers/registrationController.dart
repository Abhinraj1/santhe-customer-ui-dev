import 'dart:developer';

import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  RxString utmMedium = "".obs;
  RxString address = "".obs;
  RxString pinCode = "".obs;
  RxDouble lng = 0.0.obs;
  RxDouble lat = 0.0.obs;
  RxBool isMapSelected = false.obs;
  RxBool homeDelivery = false.obs;
  RxString howToReach = "".obs;

  Future<void> getReferrerDetails() async {
    try {
      ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;
      String installReferrer = referrerDetails.installReferrer ?? 'otp';
      // installReferrer.split('&')[1].split('=')[1];
      utmMedium.value = installReferrer.split('&')[1].split('=')[1];
      log('referrerDetails: ${utmMedium.value}');
    } on Exception catch (e) {
      utmMedium.value = 'otp';
      log(e.toString());
    }
  }
}
