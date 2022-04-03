import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/pages/archive_tab_pages/archive_tab_page.dart';
import '../controllers/api_service_controller.dart';
import 'new_tab_pages/new_tab_page.dart';
import 'sent_tab_pages/sent_tab_page.dart';

import '../widgets/navigation_drawer_widget.dart';

class HomePage extends StatefulWidget {
  final int pageIndex;
  const HomePage({this.pageIndex = 0, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.orange,
      statusBarBrightness: Brightness.dark,
    ));
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final int pageIndex = widget.pageIndex;
    final apiController = Get.find<APIs>();

    double screenHeight = MediaQuery.of(context).size.height / 100;
    double screenWidth = MediaQuery.of(context).size.width / 100;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    return SafeArea(
        child: DefaultTabController(
      length: 3,
      initialIndex: pageIndex,
      child: Scaffold(
        key: _key,
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          toolbarHeight: screenHeight * 10,
          leading: Padding(
            padding: const EdgeInsets.all(9.0),
            child: IconButton(
              onPressed: () {
                _key.currentState!.openDrawer();
              },
              splashRadius: 25.0,
              icon: SvgPicture.asset(
                'assets/drawer_icon.svg',
                color: Colors.white,
              ),
            ),
          ),
          shadowColor: Colors.orange.withOpacity(0.5),
          elevation: 10.0,
          title: AutoSizeText(
            kAppName,
            style: GoogleFonts.mulish(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 26.sp),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4.5),
              child: IconButton(
                onPressed: () {},
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
            indicator: const UnderlineTabIndicator(
              insets: EdgeInsets.symmetric(horizontal: 20.0),
              borderSide: BorderSide(
                width: 5.0,
                color: Colors.white,
              ),
            ),
            unselectedLabelStyle: GoogleFonts.mulish(
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
            ),
            labelColor: Colors.white,
            labelStyle: GoogleFonts.mulish(
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
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            NewTabPage(),
            OfferTabPage(),
            ArchiveTabPage(),
          ],
        ),
      ),
    ));
  }
}
