import 'dart:convert';

import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_orderhistory/hyperlocal_orderhistory_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/models/hyperlocal_models/hyperlocal_orderdetail.dart';

class HyperLocalOrderHistoryRepository with LogMixin {
  List<HyperlocalOrderDetailModel> orderDetailsLoc = [];

  List<HyperlocalOrderDetailModel> get orderDetails {
    return orderDetailsLoc;
  }

  Future<List<HyperlocalOrderDetailModel>> getOrderList() async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/hyperlocal/order/list?firebase_id=$firebaseId&limit=5&offset=0');
    try {
      errorLog('order history url $url');
      final response = await http.get(url);
      errorLog('get order history ${response.statusCode} ${response.body}');
      final responseBody = json.decode(response.body)['data']['rows'] as List;
      warningLog('$responseBody');
      orderDetailsLoc = [];
      for (var element in responseBody) {
        warningLog('$element');
        orderDetailsLoc.add(
          HyperlocalOrderDetailModel.fromMap(element),
        );
      }
      warningLog('OrderDetails $orderDetailsLoc');
      return orderDetailsLoc;
    } catch (e) {
      throw GetHyperlocalOrderHistoryErrorState(message: e.toString());
    }
  }
}
