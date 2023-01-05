import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:flutter/services.dart' as sv;
import 'package:santhe/controllers/error_user_fallback.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/controllers/home_controller.dart';
import 'package:santhe/controllers/notification_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/map_merch.dart';
import 'package:santhe/pages/ondc/ondc_shop_list/ondc_shop_list_view.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/getx/all_list_controller.dart';

class OndcIntro extends StatefulWidget {
  const OndcIntro({Key? key}) : super(key: key);

  @override
  State<OndcIntro> createState() => _OndcIntroState();
}

class _OndcIntroState extends State<OndcIntro>
    with LogMixin, SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final AllListController _allListController = Get.find();
  final ProfileController _profileController = Get.find();
  final HomeController _homeController = Get.find();
  final NotificationController _notificationController = Get.find();
  final APIs apiController = Get.find();

  _launchUrl() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=BkvCsbmzkU8');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  initFunction() async {
    _homeController.homeTabController =
        TabController(length: 3, vsync: this, initialIndex: 0);
    sv.SystemChrome.setSystemUIOverlayStyle(const sv.SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    await _profileController.initialise();
    await _profileController.getOperationalStatus();
    _allListController.getAllList();
    _allListController.checkSubPlan();
    /*Connectivity().onConnectivityChanged.listen((ConnectivityResult result) =>
        _connectivityController.listenConnectivity(result));*/
    APIs().updateDeviceToken(
      AppHelpers()
          .getPhoneNumberWithoutFoundedCountryCode(AppHelpers().getPhoneNumber),
    );
    apiController.searchedItemResult('potato');
    _notificationController.fromNotification = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            //!something to add
            //APIs().updateDeviceToken(AppHelpers().getPhoneNumberWithoutCountryCode) ;
            /*log(await AppHelpers().getToken);
            sendNotification('tesst');*/
            _key.currentState!.openDrawer();
            /*FirebaseAnalytics.instance.logEvent(
              name: "select_content",
              parameters: {
                "content_type": "image",
                "item_id": 'itemId',
              },
            ).then((value) => print('success')).catchError((e) => print(e.toString()));*/
          },
          splashRadius: 25.0,
          icon: SvgPicture.asset(
            'assets/drawer_icon.svg',
            color: Colors.white,
          ),
        ),
        shadowColor: Colors.orange.withOpacity(0.5),
        elevation: 10.0,
        title: const AutoSizeText(
          kAppName,
          style: TextStyle(
              fontWeight: FontWeight.w800, color: Colors.white, fontSize: 24),
        ),
        actions: [
          GestureDetector(
            onTap: _launchUrl,
            //  () {
            //   Navigator.pushReplacement(
            //     context,
            //     PageTransition(
            //       child: YoutubeVideoGuide(),
            //       type: PageTransitionType.rightToLeft,
            //     ),
            //   );
            // },
            child: Image.asset(
              'assets/questioncircle.png',
              height: 18,
              width: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.5),
            child: IconButton(
              onPressed: () {
                if (Platform.isIOS) {
                  Share.share(
                    AppHelpers().appStoreLink,
                  );
                } else {
                  Share.share(
                    AppHelpers().playStoreLink,
                  );
                }
              },
              splashRadius: 25.0,
              icon: const Icon(
                Icons.share,
                color: Colors.white,
                size: 27.0,
              ),
            ),
          )
        ],
      ),
      body: GetBuilder(
          init: _profileController,
          id: 'OndcIntro',
          builder: (context) {
            CustomerModel currentUser =
                _profileController.customerDetails ?? fallback_error_customer;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Text(
                      'Welcome ${currentUser.customerName}!',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/createList.png'),
                          const Text(
                            '*Includes waiting for merchants\n to give prices, but you have more\n options here',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                            ),
                            onPressed: () {
                              Get.offAll(
                                const MapMerchant(),
                                transition: Transition.leftToRight,
                              );
                            },
                            child: const Text(
                              'Create List',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset('assets/ondclist.png'),
                          const Text(
                            '*Buy from ONDC registered \n shops near you.\n *You can see prices immediately\n and checkout,but your options\n are limite',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                            ),
                            onPressed: () {
                              Get.offAll(
                                OndcShopListView(
                                  customerModel: currentUser,
                                ),
                              );
                            },
                            child: const Text(
                              'Shop Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
