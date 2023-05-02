// ignore_for_file: non_constant_identifier_names, prefer_final_fields

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/app_url.dart';
import 'package:santhe/core/blocs/address/address_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/models/ondc/shop_model.dart';
import '../../models/ondc/single_order_model.dart';
import '../../models/ondc/support_contact_models.dart';
import '../blocs/ondc/ondc_bloc.dart';

class OndcRepository with LogMixin {
  String? transactionid;
  int _productGlobalCount = 0;
  int _shopProductCount = 0;
  int _shopsListCount = 0;
  int _searchProductCountInLocalShop = 0;
  int cartCount = 0;

  int get productGlobalCount {
    return _productGlobalCount;
  }

  int get shopsListCount {
    return _shopsListCount;
  }

  int get searchProductCountInLocalShop {
    return _searchProductCountInLocalShop;
  }

  int get totalCartItemCount {
    return cartCount;
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

  Future<List<ShopModel>> getNearByShopsModel() async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    warningLog('Firebase Id being sent$firebaseId');
    //! Firebase id needs to be updated
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/ondc/store/nearby?limit=20&offset=0&firebase_id=$firebaseId');
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

  getProductsOfShop({required String shopId}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/ondc/store/item/nearby?storeLocation_id=$shopId&search=&limit=12&offset=0&firebase_id=$firebaseId');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    warningLog('url sent to get the products $url');

    try {
      final response = await http.get(url, headers: header);
      warningLog('${response.statusCode} and ${response.body}');
      final responseBody =
          await json.decode(response.body)['data']["rows"] as List<dynamic>;
      warningLog('$responseBody');
      // _shopProductCount =
      //     await json.decode(response.body)['data']['count'] as int;
      final List<ProductOndcModel> products =
          responseBody.map((e) => ProductOndcModel.fromNewMap(e)).toList();
      warningLog('$products');
      return products;
    } catch (e) {
      warningLog(e.toString());
      throw ErrorFetchingProductsOfShops(message: e.toString());
    }
  }

  Future<List<ProductOndcModel>?> getProductsOnSearchinLocalShop({
    required String shopId,
    required String productName,
  }) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/ondc/store/item/nearby?&storeLocation_id=$shopId&search=%$productName%&limit=12&offset=0&firebase_id=$firebaseId');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      warningLog('product name $productName also $url');
      final response = await http.get(url, headers: header);
      warningLog('${response.statusCode}');

      warningLog(
          '################ ROW COUNT = ${json.decode(response.body)['data']["count"]}');

      warningLog(
          '################ TYPE IS ${json.decode(response.body)['type']}');

      if (json.decode(response.body)['type'] == "SUCCESS" &&
          json.decode(response.body)['data']["count"] as int != 0) {
        final responseBody =
            await json.decode(response.body)['data']['rows'] as List<dynamic>;

        warningLog('RESPONSE BODY = $responseBody');

        // _searchProductCountInLocalShop =
        //     await json.decode(response.body)['data']['count'] as int;

        List<ProductOndcModel> searchedProducts =
            responseBody.map((e) => ProductOndcModel.fromNewMap(e)).toList();
        warningLog('$searchedProducts');

        return searchedProducts;
      } else if (json.decode(response.body)['type'] == "SUCCESS" &&
          json.decode(response.body)['data']["count"] as int == 0) {
        return null;
      }
      return null;

      // else{
      //   BlocProvider.of<OndcBloc>(context).add(ErrorFetchingProductsOfShopsEvent(
      //     message: json.decode(response.body)["message"]
      //   ));
      // }
    } catch (e) {
      warningLog(e.toString());

      rethrow;
    }
  }

  Future<List<ProductOndcModel>> searchProductsOnGlobal(
      {required String transactionIdLocal, required String productName}) async {
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/ondc/item/nearby?transaction_id=$transactionIdLocal&search=%$productName%&limit=10&offset=0');
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

  Future<int> getCartCountMethod({required String storeLocation_id}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/ondc/cart/count?firebase_id=$firebaseId&storeLocation_id=$storeLocation_id');
    try {
      warningLog('logging count url $url');
      final response = await http.get(url, headers: header);
      warningLog('Count code${response.statusCode}');
      final responseBody = json.decode(response.body);
      warningLog('Count body$responseBody');
      cartCount = responseBody['data'];
      debugLog('cartCount $cartCount');
      return cartCount;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ShopModel>> getListOfShopsForSearchedProduct(
      {required String productName}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/ondc/item/nearby?search=$productName&limit=10&offset=0&firebase_id=$firebaseId');
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

      warningLog('Searched shops $shopsWithSearchedProduct');
      return shopsWithSearchedProduct;
    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }


  Future<Data> getSingleOrder({required String OrderId}) async {
    // "89088251-33a2-4e2b-9602-e83f5fb57f7d";
    //  "e80574c6-32f2-45ce-8b67-d97a89490523";

    final url = Uri.parse(
        "https://ondcstaging.santhe.in/santhe/ondc/customer/order/$OrderId");

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    try {
      warningLog('GET Single ODER DETAILS $url');

      final response = await http.get(url, headers: header);

      warningLog('${response.statusCode}');

      final responseBody = await json.decode(response.body);

      warningLog(' respose here =============############### $responseBody');

      Data data = Data.fromJson(responseBody);
      //SingleOrderModel.fromJson(responseBody);
      /// data.add(SingleOrderModel.fromJson(responseBody));

      warningLog('${data.singleOrderModel!.quotes!.first.status}');

      return data;
    } catch (e) {
      warningLog(e.toString());

      rethrow;
    }
  }

  Future<List<SingleOrderModel>> getPastOrder({required String offset}) async {
    final firebaseId = //"8808435978";
        AppHelpers().getPhoneNumberWithoutCountryCode;

    final url = Uri.parse(
        "https://ondcstaging.santhe.in/santhe/ondc/customer/"
            "order/list?limit=10&offset=$offset&"
        "firebase_id=$firebaseId");

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    try {

      warningLog('GET Past ODER DETAILS $url');

      final response = await http.get(url, headers: header);

      warningLog('${response.statusCode}');

      final responseBody = await json.decode(response.body)["data"]["rows"];

      warningLog(' respose here =============############### $responseBody');

      List<SingleOrderModel> data = SingleOrderModel.fromList(responseBody);

      //warningLog('${data.first.quotes!.first.status}');

      return data;

    } catch (e) {
      warningLog(e.toString());

      rethrow;
    }
  }

  Future<List<CategoryModel>> getCategoryForContactSupport() async {


    final url = Uri.parse('https://ondcstaging.santhe.in/santhe'
        '/ondc/issue/category');

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    try {
      warningLog('Get Category Customer Contact url = $url');
      final response = await http.get(
        url,
        headers: header,
      );

      warningLog('${response.statusCode}');

      final responseBody = await json.decode(response.body)["data"]["rows"];

     List<CategoryModel> list =  CategoryModel.fromList(responseBody);

      warningLog('$responseBody');

      return list;
    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }


  Future<List<CategoryModel>> getSubCategoryForContactSupport() async {


    final url = Uri.parse('https://ondcstaging.santhe.in/santhe/'
        'ondc/issue/subcategory?category=ORDER');

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    try {
      warningLog('Get Sub Category Customer Contact url = $url');
      final response = await http.get(
        url,
        headers: header,
      );

      warningLog('${response.statusCode}');

      final responseBody = await json.decode(response.body)["data"]["rows"];

      List<CategoryModel> list =  CategoryModel.fromList(responseBody);

      warningLog('$responseBody');

      return list;
    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }



  Future<String> raiseIssue(
      {required String orderId, required String longDescription,
        required List<String> cartItemPricesId, required List<String> images,
         String? shortDescription, required String categoryCode,
        required String subCategoryCode}) async {


    final url = Uri.parse('https://ondcstaging.santhe.in/santhe/ondc/issue/raise');

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    try {
      warningLog('Raise Issue URL = $url');
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
            {
              "order_id": orderId,
              "long_description": longDescription,
              "category_code": categoryCode,
              "sub_category_code": subCategoryCode,
              "short_description":" ",
              "imagesArr":images,
              "cartItemIds":cartItemPricesId
            }
        ),
      );

      warningLog('${response.statusCode}');

      final responseType = await json.decode(response.body);

      final responseMessage = await json.decode(response.body)["type"];

      warningLog('RESPONSE Body IS $responseType');

      warningLog('RESPONSE type IS $responseMessage');

      return responseMessage;

    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }
}
