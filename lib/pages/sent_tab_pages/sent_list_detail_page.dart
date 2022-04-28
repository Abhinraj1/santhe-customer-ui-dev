import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/pages/sent_tab_pages/user_list_item_page.dart';

import '../../models/santhe_user_list_model.dart';
import 'offers_list_page.dart';

class SentUserListDetailsPage extends StatelessWidget {
  final UserList userList;
  final bool showOffers;
  const SentUserListDetailsPage({required this.userList, Key? key, required this.showOffers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    TabBar _tabBar = TabBar(
      indicator: const UnderlineTabIndicator(
        insets: EdgeInsets.symmetric(horizontal: 30.0),
        borderSide: BorderSide(
          width: 2.5,
          style: BorderStyle.solid,
          color: Colors.orange,
        ),
      ),
      unselectedLabelStyle: GoogleFonts.mulish(
          fontWeight: FontWeight.w400, fontSize: 18.sp, color: Colors.grey),
      labelColor: Colors.orange,
      labelStyle: GoogleFonts.mulish(
          fontSize: 18.sp, color: Colors.orange, fontWeight: FontWeight.w700),
      unselectedLabelColor: const Color(0xffBBBBBB),
      labelPadding: const EdgeInsets.all(4.0),
      tabs: const [
        Tab(
          child: Text(
            'Offers',
          ),
        ),
        Tab(
          child: Text(
            'List Items',
          ),
        ),
      ],
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: screenHeight * 5.5,
          leading: IconButton(
            splashRadius: 0.1,
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 13.sp,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            userList.listName,
            style: GoogleFonts.mulish(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp),
          ),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.grey.shade50,
              child: _tabBar,
            ),
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            OffersListPage(userList: userList, showOffers: showOffers),
            UserListItemDetailsPage(
              userList: userList,
            ),
          ],
        ),
      ),
    );
  }
}
