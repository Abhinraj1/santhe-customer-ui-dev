import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/boxes_controller.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:santhe/pages/no_offer_page.dart';
import 'package:santhe/widgets/offer_status_widget.dart';

import '../../models/santhe_user_list_model.dart';
import '../../pages/sent_tab_pages/sent_list_detail_page.dart';

class OfferCard extends StatelessWidget {
  final UserList userList;

  OfferCard({required this.userList, Key? key}) : super(key: key);
  final apiController = Get.find<APIs>();
  final int custId =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;
  final box = Boxes.getUserListDB();

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height / 100;
    // double screenWidth = MediaQuery.of(context).size.width / 100;
    String imagePath = 'assets/basket0.png';

    //image logic
    if (userList.items.isEmpty) {
      imagePath = 'assets/basket0.png';
    } else if (userList.items.length <= 10) {
      imagePath = 'assets/basket1.png';
    } else if (userList.items.length <= 20) {
      imagePath = 'assets/basket2.png';
    } else {
      imagePath = 'assets/basket3.png';
    }

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Padding(
      padding: EdgeInsets.all(15.sp),
      child: GestureDetector(
        onTap: () {
          if (userList.processStatus == 'nomerchant' ||
              userList.processStatus == 'nooffer' ||
              userList.processStatus == 'missed') {
            Get.to(
              () => NoOfferPage(
                userList: userList,
                missed: userList.processStatus == 'missed',
              ),
            );
          } else {
            Get.to(
              () => SentUserListDetailsPage(
                userList: userList,
                showOffers: _showOffer(),
              ),
            );
          }
        },
        child: Container(
          // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.21),
                blurRadius: 15.0, // soften the shadow
                spreadRadius: 3.6, //extend the shadow
                offset: const Offset(
                  0.0,
                  0.0,
                ),
              )
            ],
          ),
          child: Slidable(
            endActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),

              // All actions are defined in the children parameter.
              children: [
                //copy from old list
                Visibility(
                  visible: Boxes.getUserListDB().values.length < 3,
                  child: SlidableAction(
                    onPressed: (context) async {
                      int userListCount =
                          await apiController.getAllCustomerLists(custId);

                      UserList newImportedList = UserList(
                          createListTime: DateTime.now(),
                          custId: userList.custId,
                          items: userList.items,
                          listId: int.parse('$custId${userListCount + 1}'),
                          listName: '(COPY) ${userList.listName}',
                          custListSentTime: userList.custListSentTime,
                          custListStatus: userList.custListStatus,
                          listOfferCounter: userList.listOfferCounter,
                          processStatus: userList.processStatus,
                          custOfferWaitTime: userList.custOfferWaitTime);

                      int response = await apiController.addCustomerList(
                          newImportedList, custId, 'new');

                      if (response == 1) {
                        box.add(newImportedList);
                        Get.to(const HomePage(
                          pageIndex: 0,
                        ));
                      } else {
                        Get.dialog(const Card(
                          child: Center(
                            child: Text('Error!'),
                          ),
                        ));
                      }
                    },
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.orange,
                    autoClose: true,
                    icon: Icons.copy_rounded,
                    label: 'Copy',
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 10.0, left: 15.0, right: 15.0),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 15.sp),
                                child: AutoSizeText(
                                  userList.listName,
                                  maxLines: 2,
                                  style: TextStyle(
                                      letterSpacing: 0.2,
                                      fontSize: 21.sp,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 18.77.sp),
                                child: AutoSizeText(
                                  '${userList.items.length} ${userList.items.length > 1 ? 'Items' : 'Item'}',
                                  style: TextStyle(
                                      fontSize: 36.sp,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 1.sp, bottom: 8.32.sp),
                                child: AutoSizeText(
                                  'Added on ${userList.createListTime.day}/${userList.createListTime.month}/${userList.createListTime.year}',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.transparent,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          imagePath,
                          height: 139.2.sp,
                          width: 139.2.sp,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          'Added on ${userList.createListTime.day}/${userList.createListTime.month}/${userList.createListTime.year}',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xffBBBBBB),
                              fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 6.sp,
                          ),
                          child: OfferStatus(
                            userList: userList,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _showOffer() {
    return (userList.processStatus == 'minoffer' &&
                userList.custOfferWaitTime
                    .toLocal()
                    .isBefore(DateTime.now())) ||
            userList.processStatus == 'maxoffer' ||
            userList.processStatus == 'accepted' ||
            userList.processStatus == 'processed'
        ? true
        : false;
  }
}
