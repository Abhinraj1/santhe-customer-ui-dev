// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/app_url.dart';
import 'package:santhe/core/blocs/address/address_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/models/ondc/shop_model.dart';

class OndcRepository with LogMixin {
  String? transactionid;
  int _productGlobalCount = 0;
  int _shopProductCount = 0;
  int _shopsListCount = 0;
  int _searchProductCountInLocalShop = 0;

  int get productGlobalCount {
    return _productGlobalCount;
  }

  int get shopsListCount {
    return _shopsListCount;
  }

  int get searchProductCountInLocalShop {
    return _searchProductCountInLocalShop;
  }

  int get productShopCount {
    return _shopProductCount;
  }

  String get transactionId {
    return transactionid!;
  }

  Future<String?> getNearByOndcShopsTransactionId(
      {required String lat,
      required String lng,
      required String pincode,
      required bool isDelivery}) async {
    final url = Uri.parse(AppUrl.transactionIdUrl);
    // final tokenHandler = Get.find<ProfileController>();
    // await tokenHandler.generateUrlToken();
    // final token = tokenHandler.urlToken;
    // final header = {"authorization": 'Bearer $token'};
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    // final header = {"authorization": 'Bearer $authtoken'};
    try {
      warningLog('the header token being sent $header');
      final response = await http.get(
        url,
        // body: json.encode({
        //   "firebase_id": 2.toString(),
        //   // "lat": lat,
        //   // "lng": lng,
        //   // "pincode": pincode,
        //   // "isDelivery": isDelivery
        // }),
        headers: header,
      );
      warningLog('checking for transactionid response${response.statusCode}');
      final responseBody = json.decode(response.body)['data']['transaction_id'];
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
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    warningLog('Firebase Id being sent$firebaseId');
    //! Firebase id needs to be updated
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/store/nearby?transaction_id=$transactionIdl&limit=10&offset=0&firebase_id=$firebaseId');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      warningLog('api call made to shops $url');
      final response = await http.get(url, headers: header);
      warningLog('checking for shop model via transcationid $response');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      final count = json.decode(response.body);
      warningLog('shops$count $responseBody ');
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
        'http://ondcstaging.santhe.in/santhe/ondc/store/item/nearby?transaction_id=$transactionIdLoc&storeLocation_id=$shopId&search=%%&limit=10&offset=0');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    warningLog('url sent to get the products $url');

    try {
      final response = await http.get(url, headers: header);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['data'] as List<dynamic>;
      warningLog('$responseBody');
      // _shopProductCount =
      //     await json.decode(response.body)['data']['count'] as int;
      final List<ProductOndcModel> products =
          responseBody.map((e) => ProductOndcModel.fromNewMap(e)).toList();
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
        'http://ondcstaging.santhe.in/santhe/ondc/store/item/nearby?transaction_id=$transactionIdLoc&storeLocation_id=$shopId&search=%$productName%&limit=100&offset=0');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      warningLog('product name $productName alsoe $url');
      final response = await http.get(url, headers: header);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['data'] as List<dynamic>;
      warningLog('$responseBody');
      // _searchProductCountInLocalShop =
      //     await json.decode(response.body)['data']['count'] as int;
      List<ProductOndcModel> searchedProducts =
          responseBody.map((e) => ProductOndcModel.fromNewMap(e)).toList();
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
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      warningLog('global search product $productName');
      final response = await http.get(url, headers: header);
      warningLog('${response.statusCode}');

      final responseBody =
          await json.decode(response.body)['data']['rows'] as List<dynamic>;

      warningLog('$responseBody');
      _productGlobalCount =
          await json.decode(response.body)['data']['count'] as int;
      warningLog('checking for count of global items $_productGlobalCount');
      List<ProductOndcModel> searchedProducts =
          responseBody.map((e) => ProductOndcModel.fromNewMap(e)).toList();
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

  Future<List<ShopModel>> getListOfShopsForSearchedProduct(
      {required String transactionIdLocal, required String productName}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/item/nearby?transaction_id=$transactionIdLocal&search=$productName&limit=15&offset=0&firebase_id=$firebaseId');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      warningLog('global search product $url');
      final response = await http.get(url, headers: header);
      warningLog('${response.statusCode}');
      final responseBody =
          await json.decode(response.body)['data']['rows'] as List<dynamic>;

      warningLog('$responseBody');
      _shopsListCount =
          await json.decode(response.body)['data']['count'] as int;
      warningLog('checking for count of global items $_shopsListCount');
      List<ShopModel> shopsWithSearchedProduct =
          responseBody.map((e) => ShopModel.fromMap(e)).toList();
      warningLog('$shopsWithSearchedProduct');
      return shopsWithSearchedProduct;
    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }
}
