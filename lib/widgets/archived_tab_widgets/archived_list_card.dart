import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/pages/no_offer_page.dart';
import 'package:santhe/pages/sent_tab_pages/merchant_items_list_page.dart';
import 'package:santhe/widgets/offer_status_widget.dart';

import '../../models/new_list/user_list_model.dart';

class ArchivedUserListCard extends StatelessWidget {
  final UserListModel userList;

  const ArchivedUserListCard({required this.userList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/basket0.png';
    final AllListController allListController = Get.find<AllListController>();

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

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: (){
          if (userList.processStatus == 'nomerchant' ||
              userList.processStatus == 'nooffer' ||
              userList.processStatus == 'missed') {
            Get.to(
                  () => NoOfferPage(
                userList: userList,
                missed: userList.processStatus == 'missed',
              ),
            );
          } else if (userList.processStatus == 'accepted' ||
              userList.processStatus == 'processed') {
            Get.to(
                  () => MerchantItemsListPage(
                userList: userList,
                archived: true,
              ),
            );
          }
        },
        child: Container(
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
              motion: const ScrollMotion(),
              children: [
                //copy from old list
                Visibility(
                  visible: allListController.newList.length < allListController.lengthLimit,
                  child: SlidableAction(
                    onPressed: (context) => allListController.addCopyListToDB(userList.listId),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.orange,
                    autoClose: true,
                    icon: Icons.copy_rounded,
                    label: 'Copy',
                  ),
                ),
                //delete list
                SlidableAction(
                  onPressed: (context) => allListController.deleteListFromDB(userList.listId, 'archived'),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.orange,
                  icon: CupertinoIcons.delete_solid,
                  label: 'Delete',
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 10.0, left: 15.0, right: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              userList.listName,
                              maxLines: 2,
                              style: TextStyle(
                                  letterSpacing: 0.2,
                                  fontSize: 20.sp,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w400),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.sp),
                              child: AutoSizeText(
                                '${userList.items.length} ${userList.items.length > 1 ? 'Items' : 'Item'}',
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 1.sp, bottom: 8.32.sp),
                              child: AutoSizeText(
                                'Added on ${userList.createListTime.day}/${userList.createListTime.month}/${userList.createListTime.year}',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.transparent,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        imagePath,
                        height: 129.sp,
                        width: 129.sp,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Added on ${userList.createListTime.day}/${userList.createListTime.month}/${userList.createListTime.year}',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xffBBBBBB),
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 10.sp,
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
    );
  }
}
