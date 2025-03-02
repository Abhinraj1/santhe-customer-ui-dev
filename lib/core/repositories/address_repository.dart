// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/address/address_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/models/ondc/address_ondc_model.dart';

import '../../controllers/registrationController.dart';
import '../app_url.dart';


var homeAddress = "".obs;
var howToReachHome = "".obs;
final registrationController = Get.find<RegistrationController>();

class AddressRepository with LogMixin {
  List<AddressOndcModel> addressOndcModels = [];

  AddressOndcModel? _homeAddress;


  AddressOndcModel? deliveryAddressModel;
  String? deliveryAddressId;

  AddressOndcModel? billingAddressModel;
  String? billingAddressId;

  List<AddressOndcModel> get addressModels {
    return addressOndcModels;
  }

  AddressOndcModel? get deliveryModel {
    return deliveryAddressModel;
  }

  AddressOndcModel? get billingModel {
    return billingAddressModel;
  }

  String? get billingAddressIdGlobal {
    return billingAddressId;
  }

  Future<String> updateAddress({
    required double lat,
    required double lng,
    required String flat,
    required String address_id,
    required String deliveryName,
    String? howtoReach,
  }) async {
    final url = Uri.parse('${AppUrl().baseUrl}/santhe/ondc/address/update');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    var response;
    errorLog('$flat, and also id $address_id also the keyWord $deliveryName');

    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      final getfinalAddress = placemarks[0];
      final body = json.encode({
        "firebase_id": firebaseId,
        "address_name": deliveryName,
        "lat": lat,
        "lng": lng,
        "flat": flat,
        "locality": flat,
        "city": getfinalAddress.locality,
        "state": getfinalAddress.administrativeArea,
        "country": getfinalAddress.country,
        "pincode": getfinalAddress.postalCode,
        "address_id": address_id,
        "howToReach": "$howtoReach"
      });
      warningLog('$url $body');
       response = await http.post(
        url,
        headers: header,
        //! how to reach api update
        body: json.encode(
          {
            "firebase_id": firebaseId,
            "address_name": deliveryName,
            "lat": lat,
            "lng": lng,
            "flat": flat,
            "locality": flat,
            "city": getfinalAddress.locality,
            "state": getfinalAddress.administrativeArea,
            "country": getfinalAddress.country,
            "pincode": getfinalAddress.postalCode,
            "address_id": address_id,
            "howToReach": "$howtoReach"
          },
        ),
      );
      errorLog('${response.statusCode}');
      final responseBody = json.decode(response.body);

      errorLog('$responseBody');

      return responseBody['message'];
    } catch (e) {
     // AppHelpers.crashlyticsLog(response.body.toString());
      throw OndcUpdateAddressErrorState(message: e.toString());
    }
  }

  Future<List<AddressOndcModel>> getAddressList() async {
    addressLoaded.value = false;

    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;

    warningLog('Firebase Id being sent IN GET ADDRESS LIST $firebaseId');
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/ondc/address/list?firebase_id=$firebaseId');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
   var response;
    try {
       response = await http.get(
        url,
        headers: header,
      );
      errorLog('${response.statusCode}');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;

      ///
      errorLog('################ RAW DATA  HEREE also url $url $responseBody');
      addressOndcModels =
          responseBody.map((e) => AddressOndcModel.fromMap(e)).toList();
      errorLog('Fetching address $addressOndcModels');

      ///
      warningLog("################################# body ${addressOndcModels}");
      deliveryAddressModel = addressOndcModels.firstWhere(
        (element) => element.address_name.toString().contains('Delivery'),
      );

      billingAddressModel = addressOndcModels.firstWhere(
        (element) => element.address_name.toString().contains('Billing'),
      );

       _homeAddress = addressOndcModels.firstWhere(
             (element) => element.address_name.toString().contains('Home'),
       );

      errorLog('Delivery ${deliveryAddressModel?.flat}');

      deliveryAddressId = deliveryAddressModel?.id;
       deliveryAddress = deliveryAddressModel;
       registrationController.address.value = _homeAddress!.flat;
       //registrationController.howToReach.value = _homeAddress!.howToReach;
      // customerModel.lat = deliveryAddressModel!.lat;
      // customerModel.lng = deliveryAddressModel!.lng;

      billingAddressId = billingAddressModel?.id;

      warningLog('$deliveryAddressId');
      return addressOndcModels;
    } catch (e) {
      AppHelpers.crashlyticsLog(response.body.toString());
      throw ErrorGettingAddressState(message: e.toString());
    }finally{
      addressLoaded.value = true;
    }
  }
}
