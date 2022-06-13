import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer.periodic(
      const Duration(seconds: 2),
      (_) async {
        final hasConnection = await AppHelpers.checkConnection();
        if (hasConnection) {
          Get.back();
        }
      },
    );

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: screenSize.width,
                height: screenSize.height * 2 / 3,
                child: Image.asset(
                  'assets/no_internet.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: screenSize.width,
                child: Text(
                  'No Internet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontFamily: 'Mulish',
                    color: AppColors().grey100,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 10.sp,
              ),
              SizedBox(
                width: screenSize.width,
                child: Text(
                  'Your device is not connected to the internet.\nCheck your internet connection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Mulish',
                    color: AppColors().grey100,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
