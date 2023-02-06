import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/checkout/checkout_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/ondc/checkout_cart.dart';
import 'package:santhe/models/ondc/final_costing.dart';
import 'package:santhe/models/ondc/preview_ondc_cart_model.dart';

class OndcCheckoutRepository with LogMixin {
  FinalCostingModel? finalCostingModel;
  double? finalCost;
  List<dynamic> items = [];
  List<PreviewWidgetModel> previewModels = [];
  String razorPayOrderId = '';
  String receiptNo = '';
  String offer_id = '';

  double? get costCheckout {
    return finalCost;
  }

  List<PreviewWidgetModel> get previewFinalModels {
    return previewModels;
  }

  String get razorOrderId {
    return razorPayOrderId;
  }

  String get receiptNoRazor {
    return receiptNo;
  }

  String get offerIdRazor {
    return offer_id;
  }

  Future<dynamic> proceedToCheckoutMethodPost(
      {required final String transactionId}) async {
    final url =
        Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/price/request');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {
            "firebase_id": AppHelpers().getPhoneNumberWithoutCountryCode,
            "transaction_id": transactionId
          },
        ),
      );
      warningLog('${response.statusCode}');
      final responseBody = json.decode(response.body)['message_id'];
      warningLog('$responseBody');
      return responseBody;
    } catch (e) {
      CheckoutPostError(
        message: e.toString(),
      );
    }
  }

  Future<List<CheckoutCartModel>> proceedToCheckoutGet(
      {required final String transactionId,
      required final String messageId}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/price/request?message_id=$messageId');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      List<CheckoutCartModel> cartCheckoutModels = [];
      final response = await http.get(url, headers: header);
      warningLog('${response.statusCode}');
      final responseBody =
          json.decode(response.body)['data']['rows'] as List<dynamic>;
      responseBody.forEach((element) {
        cartCheckoutModels.add(
          CheckoutCartModel.fromMap(element),
        );
      });
      warningLog('checkout models$cartCheckoutModels');
      return cartCheckoutModels;
    } catch (e) {
      throw CheckoutGetError(
        message: e.toString(),
      );
    }
  }

  Future<FinalCostingModel?> proceedToCheckoutFinalCart(
      {required final String transactionid, required String messageId}) async {
    warningLog("finalcart$messageId");
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/cart/items?message_id=$messageId');
    warningLog("finalcart  $url");
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      final response = await http.get(url, headers: header);
      warningLog(response.body);
      final responseBody = await json.decode(response.body);
      warningLog('$responseBody');
      dynamic map = responseBody['finalCosting'];
      items = responseBody['data']['rows'] as List<dynamic>;
      List collection = items.first['cartItemPrices'] as List<dynamic>;
      for (var element in collection) {
        previewModels.add(PreviewWidgetModel.fromMap(element));
      }
      finalCostingModel = FinalCostingModel.fromMap(map);
      warningLog(' cost$finalCostingModel $previewModels');
      return finalCostingModel;
    } catch (e) {
      rethrow;
    }
  }

  verifyPayment(
      {required String razorpayOrderIDLocal,
      required String razorpayPaymentId,
      required String razorpaySignature}) async {
    final url =
        Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/payment/verify');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {
            "razorpay_order_id": razorpayOrderIDLocal,
            "razorpay_payment_id": razorpayPaymentId,
            "razorpay_signature": razorpaySignature,
          },
        ),
      );
      warningLog('${response.statusCode}');
      final responseBody = await json.decode(response.body);
      warningLog('$responseBody');
    } catch (e) {
      throw FinalizePaymentErrorState(message: e.toString());
    }
  }

  Future<String> initializeCart({
    required String firebaseId,
    required String messageId,
  }) async {
    final url =
        Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/payment/checkout');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    warningLog('$messageId $firebaseId');
    try {
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {
            "firebase_id": AppHelpers().getPhoneNumberWithoutCountryCode,
            "message_id": messageId,
          },
        ),
      );
      final responseBody = json.decode(response.body);
      razorPayOrderId = responseBody['id'];
      receiptNo = responseBody['receipt'];
      warningLog('$razorPayOrderId, $receiptNo');
      return razorPayOrderId;
    } catch (e) {
      throw InitializeCartFailureState(
        message: e.toString(),
      );
    }
  }
}
