import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/boxes_controller.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:get/get.dart';

import '../../models/santhe_user_list_model.dart';
import '../../pages/sent_tab_pages/sent_list_detail_page.dart';

class OfferCard extends StatelessWidget {
  final UserList userList;
  OfferCard({required this.userList, Key? key})
      : super(key: key);
  final apiController = Get.find<APIs>();
  final int custId =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;
  final box = Boxes.getUserListDB();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    double screenWidth = MediaQuery.of(context).size.width / 100;
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
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Get.to(() => SentUserListDetailsPage(
                userList: userList,
                showOffers: _showOffer(),
              ));
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
                // //delete list
                // SlidableAction(
                //   onPressed: (context) async {
                //     int pressCount = 0;
                //     //delete userList from DB
                //     final box = Boxes.getUserListDB();
                //     userList.delete();
                //     //undo feature
                //     Get.snackbar(
                //       '',
                //       '',
                //       duration: const Duration(milliseconds: 4000),
                //       snackPosition: SnackPosition.BOTTOM,
                //       icon: const Icon(
                //           CupertinoIcons.exclamationmark_circle_fill,
                //           color: Colors.orange,
                //           size: 15),
                //       snackStyle: SnackStyle.FLOATING,
                //       shouldIconPulse: true,
                //       backgroundColor: Colors.white,
                //       margin: const EdgeInsets.all(12.0),
                //       padding: const EdgeInsets.all(12.0),
                //       titleText: const Text('List Deleted'),
                //       messageText: Text(
                //         'List has been deleted',
                //         style: TextStyle(
                //             color: AppColors().grey100,
                //             fontWeight: FontWeight.w400,
                //             fontSize: 15),
                //       ),
                //       mainButton: TextButton(
                //         onPressed: () async {
                //           Get.closeCurrentSnackbar();
                //           if (pressCount < 1) {
                //             Future.delayed(const Duration(seconds: 1),
                //                 () async {
                //               int response = await apiController
                //                   .undoDeleteUserList(userList.listId, "sent");
                //               _sentItemsController.sentItems
                //                   .insert(index, userList);
                //               _sentItemsController.update();
                //               if (response == 1) {
                //                 // Boxes.getUserListDB().add(userList);
                //               } else {
                //                 errorMsg('Unable to undo the list', '');
                //               }
                //             });
                //           }
                //           pressCount++;
                //           if (box.length >= 2) {
                //             Get.offAll(() => const HomePage(),
                //                 transition: Transition.fadeIn);
                //           }
                //         },
                //         child: const Text(
                //           'Undo',
                //           style: TextStyle(
                //               color: Colors.orange,
                //               fontWeight: FontWeight.w700,
                //               fontSize: 15),
                //         ),
                //       ),
                //     );
                //     if (pressCount == 0) {
                //       apiController.deletedUserLists.add(userList);

                //       int response =
                //           await apiController.deleteUserList(userList.listId);

                //       if (response == 1) {
                //         apiController.deletedUserLists.remove(userList);
                //         _sentItemsController.sentItems.removeAt(index);
                //         _sentItemsController.update();
                //       }
                //     }

                //     //for bringing Floating Action Button
                //     if (box.length >= 2) {
                //       Get.offAll(() => const HomePage(),
                //           transition: Transition.fadeIn);
                //     }
                //   },
                //   backgroundColor: Colors.transparent,
                //   foregroundColor: Colors.orange,
                //   icon: CupertinoIcons.delete_solid,
                //   label: 'Delete',
                // ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 10.0, left: 15.0, right: 15.0),
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
                            AutoSizeText(
                              userList.listName,
                              maxLines: 2,
                              style: TextStyle(
                                  letterSpacing: 0.2,
                                  fontSize: 21.sp,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w400),
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
                        //todo fix this
                        padding: const EdgeInsets.only(right: 0),
                        child: Row(
                          children: [
                            //nooofer
                            userList.processStatus == 'nooffer' ||
                                    userList.processStatus == 'noMerchants'
                                ? AutoSizeText(
                                    'No Offers',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400),
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            //processed
                            userList.processStatus == 'processed'
                                ? AutoSizeText(
                                    'Accepted',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w400),
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            //minoffer
                            _showOffer()
                                ? AutoSizeText(
                                    'Waiting for offers',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color(0xffFFC300),
                                        fontWeight: FontWeight.w400),
                                  )
                                : userList.processStatus == 'Accepted'
                                    ? AutoSizeText(
                                        '${userList.listOfferCounter} ${userList.listOfferCounter < 2 ? 'Offer Available' : 'Offers Available'} ',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w400),
                                      )
                                    : SizedBox(),
                            //minoffer
                            userList.processStatus == 'maxoffer'
                                ? AutoSizeText(
                                    '${userList.listOfferCounter} Offers Available',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w400),
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            //expired
                            userList.processStatus == 'expired'
                                ? AutoSizeText(
                                    'Offers Missed',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400),
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            const SizedBox(width: 3),
                            //ICON ICON ICON
                            //draft
                            //noofffer & nomerchants
                            userList.processStatus == 'nooffer' ||
                                    userList.processStatus == 'noMerchants'
                                ? Icon(
                                    CupertinoIcons.xmark_circle_fill,
                                    color: Colors.red,
                                    size: 18.sp,
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            //processed
                            userList.processStatus == 'processed'
                                ? Icon(
                                    CupertinoIcons.checkmark_alt_circle_fill,
                                    color: Colors.green,
                                    size: 18.sp,
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            //minoffer
                            _showOffer()
                                ? Icon(
                                    CupertinoIcons.time_solid,
                                    color: Colors.orangeAccent,
                                    size: 18.sp,
                                  )
                                : userList.processStatus == 'Accepted'
                                    ? Icon(
                                        CupertinoIcons.hand_thumbsup,
                                        color: Colors.orangeAccent,
                                        size: 18.sp,
                                      )
                                    : const SizedBox(),
                            //max offer
                            if (userList.processStatus == 'maxoffer')
                              Icon(
                                CupertinoIcons.hand_thumbsup_fill,
                                color: Colors.deepPurple,
                                size: 18.sp,
                              ),
                            //expired
                            if (userList.processStatus == 'expired')
                              Icon(
                                CupertinoIcons.exclamationmark_circle_fill,
                                color: Colors.grey,
                                size: 18.sp,
                              )
                          ],
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

  bool _showOffer() {
    return (userList.processStatus == 'minoffer' &&
                userList.custListSentTime.toLocal().isBefore(DateTime.now())) ||
            userList.processStatus == 'draft' ||
            userList.processStatus == 'processing' ||
            userList.processStatus == 'waiting'
        ? true
        : false;
  }
}
