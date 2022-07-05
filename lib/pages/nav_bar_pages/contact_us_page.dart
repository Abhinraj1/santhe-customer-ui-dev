import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';

import 'package:santhe/core/app_colors.dart';
import 'package:get/get.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/error_user_fallback.dart';
import '../../widgets/confirmation_widgets/success_snackbar_widget.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();

  int userPhoneNumber = int.parse(AppHelpers().getPhoneNumberWithoutCountryCode);

  final profileController = Get.find<ProfileController>();

  late final CustomerModel? currentUser;
  late final TextEditingController _messageController = TextEditingController();
  late final TextEditingController _userNameController;
  late final TextEditingController _userEmailController;

  @override
  void initState() {
    currentUser = profileController.customerDetails ?? fallback_error_customer;
    _userNameController =
        TextEditingController(text: currentUser?.customerName ?? 'John Doe');
    _userEmailController =
        TextEditingController(text: currentUser?.emailId ?? 'johndoe@gmail.com');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    final apiController = Get.find<APIs>();
    final TextStyle kHintStyle = TextStyle(
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        color: Colors.grey.shade500);
    final TextStyle kTextInputStyle = TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        color: Colors.grey.shade600);
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
          'Contact Us/Feedback',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // Padding(
          //   padding: EdgeInsets.only(top: 29.sp, bottom: 30.sp),
          //   child: Center(
          //     child: Text(
          //       'Contact Us',
          //       style: TextStyle(
          //           color: Colors.orange,
          //           fontWeight: FontWeight.w700,
          //           fontSize: 24.sp),
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(
              top: 24.sp,
              left: 24.sp,
              right: 24.sp,
            ),
            child: Text(
              'Your opinion and feedback is of utmost importance to us. Please leave your comments and contact information below and we will get back to you. You can also reach us on your favorite social media sites and apps.',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
                // height: 1.2,
                fontSize: 16.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.sp, vertical: 24.sp),
            child: Form(
              key: _formKey,
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
                          'Phone no.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: Colors.orange),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            enabled: false,
                            initialValue: userPhoneNumber.toString(),
                            validator: (value) {
                              final RegExp phoneRegExp =
                                  RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number here';
                              } else if (value.length != 10) {
                                return 'Please enter a proper 10 digit number';
                              } else if (!phoneRegExp.hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              } else {
                                return null;
                              }
                            },
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
                          'Name',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: Colors.orange),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            enabled: false,
                            controller: _userNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name here';
                              } else {
                                return null;
                              }
                            },
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
                              hintText: 'e.g. Your name here...',
                              hintStyle: kHintStyle,
                            ),
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
                          'Email Id',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: Colors.orange),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _userEmailController,
                            enabled: false,
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
                              hintText: 'e.g. Your email here...',
                              hintStyle: kHintStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Your Message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 23.sp, bottom: 5),
                        child: Text(
                          'Your Message',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: Colors.orange),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _messageController,
                        autofocus: true,
                        maxLength: 500,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some feedback or query here';
                          } else {
                            return null;
                          }
                        },
                        maxLines: 4,
                        style: kTextInputStyle,
                        decoration: InputDecoration(
                          prefixIcon: Align(
                            alignment: Alignment.topCenter,
                            widthFactor: 1.1,
                            heightFactor: 2.1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0.sp, horizontal: 6),
                              child: CircleAvatar(
                                radius: 19.sp,
                                backgroundColor: Colors.orange,
                                child: Image(
                                  width: 16.sp,
                                  height: 16.sp,
                                  fit: BoxFit.cover,
                                  image: const AssetImage(
                                      "assets/icon_message.png"),
                                ),
                              ),
                            ),
                          ),
                          // counterStyle: TextStyle(color: Colors.grey),
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
                                width: 2.0, color: AppColors().brandDark),
                          ),
                          hintText: 'Write your message here...',
                          hintStyle: kHintStyle,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 38.sp),
                    child: SizedBox(
                      width: 244.sp,
                      height: 50.sp,
                      child: MaterialButton(
                        elevation: 0.0,
                        highlightElevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        color: Colors.orange,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            log('btn');
                            int response = await apiController.contactUs(
                                userPhoneNumber,
                                _messageController.text,
                               double.parse(profileController.customerDetails!.customerRatings));

                            //checking for API call's success | 1 = success
                            if (response == 1) {
                              successMsg(
                                  'Success', 'We have received your message');
                              Navigator.pop(context);
                            } else {
                              log('conact us faliled');
                              errorMsg('Connectivity Error',
                                  'Some connectivity error has occurred, please try again later!');
                            }
                            // Get.offAll(() => const HomePage());
                          } else {
                            // errorMsg('Enter Message',
                            //     'Please write some message before sending it.');
                          }
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Send',
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
    );
  }
}
