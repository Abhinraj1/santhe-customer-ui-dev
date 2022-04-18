import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:santhe/widgets/confirmation_widgets/success_snackbar_widget.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:get/get.dart';

import '../../controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import '../../models/santhe_user_list_model.dart';
import '../customer_registration_pages/customer_registration.dart';
import '../home_page.dart';

class OtpPage extends StatefulWidget {
  final int userPhone;
  final String sessionInfo;
  const OtpPage({required this.sessionInfo, required this.userPhone, Key? key})
      : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  bool showError = false;
  bool isLoading = false;
  bool resendOtpActive = false;
  final CountdownController _countdownController =
      CountdownController(autoStart: true);

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  String formatedTime(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        getParsedTime(min.toString()) + " : " + getParsedTime(sec.toString());

    return parsedTime;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    final String sessionInfo = widget.sessionInfo;
    final int userPhone = widget.userPhone;
    const length = 6;
    const borderColor = Colors.orange;
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Colors.transparent;
    final defaultPinTheme = PinTheme(
      width: screenWidth * 12,
      height: screenWidth * 15,
      textStyle: GoogleFonts.mulish(
          fontSize: screenWidth * 6,
          color: Colors.orange,
          fontWeight: FontWeight.w700),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.grey),
      ),
    );

    final apiController = Get.find<APIs>();
    print("PHONE NUMBER: $userPhone");
    // int userPhone = Boxes.getUserCredentialsDB()
    //         .get('currentUserCredentials')
    //         ?.phoneNumber ??
    //     404;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: 0.9.sh,
            width: 1.sw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 130.h),
                  child: Column(
                    children: [
                      Text(
                        'Santhe',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mulish(
                          color: Colors.orange,
                          fontWeight: FontWeight.w900,
                          fontSize: 60.sp,
                          letterSpacing: -0.02.w,
                        ),
                      ),
                      Text(
                        'Supporting local economy',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mulish(
                          fontWeight: FontWeight.w400,
                          color: Colors.orange,
                          fontSize: 15.sp,
                          letterSpacing: -0.02.w,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: screenWidth * 20,
                      width: screenWidth * 95,
                      child: Pinput(
                        length: length,
                        controller: controller,
                        focusNode: focusNode,
                        defaultPinTheme: defaultPinTheme,
                        showError: showError,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          width: screenWidth * 15,
                          height: screenWidth * 17,
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(color: borderColor),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyBorderWith(
                          border: Border.all(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 34.h),
                      child: isLoading
                          ? const CircularProgressIndicator.adaptive()
                          : Text(
                              showError
                                  ? 'OTP is Incorrect'
                                  : 'Enter OTP to verify',
                              style: GoogleFonts.mulish(
                                  fontWeight: showError
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  fontSize: 18.sp,
                                  color: showError
                                      ? kErrorTextRedColor
                                      : Colors.orange),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 58.h),
                      child: SizedBox(
                        height: 55.h,
                        width: 244.w,
                        child: MaterialButton(
                          elevation: 0.0,
                          highlightElevation: 0.0,
                          onPressed: () async {
                            // Get.to(() => const OtpPage());

                            int enteredOtp = int.parse(controller.text);
                            print('--> OTP: $enteredOtp');
                            if (controller.text.isEmpty ||
                                controller.text.length != 6) {
                              setState(() {
                                showError = true;
                              });
                            } else if (controller.text.length == 6) {
                              setState(() {
                                isLoading = true;
                              });

                              bool userVerified = await apiController.verifyOTP(
                                  sessionInfo, enteredOtp);

                              if (userVerified) {
                                Boxes.getUserPrefs().put('isLoggedIn', true);
                                Boxes.getUserPrefs().put('showHome', false);
                                Boxes.getUserPrefs().put('isRegistered', false);

//skipping check and sending existing user directly to HomePage
//                                 Boxes.getUserCredentialsDB()
//                                     .get('currentUserCredentials')
//                                     ?.isNewUser ??
//                                     false

                                int response = await apiController
                                    .getCustomerInfo(userPhone);

                                if (response == 0) {
                                  //if new user, get them registered

                                  print("--------$userPhone--------");
                                  //to not show start from old list to new user (code is inside of registration page), get's triggerd only after successful registration
                                  _countdownController.pause();
                                  if (userPhone == 404) return;
                                  Get.off(
                                      () => UserRegistrationPage(
                                          userPhoneNumber: userPhone),
                                      transition: Transition.fadeIn);
                                } else {
                                  //Send user to Home Page directly as they r pre existing
                                  //take data from firebase & add
//response will auto add it to hive.

                                  Boxes.getUserPrefs().put('isLoggedIn', true);
                                  Boxes.getUserPrefs().put('showHome', true);
                                  Boxes.getUserPrefs()
                                      .put('isRegistered', true);

                                  //getting and adding old lists to offline db
                                  List<UserList> newStatusUserLists =
                                      await apiController
                                          .getNewCustList(userPhone);
                                  Boxes.getUserListDB()
                                      .addAll(newStatusUserLists);

                                  _countdownController.pause();
                                  Get.off(() => const HomePage(),
                                      transition: Transition.fadeIn);
                                }
                                setState(() {
                                  showError = false;
                                });
                              } else {
                                controller.text = '';
                                // errorMsg('Invalid OTP!',
                                //     'Please enter the correct OTP verify.');
                                setState(() {
                                  showError = true;
                                });
                              }

                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            } else {
                              print('ERROROROROROOROROR');
                            }
                          },
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            'Next',
                            style: GoogleFonts.mulish(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.h),
                      child: Column(
                        children: [
                          Countdown(
                            controller: _countdownController,
                            seconds: 120,
                            build: (BuildContext context, double time) {
                              ScreenUtil.init(
                                  BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width,
                                      maxHeight:
                                          MediaQuery.of(context).size.height),
                                  designSize: const Size(390, 844),
                                  context: context,
                                  minTextAdapt: true,
                                  orientation: Orientation.portrait);
                              return Column(
                                children: [
                                  TextButton(
                                    child: Text(
                                      'Resend OTP',
                                      style: GoogleFonts.mulish(
                                          color: resendOtpActive
                                              ? Colors.orange
                                              : Colors.grey,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.sp),
                                    ),
                                    onPressed: () async {
                                      //todo implement resend feature
                                      if (resendOtpActive) {
                                        await apiController.getOTP(userPhone);
                                        successMsg('OTP Resent!',
                                            'Please await a new OTP, then verify to continue...');

                                        setState(() {
                                          resendOtpActive = false;
                                        });
                                        _countdownController.restart();
                                      } else {}
                                    },
                                  ),
                                  Visibility(
                                    visible: !resendOtpActive,
                                    child: AutoSizeText(
                                      'Please wait for ${time.toInt() < 60 ? time.toInt().toString() : formatedTime(time.toInt())} ${time.toInt() < 60 ? time.toInt() < 2 ? 'second' : 'seconds' : 'minutes'} to resend OTP',
                                      style: GoogleFonts.mulish(
                                          color: Colors.grey),
                                    ),
                                  ),
                                ],
                              );
                            },
                            interval: const Duration(milliseconds: 500),
                            onFinished: () {
                              print('Resend OTP is now Active!');

                              setState(() {
                                resendOtpActive = true;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
