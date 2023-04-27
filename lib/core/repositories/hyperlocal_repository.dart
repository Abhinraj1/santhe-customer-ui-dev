import 'dart:convert';

import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;

import '../blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';

class HyperLocalRepository with LogMixin {
  getHyperLocalShops({String? lat, String? lng}) async {
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/hyperlocal/merchant/list?lat=$lat&lang=$lng&limit=10&offset=0');
    try {
      final response = await http.get(url);
      warningLog('${response.statusCode} and body ${response.body}');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      warningLog('Response Body $responseBody');
    } catch (e) {
      throw HyperLocalGetShopErrorState(message: e.toString());
    }
  }
}
