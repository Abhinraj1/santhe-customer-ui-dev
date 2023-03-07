// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/checkout/checkout_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/ondc/checkout_cart.dart';
import 'package:santhe/models/ondc/final_costing.dart';
import 'package:santhe/models/ondc/preview_ondc_cart_model.dart';
import 'package:santhe/models/ondc/shipment_segregator_model.dart';
import 'package:santhe/widgets/ondc_widgets/shipment_segregator.dart';

class OndcCheckoutRepository with LogMixin {
  FinalCostingModel? finalCostingModel;
  double? finalCost;
  List<dynamic> items = [];
  List<PreviewWidgetModel> previewModels = [];
  List<ShipmentSegregatorModel> shipmentModels = [];
  String razorPayOrderId = '';
  String receiptNo = '';
  String offer_id = '';
  String orderIdCart = '';
  String oneOrMoreItemsNotAvailable = '';

  String get orderId {
    return orderIdCart;
  }

  String get oneOrMoreItemsHasChanged {
    return oneOrMoreItemsNotAvailable;
  }

  double? get costCheckout {
    return finalCost;
  }

  List<PreviewWidgetModel> get previewFinalModels {
    return previewModels;
  }

  List<ShipmentSegregatorModel> get shipmentFinalModels {
    return shipmentModels;
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
      {required final String transactionId,
      required final String storeLocation_id}) async {
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
            "storeLocation_id": storeLocation_id,
          },
        ),
      );
      warningLog('Setter ${response.statusCode}');
      final responseBody = json.decode(response.body)['message_id'];
      warningLog('$responseBody');
      if (responseBody == null) {
        throw const CheckoutPostError(message: 'There is no response');
      }
      return responseBody;
    } catch (e) {
      throw CheckoutPostError(
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
      {required final String storeLocation_id,
      required final String transactionid,
      required String messageId}) async {
    final String firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    warningLog("finalcart$messageId $firebaseId and also $storeLocation_id");

    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/cart/items?message_id=$messageId&firebase_id=$firebaseId&storeLocation_id=$storeLocation_id');
    warningLog("finalcart  $url");
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      final response = await http.get(url, headers: header);
      final responseBody = await json.decode(response.body);
      warningLog('$url $responseBody');

      dynamic map = responseBody['finalCosting'];
      items = responseBody['data']['quotes'] as List<dynamic>;
      orderIdCart = items.first['orderId'] as String;
      errorLog('checking for orderID $orderIdCart');
      List collection = items.first['cartItemPrices'] as List<dynamic>;
      previewModels = [];
      for (var element in collection) {
        shipmentModels.add(
          ShipmentSegregatorModel.fromMap(element),
        );
        previewModels.add(
          PreviewWidgetModel.fromMap(element),
        );
      }
      finalCostingModel = FinalCostingModel.fromMap(map);
      warningLog(' cost$finalCostingModel $previewModels');
      if (responseBody['message']
          .toString()
          .contains('Quantity of one more items in your cart is updated')) {
        throw const FinalizeProductErrorState(
            message:
                'Quantity of one or more items items in your cart is updated or are not deliverable anymore.please review before proceeding');
      }
      return finalCostingModel;
    } catch (e) {
      throw FinalizeProductErrorState(
        message: e.toString(),
      );
    }
  }

  Future<dynamic> initPost(
      {required String messageId, required String order_id}) async {
    final url = Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/init');
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    warningLog(
        "message id $messageId also orderId $order_id firebase id $firebaseId and url $url");
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
            "firebase_id": firebaseId,
            "message_id": messageId,
            "order_id": order_id
          },
        ),
      );
      warningLog('checking for response body ${response.body}');
      final responseBody = json.decode(response.body);
      final status = responseBody['status'];
      return status;
    } catch (e) {
      throw InitializePostErrorState(
        message: e.toString(),
      );
    }
  }

  Future<String> initGet({required String order_Id}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/init/response?order_id=$order_Id');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      warningLog(url.toString());
      final response = await http.get(url, headers: header);
      warningLog('${response.statusCode} and also ${response.body}');

      final responseBody = json.decode(response.body);
      final String status = responseBody['data']['status'];
      //!
      errorLog('checking for status $status');
      return status;
    } catch (e) {
      throw InitializeGetErrorState(
        message: e.toString(),
      );
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
      final statusCodeFromApiBody = responseBody['status'];
      if (statusCodeFromApiBody == 400) {
        throw FinalizePaymentErrorState(
          message: responseBody['message'],
        );
      }
    } catch (e) {
      throw FinalizePaymentErrorState(message: e.toString());
    }
  }

  confirmOrder(
      {required String messageId, required String transactionId}) async {
    final url =
        Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/confirm/order');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {"transaction_id": transactionId, "message_id": messageId},
        ),
      );
      final responseBody = json.decode(response.body);
      warningLog('confirm order url $url and confirm order body $responseBody');
      final typeErrorMessage = responseBody['type'];
      debugLog('$typeErrorMessage');
      if (typeErrorMessage.toString().contains('ERROR')) {
        throw FinalizePaymentErrorState(message: responseBody['message']);
      }
      if (typeErrorMessage.toString().contains('SYSTEM_ERROR')) {
        throw FinalizePaymentErrorState(message: responseBody['message']);
      }
    } catch (e) {
      throw FinalizePaymentErrorState(
        message: e.toString(),
      );
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
