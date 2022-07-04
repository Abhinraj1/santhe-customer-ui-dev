import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/login_pages/phone_number_login_page.dart';

class ProfileController extends GetxController{

  CustomerModel? customerDetails;

  bool isRegistered = false;

  bool isLoggedIn = false;

  String? _urlToken;

  String get urlToken => _urlToken ?? '';

  Future<void> initialiseUrlToken({bool override = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      isLoggedIn = true;
      final tokenId = await user.getIdToken();
      _urlToken = tokenId;
      log(tokenId);
    }else{
      isLoggedIn = false;
      if(!override){
        Get.offAll(()=>const LoginScreen());
      }
    }
  }

  Future<void> initialise() async{
    await initialiseUrlToken(override: true);
    await getCustomerDetailsInit();
  }

  Future<void> getCustomerDetailsInit() async {
    final apiController = Get.find<APIs>();
    final result = await apiController.getCustomerInfo(int.parse(AppHelpers().getPhoneNumberWithoutCountryCode));
    if(result==0){
      isRegistered = false;
    }else{
      isRegistered = true;
    }
  }

  set getCustomerDetails(CustomerModel customer){
    customerDetails = customer;
  }
}