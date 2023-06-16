import 'dart:convert';

import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;

import '../../models/hyperlocal_models/hyperlocal_cancel.dart';

class HyperlocalCancelReturnRepository with LogMixin {
  List<HyperlocalCancelModel> cancelModelLoc = [];
  dynamic messageCancelLoc;

  dynamic get messageCancel {
    return messageCancelLoc;
  }

  List<HyperlocalCancelModel> get cancelModel {
    return cancelModelLoc;
  }

  Future<List<HyperlocalCancelModel>> getCancelReason() async {
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/hyperlocal/cancel/reasons');
    try {
      final response = await http.get(url);
      warningLog('${response.statusCode}');
      final responseBody = json.decode(response.body)['data'] as List;
      cancelModelLoc = [];
      warningLog('Responsebody Cancel flow$responseBody');
      for (var element in responseBody) {
        cancelModelLoc.add(
          HyperlocalCancelModel.fromMap(element),
        );
      }
      warningLog('Cancel Models ${cancelModelLoc}');
      return cancelModelLoc;
    } catch (e) {
      rethrow;
    }
  }

  postcancelReason({required String reason, required String orderId}) async {
    final url =
        Uri.parse('https://ondcstaging.santhe.in/santhe/hyperlocal/cancel');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {"order_id": orderId, "reason": reason, "type": "Customer"},
        ),
      );
      warningLog('${response.statusCode}');
      final responseBody = json.decode(response.body);
      warningLog('Response Body $responseBody');
      messageCancelLoc = [];
      messageCancelLoc = responseBody['message'];
      if (response.statusCode != 500) {
        return false;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
