import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/pages/map_merch.dart';
import '../../constants.dart';
import '../../controllers/api_service_controller.dart';
import '../../core/app_shared_preference.dart';
import '../../widgets/confirmation_widgets/error_snackbar_widget.dart';
import '../../widgets/confirmation_widgets/success_snackbar_widget.dart';
import '../customer_registration_pages/customer_registration.dart';
import '../home_page.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with LogMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int start = 60;
  bool wait = false;
  TextEditingController phoneController = TextEditingController();
  String verificationIdFinal = "";
  String smsCode = "";
  Timer? _timer;
  String _otp = '';
  bool _isLoading = false;
  bool _isSubmitted = false;
  bool _incorrectOtp = false;

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber(widget.phoneNumber, setData);
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      height: 49.h,
      width: 40.w,
      textStyle: TextStyle(
          fontSize: 15.sp, color: Colors.orange, fontWeight: FontWeight.w700),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.grey),
      ),
    );
    debugLog(
        'Checking for intial phone number being sent ${widget.phoneNumber}');
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
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
                fontSize: 18.sp,
                color: Constant.bgColor,
              ),
            ),
            SizedBox(
              height: 150.h,
            ),
            //pin input
            Pinput(
              // validator: (value) {
              //   return _otp.toString().length < 6 && _isSubmitted
              //       ? 'Invalid OTP'
              //       : null;
              // },
              length: 6,
              defaultPinTheme:
                  (_isSubmitted && _otp.length < 6) || _incorrectOtp
                      ? defaultPinTheme.copyWith(
                          height: 49.h,
                          width: 40.w,
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(color: AppColors().red100),
                          ),
                        )
                      : defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                height: 49.h,
                width: 40.w,
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: AppColors().grey40),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyWith(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors().red100),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              onChanged: (String val) => _otp = val,
            ),
            Padding(
              padding: EdgeInsets.only(top: 34.h),
              child: Text(
                _otp.isEmpty
                    ? 'Enter OTP to verify'
                    : _otp.length < 6 && _isSubmitted
                        ? 'Invalid OTP'
                        : _incorrectOtp
                            ? "Incorrect OTP"
                            : 'Enter OTP to verify',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.sp,
                    color: Colors.orange),
              ),
            ),
            SizedBox(
              height: 34.h,
            ),
            SizedBox(
              height: 58.h,
            ),
            //button
            InkWell(
              onTap: () {
                signInWithPhoneNumber(verificationIdFinal, _otp, context);
                setState(() {
                  _isSubmitted = true;
                });
              },
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors().brandDark,
                        strokeWidth: 2,
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.55,
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
            SizedBox(
              width: 90.vw,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (start <= 0) {
                          verifyPhoneNumber(
                              '+91${widget.phoneNumber}', setData);
                          start = 60;
                          startTimer();
                        } else {
                          errorMsg('Please wait before trying again', '');
                        }
                      },
                      child: Text(
                        start > 0
                            ? '${' Request Again in'.tr} $start secs'
                            : ' Request Again',
                        maxLines: 4,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ));
  }

  void startTimer() {
    const seconds = Duration(seconds: 1);
    if (mounted) {
      _timer = Timer.periodic(seconds, (timer) {
        if (start == 0) {
          if (mounted) {
            setState(() {
              timer.cancel();
              wait = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              start--;
            });
          }
        }
      });
    }
  }

  void setData(String verificationId) {
    if (mounted) {
      setState(() {
        verificationIdFinal = verificationId;
      });
    }
  }

  //automatic verification and start verification
  Future<void> verifyPhoneNumber(String phoneNumber, Function setData) async {
    try {
      debugLog(
          'Checking for phonnumber in VerifyPHoneNumber function $phoneNumber');
      await _auth.verifyPhoneNumber(
          //after this you can't enter the code
          timeout: const Duration(seconds: 50),
          phoneNumber: phoneNumber,
          verificationCompleted: onVerificationCompleted,
          verificationFailed: onVerificationFailed,
          codeSent: onCodeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      log(e.toString());
      errorMsg('Error Occurred', e.toString());
      if (_timer != null) _timer!.cancel();
    }
  }

  //manual verification
  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      _auth.signInWithCredential(credential).then((value) async {
        if (_timer != null) _timer!.cancel();
        setState(() {
          start = 0;
          wait = false;
        });
        _nextStep();
      }).catchError((e) {
        setState(() {
          _isLoading = false;
          _incorrectOtp = true;
        });
        // errorMsg('Invalid OTP', 'Please try again');
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      errorMsg('Error Occurred', e.toString());
    }
  }

  Future<void> _nextStep() async {
    final apiController = Get.find<APIs>();

    int userPhone = int.parse(widget.phoneNumber);
    final profileController = Get.find<ProfileController>();
    await profileController.generateUrlToken();
    warningLog(
        'Checking for phone Number being passed in the next steps $userPhone');
    if (await profileController.getCustomerDetailsInit()) {
      Get.off(() => UserRegistrationPage(userPhoneNumber: userPhone),
          transition: Transition.fadeIn);
    } else {
      AppSharedPreference().setLogin(true);
      apiController.updateDeviceToken(widget.phoneNumber.toString());
      await profileController.initialise();
      Get.offAll(() => const MapMerchant(), transition: Transition.fadeIn);
    }
  }

  onVerificationCompleted(PhoneAuthCredential phoneAuthCredential) {
    _auth.signInWithCredential(phoneAuthCredential).then((value) async {
      log(value.toString());
      if (_timer != null) _timer!.cancel();
      _nextStep();
    });
  }

  onVerificationFailed(FirebaseAuthException exception) {
    errorMsg(exception.message.toString(), '');
    if (_timer != null) _timer!.cancel();
  }

  onCodeSent(String verificationID, int? forceResendingToken) {
    showSnackBar(context, "Verification Code sent to ${widget.phoneNumber}");
    setData(verificationID);
  }

  //error handling after automatic timeout
  codeAutoRetrievalTimeout(String verificationID) {
    //errorMsg('Time out', '');
  }

  void showSnackBar(BuildContext context, String text) {
    successMsg('', text, textColorGreen: true);
  }
}
