import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resize/resize.dart';
import 'package:flutter/material.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_initialisations.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/pages/nav_bar_pages/privacy_policy_page.dart';
import 'package:santhe/pages/nav_bar_pages/terms_condition_page.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import 'otpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LogMixin {
  bool isLoading = false;
  final GlobalKey<FormState> key = GlobalKey();
  String? number;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors().white100,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: AppColors().white100,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColors().white100,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //header
            Column(
              children: [
                SizedBox(
                  height: 130.h,
                ),
                Text(
                  "Santhe",
                  style: TextStyle(
                      fontSize: 60.sp,
                      fontWeight: FontWeight.w900,
                      color: Constant.bgColor),
                ),
                Text(
                  "Supporting Local Economy",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Constant.bgColor,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 190.h,
            ),
            //mobile field
            Form(
              key: key,
              child: SizedBox(
                width: 276.w,
                child: Row(
                  children: [
                    // SizedBox(
                    //   width: 50,
                    //   child: TextFormField(
                    //     enabled: false,
                    //     cursorColor: Constant.bgColor,
                    //     decoration: InputDecoration(
                    //       disabledBorder: UnderlineInputBorder(
                    //         borderSide:
                    //             BorderSide(color: Constant.bgColor, width: 2.0),
                    //       ),
                    //       focusedBorder: UnderlineInputBorder(
                    //         borderSide:
                    //             BorderSide(color: Constant.bgColor, width: 2.0),
                    //       ),
                    //       errorBorder: const UnderlineInputBorder(
                    //         borderSide:
                    //             BorderSide(color: Colors.red, width: 2.0),
                    //       ),
                    //       enabledBorder: UnderlineInputBorder(
                    //         borderSide:
                    //             BorderSide(color: Constant.bgColor, width: 2.0),
                    //       ),
                    //       border: UnderlineInputBorder(
                    //         borderSide:
                    //             BorderSide(color: Constant.bgColor, width: 2.0),
                    //       ),
                    //       contentPadding: EdgeInsets.zero,
                    //       label: Text(
                    //         '+91',
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.w900,
                    //           color: Constant.bgColor,
                    //         ),
                    //       ),
                    //     ),
                    //     validator: (String? val) {
                    //       if (number != null &&
                    //           number.toString().length == 10) {
                    //         return null;
                    //       }
                    //       return '';
                    //     },
                    //     readOnly: true,
                    //   ),
                    // ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: IntlPhoneField(
                        focusNode: _focusNode,
                        cursorColor: Constant.bgColor,
                        initialCountryCode: 'IN',
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constant.bgColor, width: 2.0),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constant.bgColor, width: 2.0),
                          ),
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constant.bgColor, width: 2.0),
                          ),
                          // contentPadding: EdgeInsets.zero,
                        ),
                        keyboardType: TextInputType.number,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly,
                        //   LengthLimitingTextInputFormatter(10)
                        // ],
                        onChanged: (phone) {
                          warningLog(phone.completeNumber);
                          number = phone.completeNumber;
                        },
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Constant.bgColor,
                          letterSpacing: 6.sp,
                        ),
                        // validator: (String? val) {
                        //   if (val != null && val.length == 10) {
                        //     return null;
                        //   }
                        //   return 'Valid mobile number required';
                        // },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 22.h,
            ),
            //field sub header
            SizedBox(
              width: 70.vw,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Enter your phone number to ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Constant.bgColor,
                  ),
                  children: [
                    TextSpan(
                      text: "Login ",
                      style: TextStyle(
                          fontSize: 18,
                          color: Constant.bgColor,
                          fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: "or ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Constant.bgColor,
                      ),
                    ),
                    TextSpan(
                      text: "SignUp",
                      style: TextStyle(
                          fontSize: 18,
                          color: Constant.bgColor,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 70.h,
            ),
            //next
            InkWell(
              onTap: () async {
                if (key.currentState!.validate() && !isLoading) {
                  setState(() => isLoading = true);
                  // bool status = await APIs().getLoginStatus(number!);
                  // if (status) {
                  //   setState(() => isLoading = false);
                    Get.to(
                      OtpScreen(phoneNumber: number!),
                    );
                  // } else {
                  //   setState(() => isLoading = false);
                  //   errorMsg(
                  //       'Account Deleted', 'Please use different phone number');
                  // }
                }
              },
              child: Container(
                width: 55.vw,
                decoration: BoxDecoration(
                  color: Constant.bgColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24),
                    child: isLoading
                        ? SizedBox(
                            height: 25.h,
                            width: 25.h,
                            child: CircularProgressIndicator(
                              color: AppColors().white100,
                            ),
                          )
                        : Text(
                            "Next",
                            style: TextStyle(
                                color: Constant.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
            //privacy policy
            SizedBox(
              width: 70.vw,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "By continuing to use the app, you accept our ",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(
                      text: "Terms & Conditions ",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => const TermsAndConditionsPage());
                        },
                      style: TextStyle(
                          fontSize: 13,
                          color: Constant.bgColor,
                          fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(
                      text: "and ",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => const PrivacyPolicyPage());
                        },
                      style: TextStyle(
                          fontSize: 13,
                          color: Constant.bgColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 34.h,
            ),
            //footer
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_circle_fill,
                      color: Colors.orange,
                      size: 12.w,
                    ),
                    const Text(
                      "  If you are a merchant, please use the",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      await launchUrl(
                        Uri.parse(
                            'https://play.google.com/store/apps/details?id=com.santhe.merchant'),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    } else {
                      await launchUrl(
                        Uri.parse(
                            'https://apps.apple.com/in/app/santhe-merchant/id1635267213'),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text(
                    "Santhe Merchant App",
                    style: TextStyle(
                        fontSize: 13,
                        color: Constant.bgColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
