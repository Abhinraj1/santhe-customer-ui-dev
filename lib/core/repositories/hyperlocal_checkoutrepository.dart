import 'dart:convert';

import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_checkout/hyperlocal_checkout_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/models/hyperlocal_models/hyperlocal_paymentmodel.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_previewmodel.dart';

import '../../models/hyperlocal_models/hyperlocal_orders_model.dart';
import '../../models/hyperlocal_models/hyperlocal_payment_model.dart';
import '../app_url.dart';

class HyperLocalCheckoutRepository with LogMixin {
  dynamic deliveryChargeLoc;
  dynamic taxLoc;
  dynamic convenienceFeeLoc;
  dynamic subTotalLoc;
  dynamic totalAmount;
  dynamic orderIdLoc;
  dynamic shopNameOrderLoc;
  dynamic shopAddressOrderLoc;
  dynamic shopEmailOrderLoc;
  dynamic shopOrderIdloc;
  dynamic shopOrderStatusLoc;
  dynamic shopPaymentStatusLoc;
  dynamic shopOrderDateLoc;
  dynamic shopHomeDeliveryLoc;
  dynamic homeDeliveryLoc;
  dynamic deliveryStatesLoc;
  dynamic supportLoc;
  dynamic userReadableOrderIdLoc;
  dynamic phoneNumberLoc;
  dynamic returnMessageLoc;
  List<HyperLocalPreviewModel> previewModels = [];
  dynamic orderInvoiceLoc;
  late OrderInfo _orderInfo;

  late HyperlocalPaymentInfoModel paymentModelLoc;

  dynamic get returnMessage {
    return returnMessageLoc;
  }

  dynamic get orderInvoice {
    return orderInvoiceLoc;
  }

  dynamic get orderInfo {
    return _orderInfo;
  }

  dynamic get shopPhoneNumber {
    return phoneNumberLoc;
  }

  dynamic get userOrderId {
    return userReadableOrderIdLoc;
  }

  dynamic get support {
    return supportLoc;
  }

  dynamic get deliveryState {
    return deliveryStatesLoc;
  }

  dynamic get homeDelivery {
    return homeDeliveryLoc;
  }

  dynamic get shopName {
    return shopNameOrderLoc;
  }

  dynamic get shopAddress {
    return shopAddressOrderLoc;
  }

  dynamic get shopEmail {
    return shopEmailOrderLoc;
  }

  dynamic get shopOrderId {
    return shopOrderIdloc;
  }

  dynamic get shopOrderStatus {
    return shopOrderStatusLoc;
  }

  dynamic get shopPaymentStatus {
    return shopPaymentStatusLoc;
  }

  dynamic get shopOrderDate {
    return shopOrderDateLoc;
  }

  dynamic get shopHomeDelivery {
    return shopHomeDeliveryLoc;
  }

  List<HyperLocalPreviewModel> get hyperlocalPreviewModels {
    return previewModels;
  }

  HyperlocalPaymentInfoModel get paymentModel {
    return paymentModelLoc;
  }

  dynamic get orderId {
    return orderIdLoc;
  }

  dynamic get deliveryCharge {
    return deliveryChargeLoc;
  }

  dynamic get tax {
    return taxLoc;
  }

  dynamic get convenienceFee {
    return convenienceFeeLoc;
  }

  dynamic get subTotal {
    return subTotalLoc;
  }

  dynamic get total {
    return totalAmount;
  }

  Future<String> postOrderInfo({required String storeDescriptionId}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url =
        Uri.parse('${AppUrl().baseUrl}/santhe/hyperlocal/order/cartcheckout');
    final body = json.encode({
      "firebase_id": firebaseId,
      "storeDescription_id": storeDescriptionId,
    });
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      warningLog('Url Send to get Checkout items $url body sent $body');
      final response = await http.post(url, body: body, headers: header);
      warningLog('POst Order Info Api${response.statusCode}');
      print("#############################################"
          "################");
      print(" responseBody['order_id'] =${response.body.toString()}");

      final responseBody = json.decode(response.body)['order_id'] as String;
      warningLog('Post order info body $responseBody');
      return responseBody;
    } catch (e) {
      throw GetOrderInfoErrorState(
        message: e.toString(),
      );
    }
  }

  Future<List<HyperLocalPreviewModel>> getOrderdetails(
      {required String orderId}) async {
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/order/get?id=$orderId');
    try {
      final response = await http.get(url);
      warningLog('Get order ${response.statusCode} and url $url');
      final responseBody = json.decode(response.body)['data'];
      warningLog('Body $responseBody');
      returnMessageLoc = json.decode(response.body)['message'];
      warningLog('OrderInfo Response Body $responseBody');
      _orderInfo = OrderInfo.fromJson(json.decode(response.body));

      previewModels = [];
      deliveryChargeLoc = '';
      deliveryChargeLoc = responseBody['delivery_charge'];
      taxLoc = '';
      taxLoc = responseBody['tax'];
      convenienceFeeLoc = '';
      convenienceFeeLoc = responseBody['convenience_fee'];
      subTotalLoc = '';
      subTotalLoc = responseBody['sub_total'];
      totalAmount = '';
      totalAmount = responseBody['total_amount'];
      orderInvoiceLoc = '';
      orderInvoiceLoc = responseBody['customerInvoice'];
      shopNameOrderLoc = '';
      shopNameOrderLoc = responseBody['storeDescription']['name'];
      shopEmailOrderLoc = '';
      shopEmailOrderLoc = responseBody['storeDescription']['email'];
      shopAddressOrderLoc = '';
      shopAddressOrderLoc = responseBody['storeDescription']['address'];
      shopOrderDateLoc = '';
      shopOrderDateLoc = responseBody['createdAt'];
      supportLoc = '';
      supportLoc = responseBody['support'];
      homeDeliveryLoc = '';
      homeDeliveryLoc = responseBody['storeDescription']['fulfillment_type'];
      phoneNumberLoc = '';
      phoneNumberLoc =
          responseBody['storeDescription']['phone_number'];
      shopOrderIdloc = '';
      shopOrderIdloc = responseBody['id'];
      userReadableOrderIdLoc = '';
      userReadableOrderIdLoc = responseBody['order_id'];
      shopPaymentStatusLoc = '';
      shopPaymentStatusLoc = responseBody['payment'] != null
          ? responseBody['payment']['payment_status']
          : 'Pending';

      final states = responseBody['states'] as List;
      shopOrderStatusLoc = '';
      shopOrderStatusLoc = states.first['title'];

      errorLog(
          'order info values54 $shopPaymentStatusLoc, $shopOrderStatusLoc, $shopAddressOrderLoc order id find $orderId, $shopOrderIdloc and support $support userOrderId $userReadableOrderIdLoc');
      final orderItems = responseBody['orderItems'] as List;
      warningLog('Checking for order Items $orderItems');
      for (var element in orderItems) {
        previewModels.add(
          HyperLocalPreviewModel.fromMap(element),
        );
      }
      warningLog('Preview Models $previewModels');
      return previewModels;
    } catch (e) {
      throw GetOrderInfoErrorState(
        message: e.toString(),
      );
    }
  }

  Future<String> postPaymentCheckout(
      {required String orderIdRec,
      required String targetApp,
        required bool isUpi
      }) async {
    print("ORDER ID ==================== ${orderIdRec}");
    final url =
       // Uri.parse('${AppUrl().baseUrl}/santhe/hyperlocal/payment/checkout');
    Uri.parse('${AppUrl().baseUrl}/santhe/hyperlocal/payment/phonepay/checkout');

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    final body = json.encode(
      {"order_id": orderIdRec,
        "target_app":targetApp,
        "isUpi":isUpi
      },
    );
    try {
      final response = await http.post(url, headers: header, body: body);
      warningLog(
          'Post payment ${response.statusCode} ${response.body} $url and body $body');
      final responseBody = json.decode(response.body);
      warningLog('post payment Response body $responseBody');

      if(responseBody["data"] != null){
        if(isUpi){
          String intentUrl = responseBody["data"]["instrumentResponse"]["intentUrl"].toString();

          return intentUrl;
        }else{
          String intentUrl = responseBody["data"]["instrumentResponse"]
          ["redirectInfo"]["url"].toString();

          return intentUrl;
        }

      }else{
        throw const PostPaymentHyperlocalErrorState(
                 message: 'Cant Create order');
        return "error";
      }
      // if (responseBody['message']
      //     .toString()
      //     .contains('Unable to create order')) {
      //   throw const PostPaymentHyperlocalErrorState(
      //       message: 'Cant Create order');
      //  // return false;
      // }
      // if(responseBody["type"].toString().contains("SUCCESS")){
      //   return true;
      // }else{
      //   throw const PostPaymentHyperlocalErrorState(
      //       message: 'Cant Create order');
      // }
      HyperLocalPaymentModel paymentModel = HyperLocalPaymentModel.fromJson(responseBody);
     // warningLog('Payment info model$paymentModel');

    } catch (e) {
      throw PostPaymentHyperlocalErrorState(
        message: e.toString(),
      );
    }
  }
  ///74120298-15aa-4a8f-8f96-3790125ab012

  Future<bool> verifyPayment(
      {required String orderID}) async {
    final url =
        Uri.parse('${AppUrl().baseUrl}/santhe/hyperlocal/payment/phonepe/verify?order_id=$orderID');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    // final body = json.encode(
    //   {
    //     "razorpay_order_id": razorPayOrderID,
    //     "razorpay_payment_id": razorPayPaymentId,
    //     "razorpay_signature": razorPaySignature
    //   },
    // );
    try {
      final response = await http.get(url, headers: header);
      warningLog(
          'Verify payment id${response.statusCode} ${response.body} url $url ');
      final responseBody = json.decode(response.body);
      warningLog('$responseBody');
      if (responseBody['message']
          .toString()
          .contains('Please send all the details')) {
        throw const VerifyPaymentHyperlocalErrorState(
            message: 'Unable to verify Phonepe Payment');
      }
      // if (responseBody['message'].toString().contains('Razorpay Issue')) {
      //   throw VerifyPaymentHyperlocalErrorState(
      //       message: responseBody['message']);
      // }
      bool paymentStatus = responseBody['data']["payment_status"];
      return paymentStatus;
    } catch (e) {
      throw VerifyPaymentHyperlocalErrorState(
        message: e.toString(),
      );
    }
  }
}
