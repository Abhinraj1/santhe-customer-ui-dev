import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resize/resize.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/controllers/boxes_controller.dart';
import 'package:santhe/controllers/connectivity_controller.dart';
import 'package:santhe/pages/archive_tab_pages/archive_tab_page.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/api_service_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/notification_controller.dart';
import '../core/app_helpers.dart';
import 'new_tab_pages/new_tab_page.dart';
import 'sent_tab_pages/sent_tab_page.dart';

import '../widgets/navigation_drawer_widget.dart';

class HomePage extends StatefulWidget {
  final int pageIndex;

  const HomePage({this.pageIndex = 0, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  final apiController = Get.find<APIs>();

  Future<int> checkSubPlan() async {
    final data = await apiController
        .getSubscriptionLimit(Boxes.getUser().values.first.custPlan);
    return data;
  }

  final NotificationController _notificationController = Get.find();
  final ConnectivityController _connectivityController = Get.find();

  @override
  void initState() {
    _homeController.homeTabController = TabController(length: 3, vsync: this, initialIndex: widget.pageIndex);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) => _connectivityController.listenConnectivity(result));
    apiController.searchedItemResult('potato');
    _notificationController.fromNotification = false;
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _key.currentState!.openDrawer();
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
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 24),
        ),
        actions: [
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
              icon: Icon(
                Icons.adaptive.share,
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
      body: FutureBuilder(
          future: checkSubPlan(),
          builder: (c, s) {
            if (s.connectionState == ConnectionState.done) {
              return TabBarView(
                controller: _homeController.homeTabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  NewTabPage(
                    limit: s.data == null ? 3 : s.data! as int,
                  ),
                  const OfferTabPage(),
                  const ArchiveTabPage(),
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
