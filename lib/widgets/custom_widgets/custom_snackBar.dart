import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/manager/font_manager.dart';


customSnackBar({required String message, bool? isErrorMessage, bool? showOnTop}){

  Get.snackbar(
  "",
    "",

    messageText: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: isErrorMessage ?? false ?
              Icon(Icons.error_outline,
                  color: AppColors().red100,
                  size: 35) :
              Icon(Icons.check_circle_outline,
                  color: AppColors().green100,
              size: 35),
            ),
            SizedBox(
              width: 260,
              child: AutoSizeText(message,
                style:
                isErrorMessage ?? false ?
                FontStyleManager().s18fw700Red :
                FontStyleManager().s18fw700Green,
              textAlign: TextAlign.center,
              minFontSize: 16,
              maxLines: 3),
            ),
          ],
        )),
    snackPosition: showOnTop ?? false ? SnackPosition.TOP : SnackPosition.BOTTOM,
    backgroundColor:AppColors().white100,
    borderRadius: 20,
    padding: EdgeInsets.only(bottom: 25,left: 10,right: 10),

    margin: EdgeInsets.all(15),
    colorText: Colors.white,
    duration: Duration(seconds: 4),
    isDismissible: true,
    // dismissDirection: SnackDismissDirection.HORIZONTAL,
    forwardAnimationCurve: Curves.easeOutBack,

  );
}