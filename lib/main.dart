import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/archived_controller.dart';
import 'package:santhe/controllers/custom_image_controller.dart';
import 'package:santhe/controllers/location_controller.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/core/app_theme.dart';
import 'package:santhe/models/santhe_cache_refresh.dart';
import 'package:santhe/pages/customer_registration_pages/customer_registration.dart';
import 'package:santhe/pages/splash_to_home.dart';
import 'package:santhe/pages/splash_to_onboarding.dart';
import 'controllers/boxes_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/notification_controller.dart';
import 'controllers/registrationController.dart';
import 'controllers/search_query_controller.dart';
import 'controllers/sent_tab_offer_card_controller.dart';
import 'models/santhe_category_model.dart';
import 'models/santhe_faq_model.dart';
import 'models/santhe_item_model.dart';
import 'models/santhe_list_item_model.dart';
import 'models/santhe_user_credenetials_model.dart';
import 'models/santhe_user_list_model.dart';
import 'models/santhe_user_model.dart';

//todo start with new list page, send list name data till end of piperline  
//todo then to list controller, then display on new list tab on homepage
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

  final bool showHome = Boxes.getUserPrefs().get('showHome', defaultValue: false) ?? false;
  final bool isLoggedIn = Boxes.getUserPrefs().get('isLoggedIn', defaultValue: false) ?? false;
  final bool isRegistered = Boxes.getUserPrefs().get('isRegistered', defaultValue: false) ?? false;

  Get.put(APIs());
  Get.put(LocationController());
  Get.put(RegistrationController());
  Get.put(CustomImageController());
  Get.put(SentUserListController());
  Get.put(SearchQueryController());
  Get.put(ArchivedController());
  Get.put(NotificationController());
  Notifications().fcmInit();

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

    return Resize(
      builder: () => GetMaterialApp(
        defaultTransition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        debugShowCheckedModeBanner: false,
        title: kAppName,
        theme: AppTheme().themeData.copyWith(
              textSelectionTheme: const TextSelectionThemeData(
                selectionHandleColor: Colors.transparent,
              ),
            ),
        home: showHome2 && isLoggedIn2
            ? isRegistered2
                ? const SplashToHome()
                : UserRegistrationPage(userPhoneNumber: userPhone)
            : const SplashToOnboarding(),
      ),
      allowtextScaling: false,
      size: const Size(390, 844),
    );
  }
}
