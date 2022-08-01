

import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../controllers/api_service_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/connectivity_controller.dart';
import '../controllers/custom_image_controller.dart';
import '../controllers/getx/all_list_controller.dart';
import '../controllers/getx/profile_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/registrationController.dart';
import '../controllers/search_query_controller.dart';
import '../models/santhe_cache_refresh.dart';
import '../models/santhe_category_model.dart';
import '../models/santhe_faq_model.dart';
import '../models/santhe_item_model.dart';
import '../models/santhe_list_item_model.dart';
import '../models/santhe_user_credenetials_model.dart';
import '../models/santhe_user_list_model.dart';
import '../models/santhe_user_model.dart';
import 'app_shared_preference.dart';

class AppInitialisations{

  Future<void> initialiseApplication() async {
    //shared preferences
    await AppSharedPreference().initSharedPreference();

    //hive
    await _initialiseHive();

    //getX
    _initialiseControllers();
  }

  Future<void> _initialiseHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ListItemAdapter());
    Hive.registerAdapter(UserListAdapter());
    Hive.registerAdapter(UserCredentialAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(CacheRefreshAdapter());
    Hive.registerAdapter(FAQAdapter());
    Hive.registerAdapter(ItemAdapter());

    await Hive.openBox<Category>('categoryDB');
    await Hive.openBox<Item>('itemDB');
    await Hive.openBox<CacheRefresh>('cacheRefreshDB');
    await Hive.openBox<FAQ>('faqDB');
    await Hive.openBox<String>('contentDB');
  }

  void _initialiseControllers(){
    Get.put(AllListController());
    Get.put(APIs());
    Get.put(LocationController());
    Get.put(RegistrationController());
    Get.put(CustomImageController());
    Get.put(SearchQueryController());
    Get.put(NotificationController());
    Get.put(ChatController());
    Get.put(HomeController());
    Get.put(ProfileController());
    Get.put(ConnectivityController());
  }

}