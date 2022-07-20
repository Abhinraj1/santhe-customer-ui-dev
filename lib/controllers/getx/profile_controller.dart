import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/boxes_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/models/santhe_cache_refresh.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/login_pages/phone_number_login_page.dart';

class ProfileController extends GetxController {
  CustomerModel? customerDetails;

  RxBool isOperational = false.obs;

  bool isRegistered = false;

  bool isLoggedIn = false;

  String? _urlToken;

  Timer? refreshToken;

  String get urlToken => _urlToken ?? '';

  Future<void> initialiseUrlToken({bool override = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      isLoggedIn = true;
      final tokenId = await user.getIdToken();
      _urlToken = tokenId;
    } else {
      isLoggedIn = false;
      if (!override) {
        Get.offAll(() => const LoginScreen());
      }
    }
  }

  void startTimer() {
    refreshToken =
        Timer.periodic(const Duration(minutes: 1), (_) => initialiseUrlToken());
  }

  Future<void> initialise({bool startApp = false}) async {
    await initialiseUrlToken(override: startApp);
    if (isLoggedIn) await getCustomerDetailsInit();
    if (isLoggedIn && isRegistered) await cacheRefresh();
    if (isLoggedIn && isRegistered) await getOperationalStatus();
  }

  Future<void> getCustomerDetailsInit() async {
    final apiController = Get.find<APIs>();
    final result = await apiController.getCustomerInfo(
        int.parse(AppHelpers().getPhoneNumberWithoutCountryCode));
    if (result == 0) {
      isRegistered = false;
    } else {
      isRegistered = true;
    }
  }

  Future<void> getOperationalStatus() async {
    final apiController = Get.find<APIs>();
    await apiController.getCheckRadius(
        int.parse(AppHelpers().getPhoneNumberWithoutCountryCode));
    log("Is Operational: " + isOperational.toString());
  }

  set getCustomerDetails(CustomerModel customer) {
    customerDetails = customer;
    update(['navDrawer']);
  }

  Future<void> cacheRefresh() async {
    final apiController = Get.find<APIs>();

    CacheRefresh newCacheRefresh = await apiController.cacheRefreshInfo();
    var box = Boxes.getCacheRefreshInfo();

    //getting all content that's to be cached if not already done
    if (!box.containsKey('cacheRefresh') || box.isEmpty) {
      //cat data
      await apiController.getAllCategories();
      box.put('cacheRefresh', newCacheRefresh);

      //faq data
      await apiController.getAllFAQs();

      //aboutUs & terms n condition data
      await apiController.getCommonContent();

      //items data for search
      // await apiController.getAllItems();

      log('first cache load');
    }

    //catUpdate checking
    if (box
            .get('cacheRefresh')
            ?.catUpdate
            .isBefore(newCacheRefresh.catUpdate) ??
        true) {
      log('========${box.get('cacheRefresh')?.catUpdate} vs ${newCacheRefresh.catUpdate}');
//calling api and saving to db (api code has db write code integrated)
      await apiController.getAllCategories();
      log('>>>>>>>>>>>>>>fetching cat');
    }
    // apiController.initCategoriesDB();

    //faq cache check and storing
    if (box
            .get('cacheRefresh')
            ?.custFaqUpdate
            .isBefore(newCacheRefresh.custFaqUpdate) ??
        true) {
      //get & store faq data
      log('-----------------Updating FAQ------------------');
      await apiController.getAllFAQs();
    }

    // aboutUs cache check and storing
    if (box
            .get('cacheRefresh')
            ?.aboutUsUpdate
            .isBefore(newCacheRefresh.aboutUsUpdate) ??
        true) {
      log('-----------------Updating About Us------------------');
      await apiController.getCommonContent();
    } else if (box
            .get('cacheRefresh')
            ?.termsUpdate
            .isBefore(newCacheRefresh.termsUpdate) ??
        true) {
      log('-----------------Updating Terms & Condition------------------');
      await apiController.getCommonContent();
    }

    //item cache check and storing
    if (box
            .get('cacheRefresh')
            ?.itemUpdate
            .isBefore(newCacheRefresh.itemUpdate) ??
        true) {
      log('-----------------Refreshing Item Image------------------');
      // await apiController.getAllItems();
      //clearing image cache
      DefaultCacheManager manager = DefaultCacheManager();
      manager.emptyCache();
    }

    box.put('cacheRefresh', newCacheRefresh);
  }
}
