import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/pages/error_pages/no_internet_page.dart';

import '../controllers/api_service_controller.dart';
import '../controllers/boxes_controller.dart';
import '../models/santhe_cache_refresh.dart';
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
      Get.off(() => const HomePage(), transition: Transition.fadeIn);
      print('called!');
    });
  }

  Future init() async {
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

      print('first cache load');
    }

    //catUpdate checking
    if (box
            .get('cacheRefresh')
            ?.catUpdate
            .isBefore(newCacheRefresh.catUpdate) ??
        true) {
      print(
          '========${box.get('cacheRefresh')?.catUpdate} vs ${newCacheRefresh.catUpdate}');
//calling api and saving to db (api code has db write code integrated)
      await apiController.getAllCategories();
      print('>>>>>>>>>>>>>>fetching cat');
    }
    // apiController.initCategoriesDB();

    //faq cache check and storing
    if (box
            .get('cacheRefresh')
            ?.custFaqUpdate
            .isBefore(newCacheRefresh.custFaqUpdate) ??
        true) {
      //get & store faq data
      print('-----------------Updating FAQ------------------');
      await apiController.getAllFAQs();
    }

    // aboutUs cache check and storing
    if (box
            .get('cacheRefresh')
            ?.aboutUsUpdate
            .isBefore(newCacheRefresh.aboutUsUpdate) ??
        true) {
      print('-----------------Updating About Us------------------');
      await apiController.getCommonContent();
    } else if (box
            .get('cacheRefresh')
            ?.termsUpdate
            .isBefore(newCacheRefresh.termsUpdate) ??
        true) {
      print('-----------------Updating Terms & Condition------------------');
      await apiController.getCommonContent();
    }

    //item cache check and storing
    if (box
            .get('cacheRefresh')
            ?.itemUpdate
            .isBefore(newCacheRefresh.itemUpdate) ??
        true) {
      print('-----------------Refreshing Item Image------------------');
      // await apiController.getAllItems();
      //clearing image cache
      DefaultCacheManager manager = DefaultCacheManager();
      manager.emptyCache();
    }

    box.put('cacheRefresh', newCacheRefresh);

  }

  @override
  void initState() {
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
      init();
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
