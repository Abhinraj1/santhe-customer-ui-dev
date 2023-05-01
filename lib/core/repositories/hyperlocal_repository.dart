import 'dart:convert';

import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';

import '../blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';

class HyperLocalRepository with LogMixin {
  List<HyperLocalShopModel> localHyperLocalShopModel = [];

  List<HyperLocalShopModel> get hyperLocalShopModel {
    return localHyperLocalShopModel;
  }

  Future<List<HyperLocalShopModel>> getHyperLocalShops(
      {String? lat, String? lng}) async {
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/hyperlocal/merchant/list?lat=$lat&lang=$lng&limit=10&offset=0');
    try {
      debugLog('HyperLocal Url for Shops $url');
      final response = await http.get(url);
      warningLog('${response.statusCode} and body ${response.body}');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('Response Body $responseBody');
      localHyperLocalShopModel = [];
      for (var element in responseBody) {
        localHyperLocalShopModel.add(HyperLocalShopModel.fromMap(element));
      }
      warningLog('$localHyperLocalShopModel');
      return localHyperLocalShopModel;
    } catch (e) {
      throw HyperLocalGetShopErrorState(message: e.toString());
    }
  }
}
