import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/boxes_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/models/santhe_user_list_model.dart';
import 'package:santhe/pages/home_page.dart';

class ArchivedUserListCard extends StatelessWidget {
  final UserList userList;
  const ArchivedUserListCard({required this.userList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    double screenWidth = MediaQuery.of(context).size.width / 100;
    final apiController = Get.find<APIs>();
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
          //todo
          print('UserList Process Status: ${userList.processStatus}');
          // Get.to(() => ArchivedUserListPage(
          //       userList: userList,
          //     ));
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
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.orange,
                  autoClose: true,
                  icon: Icons.copy_rounded,
                  label: 'Copy',
                ),
                SlidableAction(
                  onPressed: (context) async {
                    //todo implement delete feature for archive lists
                    int pressCount = 0;
                    apiController.deletedUserLists.add(userList);

                    Future.delayed(const Duration(milliseconds: 5000),
                        () async {
                      print('Deleting list - 4 Sec Elapsed!');
                      int response =
                          await apiController.deleteUserList(userList.listId);

                      if (response == 1) {
                        apiController.deletedUserLists.remove(userList);
                      }
                    });

                    //delete userList from DB
                    final box = Boxes.getUserListDB();
                    userList.delete();

                    //undo feature
                    Get.snackbar(
                      '',
                      '',
                      duration: const Duration(milliseconds: 4000),
                      snackPosition: SnackPosition.BOTTOM,
                      icon: const Icon(
                          CupertinoIcons.exclamationmark_circle_fill,
                          color: Colors.orange,
                          size: 15),
                      snackStyle: SnackStyle.FLOATING,
                      shouldIconPulse: true,
                      backgroundColor: Colors.white,
                      margin: const EdgeInsets.all(12.0),
                      padding: const EdgeInsets.all(12.0),
                      titleText: const Text('List Deleted'),
                      messageText: Text(
                        'List has been deleted',
                        style: GoogleFonts.mulish(
                            color: AppColors().grey100,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                      mainButton: TextButton(
                        onPressed: () {
                          print('Undo Button Pressed');
                          if (pressCount < 1) {
                            Boxes.getUserListDB().add(userList);
                          }
                          pressCount++;
                          if (box.length >= 2) {
                            Get.offAll(() => const HomePage(),
                                transition: Transition.fadeIn);
                          }
                        },
                        child: Text(
                          'Undo',
                          style: GoogleFonts.mulish(
                              color: Colors.orange,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ),
                    );

                    //for bringing Floating Action Button
                    if (box.length >= 2) {
                      Get.offAll(() => const HomePage(),
                          transition: Transition.fadeIn);
                    }
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.orange,
                  icon: CupertinoIcons.delete_solid,
                  label: 'Delete',
                ),
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
                              style: GoogleFonts.mulish(
                                  letterSpacing: 0.2,
                                  fontSize: 21.sp,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w400),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 18.77.sp),
                              child: AutoSizeText(
                                '${userList.items.length} ${userList.items.length > 1 ? 'Items' : 'Item'}',
                                style: GoogleFonts.mulish(
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
                                style: GoogleFonts.mulish(
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
                        style: GoogleFonts.mulish(
                            fontSize: 14.sp,
                            color: const Color(0xffBBBBBB),
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        //todo fix this
                        padding: const EdgeInsets.only(right: 0),
                        child: Row(
                          children: [
                            //TEXT TEXT TEXT
                            //draft
                            userList.processStatus == 'draft' ||
                                    userList.processStatus == 'processing' ||
                                    userList.processStatus == 'waiting'
                                ? AutoSizeText(
                                    'Waiting for Offers',
                                    style: GoogleFonts.mulish(
                                        fontSize: 14.sp,
                                        color: const Color(0xffFFC300),
                                        fontWeight: FontWeight.w400),
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            //nooofer
                            userList.processStatus == 'nooffer' ||
                                    userList.processStatus == 'noMerchants'
                                ? AutoSizeText(
                                    'No Offers',
                                    style: GoogleFonts.mulish(
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
                                    style: GoogleFonts.mulish(
                                        fontSize: 14.sp,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w400),
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            //minoffer
                            userList.processStatus == 'minoffer'
                                ? AutoSizeText(
                                    '${userList.listOfferCounter} ${userList.listOfferCounter < 2 ? 'Offer Available' : 'Offers Available'} ',
                                    style: GoogleFonts.mulish(
                                        fontSize: 14.sp,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w400),
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            //minoffer
                            userList.processStatus == 'maxoffer'
                                ? AutoSizeText(
                                    '${userList.listOfferCounter} Offers Available',
                                    style: GoogleFonts.mulish(
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
                                    style: GoogleFonts.mulish(
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
                            userList.processStatus == 'draft' ||
                                    userList.processStatus == 'waiting' ||
                                    userList.processStatus == 'processing'
                                ? Icon(
                                    CupertinoIcons.time_solid,
                                    color: const Color(0xffFFC300),
                                    size: 18.sp,
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
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
                            userList.processStatus == 'minoffer'
                                ? Icon(
                                    CupertinoIcons.hand_thumbsup,
                                    color: Colors.orangeAccent,
                                    size: 18.sp,
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            //minoffer
                            userList.processStatus == 'maxoffer'
                                ? Icon(
                                    CupertinoIcons.hand_thumbsup_fill,
                                    color: Colors.deepPurple,
                                    size: 18.sp,
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
                            //expired
                            userList.processStatus == 'expired'
                                ? Icon(
                                    CupertinoIcons.exclamationmark_circle_fill,
                                    color: Colors.grey,
                                    size: 18.sp,
                                  )
                                : const Visibility(
                                    visible: false,
                                    child: SizedBox(),
                                  ),
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
}
