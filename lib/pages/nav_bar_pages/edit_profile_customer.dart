import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resize/resize.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/delete_account_page.dart';

import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:santhe/widgets/confirmation_widgets/success_snackbar_widget.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/error_user_fallback.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/registrationController.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../models/santhe_user_model.dart';
import '../customer_registration_pages/mapSearchScreen.dart';
import '../login_pages/phone_number_login_page.dart';

class EditCustomerProfile extends StatefulWidget {
  const EditCustomerProfile({Key? key}) : super(key: key);

  @override
  State<EditCustomerProfile> createState() => _EditCustomerProfileState();
}

class _EditCustomerProfileState extends State<EditCustomerProfile> {
  final _formKey = GlobalKey<FormState>();

  final profileController = Get.find<ProfileController>();
  int userPhoneNumber =
      int.parse(AppHelpers().getPhoneNumberWithoutCountryCode);
  late final CustomerModel? currentUser;
  late final TextEditingController _userNameController;
  late final TextEditingController _userEmailController;
  bool addressUpdateFlag = false;
  bool donePressed = false;
  bool mapSelected = false;
  bool isProcessing = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.orange,
      statusBarBrightness: Brightness.light,
    ));

    currentUser = profileController.customerDetails ?? fallback_error_customer;
    _userNameController =
        TextEditingController(text: currentUser?.customerName ?? 'John Doe');
    _userEmailController = TextEditingController(
        text: currentUser?.emailId ?? 'johndoe@gmail.com');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final registrationController = Get.find<RegistrationController>();
    final apiController = Get.find<APIs>();
    double screenHeight = MediaQuery.of(context).size.height / 100;
    if (registrationController.address.value.trim().isEmpty) {
      registrationController.address.value = currentUser?.address ?? '';
    }
    if (registrationController.howToReach.value.trim().isEmpty) {
      registrationController.howToReach.value = currentUser?.howToReach ?? '';
    }
    if (registrationController.lat.value == 0.0 ||
        registrationController.lng.value == 0.0) {
      registrationController.lat.value =
          double.parse(currentUser?.lat ?? '0.0');
      registrationController.lng.value =
          double.parse(currentUser?.lng ?? '0.0');
    }
    if (registrationController.pinCode.value.isEmpty) {
      registrationController.pinCode.value =
          currentUser?.pinCode.toString() ?? '';
    }

    if (userPhoneNumber == 404) {
      Get.snackbar('Verify Number First',
          'Please Verify Your Phone Number before continuing...');
      profileController.isLoggedIn = false;
      Get.offAll(() => const LoginScreen(), transition: Transition.fadeIn);
    }
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
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: screenHeight * 5.5,
        leading: IconButton(
          splashRadius: 0.1,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 13.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20.sp,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 50.0,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60.0,
                        child: Icon(
                          CupertinoIcons.person_solid,
                          color: Colors.orange,
                          size: 90.0,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 16.sp, left: 23.sp, right: 23.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    enabled: false,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.0,
                                        fontSize: 16.sp,
                                        color: Colors.grey.shade600),
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 6),
                                        child: SizedBox(
                                          height: 25.w,
                                          width: 25.w,
                                          child: Center(
                                            child: Container(
                                                height: 24.w,
                                                width: 24.w,
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColors().brandDark,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Icon(
                                                  Icons.phone,
                                                  color: AppColors().white100,
                                                  size: 15.sp,
                                                )),
                                          ),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            kTextFieldCircularBorderRadius),
                                        borderSide: const BorderSide(
                                            width: 2.0, color: kTextFieldGrey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            kTextFieldCircularBorderRadius),
                                        borderSide: const BorderSide(
                                            width: 2.0, color: kTextFieldGrey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            kTextFieldCircularBorderRadius),
                                        borderSide: BorderSide(
                                            width: 2.0,
                                            color: AppColors().brandDark),
                                      ),
                                      hintText:
                                          '+91-${currentUser?.customerId ?? '91-9876543210'}',
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.0,
                                          color: Colors.grey.shade500),
                                    ),
                                  ),
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
                                  keyboardType: TextInputType.name,
                                  controller: _userNameController,
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
                                      child: SizedBox(
                                        height: 25.w,
                                        width: 25.w,
                                        child: Center(
                                          child: Container(
                                              height: 24.w,
                                              width: 24.w,
                                              decoration: BoxDecoration(
                                                  color: AppColors().brandDark,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Icon(
                                                Icons.person,
                                                color: AppColors().white100,
                                                size: 15.sp,
                                              )),
                                        ),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kTextFieldCircularBorderRadius),
                                      borderSide: const BorderSide(
                                          width: 2.0, color: kTextFieldGrey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kTextFieldCircularBorderRadius),
                                      borderSide: const BorderSide(
                                          width: 2.0, color: kTextFieldGrey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kTextFieldCircularBorderRadius),
                                      borderSide: BorderSide(
                                          width: 2.0,
                                          color: AppColors().brandDark),
                                    ),
                                    hintText: 'Your name',
                                    hintStyle: kHintStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //* email
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 8.sp, bottom: 5),
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
                                  controller: _userEmailController,
                                  validator: (value) {
                                    final RegExp emailRegExp = RegExp(
                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
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
                                      child: SizedBox(
                                        height: 25.w,
                                        width: 25.w,
                                        child: Center(
                                          child: Container(
                                              height: 24.w,
                                              width: 24.w,
                                              decoration: BoxDecoration(
                                                  color: AppColors().brandDark,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Icon(
                                                Icons.email,
                                                color: AppColors().white100,
                                                size: 15.sp,
                                              )),
                                        ),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kTextFieldCircularBorderRadius),
                                      borderSide: const BorderSide(
                                          width: 2.0, color: kTextFieldGrey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kTextFieldCircularBorderRadius),
                                      borderSide: const BorderSide(
                                          width: 2.0, color: kTextFieldGrey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kTextFieldCircularBorderRadius),
                                      borderSide: BorderSide(
                                          width: 2.0,
                                          color: AppColors().brandDark),
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
                                padding: EdgeInsets.only(top: 8.sp, bottom: 5),
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
                                  FocusScopeNode currentScope =
                                      FocusScope.of(context);
                                  if (!currentScope.hasPrimaryFocus &&
                                      currentScope.hasFocus) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                  if (locationController.lng.value != 0.0 ||
                                      locationController.lat.value != 0.0) {
                                    setState(() {
                                      mapSelected = true;
                                    });
                                  }
                                  var res = await Get.to(
                                      () => const MapSearchScreen());
                                  if (res == 1) {
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: 344.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                          color: registrationController
                                                      .address.isEmpty &&
                                                  donePressed
                                              ? AppColors().red100
                                              : AppColors().grey40,
                                          width: 2.0)),
                                  // padding: EdgeInsets.only(
                                  //     top: 13.h,
                                  //     left: 10.w,
                                  //     right: 10.w,
                                  //     bottom: 13.h),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //icon
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 12),
                                          child: Container(
                                              height: 24.w,
                                              width: 24.w,
                                              decoration: BoxDecoration(
                                                  color: AppColors().brandDark,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                child: Icon(
                                                  Icons.home,
                                                  color: AppColors().white100,
                                                  size: 15.sp,
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 1.w,
                                        ),
                                        //text
                                        Expanded(
                                          child: Obx(() => Text(
                                                registrationController
                                                            .address.value
                                                            .trim() ==
                                                        ''
                                                    ? 'Select Address'
                                                    : '${registrationController.address.value} ${registrationController.howToReach.value}',
                                                style: registrationController
                                                            .address.value
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
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Visibility(
                                visible:
                                    registrationController.address.isEmpty &&
                                        donePressed,
                                child: Text(
                                  'Please Enter your Address',
                                  style: AppTheme().normal400(12).copyWith(
                                        color: const Color.fromARGB(
                                            255, 214, 77, 93),
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.sp),
                            child: SizedBox(
                              width: isProcessing ? 50.sp : 244.sp,
                              height: 50.sp,
                              child: isProcessing
                                  ? const CircularProgressIndicator.adaptive()
                                  : MaterialButton(
                                      elevation: 0.0,
                                      highlightElevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      color: Colors.orange,
                                      onPressed: () async {
                                        setState(() {
                                          donePressed = true;
                                          isProcessing = true;
                                        });
                                        if (_formKey.currentState!.validate() &&
                                            registrationController
                                                .address.isNotEmpty) {
                                          if (profileController.isLoggedIn) {
                                            CustomerModel? currentUser =
                                                profileController
                                                        .customerDetails ??
                                                    fallback_error_customer;

                                            int userPhone = int.parse(AppHelpers()
                                                .getPhoneNumberWithoutCountryCode);

                                            if (userPhone == 404) {
                                              Get.off(
                                                  () => const LoginScreen());
                                            }

                                            log('------>>>>>>>>${registrationController.pinCode.value}');
                                            //todo add how to reach howToReach
                                            User updatedUser = User(
                                                address: registrationController
                                                    .address.value,
                                                emailId:
                                                    _userEmailController.text,
                                                lat: registrationController
                                                    .lat.value,
                                                lng: registrationController
                                                    .lng.value,
                                                pincode: int.parse(
                                                    registrationController
                                                        .pinCode.value),
                                                phoneNumber: userPhone,
                                                custId: userPhone,
                                                custName:
                                                    _userNameController.text,
                                                custRatings: double.parse(
                                                    currentUser
                                                        .customerRatings),
                                                custReferal: 0000,
                                                custStatus: 'active',
                                                howToReach:
                                                    registrationController
                                                        .howToReach.value,
                                                custLoginTime: DateTime.now(),
                                                custPlan: 'default');
//todo add cust plan
                                            //todo add to firebase
                                            int userUpdated =
                                                await apiController
                                                    .updateCustomerInfo(
                                                        userPhone, updatedUser);
                                            if (userUpdated == 1) {
                                              await profileController
                                                  .getCustomerDetailsInit();
                                              successMsg('Profile Updated',
                                                  'Your profile information was updated successfully.');

                                              await profileController
                                                  .getOperationalStatus();

//go back after successful user profile edit, Get.back() didn't work for some reason
                                              Navigator.pop(context);
                                            } else {
                                              errorMsg('Connectivity Error',
                                                  'Some connectivity error has occurred, please try again later!');
                                            }
                                          } else {
                                            errorMsg('Verify Number First',
                                                'Please Verify Your Phone Number before continuing...');
                                            profileController.isRegistered =
                                                false;
                                            profileController.isLoggedIn =
                                                false;
                                            Get.offAll(
                                                () => const LoginScreen(),
                                                transition: Transition.fadeIn);
                                          }
                                        }
                                        setState(() {
                                          isProcessing = false;
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.sp),
                child: Text(
                  'We will use your Phone number and Email to send you important communications',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xff8B8B8B),
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              if (Platform.isIOS)
                Padding(
                  padding: EdgeInsets.only(top: 8.sp),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'If you wish to delete your account click here: ',
                      style: TextStyle(
                        color: const Color(0xff8B8B8B),
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                      children: [
                        TextSpan(
                          text: 'Delete Account',
                          style: TextStyle(
                            color: AppColors().brandDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Get.to(() => const DeleteAccountPage()),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
