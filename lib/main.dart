import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:santhe/REEEEEEEEEEE/firestoreeeee.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/custom_image_controller.dart';
import 'package:santhe/controllers/location_controller.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/firebase/firebase_helper.dart';
import 'package:santhe/models/santhe_cache_refresh.dart';
import 'package:santhe/pages/customer_registration_pages/customer_registration.dart';
import 'package:santhe/pages/error_pages/no_internet_error.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:santhe/pages/login_pages/phone_number_login_page.dart';
import 'package:santhe/pages/onboarding_page.dart';
import 'package:santhe/pages/splash_to_home.dart';
import 'package:santhe/pages/splash_to_onboarding.dart';
import 'REEEEEEEEEEE/firestoraaage.dart';
import 'controllers/boxes_controller.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/registrationController.dart';
import 'controllers/search_query_controller.dart';
import 'controllers/sent_tab_offer_card_controller.dart';
import 'models/santhe_category_model.dart';
import 'models/santhe_faq_model.dart';
import 'models/santhe_item_model.dart';
import 'models/santhe_list_item_model.dart';
import 'models/santhe_user_credenetials_model.dart';
import 'models/santhe_user_list_model.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'models/santhe_user_model.dart';

//todo start with new list page, send list name data till end of piperline
//todo then to list controller, then display on new list tab on homepage
void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseHelper().offerStream();

  // DataFeeder().itemDataFeeder();
  // await FireStorage().getFirebaseImageFolder();

  Hive.registerAdapter(ListItemAdapter());
  Hive.registerAdapter(UserListAdapter());
  Hive.registerAdapter(UserCredentialAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(CacheRefreshAdapter());
  Hive.registerAdapter(FAQAdapter());
  Hive.registerAdapter(ItemAdapter());
  await Hive.initFlutter();

  await Hive.openBox<UserList>('userListsDB');
  await Hive.openBox<User>('userDB');
  await Hive.openBox<UserCredential>('userCredentialsDB');
  await Hive.openBox<bool>('userPrefsDB');
  await Hive.openBox<Category>('categoryDB');
  await Hive.openBox<Item>('itemDB');
  await Hive.openBox<CacheRefresh>('cacheRefreshDB');
  await Hive.openBox<FAQ>('faqDB');
  await Hive.openBox<String>('contentDB');
  await Hive.openBox<UserList>('userListDB');

  final bool showHome =
      Boxes.getUserPrefs().get('showHome', defaultValue: false) ?? false;
  final bool isLoggedIn =
      Boxes.getUserPrefs().get('isLoggedIn', defaultValue: false) ?? false;
  final bool isRegistered =
      Boxes.getUserPrefs().get('isRegistered', defaultValue: false) ?? false;

  if (showHome) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.orange,
      statusBarBrightness: Brightness.light,
    ));
  } else {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.orange,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.orange,
      statusBarBrightness: Brightness.light,
    ));
  }

  final apiController = Get.put(APIs());
  final locationController = Get.put(LocationController());
  final registrationController = Get.put(RegistrationController());
  final customImageUrl = Get.put(CustomImageController());
  final sentUserListController = Get.put(SentUserListController());
  final searchQueryController = Get.put(SearchQueryController());
  // apiController.initCategoriesDB();

  //content update check and caching

// //OVOOVOVOOO
//   CacheRefresh newCacheRefresh = await apiController.cacheRefreshInfo();
//   var box = Boxes.getCacheRefreshInfo();
//
//   //getting all content that's to be cached if not already done
//   if (!box.containsKey('cacheRefresh') || box.isEmpty) {
//     //cat data
//     await apiController.getAllCategories();
//     box.put('cacheRefresh', newCacheRefresh);
//
//     //faq data
//     await apiController.getAllFAQs();
//
//     //aboutUs & terms n condition data
//     await apiController.getCommonContent();
//
//     //items data for search
//     // await apiController.getAllItems();
//
//     print('first cache load');
//   }
//
//   //catUpdate checking
//   if (box.get('cacheRefresh')?.catUpdate.isBefore(newCacheRefresh.catUpdate) ??
//       true) {
//     print(
//         '========${box.get('cacheRefresh')?.catUpdate} vs ${newCacheRefresh.catUpdate}');
// //calling api and saving to db (api code has db write code integrated)
//     await apiController.getAllCategories();
//     print('>>>>>>>>>>>>>>fetching cat');
//   }
//   // apiController.initCategoriesDB();
//
//   //faq cache check and storing
//   if (box
//           .get('cacheRefresh')
//           ?.custFaqUpdate
//           .isBefore(newCacheRefresh.custFaqUpdate) ??
//       true) {
//     //get & store faq data
//     print('-----------------Updating FAQ------------------');
//     await apiController.getAllFAQs();
//   }
//
//   // aboutUs cache check and storing
//   if (box
//           .get('cacheRefresh')
//           ?.aboutUsUpdate
//           .isBefore(newCacheRefresh.aboutUsUpdate) ??
//       true) {
//     print('-----------------Updating About Us------------------');
//     await apiController.getCommonContent();
//   } else if (box
//           .get('cacheRefresh')
//           ?.termsUpdate
//           .isBefore(newCacheRefresh.termsUpdate) ??
//       true) {
//     print('-----------------Updating Terms & Condition------------------');
//     await apiController.getCommonContent();
//   }
//
//   //item cache check and storing
//   if (box
//           .get('cacheRefresh')
//           ?.itemUpdate
//           .isBefore(newCacheRefresh.itemUpdate) ??
//       true) {
//     print('-----------------Refreshing Item Image------------------');
//     // await apiController.getAllItems();
//     //clearing image cache
//     DefaultCacheManager manager = DefaultCacheManager();
//     manager.emptyCache();
//   }
//
//   box.put('cacheRefresh', newCacheRefresh);
//
// //OVOVOVO

  runApp(MyApp(
    showHome: showHome,
    isRegistered: isRegistered,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  final bool isRegistered;
  final bool isLoggedIn;
  const MyApp(
      {required this.showHome,
      required this.isRegistered,
      required this.isLoggedIn,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showHome2 = showHome;
    bool isRegistered2 = isRegistered;
    bool isLoggedIn2 = isLoggedIn;

    int userPhone = Boxes.getUserCredentialsDB()
            .get('currentUserCredentials')
            ?.phoneNumber ??
        404;

    if (userPhone == 404) {
      isLoggedIn2 = false;
      Boxes.getUserPrefs().put('isLoggedIn', false);
      isRegistered2 = false;
      Boxes.getUserPrefs().put('isRegistered', false);
      showHome2 = false;
      Boxes.getUserPrefs().put('showHome', false);
    }
    bool hasInternet = false;

    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
      debugShowCheckedModeBanner: false,
      title: kAppName,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        splashColor: Colors.transparent,
        highlightColor: Colors.orangeAccent,
        backgroundColor: Colors.grey.shade50,
        textTheme: TextTheme(
          bodyText1: GoogleFonts.mulish(color: Colors.grey.shade600),
          bodyText2: GoogleFonts.mulish(color: Colors.grey.shade600),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 1.0,
          shadowColor: Colors.orange,
          centerTitle: true,
          color: Colors.orange,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.orange,
          ),
        ),
      ),
      home: showHome2 && isLoggedIn2
          ? isRegistered2
              ? const SplashToHome()
              : UserRegistrationPage(userPhoneNumber: userPhone)
          : const SplashToOnboarding(),

      // home: showHome ? const SplashToHome() : const OnboardingPage(),
    );
  }
}
