import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/boxes_controller.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/controllers/registrationController.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/models/santhe_cache_refresh.dart';
import 'package:santhe/models/santhe_category_model.dart';
import 'package:santhe/models/santhe_faq_model.dart';
import 'package:santhe/models/santhe_item_model.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/login_pages/phone_number_login_page.dart';

class ProfileController extends GetxController {
  CustomerModel? customerDetails;

  RxBool isOperational = true.obs;

  String? _urlToken;

  String get urlToken => _urlToken ?? '';

  Future<void> generateUrlToken({bool override = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final tokenId = await user.getIdToken();
      _urlToken = tokenId;
    } else {
      if (!override) {
        Get.offAll(() => const LoginScreen());
      }
    }
  }

  Future<void> initialise({bool startApp = false}) async {
    await generateUrlToken(override: startApp);
    await getCustomerDetailsInit();
    await cacheRefresh();
    if (!customerDetails!.opStats) await getOperationalStatus();
  }

  Future<bool> getCustomerDetailsInit() async {
    final apiController = Get.find<APIs>();
    final result = await apiController.getCustomerInfo(int.parse(AppHelpers().getPhoneNumberWithoutCountryCode));
    return result == 0;
  }

  Future<void> getOperationalStatus() async {
    final apiController = Get.find<APIs>();
    await apiController.getCheckRadius(
      int.parse(AppHelpers().getPhoneNumberWithoutCountryCode),
      customerDetails!.lat.toString(),
      customerDetails!.lng.toString(),
      customerDetails!.pinCode,
    );
    log("Is Operational: $isOperational");
  }

  set getCustomerDetails(CustomerModel customer) {
    customerDetails = customer;
    RegistrationController registrationController = Get.find();
    registrationController.address.value = customerDetails!.address;
    registrationController.howToReach.value = customerDetails!.howToReach;
    registrationController.lat.value = double.parse(customerDetails!.lat);
    registrationController.lng.value = double.parse(customerDetails!.lng);
    update(['navDrawer']);
  }

  Future<void> cacheRefresh() async {
    final apiController = Get.find<APIs>();

    CacheRefresh newCacheRefresh = await apiController.cacheRefreshInfo();
    var box = Boxes.getCacheRefreshInfo();

    await Hive.openBox<Category>('categoryDB');
    await Hive.openBox<Item>('itemDB');
    await Hive.openBox<CacheRefresh>('cacheRefreshDB');
    await Hive.openBox<FAQ>('faqDB');
    await Hive.openBox<String>('contentDB');

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

  void deleteEverything(){
    isOperational.value = false;
    customerDetails = null;
    _urlToken = null;
  }
}
