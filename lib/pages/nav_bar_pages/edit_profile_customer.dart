import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:santhe/widgets/confirmation_widgets/success_snackbar_widget.dart';
//EditCustomerProfile
import 'package:santhe/widgets/faq_drop_text_widget.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import '../../controllers/error_user_fallback.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/registrationController.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../models/santhe_user_model.dart';
import '../customer_registration_pages/mapSearchScreen.dart';
import '../home_page.dart';
import '../login_pages/phone_number_login_page.dart';
import '../onboarding_page.dart';

class EditCustomerProfile extends StatefulWidget {
  const EditCustomerProfile({Key? key}) : super(key: key);

  @override
  State<EditCustomerProfile> createState() => _EditCustomerProfileState();
}

class _EditCustomerProfileState extends State<EditCustomerProfile> {
  final _formKey = GlobalKey<FormState>();

  int userPhoneNumber =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;
  User? currentUser =
      Boxes.getUser().get('currentUserDetails') ?? fallBack_error_user;
  late final TextEditingController _addressController = TextEditingController();
  late final TextEditingController _userNameController =
      TextEditingController(text: currentUser?.custName ?? 'John Doe');
  late final TextEditingController _userEmailController =
      TextEditingController(text: currentUser?.emailId ?? 'johndoe@gmail.com');
  bool addressUpdateFlag = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.orange,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final registrationController = Get.find<RegistrationController>();
    final apiController = Get.find<APIs>();
    double screenHeight = MediaQuery.of(context).size.height / 100;

    if (userPhoneNumber == 404) {
      Get.snackbar('Verify Number First',
          'Please Verify Your Phone Number before continuing...');
      Boxes.getUserPrefs().put('showHome', false);
      Boxes.getUserPrefs().put('isRegistered', false);
      Boxes.getUserPrefs().put('isLoggedIn', false);
      Get.offAll(() => LoginScreen(), transition: Transition.fadeIn);
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
          style: GoogleFonts.mulish(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: 1.sw,
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
                                    style: GoogleFonts.mulish(
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.0,
                                        fontSize: 16.sp,
                                        color: Colors.grey.shade600),
                                    decoration: InputDecoration(
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
                                      hintText:
                                      '+91-${currentUser?.custId ?? '91-9876543210'}',
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
                                  keyboardType: TextInputType.name,
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
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25.sp),
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
                                      User? currentUser = Boxes.getUser()
                                          .get('currentUserDetails') ??
                                          fallBack_error_user;

                                      int userPhone =
                                          Boxes.getUserCredentialsDB()
                                              .get('currentUserCredentials')
                                              ?.phoneNumber ??
                                              404;

                                      if (userPhone == 404) {
                                        Get.off(() =>  LoginScreen());
                                      }

                                      //todo add how to reach howToReach
                                      User updatedUser = User(
                                          address: registrationController
                                              .address.value,
                                          emailId: _userEmailController.text,
                                          lat: addressUpdateFlag
                                              ? registrationController.lat.value
                                              : currentUser.lat,
                                          lng: addressUpdateFlag
                                              ? registrationController.lng.value
                                              : currentUser.lng,
                                          pincode: addressUpdateFlag
                                              ? int.parse(registrationController
                                              .pinCode.value)
                                              : currentUser.pincode,
                                          phoneNumber: userPhone,
                                          custId: userPhone,
                                          custName: _userNameController.text,
                                          custRatings: currentUser.custRatings,
                                          custReferal: 0000,
                                          custStatus: 'active',
                                          howToReach: registrationController.howToReach.value,
                                          custLoginTime: DateTime.now(),
                                          custPlan: 'default');
//todo add cust plan
                                      //todo add to firebase
                                      int userUpdated = await apiController
                                          .updateCustomerInfo(
                                          userPhone, updatedUser);
                                      if (userUpdated == 1) {
//since update user calls getCustomerInfo which auto adds to hive DB no need to add data to hive DB.
                                        successMsg('Profile Updated',
                                            'Your profile information was updated successfully.');

//go back after successful user profile edit, Get.back() didn't work for some reason
                                        Navigator.pop(context);
                                      } else {
                                        errorMsg('Connectivity Error',
                                            'Some connectivity error has occurred, please try again later!');
                                        // Get.offAll(
                                        //     () => const OnboardingPage());
                                      }
                                    } else {
                                      errorMsg('Verify Number First',
                                          'Please Verify Your Phone Number before continuing...');
                                      Boxes.getUserPrefs()
                                          .put('showHome', false);
                                      Boxes.getUserPrefs()
                                          .put('isRegistered', false);
                                      Boxes.getUserPrefs()
                                          .put('isLoggedIn', false);
                                      Get.offAll(() =>  LoginScreen(),
                                          transition: Transition.fadeIn);
                                    }
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
                padding: EdgeInsets.only(top: 18.sp),
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
