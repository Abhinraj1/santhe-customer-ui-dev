// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:resize/resize.dart';
import 'package:share_plus/share_plus.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/controllers/connectivity_controller.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/pages/archive_tab_pages/archive_tab_page.dart';
import 'package:santhe/pages/map_merch.dart';
import 'package:santhe/pages/youtubevideo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/api_service_controller.dart';
import '../controllers/getx/all_list_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/notification_controller.dart';
import '../core/app_helpers.dart';
import '../core/app_url.dart';
import '../widgets/navigation_drawer_widget.dart';
import 'new_tab_pages/new_tab_page.dart';
import 'sent_tab_pages/sent_tab_page.dart';

class HomePage extends StatefulWidget {
  final int pageIndex;
  bool showMap;
  bool? cameFromHomeScreen;

  HomePage({
    Key? key,
    required this.pageIndex,
    required this.showMap,
    this.cameFromHomeScreen,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, LogMixin {
  final apiController = Get.find<APIs>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final NotificationController _notificationController = Get.find();
  final ConnectivityController _connectivityController = Get.find();
  final AllListController _allListController = Get.find();
  final ProfileController _profileController = Get.find();
  bool _showMapOnStart = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    _allListController.isLoading = true;
    _init();
    warningLog('$_showMapOnStart');
    super.initState();
  }

  Future<void> _init() async {
    _homeController.homeTabController =
        TabController(length: 3, vsync: this, initialIndex: widget.pageIndex);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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
    apiController.searchedItemResult('potato');
    _notificationController.fromNotification = false;
  }

  _launchUrl() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=BkvCsbmzkU8');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
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
        bottom: TabBar(
          controller: _homeController.homeTabController,
          indicator: const UnderlineTabIndicator(
            insets: EdgeInsets.symmetric(horizontal: 20.0),
            borderSide: BorderSide(
              width: 5.0,
              color: Colors.white,
            ),
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18.sp,
          ),
          labelColor: Colors.white,
          labelStyle: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w800),
          unselectedLabelColor: Colors.white.withOpacity(0.8),
          tabs: const [
            Tab(
              child: Text(
                'New',
              ),
            ),
            Tab(
              child: Text(
                'Sent',
              ),
            ),
            Tab(
              child: Text(
                'Archived',
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _homeController.homeTabController,
            physics: const BouncingScrollPhysics(),
            children: [
              const NewTabPage(),
              OfferTabPage(),
              ArchivedTabScreen(),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onTap: () {
                log('Tapped on floating action button');
                widget.cameFromHomeScreen == true
                    ? Navigator.pop(context)
                    :
                    // Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapMerchant(),
                        ),
                      );
              },
              child: Image.asset(
                'assets/map_dialog.png',
                height: 90,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendNotification(String content) {
    var url = 'https://fcm.googleapis.com/fcm/send';
    http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${AppUrl.FCMKey}', // FCM Server key
      },
      body: jsonEncode(
        <String, dynamic>{
          "notification": <String, dynamic>{
            "body": content,
            "title": 'New message from merchant',
            "priority": "high",
            "sound": "slow_spring_board.aiff",
            "android_channel_id": "santhe_alerts"
          },
          //'registration_ids': pairs['data'].values.toList(), // Multiple id
          'to':
              'fJQjW1terEU0kau3KcQcR8:APA91bFW54GwmRuizhyosmZaKXFPV-kOkMu8IdD9O_16r7HXhHW0H8C2YKSUK5dQLG7nQTeLld8E4qpz1eXQx_peCBgku9lfiWnxwSc0oWhKrJanrdTPNRV4BUTyA2Fft1BMbU9FD0gw', // single id
          "direct_boot_ok": true,
          "data": {}
        },
      ),
    );
  }
}
