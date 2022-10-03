import 'dart:io';

import '../core/app_theme.dart';
import '../core/app_colors.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resize/resize.dart';

import 'package:santhe/pages/login_pages/phone_number_login_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

import '../core/app_shared_preference.dart';

//!New Responsive code
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController controller = PageController();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors().brandDark,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: AppColors().brandDark,
      statusBarBrightness: Brightness.dark,
    ));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _showNextButton = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        width: 100.vw,
        height: 100.vh,
        color: AppColors().brandDark,
        child: Column(
          children: [
            SizedBox(
              height: mediaQueryData.padding.top + 20.h,
            ),
            Text(
              'Welcome to',
              style: AppTheme().normal500(24, color: AppColors().white100),
            ),
            Text(
              'Santhe',
              style: AppTheme().bold900(60, color: AppColors().white100),
            ),
            Text(
              'Supporting Local Economy',
              style: AppTheme().normal400(15, color: AppColors().white100),
            ),
            SizedBox(
              height: 55.vh,
              child: PageView(
                controller: controller,
                onPageChanged: (int index) => setState(() {
                  if (index == 2) {
                    _showNextButton = true;
                  } else {
                    _showNextButton = false;
                  }
                }),
                children: [
                  //page 1
                  Column(
                    children: [
                      Image.asset(
                        Platform.isIOS
                            ? 'assets/onboarding1_ios.png'
                            : 'assets/onboarding1.png',
                        height: 350.h,
                        width: 350.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: 70.vw,
                        child: Text(
                          'Create your shopping list',
                          style: TextStyle(
                              fontSize: 21.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  //page 2
                  Column(
                    children: [
                      Image.asset(
                        Platform.isIOS
                            ? 'assets/onboarding2_ios.png'
                            : 'assets/onboarding2.png',
                        height: 350.h,
                        width: 350.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: 70.vw,
                        child: Text(
                          'Send your shopping list to shops near you',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 21.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  //page 3
                  Column(
                    children: [
                      Image.asset(
                        Platform.isIOS
                            ? 'assets/onboarding3_ios.png'
                            : 'assets/onboarding3.png',
                        height: 350.h,
                        width: 350.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: 70.vw,
                        child: Text(
                          'Get great deals while supporting local economy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 21.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: WormEffect(
                  spacing: 15.0,
                  dotColor: Colors.white.withOpacity(0.5),
                  activeDotColor: Colors.white),
            ),
            if (_showNextButton)
              SizedBox(
                height: 25.h,
              ),
            if (_showNextButton)
              SizedBox(
                width: 65.vw,
                child: MaterialButton(
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  onPressed: () {
                    //show login screen for onboarded user
                    AppSharedPreference().setFirstTimeCompleted(true);
                    Get.off(() => const LoginScreen());
                  },
                  color: Colors.white,
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
