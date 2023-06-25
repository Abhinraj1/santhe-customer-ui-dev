import 'dart:convert';

import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/models/hyperlocal_models/hyperlocal_productmodel.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';

import '../blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';

class HyperLocalRepository with LogMixin {
  List<HyperLocalShopModel> localHyperLocalShopModel = [];
  List<HyperLocalShopModel> searchHyperLocalShopModels = [];
  List<HyperLocalProductModel> localHyperLocalProductModel = [];
  List<HyperLocalProductModel> searchHyperLocalProductModel = [];

  dynamic cartTotalCountLocal;
  dynamic _itemCount = '';
  dynamic _searchItemCount = '';

  dynamic get totalCartCount {
    return cartTotalCountLocal;
  }

  dynamic get searchItemCount {
    return _searchItemCount;
  }

  dynamic get itemCount {
    return _itemCount;
  }

  List<HyperLocalShopModel> get hyperLocalShopModel {
    return localHyperLocalShopModel;
  }

  List<HyperLocalShopModel> get searchHyperLocalShopModelsGlobal {
    return searchHyperLocalShopModels;
  }

  List<HyperLocalProductModel> get productModels {
    return localHyperLocalProductModel;
  }

  List<HyperLocalProductModel> get searchModels {
    return searchHyperLocalProductModel;
  }

  Future<List<HyperLocalShopModel>> getHyperLocalShops(
      {String? lat, String? lng}) async {
    final url = Uri.parse(
        'https://api.santhe.in/santhe/hyperlocal/merchant/list?lat=$lat&lang=$lng&limit=10&offset=0');
    try {
      debugLog('HyperLocal Url for Shops $url');
      final response = await http.get(url);
      warningLog(
          'Response Structure ${response.statusCode} HyperLocal Url for Shops $url and body ${response.body} ');
      final responseBody = json.decode(response.body)['data'] as List;
      warningLog('Response Body Structure $responseBody');
      localHyperLocalShopModel = [];
      for (var element in responseBody) {
        // errorLog('Checking for data in getHyperlocalShops $element');
        localHyperLocalShopModel.add(HyperLocalShopModel.fromMap(element));
      }
      warningLog('$localHyperLocalShopModel');
      return localHyperLocalShopModel;
    } catch (e) {
      throw HyperLocalGetShopErrorState(message: e.toString());
    }
  }

  Future<List<HyperLocalShopModel>> getHyperLocalSearchShop(
      {required String nameOfProduct,
      required String lat,
      required String lng}) async {
    final url = Uri.parse(
        'https://api.santhe.in/santhe/hyperlocal/product/search?limit=10&offset=0&item_name=$nameOfProduct&lat=$lat&lang=$lng');
    try {
      final response = await http.get(url);
      infoLog(
          'status code of url $url ${response.statusCode} and body ${response.body}');
      final responsebody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      debugLog('search body $responsebody');
      searchHyperLocalShopModels = [];
      for (var element in responsebody) {
        searchHyperLocalShopModels.add(
          HyperLocalShopModel.fromMap(
            element['storeDescription'],
          ),
        );
      }
      warningLog('Search Models $searchHyperLocalShopModels');
      return searchHyperLocalShopModels;
    } catch (e) {
      throw HyperLocalGetShopSearchErrorState(
        message: e.toString(),
      );
    }
  }

  Future<List<HyperLocalProductModel>> getProductsOfShop(
      {required String storeId,
      required String lat,
      required String lng}) async {
    final url = Uri.parse(
        'https://api.santhe.in/santhe/hyperlocal/product/list?store_description_id=$storeId&limit=10&offset=0&lat=$lat&lang=$lng');
    try {
      final response = await http.get(url);
      warningLog('statusCode of Get ${response.statusCode} and url $url');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      _itemCount = json.decode(response.body)['data']['count'];
      debugLog('Body of the products ${responseBody.length}');
      localHyperLocalProductModel = [];
      // final HyperLocalShopModel hyperLocal =
      //     HyperLocalShopModel.fromMap(responseBody.first);
      // warningLog('Checking for ${hyperLocal}');
      for (var element in responseBody) {
        localHyperLocalProductModel.add(
          HyperLocalProductModel.fromMap(element),
        );
      }
      return localHyperLocalProductModel;
    } catch (e) {
      throw HyperLocalGetProductsOfShopErrorState(
        message: e.toString(),
      );
    }
  }

  Future<List<HyperLocalProductModel>> getSearchProductsOfShop(
      {required final String storeId,
      required final String itemName,
      required final String lat,
      required final String lng}) async {
    final url = Uri.parse(
        'https://api.santhe.in/santhe/hyperlocal/product/search?store_description_id=$storeId&limit=10&offset=0&item_name=$itemName&lat=$lat&lang=$lng');
    try {
      final response = await http.get(url);
      warningLog(
          'Status Code of search product api${response.statusCode} of url $url');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      _searchItemCount = json.decode(response.body)['data']['count'];
      warningLog('ResponseBody Search $_searchItemCount $responseBody');
      searchHyperLocalProductModel = [];
      for (var element in responseBody) {
        searchHyperLocalProductModel.add(
          HyperLocalProductModel.fromMap(element),
        );
      }
      warningLog('Search models $searchHyperLocalProductModel');
      return searchHyperLocalProductModel;
    } catch (e) {
      throw HyperLocalGetSearchProductsOfShopErrorState(
        message: e.toString(),
      );
    }
  }

  Future<dynamic> getCartCount({required String storeDescriptionId}) async {
    final firebaseID = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url = Uri.parse(
        'https://api.santhe.in/santhe/hyperlocal/cart/count?firebase_id=$firebaseID&storeDescription_id=$storeDescriptionId');
    try {
      final response = await http.get(url);
      warningLog(
          'cart Count hyper local ${response.statusCode} ${response.body}');
      final responseBody = json.decode(response.body)['data'] as dynamic;
      cartTotalCountLocal = responseBody;
      return cartTotalCountLocal;
    } catch (e) {
      rethrow;
    }
  }
}
