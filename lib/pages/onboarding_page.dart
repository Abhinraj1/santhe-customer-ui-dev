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

// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({Key? key}) : super(key: key);

//   @override
//   _OnboardingPageState createState() => _OnboardingPageState();
// }

// class _OnboardingPageState extends State<OnboardingPage> {
//   final controller = PageController();

//   @override
//   void initState() {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       systemNavigationBarColor: Colors.orange,
//       systemNavigationBarIconBrightness: Brightness.light,
//       statusBarColor: Colors.orange,
//       statusBarBrightness: Brightness.dark,
//     ));
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width / 100;

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         color: Colors.orange,
//         child: PageView(
//           controller: controller,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     AutoSizeText(
//                       'Welcome to',
//                       style: TextStyle(
//                         fontSize: 24.sp,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     AutoSizeText(
//                       'Santhe',
//                       style: TextStyle(
//                           fontSize: 60.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w900),
//                     ),
//                     AutoSizeText(
//                       'Supporting Local Economy',
//                       style: TextStyle(
//                           fontSize: 15.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w400),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Image.asset(
//                       Platform.isIOS
//                           ? 'assets/onboarding1_ios.png'
//                           : 'assets/onboarding1.png',
//                       height: 344.sp,
//                       width: 344.sp,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     AutoSizeText(
//                       'Create your shopping list',
//                       style: TextStyle(
//                           fontSize: 21.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     SmoothPageIndicator(
//                       controller: controller,
//                       count: 3,
//                       onDotClicked: (index) {
//                         controller.animateToPage(index,
//                             duration: const Duration(milliseconds: 900),
//                             curve: Curves.ease);
//                       },
//                       effect: WormEffect(
//                           spacing: 15.0,
//                           dotColor: Colors.white.withOpacity(0.5),
//                           activeDotColor: Colors.white),
//                     ),
//                     const SizedBox(height: 25.0),
//                     SizedBox(
//                       width: screenWidth * 60,
//                       height: 50.0,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     AutoSizeText(
//                       'Welcome to',
//                       style: TextStyle(
//                         fontSize: 24.sp,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     AutoSizeText(
//                       'Santhe',
//                       style: TextStyle(
//                           fontSize: 60.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w900),
//                     ),
//                     AutoSizeText(
//                       'Supporting Local Economy',
//                       style: TextStyle(
//                           fontSize: 15.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w400),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Image.asset(
//                       Platform.isIOS
//                           ? 'assets/onboarding2_ios.png'
//                           : 'assets/onboarding2.png',
//                       height: 344.sp,
//                       width: 344.sp,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                       child: AutoSizeText(
//                         'Send your shopping list to shops near you',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 21.sp,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     SmoothPageIndicator(
//                       controller: controller,
//                       count: 3,
//                       onDotClicked: (index) {
//                         controller.animateToPage(index,
//                             duration: const Duration(milliseconds: 900),
//                             curve: Curves.ease);
//                       },
//                       effect: WormEffect(
//                           spacing: 15.0,
//                           dotColor: Colors.white.withOpacity(0.5),
//                           activeDotColor: Colors.white),
//                     ),
//                     const SizedBox(height: 25.0),
//                     SizedBox(
//                       width: screenWidth * 60,
//                       height: 50.0,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     AutoSizeText(
//                       'Welcome to',
//                       style: TextStyle(
//                         fontSize: 24.sp,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     AutoSizeText(
//                       'Santhe',
//                       style: TextStyle(
//                           fontSize: 60.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w900),
//                     ),
//                     AutoSizeText(
//                       'Supporting Local Economy',
//                       style: TextStyle(
//                           fontSize: 15.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w400),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Image.asset(
//                       Platform.isIOS
//                           ? 'assets/onboarding3_ios.png'
//                           : 'assets/onboarding3.png',
//                       height: 344.sp,
//                       width: 344.sp,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                       child: AutoSizeText(
//                         'Get great deals while supporting local economy',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 21.sp,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     SmoothPageIndicator(
//                       controller: controller,
//                       count: 3,
//                       onDotClicked: (index) {
//                         controller.animateToPage(index,
//                             duration: const Duration(milliseconds: 900),
//                             curve: Curves.ease);
//                       },
//                       effect: WormEffect(
//                           spacing: 15.0,
//                           dotColor: Colors.white.withOpacity(0.5),
//                           activeDotColor: Colors.white),
//                     ),
//                     const SizedBox(height: 25.0),
//                     SizedBox(
//                       width: screenWidth * 65,
//                       height: 50.0,
//                       child: MaterialButton(
//                         elevation: 0.0,
//                         highlightElevation: 0.0,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16.0)),
//                         onPressed: () {
//                           //show login screen for onboarded user
//                           AppSharedPreference().setFirstTimeCompleted(true);
//                           Get.off(() => const LoginScreen());
//                         },
//                         color: Colors.white,
//                         child: AutoSizeText(
//                           'Get Started',
//                           style: TextStyle(
//                               color: Colors.orange,
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w700),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
