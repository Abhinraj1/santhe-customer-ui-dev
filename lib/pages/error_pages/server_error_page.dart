import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';

class ServerErrorPage extends StatelessWidget{
  const ServerErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
                'assets/server_error.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: screenSize.width,
              child: Text(
                'Error!!',
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
                'Something went wrong.\nPlease try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Mulish',
                  color: AppColors().grey100,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 60.sp,
            ),
            InkWell(
              onTap: () => Get.back(),
              splashColor: AppColors().white100,
              child: Container(
                height: 50.sp,
                width: screenSize.width/3,
                decoration: BoxDecoration(
                  color: AppColors().brandDark,
                  borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                alignment: Alignment.center,
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: AppColors().white100,
                    fontFamily: 'Mulish',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}