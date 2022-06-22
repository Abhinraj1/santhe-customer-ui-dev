import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:santhe/controllers/notification_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/pages/home_page.dart';

import 'package:santhe/pages/sent_tab_pages/user_list_item_page.dart';

import '../../controllers/api_service_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../models/answer_list_model.dart';
import '../../models/item_model.dart';
import '../../models/santhe_list_item_model.dart';
import '../../models/santhe_user_list_model.dart';
import 'offers_list_page.dart';

class SentUserListDetailsPage extends StatefulWidget {
  UserList? userList;
  final bool showOffers;
  bool? fromChat;
  String? listEventId;
  SentUserListDetailsPage({this.userList, Key? key, required this.showOffers, this.fromChat, this.listEventId})
      : super(key: key);

  @override
  State<SentUserListDetailsPage> createState() => _SentUserListDetailsPageState();
}

class _SentUserListDetailsPageState extends State<SentUserListDetailsPage> {

  final ChatController _chatController = Get.find();
  final NotificationController _notificationController = Get.find();
  final apiController = Get.find<APIs>();
  bool isLoading = true;

  @override
  void initState(){
    _chatController.inOfferScreen = true;
    if(widget.fromChat == true){
      loadDetails();
    }else{
      setState(() => isLoading = false);
    }
    super.initState();
  }

  Future<void> loadDetails() async {
    AnswerList? data = await apiController.getListByListEventId(widget.listEventId!);
    widget.userList = UserList(
        createListTime: DateTime.parse(data!.date).toLocal(),
        custId: int.parse(data.custId),
        items: getList(data.items),
        listId: int.parse(data.listId),
        listName: 'Offer',
        custListSentTime: data.custUpdateTime,
        custListStatus: data.custStatus,
        listOfferCounter: 0,
        processStatus: data.custOfferStatus,
        custOfferWaitTime: DateTime.now()
    );
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
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

    return isLoading ? Container(
      height: 100.vh,
      width: 100.vw,
      color: AppColors().white100,
      child: Center(child: CircularProgressIndicator(color: AppColors().brandDark),),
    ) :
    DefaultTabController(
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
              if(_notificationController.fromNotification){
                _notificationController.fromNotification = false;
                Get.offAll(() => const HomePage(pageIndex: 1), transition: Transition.leftToRight);
              }else{
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
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.grey.shade50,
              child: _tabBar,
            ),
          ),
        ),
        body: WillPopScope(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              OffersListPage(userList: widget.userList!, showOffers: widget.showOffers),
              UserListItemDetailsPage(
                userList: widget.userList!,
              ),
            ],
          ),
          onWillPop: () async{
            if(_notificationController.fromNotification){
              _notificationController.fromNotification = false;
              Get.offAll(() => const HomePage(pageIndex: 1), transition: Transition.leftToRight);
            }else{
              Navigator.pop(context);
            }
            return false;
          },
        ),
      ),
    );
  }

  List<ListItem> getList(List<ItemModel> item){
    List<ListItem> list = [];
    for (var element in item) {
      list.add(ListItem(
          brandType: element.brandType,
          itemId: element.itemId,
          notes: element.itemNotes,
          quantity: num.parse(element.quantity),
          itemName: element.itemName,
          itemImageId: element.itemImageId,
          unit: element.unit,
          catName: element.catName,
          catId: 0,
          possibleUnits: []));
    }
    return list;
  }

  @override
  void dispose(){
    _chatController.inOfferScreen = false;
    super.dispose();
  }
}
