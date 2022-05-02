import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

SnackbarController errorMsg(String title, String body) {
  print(title);
  return Get.snackbar(
    '',
    '',
    titleText: Padding(
      padding: const EdgeInsets.only(left: 23.0),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
            fontSize: 16,
            color: Colors.orange),
      ),
    ),
    messageText: Padding(
      padding: const EdgeInsets.only(left: 23.0),
      child: Text(
        body,
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 16, color: kTextGrey),
      ),
    ),
    margin: const EdgeInsets.all(10.0),
    padding: const EdgeInsets.all(8.0),
    //todo definitely remove once done
    duration: const Duration(milliseconds: 2100),
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
    icon: const Padding(
      padding: EdgeInsets.all(18.0),
      child: Icon(
        CupertinoIcons.exclamationmark_triangle_fill,
        color: Colors.orange,
        size: 45,
      ),
    ),
  );
}
