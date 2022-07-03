import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:resize/resize.dart';

SnackbarController undoDelete(int userListId, String status) {

  final APIs apiController = Get.find<APIs>();
  final AllListController _allListController = Get.find<AllListController>();

  return Get.snackbar(
    '',
    '',
    messageText: Padding(
      padding: const EdgeInsets.only(left: 23.0),
      child: Row(
        children: [
          Text(
            'List has been deleted',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: AppColors().grey60,
            ),
          ),
          InkWell(
            onTap: () async{
              final result = await apiController.undoDeleteUserList(userListId, status);
              if(result==1){
                _allListController.getAllList();
              }
            },
            child: Text(
              'Undo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors().brandDark,
                fontSize: 17.sp,
              ),
            ),
          )
        ],
      ),
    ),
    margin: const EdgeInsets.all(10.0),
    padding: const EdgeInsets.all(8.0),
    //todo definitely remove once done
    duration: const Duration(milliseconds: 3000),
    backgroundColor: Colors.white,
    shouldIconPulse: true,
    boxShadows: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.21),
        blurRadius: 15.0, // soften the shadow
        spreadRadius: 5.0, //extend the shadow
        offset: const Offset(
          0.0,
          0.0,
        ),
      )
    ],
    icon:Padding(
      padding: EdgeInsets.all(18.sp),
      child: Icon(
        CupertinoIcons.exclamationmark_circle_fill,
        color: AppColors().brandDark,
        size: 45,
      ),
    ),
  );
}
