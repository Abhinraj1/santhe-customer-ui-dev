import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:santhe/controllers/getx/new_list_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:get/get.dart';

import '../../core/app_colors.dart';
import '../../models/new_list/user_list_model.dart';

class UserListCard extends StatelessWidget {
  final UserListModel userList;

  UserListCard({Key? key, required this.userList})
      : super(key: key);
  final int custId = int.parse(AppHelpers().getPhoneNumberWithoutCountryCode);
  final NewListController _newListController = Get.find();

  @override
  Widget build(BuildContext context) {
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

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () async {
          //print(userList.items.first.quantity);
         // Get.to(() => UserListPage(userList: userList, userKey: userKey));
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
                  visible: _newListController.newList.length < _newListController.lengthLimit,
                  child: SlidableAction(
                    onPressed: (context) async {
                      _newListController.addCopyListToDB(userList.listId);
                    },
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.orange,
                    autoClose: true,
                    icon: Icons.copy_rounded,
                    label: 'Copy',
                  ),
                ),
                //delete list
                SlidableAction(
                  onPressed: (context) async {
                    int pressCount = 0;
                    _newListController.deleteListFromDB(userList.listId);
                    //undo feature
                    /*Get.snackbar(
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
                        style: TextStyle(
                            color: AppColors().grey100,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                      mainButton: TextButton(
                        onPressed: () async {
                          *//*Get.closeCurrentSnackbar();
                          if (pressCount < 1) {
                            Future.delayed(const Duration(seconds: 1),
                                () async {
                              int response = await apiController
                                  .undoDeleteUserList(userList.listId, "new");
                              if (response == 1) {
                                Boxes.getUserListDB().add(userList);
                              } else {
                                errorMsg('Unable to undo the list', '');
                              }
                            });
                          }
                          pressCount++;
                          if (box.length >= 2) {
                            Get.offAll(() => const HomePage(),
                                transition: Transition.fadeIn);
                          }*//*
                        },
                        child: const Text(
                          'Undo',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ),
                    );*/
                    if (pressCount == 0) {
                      /*apiController.deletedUserLists.add(userList);

                      int response =
                          await apiController.deleteUserList(userList.listId);

                      if (response == 1) {
                        apiController.deletedUserLists.remove(userList);
                      }*/
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
