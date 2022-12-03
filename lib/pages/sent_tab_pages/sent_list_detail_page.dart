import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:santhe/models/item_model.dart';
import 'package:santhe/controllers/notification_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/pages/home_page.dart';

import 'package:santhe/pages/sent_tab_pages/user_list_item_page.dart';

import '../../controllers/api_service_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/answer_list_model.dart';
import '../../models/new_list/list_item_model.dart';
import '../../models/new_list/user_list_model.dart';
import 'offers_list_page.dart';

class SentUserListDetailsPage extends StatefulWidget {
  UserListModel? userList;
  final bool showOffers;
  bool? fromChat;
  String? listEventId;
  bool overrideData;

  SentUserListDetailsPage({
    this.userList,
    Key? key,
    required this.showOffers,
    this.fromChat,
    this.listEventId,
    this.overrideData = false,
  }) : super(key: key);

  @override
  State<SentUserListDetailsPage> createState() =>
      _SentUserListDetailsPageState();
}

class _SentUserListDetailsPageState extends State<SentUserListDetailsPage> {
  final ChatController _chatController = Get.find();
  final NotificationController _notificationController = Get.find();
  final apiController = Get.find<APIs>();
  bool isLoading = true;

  @override
  void initState() {
    _chatController.inOfferScreen = true;
    if (widget.fromChat == true) {
      loadDetails();
    } else {
      setState(() => isLoading = false);
    }
    super.initState();
  }

  Future<void> loadDetails() async {
    AnswerList? data =
        await apiController.getListByListEventId(widget.listEventId!);
    widget.userList = UserListModel(
      createListTime: DateTime.parse(data!.date).toLocal(),
      custId: data.custId,
      items: getList(data.items),
      listId: data.listId,
      listName: 'Offer',
      custListSentTime: data.custUpdateTime,
      custListStatus: data.custStatus,
      listOfferCounter: '0',
      processStatus: data.custOfferStatus,
      custOfferWaitTime: DateTime.now(),
      listUpdateTime: DateTime.now(),
    );
    setState(() => isLoading = false);
  }

  void switchOverride(bool value) {
    setState(() {
      widget.overrideData = value;
    });
  }

  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;

    TabBar tabBar = TabBar(
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

    return isLoading
        ? Container(
            height: 100.vh,
            width: 100.vw,
            color: AppColors().white100,
            child: Center(
              child: CircularProgressIndicator(color: AppColors().brandDark),
            ),
          )
        : DefaultTabController(
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
                    if (_notificationController.fromNotification) {
                      _notificationController.fromNotification = false;
                      Get.offAll(
                          () => HomePage(
                                pageIndex: 1,
                                showMap: false,
                              ),
                          transition: Transition.leftToRight);
                    } else if (widget.overrideData) {
                      Navigator.of(context).pop(widget.overrideData);
                    } else {
                      if (_homeController.homeTabController.index != 1) {
                        _homeController.homeTabController.animateTo(1);
                      }
                      Navigator.pop(context);
                    }
                  },
                ),
                title: Text(
                  widget.userList!.listName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp),
                ),
                bottom: PreferredSize(
                  preferredSize: tabBar.preferredSize,
                  child: ColoredBox(
                    color: Colors.grey.shade50,
                    child: tabBar,
                  ),
                ),
              ),
              body: WillPopScope(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    OffersListPage(
                      userList: widget.userList!,
                      showOffers: widget.showOffers,
                      merchTitle: 'Request',
                      function: switchOverride,
                    ),
                    UserListItemDetailsPage(
                      userList: widget.userList!,
                    ),
                  ],
                ),
                onWillPop: () async {
                  if (_notificationController.fromNotification) {
                    _notificationController.fromNotification = false;
                    Get.offAll(
                        () => HomePage(
                              pageIndex: 1,
                              showMap: false,
                            ),
                        transition: Transition.leftToRight);
                  } else if (widget.overrideData) {
                    Navigator.of(context).pop(widget.overrideData);
                  } else {
                    if (_homeController.homeTabController.index != 1) {
                      _homeController.homeTabController.animateTo(1);
                    }
                    Navigator.pop(context);
                  }
                  return false;
                },
              ),
            ),
          );
  }

  List<ListItemModel> getList(List<ItemModel> item) {
    List<ListItemModel> list = [];
    for (var element in item) {
      list.add(ListItemModel(
          brandType: element.brandType,
          itemId: element.itemId,
          notes: element.itemNotes,
          quantity: element.quantity,
          itemName: element.itemName,
          itemImageId: element.itemImageId,
          unit: element.unit,
          catName: element.catName,
          catId: '0',
          possibleUnits: []));
    }
    return list;
  }

  @override
  void dispose() {
    _chatController.inOfferScreen = false;
    super.dispose();
  }
}
