import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:santhe/pages/new_tab_pages/user_list_page.dart';
import '../../constants.dart';
import 'package:get/get.dart';

import '../../controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import 'package:santhe/models/santhe_user_list_model.dart';

class UserListCard extends StatelessWidget {
  final UserList userList;
  const UserListCard({required this.userList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    double screenWidth = MediaQuery.of(context).size.width / 100;
    final apiController = Get.find<APIs>();
    String imagePath = 'assets/basket0.png';

    //image logic
    Color clr = Colors.orange;
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
//goto create new list page

          Get.to(() => UserListPage(
                userList: userList,
              ));
        },
        child: Container(
          // padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                            color: kTextGrey,
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
                          Get.closeCurrentSnackbar();
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 18.77.sp),
                          child: AutoSizeText(
                            userList.listName,
                            maxLines: 2,
                            style: GoogleFonts.mulish(
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
                            style: GoogleFonts.mulish(
                                fontSize: 36.sp,
                                color: Colors.orange,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 28.53.sp, bottom: 16.32.sp),
                          child: AutoSizeText(
                            'Added on ${userList.createListTime.day}/${userList.createListTime.month}/${userList.createListTime.year}',
                            style: GoogleFonts.mulish(
                                fontSize: 14.sp,
                                color: const Color(0xffBBBBBB),
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
