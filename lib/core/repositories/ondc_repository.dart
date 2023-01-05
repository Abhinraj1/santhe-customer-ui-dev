import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/app_url.dart';
import 'package:santhe/core/error/error_handler.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/models/ondc/shop_model.dart';

import '../../controllers/getx/profile_controller.dart';

class OndcRepository with LogMixin {
  String? transactionid;

  String get transactionId {
    return transactionid!;
  }

  Future<String?> getNearByOndcShopsTransactionId(
      {required String lat,
      required String lng,
      required String pincode,
      required bool isDelivery}) async {
    final url = Uri.parse(AppUrl.getNearByStore);
    // final tokenHandler = Get.find<ProfileController>();
    // await tokenHandler.generateUrlToken();
    // final token = tokenHandler.urlToken;
    // final header = {"authorization": 'Bearer $token'};
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    // final header = {"authorization": 'Bearer $authtoken'};
    try {
      final response = await http.post(url,
          body: json.encode({
            "firebase_id": 2.toString(),
            // "lat": lat,
            // "lng": lng,
            // "pincode": pincode,
            // "isDelivery": isDelivery
          }),
          headers: header);
      warningLog('$response');
      final responseBody =
          json.decode(response.body)['context']['transaction_id'];
      warningLog('transactionId $responseBody');
      transactionid = responseBody;
      return transactionid;
      //getting shop logic
      // final shopurl = Uri.parse(
      //     'http://ondcstaging.santhe.in/santhe/ondc/store/nearby?transaction_id=$transactionid');
      // final responseShop = await http.get(shopurl, headers: header);
      // warningLog('checking for shop model via transcationid ${response.body}');
      // final responseBodyShop =
      //     json.decode(responseShop.body)['data']['rows'] as List<dynamic>;
      // warningLog('shops $responseBodyShop');
      // List<ShopModel> shopModel =
      //     responseBodyShop.map((e) => ShopModel.fromMap(e)).toList();
      // warningLog('$shopModel');
      // return shopModel;
      //warningLog('$shopModels');
    } catch (e) {
      rethrow;
    }
  }

  // Future<String> getAddressId({required String addressId})async{
  //   final url = Uri.parse('uri')
  // }

  Future<List<ShopModel>> getNearByShopsModel(
      {required String transactionIdl}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/store/nearby?transaction_id=$transactionIdl&limit=10&offset=0&firebase_id=2');
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      final response = await http.get(url, headers: header);
      warningLog('checking for shop model via transcationid $response');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('shops $responseBody');
      List<ShopModel> shopModel =
          responseBody.map((e) => ShopModel.fromMap(e)).toList();
      warningLog('shopModels $shopModel');
      return shopModel;
    } catch (e) {
      rethrow;
    }
  }

  getProductsOfShop(
      {required String shopId, required String transactionIdLoc}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/store/item/nearby?transaction_id=$transactionIdLoc&store_id=$shopId&search=%%&limit=100&offset=0');
    try {
      final response = await http.get(url);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('$responseBody');
      List<ProductOndcModel> products =
          responseBody.map((e) => ProductOndcModel.fromMap(e)).toList();
      warningLog('$products');
      return products;
    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }

  Future<List<ProductOndcModel>> getProductsOnSearchinLocalShop(
      {required String shopId,
      required String transactionIdLoc,
      required String productName}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/store/item/nearby?transaction_id=$transactionIdLoc&store_id=$shopId&search=%$productName%&limit=100&offset=0');
    try {
      warningLog('product name $productName');
      final response = await http.get(url);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('$responseBody');
      List<ProductOndcModel> searchedProducts =
          responseBody.map((e) => ProductOndcModel.fromMap(e)).toList();
      warningLog('$searchedProducts');
      return searchedProducts;
    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }

  Future<List<ProductOndcModel>> searchProductsOnGlobal(
      {required String transactionIdLocal, required String productName}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/item/nearby?transaction_id=$transactionIdLocal&search=%$productName%&limit=10&offset=0');
    try {
      warningLog('global search product $productName');
      final response = await http.get(url);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('$responseBody');
      List<ProductOndcModel> searchedProducts =
          responseBody.map((e) => ProductOndcModel.fromMap(e)).toList();
      warningLog('$searchedProducts');
      return searchedProducts;
    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }

  List<ShopModel> convertJsonToModel({required List<dynamic> jsonData}) {
    warningLog('json Data ${jsonData[0]['name']}');
    List<ShopModel> shopModel =
        jsonData.map((e) => ShopModel.fromMap(e)).toList();
    warningLog('$shopModel');
    return shopModel;
  }
}
