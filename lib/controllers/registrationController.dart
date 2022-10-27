import 'dart:developer';
import 'dart:io';

import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    if(Platform.isAndroid){
      getReferrerDetails();
    }
  }

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
      ReferrerDetails referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
      String installReferrer = referrerDetails.installReferrer ?? 'organic';
      List<String> val = installReferrer.split('=');
      if(val.isNotEmpty){
        utmMedium.value = val.last;
      }
      log('referrerDetails: ${utmMedium.value}');
    } on Exception catch (e) {
      utmMedium.value = 'organic';
      log(e.toString());
    }
  }
}
