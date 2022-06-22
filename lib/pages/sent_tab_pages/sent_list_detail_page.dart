import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:get/get.dart';

import 'package:santhe/pages/sent_tab_pages/user_list_item_page.dart';

import '../../controllers/chat_controller.dart';
import '../../models/santhe_user_list_model.dart';
import 'offers_list_page.dart';

class SentUserListDetailsPage extends StatefulWidget {
  final UserList userList;
  final bool showOffers;
  const SentUserListDetailsPage({required this.userList, Key? key, required this.showOffers})
      : super(key: key);

  @override
  State<SentUserListDetailsPage> createState() => _SentUserListDetailsPageState();
}

class _SentUserListDetailsPageState extends State<SentUserListDetailsPage> {

  final ChatController _controller = Get.find();

  @override
  void initState(){
    _controller.inOfferScreen = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;

    TabBar _tabBar = TabBar(
      indicator: const UnderlineTabIndicator(
        insets: EdgeInsets.symmetric(horizontal: 30.0),
        borderSide: BorderSide(
          width: 2.5,
          style: BorderStyle.solid,
          color: Colors.orange,
        ),
      ),
      unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 18.sp, color: Colors.grey),
      labelColor: Colors.orange,
      labelStyle: TextStyle(
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
            widget.userList.listName,
            style: TextStyle(
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
            OffersListPage(userList: widget.userList, showOffers: widget.showOffers),
            UserListItemDetailsPage(
              userList: widget.userList,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose(){
    _controller.inOfferScreen = false;
    super.dispose();
  }
}
