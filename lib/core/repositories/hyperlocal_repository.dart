import 'dart:convert';

import 'package:get/get.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/models/hyperlocal_models/hyperlocal_productmodel.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';

import '../../models/tutorial_link_model.dart';
import '../app_url.dart';
import '../blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';
import '../cubits/hyperlocal_shopDetails_cubit/hyperlocal_shop_details_cubit.dart';
import '../cubits/hyperlocal_shoplist_cubit/hyperlocal_shoplist_cubit.dart';
import '../cubits/tutorial_cubit/tutorial_cubit.dart';



var hyperLocalProductsCount = ''.obs;


class HyperLocalRepository with LogMixin {
  List<HyperLocalShopModel> localHyperLocalShopModel = [];
  List<HyperLocalShopModel> searchHyperLocalShopModels = [];
  List<HyperLocalProductModel> localHyperLocalProductModel = [];
  List<HyperLocalProductModel> searchHyperLocalProductModel = [];

  dynamic cartTotalCountLocal;

 // dynamic _searchItemCount = '';

  dynamic get totalCartCount {
    return cartTotalCountLocal;
  }

  // dynamic get searchItemCount {
  //   return _searchItemCount;
  // }
  //
  // dynamic get itemCount {
  //   return _itemCount;
  // }

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
      {required String lat,required String lng,required String offset}) async {
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/merchant/list?lat=$lat&lang=$lng&limit=5&'
            'offset=$offset');
    try {
      debugLog('HyperLocal Url for Shops FROM REPO $url');
      final response = await http.get(url);
      warningLog(
          'Response Structure ${response.statusCode} HyperLocal Url for Shops $url and body ${response.body} ');
      final responseBody = json.decode(response.body)['data']["rows"] as List;
      warningLog('Response Body Structure $responseBody');
      localHyperLocalShopModel = [];
      for (var element in responseBody) {
        // errorLog('Checking for data in getHyperlocalShops $element');
        localHyperLocalShopModel.add(HyperLocalShopModel.fromMap(element));
      }
      warningLog('$localHyperLocalShopModel');
      return localHyperLocalShopModel;
    } catch (e) {
      throw HyperlocalShopErrorState();
    }
  }

  Future<List<HyperLocalShopModel>> getHyperLocalSearchShop(
      {required String nameOfProduct,
      required String lat,
      required String lng,
      required String offset}) async {
    final url = Uri.parse(
    //    '${AppUrl().baseUrl}/santhe/hyperlocal/product/search?limit=10&offset=0&item_name=$nameOfProduct&lat=$lat&lang=$lng');
        '${AppUrl().baseUrl}/santhe/hyperlocal/merchant/list?&'
            'item_name=$nameOfProduct&lat=$lat&lang=$lng&limit=5&offset=$offset');
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
           // element['storeDescription'],
            element
          ),
        );
      }
      warningLog('Search Models $searchHyperLocalShopModels');
      return searchHyperLocalShopModels;
    } catch (e) {
      throw HyperlocalShopErrorState();
    }
  }

  Future<List<HyperLocalProductModel>> getProductsOfShop(
      {required String storeId,
      required String lat,
      required String lng,
      required String offset}) async {
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/product/list?store_description_id=$storeId&'
            'limit=5&offset=$offset&lat=$lat&lang=$lng');

    try {
      final response = await http.get(url);
      warningLog('statusCode of Get FROM REPO ${response.statusCode} and url $url');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      if(offset.toString() == "0"){
        hyperLocalProductsCount.value = (json.decode(response.body)['data']['count']).toString();
      }

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

      throw HyperlocalShopDetailsErrorState();
    }finally{
      Future.delayed(const Duration(seconds: 2)).then(
              (value) => loadingNewProducts.value = false);
    }
  }

  Future<List<HyperLocalProductModel>> getSearchProductsOfShop(
      {required final String storeId,
      required final String itemName,
      required final String lat,
      required final String lng,
      required String offset}) async {
    final url = Uri.parse(
      //  '${AppUrl().baseUrl}/santhe/hyperlocal/product/search?store_description_id=$storeId&limit=10&offset=0&item_name=$itemName&lat=$lat&lang=$lng');
        '${AppUrl().baseUrl}/santhe/hyperlocal/product/list?store_'
            'description_id=$storeId&limit=5&offset=$offset&item_name=$itemName&&lat=$lat&lang=$lng');

    try {
      final response = await http.get(url);
      warningLog(
          'Status Code of search product api${response.statusCode} of url $url');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      if(offset.toString() == "0"){
        hyperLocalProductsCount.value = (json.decode(response.body)['data']['count']).toString();
      }

      //warningLog('ResponseBody Search $hyperLocalProductsCount $responseBody');
      searchHyperLocalProductModel = [];
      for (var element in responseBody) {
        searchHyperLocalProductModel.add(
          HyperLocalProductModel.fromMap(element),
        );
      }
      warningLog('Search models $searchHyperLocalProductModel');
      return searchHyperLocalProductModel;
    } catch (e) {
      throw HyperlocalShopDetailsErrorState(
      );
    }finally{
      Future.delayed(const Duration(seconds: 2)).then(
              (value) => loadingNewProducts.value = false);
    }
  }

  Future<dynamic> getCartCount({required String storeDescriptionId}) async {
    final firebaseID = AppHelpers().getPhoneNumberWithoutCountryCode;
    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        "++++++++++++storeDescriptionId=${storeDescriptionId}");

    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/cart/count?firebase_id='
            '$firebaseID&storeDescription_id=$storeDescriptionId');

    try {
      final response = await http.get(url);
      warningLog(
              'url = $url' "  "
              'cart Count hyper local ${response.statusCode}'
              ' ${response.body}');
      final responseBody = json.decode(response.body)['data'] as dynamic;
      cartTotalCountLocal = responseBody;
      return cartTotalCountLocal;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TutorialLinkModel>> getTutorialLinks() async {

    final url = Uri.parse('${AppUrl().baseUrl}/santhe/link?type=customer');

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    warningLog('url sent to get the getTutorialLinks  $url');

    try {
      final response = await http.get(url, headers: header);
      warningLog('${response.statusCode} and ${response.body}');
      final responseBody = await json.decode(response.body)['data']["rows"];

      warningLog('RESPONSE DATA =$responseBody');

      if (responseBody != null) {
        List<TutorialLinkModel> model = TutorialLinkModel.fromList(responseBody);
        model.removeWhere((element) => element.type.toString().contains("merchant"));
        return model;
      }

      return [];

    } catch (e) {
      warningLog(e.toString());
      throw TutorialErrorState(
          message: "Error in getTutorialLinks ${e.toString()}");
    }
  }

}
