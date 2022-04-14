import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../controllers/api_service_controller.dart';
import 'otp_validation_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String userPhone = '';
  bool isLoading = false;
  bool isPhoneNumberWrong = false;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.orange,
      statusBarBrightness: Brightness.dark,
    ));
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

    var apiServiceController = Get.find<APIs>();

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 0.1.sw,
                          child: TextField(
                            decoration: InputDecoration(
                              errorText: ' ',
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.orange,
                              )),
                              errorStyle: TextStyle(
                                color: Colors.transparent,
                              ),
                              hintStyle: GoogleFonts.mulish(
                                color: Colors.orange,
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp,
                              ),
                              disabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.orange,
                              )),
                              hintText: '+91',
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0.6.sw,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              autofocus: true,
                              onChanged: (value) {
                                userPhone = value;
                              },
                              validator: (value) {
                                final RegExp phoneRegExp =
                                    RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    isPhoneNumberWrong = true;
                                  });
                                  return 'Please enter your phone number here';
                                } else if (value.length != 10) {
                                  setState(() {
                                    isPhoneNumberWrong = true;
                                  });
                                  return 'Please enter a proper 10 digit number';
                                } else if (!phoneRegExp.hasMatch(value)) {
                                  setState(() {
                                    isPhoneNumberWrong = true;
                                  });
                                  return 'Please enter a valid phone number';
                                } else {
                                  setState(() {
                                    isPhoneNumberWrong = false;
                                  });
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                errorText: ' ',
                                errorStyle: GoogleFonts.mulish(
                                  fontWeight: FontWeight.w500,
                                  color: kErrorTextRedColor,
                                  fontSize: 13.sp,
                                ),
                                errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: kErrorTextRedColor,
                                )),
                                focusedErrorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2.0)),
                                disabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.orange,
                                  ),
                                ),
                                hintText: 'Enter Your Number',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                hintStyle: GoogleFonts.mulish(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16.sp,
                                ),
                              ),
                              style: GoogleFonts.mulish(
                                  color: isPhoneNumberWrong
                                      ? kErrorTextRedColor
                                      : Colors.orange,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: isLoading
                          ? const CircularProgressIndicator.adaptive()
                          : RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: 'Enter your phone number to ',
                                  style: GoogleFonts.mulish(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.sp),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Login\n',
                                      style: GoogleFonts.mulish(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.sp),
                                    ),
                                    TextSpan(
                                      text: 'or',
                                      style: GoogleFonts.mulish(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.sp),
                                    ),
                                    TextSpan(
                                      text: ' Sign up',
                                      style: GoogleFonts.mulish(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.sp),
                                    ),
                                  ]),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 70.h),
                      child: SizedBox(
                        height: 55.h,
                        width: 244.w,
                        child: MaterialButton(
                          elevation: 0.0,
                          highlightElevation: 0.0,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              Future.delayed(const Duration(seconds: 10), () {
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              });
                              String sessionInfo = await apiServiceController
                                  .getOTP(int.parse(userPhone));
                              Get.off(
                                  () => OtpPage(
                                        sessionInfo: sessionInfo,
                                        userPhone: int.parse(userPhone),
                                      ),
                                  transition: Transition.fadeIn);

                              setState(() {
                                isLoading = false;
                              });
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
                      padding: EdgeInsets.only(top: 35.h),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text:
                                'By continuing to use the app, you accept our\n',
                            style: GoogleFonts.mulish(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: GoogleFonts.mulish(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch('https://www.google.com');
                                  },
                              ),
                              TextSpan(
                                text: ' and ',
                                style: GoogleFonts.mulish(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: GoogleFonts.mulish(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch('https://www.google.com');
                                  },
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 34.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Icon(
                            CupertinoIcons.exclamationmark_circle_fill,
                            color: Colors.orange,
                            size: 12.w,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'If you are a merchant, please use the\n',
                                style: GoogleFonts.mulish(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Santhe Merchant App',
                                    style: GoogleFonts.mulish(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.sp),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch('https://www.google.com');
                                      },
                                  ),
                                ]),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            CupertinoIcons.exclamationmark_circle_fill,
                            color: Colors.transparent,
                            size: 12.w,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
