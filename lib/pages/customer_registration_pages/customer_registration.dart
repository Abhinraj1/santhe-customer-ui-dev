import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resize/resize.dart';

import 'package:get/get.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/controllers/registrationController.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/app_shared_preference.dart';
import 'package:santhe/models/santhe_user_model.dart';
import 'package:santhe/pages/error_pages/no_internet_page.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:santhe/pages/map_merch.dart';
import 'package:santhe/pages/onboarding_page.dart';

import '../../constants.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/location_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../login_pages/phone_number_login_page.dart';
import 'mapSearchScreen.dart';

class UserRegistrationPage extends StatefulWidget {
  final int userPhoneNumber;

  const UserRegistrationPage({required this.userPhoneNumber, Key? key})
      : super(key: key);

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final apiController = Get.find<APIs>();
  final _formKey = GlobalKey<FormState>();
  String userName = '', userEmail = '', userRefferal = '';
  bool mapSelected = false;
  bool donePressed = false;
  bool loading = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));

    checkNet();

    super.initState();
  }

  void checkNet() async {
    final hasNet = await AppHelpers.checkConnection();
    if (!hasNet) {
      Get.to(
        () => const NoInternetPage(),
        transition: Transition.fade,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int userPhoneNumber = widget.userPhoneNumber;
    final registrationController = Get.find<RegistrationController>();
    final profileController = Get.find<ProfileController>();

    final TextStyle kHintStyle = TextStyle(
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        color: Colors.grey.shade500);
    final TextStyle kTextInputStyle = TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        color: Colors.grey.shade600);
    final locationController = Get.find<LocationController>();
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(top: 32.sp, left: 23.sp, right: 23.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 20.sp + MediaQuery.of(context).padding.top,
                ),
                Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.orange,
                    fontSize: 24.sp,
                  ),
                ),
                //phone
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.sp),
                      child: Text(
                        'Phone no.*',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: Colors.orange),
                      ),
                    ),
                    //todo add address and other stuff
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      enabled: false,
                      initialValue: '$userPhoneNumber',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                          fontSize: 16.sp,
                          color: Colors.grey.shade600),
                      decoration: InputDecoration(
                        prefix: Text(
                          '+91-',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              color: Colors.grey),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 6),
                          child: CircleAvatar(
                            radius: 4.h,
                            backgroundColor: Colors.orange,
                            child: Icon(
                              CupertinoIcons.phone_fill,
                              color: Colors.white,
                              size: 24.h,
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(
                              width: 1.0, color: Color(0xffD1D1D1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(
                              width: 1.0, color: Color(0xffD1D1D1)),
                        ),
                        hintText: '+91-9090909090',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0,
                            color: Colors.grey.shade500),
                      ),
                    ),
                  ],
                ),
                //name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 23.sp, bottom: 5),
                      child: Text(
                        'Name *',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: Colors.orange),
                      ),
                    ),
                    Center(
                      child: TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          userName = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name here';
                          } else {
                            return null;
                          }
                        },
                        maxLength: 45,
                        style: kTextInputStyle,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 6),
                            child: CircleAvatar(
                              radius: 4.h,
                              backgroundColor: Colors.orange,
                              child: Icon(
                                CupertinoIcons.person_solid,
                                color: Colors.white,
                                size: 24.h,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                kTextFieldCircularBorderRadius),
                            borderSide: const BorderSide(
                                width: 1.0, color: kTextFieldGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                kTextFieldCircularBorderRadius),
                            borderSide: const BorderSide(
                                width: 1.0, color: kTextFieldGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                kTextFieldCircularBorderRadius),
                            borderSide: BorderSide(
                                width: 1.0, color: AppColors().brandDark),
                          ),
                          hintText: 'Your name',
                          hintStyle: kHintStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                //email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 23.sp, bottom: 5),
                      child: Text(
                        'Email Id *',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: Colors.orange),
                      ),
                    ),
                    Center(
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          userEmail = value;
                        },
                        validator: (value) {
                          final RegExp emailRegExp =
                              RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (value == null || value.isEmpty) {
                            return 'Please enter your e-mail here';
                          } else if (!emailRegExp.hasMatch(value)) {
                            return 'Please enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        maxLength: 60,
                        style: kTextInputStyle,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 6),
                            child: CircleAvatar(
                              radius: 4.h,
                              backgroundColor: Colors.orange,
                              child: Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 24.h,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                kTextFieldCircularBorderRadius),
                            borderSide: const BorderSide(
                                width: 1.0, color: kTextFieldGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                kTextFieldCircularBorderRadius),
                            borderSide: const BorderSide(
                                width: 1.0, color: kTextFieldGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                kTextFieldCircularBorderRadius),
                            borderSide: BorderSide(
                                width: 1.0, color: AppColors().brandDark),
                          ),
                          hintText: 'youremail@here.com',
                          hintStyle: kHintStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                //Address
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 23.sp, bottom: 5),
                      child: Text(
                        'Address *',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: Colors.orange),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        //remove focus from text fields
                        FocusScopeNode currentScope = FocusScope.of(context);
                        if (!currentScope.hasPrimaryFocus &&
                            currentScope.hasFocus) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                        if (locationController.lng.value != 0.0 ||
                            locationController.lat.value != 0.0) {
                          setState(() {
                            mapSelected = true;
                          });
                        }
                        var res = await Get.to(() => const MapSearchScreen());
                        if (res == 1) {
                          setState(() {
                            _formKey.currentState?.validate();
                          });
                        }
                      },
                      child: Container(
                        width: 344.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: registrationController.address.isEmpty &&
                                        donePressed
                                    ? AppColors().red100
                                    : AppColors().grey40,
                                width: 1.sp)),
                        // padding: EdgeInsets.only(
                        //     top: 13.h,
                        //     left: 10.w,
                        //     right: 10.w,
                        //     bottom: 13.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //icon
                            Padding(
                              padding:
                                  registrationController.address.value.trim() ==
                                          ''
                                      ? const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 6)
                                      : const EdgeInsets.symmetric(
                                          vertical: 35.0, horizontal: 6),
                              child: Container(
                                  height: 40.w,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                      color: AppColors().brandDark,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Icon(
                                      Icons.home,
                                      color: AppColors().white100,
                                      size: 25.h,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            //text
                            Expanded(
                              child: Obx(() => Text(
                                    registrationController.address.value
                                                .trim() ==
                                            ''
                                        ? 'Select Address'
                                        : '${registrationController.address.value} ${registrationController.howToReach.value}',
                                    style: registrationController.address.value
                                                .trim() ==
                                            ''
                                        ? kHintStyle
                                        : kTextInputStyle,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Visibility(
                      visible:
                          registrationController.address.isEmpty && donePressed,
                      child: Text(
                        'Please Enter your Address',
                        style: AppTheme().normal400(12).copyWith(
                            color: const Color.fromARGB(255, 214, 77, 93)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.sp),
                  child: SizedBox(
                    width: loading ? 30.sp : 244.sp,
                    height: loading ? 30.sp : 50.sp,
                    child: loading
                        ? const CircularProgressIndicator()
                        : MaterialButton(
                            elevation: 0.0,
                            highlightElevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            color: Colors.orange,
                            onPressed: () async {
                              setState(() {
                                donePressed = true;
                                loading = true;
                              });
                              if (_formKey.currentState!.validate() &&
                                  registrationController.address.isNotEmpty) {
                                //final otp check

                                int userPhone = int.parse(AppHelpers()
                                    .getPhoneNumberWithoutCountryCode);

                                //todo add how to reach howToReach
                                User currentUser = User(
                                    address:
                                        registrationController.address.value,
                                    emailId: userEmail,
                                    lat: registrationController.lat.value,
                                    lng: registrationController.lng.value,
                                    pincode: int.parse(
                                        registrationController.pinCode.value),
                                    phoneNumber: userPhone,
                                    custId: userPhone,
                                    custName: userName,
                                    custRatings: 5.0,
                                    custReferal: 0,
                                    custStatus: 'active',
                                    howToReach:
                                        registrationController.howToReach.value,
                                    custPlan: 'planA',
                                    custLoginTime: DateTime.now());

                                int userAdded = await apiController
                                    .addCustomer(currentUser);

                                if (userAdded == 1) {
                                  //add to Hive
                                  AppSharedPreference().setLogin(true);
                                  analytics
                                      .logSignUp(
                                          signUpMethod: registrationController
                                              .utmMedium.value)
                                      .then((value) => log(
                                          'analytics send: ${registrationController.utmMedium.value}'));
                                  await profileController.initialise();
                                  Get.offAll(() => MapMerchant(),
                                      transition: Transition.fadeIn);
                                } else {
                                  log('error occurred');
                                  Get.offAll(() => const OnBoardingPage());
                                }
                              }
                              setState(() {
                                loading = false;
                              });
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.sp),
                  child: Text(
                    'We will use your Phone number and Email to send you important communications',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xff8B8B8B),
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
