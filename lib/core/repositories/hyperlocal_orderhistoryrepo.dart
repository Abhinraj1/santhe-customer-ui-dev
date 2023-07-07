import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_orderhistory/hyperlocal_orderhistory_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/models/hyperlocal_models/hyperlocal_orderdetail.dart';

import '../app_url.dart';

class HyperLocalOrderHistoryRepository with LogMixin {
  List<HyperlocalOrderDetailModel> orderDetailsLoc = [];
  List<HyperlocalOrderDetailModel> sevenOrderDetailsLoc = [];
  List<HyperlocalOrderDetailModel> thirtyOrderDetailsLoc = [];
  List<HyperlocalOrderDetailModel> customOrderDetailsLoc = [];

  List<HyperlocalOrderDetailModel> get customDetails {
    return customOrderDetailsLoc;
  }

  List<HyperlocalOrderDetailModel> get thirtyDetails {
    return thirtyOrderDetailsLoc;
  }

  List<HyperlocalOrderDetailModel> get sevenDetails {
    return sevenOrderDetailsLoc;
  }

  List<HyperlocalOrderDetailModel> get orderDetails {
    return orderDetailsLoc;
  }

  Future<List<HyperlocalOrderDetailModel>> getOrderList() async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/order/list?firebase_id=$firebaseId&limit=5&offset=0');
    try {
      errorLog('order history url $url');
      final response = await http.get(url);
      errorLog('get order history ${response.statusCode} ${response.body}');
      final responseBody = json.decode(response.body)['data']['rows'] as List;
      warningLog('${responseBody.length}');
      orderDetailsLoc = [];
      for (var element in responseBody) {
        orderDetailsLoc.add(
          HyperlocalOrderDetailModel.fromMap(element),
        );
      }
      warningLog('OrderDetails ${orderDetailsLoc.length}');
      return orderDetailsLoc;
    } catch (e) {
      throw GetHyperlocalOrderHistoryErrorState(message: e.toString());
    }
  }

  Future<List<HyperlocalOrderDetailModel>> getSevenDaysOrderList(
      {required int nSeven}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    DateTime today = DateTime.now();
    dynamic formattedToday = DateFormat('yyyy-MM-dd').format(today);
    DateTime startingDate = today.subtract(const Duration(days: 8));
    dynamic formattedStartingDate =
        DateFormat('yyyy-MM-dd').format(startingDate);
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/order/list?firebase_id=$firebaseId&limit=10&offset=$nSeven&startDate=$formattedStartingDate&endDate=$formattedToday');
    try {
      errorLog('order history url $url');
      final response = await http.get(url);
      errorLog('get seven history ${response.statusCode} ${response.body}');
      final responseBody = json.decode(response.body)['data']['rows'] as List;
      warningLog('${responseBody.length}');
      sevenOrderDetailsLoc = [];
      for (var element in responseBody) {
        sevenOrderDetailsLoc.add(
          HyperlocalOrderDetailModel.fromMap(element),
        );
      }
      errorLog('SevenOrder ${sevenOrderDetailsLoc.length}');
      return sevenOrderDetailsLoc;
    } catch (e) {
      throw SevenDaysFilterHyperlocalOrderErrorState(message: e.toString());
    }
  }

  Future<List<HyperlocalOrderDetailModel>> getThirtyDaysOrderList(
      {required int nThirty}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    DateTime today = DateTime.now();
    dynamic formattedToday = DateFormat('yyyy-MM-dd').format(today);
    DateTime startingDate = today.subtract(const Duration(days: 31));
    dynamic formattedStartingDate =
        DateFormat('yyyy-MM-dd').format(startingDate);
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/order/list?firebase_id=$firebaseId&limit=10&offset=$nThirty&startDate=$formattedStartingDate&endDate=$formattedToday');
    try {
      errorLog('order history url $url');
      final response = await http.get(url);
      errorLog('get thirty history ${response.statusCode} ${response.body}');
      final responseBody = json.decode(response.body)['data']['rows'] as List;
      warningLog('${responseBody.length}');
      thirtyOrderDetailsLoc = [];
      for (var element in responseBody) {
        thirtyOrderDetailsLoc.add(
          HyperlocalOrderDetailModel.fromMap(element),
        );
      }
      errorLog('ThirtyDetails ${thirtyOrderDetailsLoc.length}');
      return thirtyOrderDetailsLoc;
    } catch (e) {
      throw ThirtyDaysFilterHyperlocalOrderErrorState(message: e.toString());
    }
  }

  Future<List<HyperlocalOrderDetailModel>> getCustomDaysOrderList(
      {required List<DateTime?>? valuesLoc, required int nCustom}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    dynamic formattedToday = DateFormat('yyyy-MM-dd').format(valuesLoc!.first!);
    dynamic formattedStartingDate =
        DateFormat('yyyy-MM-dd').format(valuesLoc.last!);
    errorLog(
        'custom dates$formattedToday last end date $formattedStartingDate');
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/order/list?firebase_id=$firebaseId&limit=10&offset=$nCustom&startDate=$formattedToday&endDate=$formattedStartingDate');
    try {
      errorLog('order history url $url');
      final response = await http.get(url);
      errorLog('get custom history ${response.statusCode} ${response.body}');
      final responseBody = json.decode(response.body)['data']['rows'] as List;
      warningLog('${responseBody.length}');
      customOrderDetailsLoc = [];
      for (var element in responseBody) {
        customOrderDetailsLoc.add(
          HyperlocalOrderDetailModel.fromMap(element),
        );
      }
      warningLog('CustomDetails ${customOrderDetailsLoc.length}');
      return customOrderDetailsLoc;
    } catch (e) {
      throw CustomDaysFilterHyperlocalOrderErrorState(message: e.toString());
    }
  }
}
