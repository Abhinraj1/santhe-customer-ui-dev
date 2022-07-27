import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/boxes_controller.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/network_call/network_call.dart';
import 'package:santhe/pages/login_pages/phone_number_login_page.dart';
import 'package:santhe/pages/nav_bar_pages/privacy_policy_page.dart';
import 'package:santhe/pages/nav_bar_pages/terms_condition_page.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    final screenSize = MediaQuery.of(context).size;
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
            Get.back();
          },
        ),
        title: Text(
          'Delete Account',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 40.sp),
              width: screenSize.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/delete.png',
                    width: 60.sp,
                    height: 60.sp,
                  ),
                  SizedBox(
                    width: 25.sp,
                  ),
                  Text(
                    'Deleting your Account',
                    style: TextStyle(
                        color: const Color(0xFFF94943),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.sp,
            ),
            Text(
              'Please be aware of the following, while deleting your account.',
              style: TextStyle(
                color: const Color(0xff8B8B8B),
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              height: 20.sp,
            ),
            SizedBox(
              width: screenSize.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      color: const Color(0xff8B8B8B),
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(
                    width: 8.sp,
                  ),
                  Expanded(
                    child: Text(
                      'Your Account deletion cannot be reversed.',
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: const Color(0xff8B8B8B),
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            SizedBox(
              width: screenSize.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      color: const Color(0xff8B8B8B),
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(
                    width: 8.sp,
                  ),
                  Expanded(
                    child: Text(
                      'If you wish to create a new account with the same phone number, you can do so after 48 hours.',
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: const Color(0xff8B8B8B),
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            SizedBox(
              width: screenSize.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      color: const Color(0xff8B8B8B),
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(
                    width: 8.sp,
                  ),
                  Expanded(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text:
                            'To know more about data deletion please review our ',
                        style: TextStyle(
                          color: const Color(0xff8B8B8B),
                          fontWeight: FontWeight.w400,
                          fontSize: 18.sp,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms and Conditions ',
                            style: TextStyle(
                              color: const Color(0xffA187FD),
                              fontWeight: FontWeight.w400,
                              fontSize: 18.sp,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => const TermsAndConditionsPage());
                              },
                          ),
                          TextSpan(
                            text: 'and ',
                            style: TextStyle(
                              color: const Color(0xff8B8B8B),
                              fontWeight: FontWeight.w400,
                              fontSize: 18.sp,
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: const Color(0xffA187FD),
                              fontWeight: FontWeight.w400,
                              fontSize: 18.sp,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => const PrivacyPolicyPage());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.sp,
            ),
            SizedBox(
              width: screenSize.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    minWidth: screenSize.width / 3 + 10,
                    height: 50.sp,
                    elevation: 0.0,
                    highlightElevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: AppColors().brandDark,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Go Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  MaterialButton(
                    minWidth: screenSize.width / 3 + 10,
                    height: 50.sp,
                    elevation: 0.0,
                    highlightElevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: AppColors().grey80,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    onPressed: () => _confirmDelete(context, screenSize),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _confirmDelete(BuildContext context, Size screenSize) {
    bool deleting = false;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.sp),
                ),
              ),
              content: deleting
                  ? SizedBox(
                      height: screenSize.height / 5 + 15,
                      width: screenSize.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Deleting...',
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: AppColors().brandDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          const CircularProgressIndicator.adaptive(),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: screenSize.height / 5 + 15,
                      width: screenSize.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Are you sure?',
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: AppColors().brandDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          Expanded(
                            child: Text(
                              'We are Sorry to see your leave! If you change your mind, now is your chance.',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors().grey80,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          SizedBox(
                            width: screenSize.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  minWidth: screenSize.width / 4 + 10,
                                  height: 40.sp,
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  color: AppColors().brandDark,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Go Back',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  onPressed: () => Get.back(),
                                ),
                                MaterialButton(
                                  minWidth: screenSize.width / 4 + 10,
                                  height: 40.sp,
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  color: AppColors().grey80,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      deleting = true;
                                    });

                                    final result =
                                        await NetworkCall().deleteUser();
                                    if (result) {
                                      await FirebaseAuth.instance.signOut();
                                      await Boxes.getItemsDB().deleteFromDisk();
                                      await Boxes.getFAQs().deleteFromDisk();
                                      await Boxes.getContent().deleteFromDisk();
                                      await Boxes.getCacheRefreshInfo()
                                          .deleteFromDisk();
                                      await Boxes.getCategoriesDB()
                                          .deleteFromDisk();
                                      final  profile = Get.find<ProfileController>();
                                      profile.deleteEverything();
                                      final lists = Get.find<AllListController>();
                                      lists.deleteEverything();

                                      Get.offAll(() => const LoginScreen());
                                    } else {
                                      setState(() {
                                        deleting = false;
                                      });
                                      errorMsg(
                                          'Failed', 'User deletion failed');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              contentPadding: EdgeInsets.all(25.sp),
            );
          },
        ),
      ),
    );
  }
}
