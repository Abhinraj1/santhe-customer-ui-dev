import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:santhe/REEEEEEEEEEE/api_test/test.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:santhe/pages/new_tab_pages/user_list_page.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import '../../constants.dart';
import 'package:get/get.dart';

import '../../controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import 'package:santhe/models/santhe_user_list_model.dart';

class UserListCard extends StatelessWidget {
  final UserList userList;
  final box = Boxes.getUserListDB();
  final int userKey;
  UserListCard({required this.userList, Key? key, required this.userKey})
      : super(key: key);
  final int custId =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;

  @override
  Widget build(BuildContext context) {
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
          //print(userList.items.first.quantity);
          Get.to(() => UserListPage(userList: userList, userKey: userKey));
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
                      UserList oldUserList = Boxes.getUserListDB()
                          .values
                          .firstWhere(
                              (element) => element.listId == userList.listId);

                      UserList newImportedList = UserList(
                          createListTime: DateTime.now(),
                          custId: oldUserList.custId,
                          items: oldUserList.items,
                          listId: int.parse('$custId${userListCount + 1}'),
                          listName: '(COPY) ${oldUserList.listName}',
                          custListSentTime: oldUserList.custListSentTime,
                          custListStatus: oldUserList.custListStatus,
                          listOfferCounter: oldUserList.listOfferCounter,
                          processStatus: oldUserList.processStatus,
                          custOfferWaitTime: oldUserList.custOfferWaitTime);

                      int response = await apiController.addCustomerList(
                          newImportedList, custId, 'new');

                      if (response == 1) {
                        box.add(newImportedList);
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
                //delete list
                SlidableAction(
                  onPressed: (context) async {
                    int pressCount = 0;

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
                        style: TextStyle(
                            color: AppColors().grey100,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                      mainButton: TextButton(
                        onPressed: () async {
                          Get.closeCurrentSnackbar();
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
                          }
                        },
                        child: const Text(
                          'Undo',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ),
                    );
                    if (pressCount == 0) {
                      apiController.deletedUserLists.add(userList);

                      int response =
                          await apiController.deleteUserList(userList.listId);

                      if (response == 1) {
                        apiController.deletedUserLists.remove(userList);
                      }
                    }

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
                              EdgeInsets.only(top: 28.53.sp, bottom: 16.32.sp),
                          child: AutoSizeText(
                            'Added on ${userList.createListTime.day}/${userList.createListTime.month}/${userList.createListTime.year}',
                            style: TextStyle(
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
