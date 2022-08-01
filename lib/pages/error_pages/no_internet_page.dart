import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:santhe/controllers/connectivity_controller.dart';
import 'package:santhe/core/app_colors.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {

  final ConnectivityController _connectivityController = Get.find();

  @override
  Widget build(BuildContext context) {
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
                onTap: () => _connectivityController.checkConnectivity(),
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
