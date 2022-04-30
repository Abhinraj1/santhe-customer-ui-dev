import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/registrationController.dart';
import 'package:santhe/models/santhe_user_model.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:santhe/pages/onboarding_page.dart';

import '../../constants.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/boxes_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../models/santhe_cache_refresh.dart';
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
  final apiController = Get.find<APIs>();
  final _formKey = GlobalKey<FormState>();
  String userName = '', userEmail = '', userRefferal = '';
  final TextEditingController _addressController = TextEditingController();
  bool mapSelected = false;

  Future init() async {
    //OVOOVOVOOO
    CacheRefresh newCacheRefresh = await apiController.cacheRefreshInfo();
    var box = Boxes.getCacheRefreshInfo();

    //getting all content that's to be cached if not already done
    if (!box.containsKey('cacheRefresh') || box.isEmpty) {
      //cat data
      await apiController.getAllCategories();
      box.put('cacheRefresh', newCacheRefresh);

      //faq data
      await apiController.getAllFAQs();

      //aboutUs & terms n condition data
      await apiController.getCommonContent();

      //items data for search
      // await apiController.getAllItems();

      print('first cache load');
    }

    //catUpdate checking
    if (box
            .get('cacheRefresh')
            ?.catUpdate
            .isBefore(newCacheRefresh.catUpdate) ??
        true) {
      print(
          '========${box.get('cacheRefresh')?.catUpdate} vs ${newCacheRefresh.catUpdate}');
//calling api and saving to db (api code has db write code integrated)
      await apiController.getAllCategories();
      print('>>>>>>>>>>>>>>fetching cat');
    }
    // apiController.initCategoriesDB();

    //faq cache check and storing
    if (box
            .get('cacheRefresh')
            ?.custFaqUpdate
            .isBefore(newCacheRefresh.custFaqUpdate) ??
        true) {
      //get & store faq data
      print('-----------------Updating FAQ------------------');
      await apiController.getAllFAQs();
    }

    // aboutUs cache check and storing
    if (box
            .get('cacheRefresh')
            ?.aboutUsUpdate
            .isBefore(newCacheRefresh.aboutUsUpdate) ??
        true) {
      print('-----------------Updating About Us------------------');
      await apiController.getCommonContent();
    } else if (box
            .get('cacheRefresh')
            ?.termsUpdate
            .isBefore(newCacheRefresh.termsUpdate) ??
        true) {
      print('-----------------Updating Terms & Condition------------------');
      await apiController.getCommonContent();
    }

    //item cache check and storing
    if (box
            .get('cacheRefresh')
            ?.itemUpdate
            .isBefore(newCacheRefresh.itemUpdate) ??
        true) {
      print('-----------------Refreshing Item Image------------------');
      // await apiController.getAllItems();
      //clearing image cache
      DefaultCacheManager manager = DefaultCacheManager();
      manager.emptyCache();
    }

    box.put('cacheRefresh', newCacheRefresh);

//OVOVOVO
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int userPhoneNumber = widget.userPhoneNumber;
    final registrationController = Get.find<RegistrationController>();

    if (userPhoneNumber == 404) {
      Get.snackbar('Verify Number First',
          'Please Verify Your Phone Number before continuing...');
      Boxes.getUserPrefs().put('showHome', false);
      Boxes.getUserPrefs().put('isRegistered', false);
      Boxes.getUserPrefs().put('isLoggedIn', false);
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        Get.offAll(() => LoginScreen(), transition: Transition.fadeIn);
      });
    }

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    final TextStyle kHintStyle = GoogleFonts.mulish(
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        color: Colors.grey.shade500);
    final TextStyle kTextInputStyle = GoogleFonts.mulish(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        color: Colors.grey.shade600);
    final TextStyle kLabelStyle =
        GoogleFonts.mulish(fontWeight: FontWeight.w500, fontSize: 16.0);
    final locationController = Get.find<LocationController>();
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: 1.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20.sp + MediaQuery.of(context).padding.top,
                  ),
                  Text(
                    'Register',
                    style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w800,
                      color: Colors.orange,
                      fontSize: 24.sp,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 32.sp, left: 23.sp, right: 23.sp),
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
                                  style: GoogleFonts.mulish(
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
                                    initialValue: '$userPhoneNumber',
                                    style: GoogleFonts.mulish(
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
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: const BorderSide(
                                            width: 1.0,
                                            color: Color(0xffD1D1D1)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: const BorderSide(
                                            width: 1.0,
                                            color: Color(0xffD1D1D1)),
                                      ),
                                      hintText: '+91-9090909090',
                                      hintStyle: GoogleFonts.mulish(
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
                                  style: GoogleFonts.mulish(
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
                                  style: GoogleFonts.mulish(
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
                                  style: GoogleFonts.mulish(
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
                                          color: AppColors().grey40,
                                          width: 1.sp)),
                                  padding: EdgeInsets.only(
                                      top: 13.h,
                                      left: 10.w,
                                      right: 10.w,
                                      bottom: 13.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //icon
                                      Container(
                                          height: 24.w,
                                          width: 24.w,
                                          decoration: BoxDecoration(
                                              color: AppColors().brandDark,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Icon(
                                            Icons.home,
                                            color: AppColors().white100,
                                            size: 15.sp,
                                          )),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      //text
                                      Expanded(
                                        child: Obx(() => Text(
                                              registrationController
                                                          .address.value
                                                          .trim() ==
                                                      ''
                                                  ? 'Select Address'
                                                  : registrationController
                                                          .address.value +
                                                      '\n\n' +
                                                      registrationController
                                                          .howToReach.value,
                                              style: AppTheme().normal500(13),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              /*TextFormField(
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
                                  var res = await Get.to(() => const MapSearchScreen());
                                  if (res == 1) {
                                    setState(() {});
                                  }
                                },
                                readOnly: true,
                                  style: kTextInputStyle,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 6),
                                      child: CircleAvatar(
                                        radius: 4.h,
                                        backgroundColor: Colors.orange,
                                        child: Icon(
                                          Icons.home,
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
                                    hintText: 'select address',
                                    hintStyle: kHintStyle,
                                  ),
                                validator: (value) {
                                  if (registrationController.address.value.trim() == null || registrationController.address.value.trim().isEmpty) {
                                    return 'Please select an address';
                                  } else {
                                    return null;
                                  }
                                  if(registrationController.address.value.trim() == ''){
                                    return 'Enter valid address';
                                  }
                                  else {
                                    return null;
                                  }
                                },
                              )*/
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 100.sp),
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
                                    //final otp check
                                    bool isUserLoggedin = Boxes.getUserPrefs()
                                            .get('isLoggedIn',
                                                defaultValue: false) ??
                                        false;

                                    if (isUserLoggedin) {
                                      Boxes.getUserPrefs()
                                          .put('showHome', true);
                                      Boxes.getUserPrefs()
                                          .put('isRegistered', true);

                                      int userPhone =
                                          Boxes.getUserCredentialsDB()
                                                  .get('currentUserCredentials')
                                                  ?.phoneNumber ??
                                              404;

                                      //todo add how to reach howToReach
                                      User currentUser = User(
                                          address: registrationController
                                              .address.value,
                                          emailId: userEmail,
                                          lat: registrationController.lat.value,
                                          lng: registrationController.lng.value,
                                          pincode: int.parse(
                                              registrationController
                                                  .pinCode.value),
                                          phoneNumber: userPhone,
                                          custId: userPhone,
                                          custName: userName,
                                          custRatings: 5.0,
                                          custReferal: 0,
                                          custStatus: 'active',
                                          howToReach: registrationController
                                              .howToReach.value,
                                          custPlan: 'default',
                                          custLoginTime: DateTime.now());

                                      //todo add to firebase
                                      int userAdded = await apiController
                                          .addCustomer(currentUser);
                                      if (userAdded == 1) {
                                        //add to Hive
                                        Boxes.getUser().put(
                                            'currentUserDetails', currentUser);
                                        Get.offAll(() => const HomePage(),
                                            transition: Transition.fadeIn);
                                      } else {
                                        print('error occurred');
                                        Get.offAll(
                                            () => const OnboardingPage());
                                      }
                                    } else {
                                      // Get.snackbar('Verify Number First',
                                      //     'Please Verify Your Phone Number before continuing...');
                                      Boxes.getUserPrefs()
                                          .put('showHome', false);
                                      Boxes.getUserPrefs()
                                          .put('isRegistered', false);
                                      Boxes.getUserPrefs()
                                          .put('isLoggedIn', false);
                                      //to not show start from odl lsit to new user
                                      Boxes.getContent()
                                          .put('userListCount', '0');
                                      Get.offAll(() => LoginScreen(),
                                          transition: Transition.fadeIn);
                                    }
                                  } else {
                                    // Get.snackbar('', '',
                                    //     titleText: Text(
                                    //       'Enter Values Properly',
                                    //       style: GoogleFonts.mulish(
                                    //           fontWeight: FontWeight.w700,
                                    //           color: Colors.orange,
                                    //           fontSize: 16.0),
                                    //     ),
                                    //     messageText: Text(
                                    //       'Please enter all the required values before continuing...',
                                    //       style: GoogleFonts.mulish(
                                    //           fontWeight: FontWeight.w500,
                                    //           color: const Color(0xff8B8B8B),
                                    //           fontSize: 13.0),
                                    //     ),
                                    //     padding: const EdgeInsets.only(
                                    //         top: 13.0,
                                    //         bottom: 13.0,
                                    //         left: 20.0,
                                    //         right: 13.0),
                                    //     margin: const EdgeInsets.symmetric(
                                    //         vertical: 13.0, horizontal: 10.0),
                                    //     icon: Icon(
                                    //       CupertinoIcons
                                    //           .exclamationmark_triangle_fill,
                                    //       size: 40,
                                    //       color: Colors.orange,
                                    //     ),
                                    //     shouldIconPulse: false,
                                    //     snackPosition: SnackPosition.TOP,
                                    //     boxShadows: [
                                    //       BoxShadow(
                                    //         color:
                                    //         Colors.grey.withOpacity(0.21),
                                    //         blurRadius:
                                    //         15.0, // soften the shadow
                                    //         spreadRadius:
                                    //         3.6, //extend the shadow
                                    //         offset: const Offset(
                                    //           0.0,
                                    //           0.0,
                                    //         ),
                                    //       )
                                    //     ],
                                    //     backgroundColor: Colors.white);
                                  }
                                },
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Done',
                                    style: GoogleFonts.mulish(
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
                padding: EdgeInsets.only(top: 105.sp),
                child: Text(
                  'We will use your Phone number and Email to send you important communications',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                    color: const Color(0xff8B8B8B),
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
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
