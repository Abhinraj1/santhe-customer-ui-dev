// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/address/address_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/models/ondc/address_ondc_model.dart';

class AddressRepository with LogMixin {
  List<AddressOndcModel> addressOndcModels = [];

  AddressOndcModel? deliveryAddressModel;
  String? deliveryAddressId;

  List<AddressOndcModel> get addressModels {
    return addressOndcModels;
  }

  AddressOndcModel? get deliveryModel {
    return deliveryAddressModel;
  }

  String? get deliveryAddressIdGlobal {
    return deliveryAddressId;
  }

  Future<String> updateAddress({
    required double lat,
    required double lng,
    required String flat,
    required String address_id,
  }) async {
    final url =
        Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/address/update');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    errorLog('$flat, and also id $address_id');
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      final getfinalAddress = placemarks[0];
      warningLog('$getfinalAddress');
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {
            "firebase_id": AppHelpers().getPhoneNumberWithoutCountryCode,
            "address_name": "Delivery",
            "lat": lat,
            "lng": lng,
            "flat": flat,
            "locality": flat,
            "city": getfinalAddress.locality,
            "state": getfinalAddress.administrativeArea,
            "country": getfinalAddress.country,
            "pincode": getfinalAddress.postalCode,
            "address_id": address_id
          },
        ),
      );
      errorLog('${response.statusCode}');
      final responseBody = json.decode(response.body);
      errorLog('$responseBody');
      return responseBody['message'];
    } catch (e) {
      throw OndcUpdateAddressErrorState(message: e.toString());
    }
  }

  getAddressList() async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    warningLog('Firebase Id being sent$firebaseId');
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/address/list?firebase_id=$firebaseId');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      final response = await http.get(
        url,
        headers: header,
      );
      errorLog('${response.statusCode}');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      errorLog('$responseBody');
      addressOndcModels =
          responseBody.map((e) => AddressOndcModel.fromMap(e)).toList();
      errorLog('${addressOndcModels}');
      deliveryAddressModel = addressOndcModels.firstWhere(
        (element) => element.address_name.toString().contains('Delivery'),
      );
      errorLog('$deliveryAddressModel');
      deliveryAddressId = deliveryAddressModel?.id;
      warningLog('$deliveryAddressId');
      return addressOndcModels;
    } catch (e) {
      throw ErrorGettingAddressState(message: e.toString());
    }
  }
}
