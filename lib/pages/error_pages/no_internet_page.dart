import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  late Timer timer;

  void checkInternet(BuildContext context) async{
    final hasConnection = await AppHelpers.checkConnection();
    if (hasConnection) {
      timer.cancel();
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 2),
          (_) => checkInternet(context),
    );
    super.initState();
  }

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
              SizedBox(
                height: 40.sp,
              ),
              InkWell(
                onTap: () => checkInternet(context),
                child: Container(
                  height: 50.sp,
                  width: screenSize.width/3,
                  decoration: BoxDecoration(
                    color: AppColors().brandDark,
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors().white100,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Mulish'
                    ),
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
