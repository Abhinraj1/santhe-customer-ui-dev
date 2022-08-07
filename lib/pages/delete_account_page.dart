import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:resize/resize.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/network_call/network_call.dart';
import 'package:santhe/pages/login_pages/phone_number_login_page.dart';
import 'package:santhe/pages/nav_bar_pages/privacy_policy_page.dart';
import 'package:santhe/pages/nav_bar_pages/terms_condition_page.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:santhe/widgets/confirmation_widgets/success_snackbar_widget.dart';

import '../core/app_shared_preference.dart';
import '../core/app_theme.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          splashRadius: 0.1,
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors().white100,
            size: 20.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Delete Account",
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60.h,
                width: 60.h,
                child: Image.asset('assets/delete.png'),
              ),
              SizedBox(width: 17.w,),
              Text(
                'Deleting your Account',
                style: AppTheme().bold700(18, color: AppColors().red100),
              )
            ],
          ),
          SizedBox(height: 28.h,),
          //points
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            child: Column(
              children: [
                Text(
                  'Please be aware of the following, while deleting your account',
                  style: AppTheme().normal400(18, color: AppColors().grey80),
                ),
                SizedBox(height: 34.h,),
                //points
                //point 1
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•',
                      style: AppTheme().normal400(18, color: AppColors().grey80),
                    ),
                    SizedBox(width: 10.w,),
                    Expanded(
                      child: Text(
                        'Your Account deletion cannot be reversed',
                        style: AppTheme().normal400(18, color: AppColors().grey80),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h,),
                //point 2
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•',
                      style: AppTheme().normal400(18, color: AppColors().grey80),
                    ),
                    SizedBox(width: 10.w,),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'To know more about data deletion please review our ',
                                style: AppTheme().normal400(18, color: AppColors().grey80),
                              ),
                              TextSpan(
                                  text: 'Terms and Conditions ',
                                  style: AppTheme().normal400(18, color: AppColors().purple100),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: const TermsAndConditionsPage(),
                                              type: PageTransitionType.rightToLeft));
                                    }
                              ),
                              TextSpan(
                                text: 'and ',
                                style: AppTheme().normal400(18, color: AppColors().grey80),
                              ),
                              TextSpan(
                                  text: 'Privacy Policy',
                                  style: AppTheme().normal400(18, color: AppColors().purple100),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: const PrivacyPolicyPage(),
                                              type: PageTransitionType.rightToLeft));
                                    }
                              )
                            ]
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h,),
                //point 3
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•',
                      style: AppTheme().normal400(18, color: AppColors().grey80),
                    ),
                    SizedBox(width: 10.w,),
                    Expanded(
                      child: Text(
                        'Incase of any questions about your account, you can write to us at contact@santhe.in',
                        style: AppTheme().normal400(18, color: AppColors().grey80),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 40.h,),
                //buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        height: 50.h,
                        width: 150.w,
                        child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Go Back'))),
                    SizedBox(
                        height: 50.h,
                        width: 150.w,
                        child: ElevatedButton(
                          onPressed: (){
                            showDialog(context: context, builder: (builder) => StatefulBuilder(builder: (builder, setState) => Center(
                              child: SizedBox(
                                height: 280.h,
                                width: 380.w,
                                child: Card(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 15.h,),
                                      Text(
                                        'Are you sure?',
                                        style: AppTheme().bold700(24, color: AppColors().brandDark),
                                      ),
                                      SizedBox(height: 18.h,),
                                      Text(
                                        'We are Sorry to see your leave!\nIf you change your\nmind, now is your chance',
                                        textAlign: TextAlign.center,
                                        style: AppTheme().normal400(18, color: AppColors().grey80),
                                      ),
                                      SizedBox(
                                        height: 37.h,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                              height: 55.h,
                                              width: 145.w,
                                              child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))),
                                          SizedBox(
                                              height: 55.h,
                                              width: 145.w,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    if(!isLoading){
                                                      setState(() {
                                                        isLoading = true;
                                                      });

                                                      final result = await NetworkCall().deleteUser();
                                                      if (result) {
                                                        await FirebaseAuth.instance.signOut();
                                                        final  profile = Get.find<ProfileController>();
                                                        AllListController allListController = Get.find();
                                                        profile.deleteEverything();
                                                        allListController.deleteEverything();
                                                        AppSharedPreference().setLogin(false);
                                                        successMsg('Success', 'Successfully deleted account');
                                                        Get.offAll(() => const LoginScreen());
                                                      } else {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        errorMsg('Failed', 'User deletion failed');
                                                      }
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                          (Set<MaterialState> states) {
                                                        if (states.contains(MaterialState.disabled)) {
                                                          return AppColors().grey80;
                                                        }
                                                        return AppColors().grey80; // Use the component's default.
                                                      },
                                                    ),),
                                                  child: isLoading ? SizedBox(height: 20.h, width: 20.h, child: CircularProgressIndicator(color: AppColors().white100,),) : Text('Yes, Delete')
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )));
                          },
                          style:  ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return AppColors().grey80;
                                }
                                return AppColors().grey80; // Use the component's default.
                              },
                            ),),
                          child: Text('Delete'),
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
