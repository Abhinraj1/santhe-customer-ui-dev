import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:get/get.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/models/new_list/list_item_model.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:santhe/widgets/sent_tab_widgets/sent_list_item_card.dart';

import '../models/new_list/user_list_model.dart';

class NoOfferPage extends StatelessWidget {
  NoOfferPage({Key? key, required this.userList, required this.missed})
      : super(key: key);

  final bool missed;

  final UserListModel userList;

  final apiController = Get.find<APIs>();

  final AllListController _allListController = Get.find<AllListController>();
  final formattedPhoneNumber = AppHelpers()
      .getPhoneNumberWithoutFoundedCountryCode(AppHelpers().getPhoneNumber);

  final int custId = int.parse(
      // AppHelpers().getPhoneNumberWithoutCountryCode,
      AppHelpers().getPhoneNumberWithoutFoundedCountryCode(
          AppHelpers().getPhoneNumber));

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool askToRetry = userList.custListStatus != 'archived';

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: (screenSize.height / 100) * 5.5,
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
          userList.listName,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
              color: AppColors().white100,
              width: screenSize.width,
              height: screenSize.height / 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenSize.width / 5,
                    child: Image.asset(
                      'assets/sad_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      missed
                          ? 'Unfortunately, you did not accept any offers for this list.'
                          : 'Unfortunately, there were no offers for this list.',
                      softWrap: true,
                      style: TextStyle(
                        color: kTextGrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (askToRetry)
              SizedBox(
                height: 10.sp,
              ),
            askToRetry
                ? Container(
                    width: screenSize.width,
                    height: screenSize.height / 7,
                    color: AppColors().white100,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Would you like to edit your list and try again?',
                            softWrap: true,
                            style: TextStyle(
                              color: kTextGrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => _allListController.isProcessing.value
                                  ? null
                                  : _allListController.addCopyListToDB(
                                      userList.listId,
                                      moveToArchived: true),
                              splashColor: AppColors().white100,
                              child: Container(
                                height: 50,
                                width: screenSize.width * 0.36,
                                decoration: BoxDecoration(
                                  color: AppColors().brandDark,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: AppColors().white100,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.sp,
                            ),
                            InkWell(
                              onTap: () => _allListController.isProcessing.value
                                  ? null
                                  : _allListController.moveToArchive(userList),
                              splashColor: AppColors().white100,
                              child: Container(
                                height: 50,
                                width: screenSize.width * 0.36,
                                decoration: BoxDecoration(
                                  color: AppColors().grey40,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                    color: AppColors().white100,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: 10.sp,
            ),
            Expanded(
              child: Container(
                color: AppColors().white100,
                child: GroupedListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, bottom: 10, top: 20),
                  elements: userList.items,
                  groupBy: (ListItemModel element) => element.catName,
                  indexedItemBuilder:
                      (BuildContext context, dynamic element, int index) {
                    return SentListItemCard(
                      listItem: element,
                    );
                  },
                  groupSeparatorBuilder: (String value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            color: AppColors().grey100,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          thickness: 1.sp,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
