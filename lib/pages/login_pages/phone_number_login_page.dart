import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_theme.dart';
import '../../constants.dart';
import 'otpScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors().white100,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: AppColors().white100,
      statusBarIconBrightness: Brightness.dark,
    ));
    final GlobalKey<FormState> _key = GlobalKey();
    String? _number;
    return Scaffold(
      backgroundColor: AppColors().white100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 130.h,
            ),
            //header
            Column(
              children: [
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
              height: 214.h,
            ),
            //mobile field
            Form(
              key: _key,
              child: SizedBox(
                width: 276.w,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        enabled: false,
                        cursorColor: Constant.bgColor,
                        decoration: InputDecoration(
                          disabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constant.bgColor, width: 2.0),
                          ),
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
                          contentPadding: EdgeInsets.zero,
                          label: Text(
                            '+91',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Constant.bgColor,
                            ),
                          ),
                        ),
                        validator: (String? val) {
                          if (_number != null &&
                              _number.toString().length == 10) return null;
                          return '';
                        },
                        readOnly: true,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: TextFormField(
                        cursorColor: Constant.bgColor,
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
                          contentPadding: EdgeInsets.zero,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                        onChanged: (String? val) => _number = val!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Constant.bgColor,
                          letterSpacing: 6.sp,
                        ),
                        validator: (String? val) {
                          if (val != null && val.length == 10) return null;
                          return 'Valid mobile number required';
                        },
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
                              fontWeight: FontWeight.w900)),
                      TextSpan(
                          text: "or ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Constant.bgColor,
                          )),
                      TextSpan(
                          text: "SignUp",
                          style: TextStyle(
                              fontSize: 18,
                              color: Constant.bgColor,
                              fontWeight: FontWeight.w900)),
                    ]),
              ),
            ),
            SizedBox(
              height: 70.h,
            ),
            //next
            InkWell(
              onTap: () async {
                if (_key.currentState!.validate()) {
                  Get.to(OtpScreen(phoneNumber: _number!));
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
                    child: Text(
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
                          style: TextStyle(
                              fontSize: 13,
                              color: Constant.bgColor,
                              fontWeight: FontWeight.w600)),
                      const TextSpan(
                          text: "and ",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          )),
                      TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                              fontSize: 13,
                              color: Constant.bgColor,
                              fontWeight: FontWeight.w600)),
                    ]),
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
                    const Text("  If you are a merchant, please use the",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ))
                  ],
                ),
                Text("Santhe Merchant App",
                    style: TextStyle(
                        fontSize: 13,
                        color: Constant.bgColor,
                        fontWeight: FontWeight.w600))
              ],
            )
          ],
        ),
      ),
    );
  }
}

/*// Get.to(() => const OtpPage());

int enteredOtp = int.parse(controller.text);
print('--> OTP: $enteredOtp');
if (controller.text.isEmpty ||
controller.text.length != 6) {
Get.snackbar('Enter all 6 Digits',
'Please Enter All the 6 Digits of Your OTP!',
backgroundColor: Colors.orange,
colorText: Colors.white);
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

_countdownController.pause();
Get.off(() => const HomePage(),
transition: Transition.fadeIn);
}
} else {
controller.text = '';
Get.snackbar(
'',
'',
titleText: const Padding(
padding: EdgeInsets.only(left: 8.0),
child: Text('Invalid OTP!'),
),
messageText: const Padding(
padding: EdgeInsets.only(left: 8.0),
child: Text(
'Please enter the correct OTP verify.'),
),
margin: const EdgeInsets.all(10.0),
padding: const EdgeInsets.all(8.0),
backgroundColor: Colors.white,
shouldIconPulse: true,
icon: const Padding(
padding: EdgeInsets.all(8.0),
child: Icon(
CupertinoIcons
    .exclamationmark_triangle_fill,
color: Colors.orange,
size: 45,
),
),
);
}

if (mounted) {
setState(() {
isLoading = false;
});
}
} else {
print('ERROROROROROOROROR');
}*/


