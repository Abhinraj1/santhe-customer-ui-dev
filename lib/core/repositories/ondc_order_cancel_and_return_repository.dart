import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:santhe/models/ondc/order_cancel_reasons_model.dart';
import '../app_helpers.dart';
import '../app_url.dart';
import '../blocs/checkout/checkout_bloc.dart';
import '../blocs/ondc/ondc_order_cancel_and_return_bloc/ondc_order_cancel_and_return_bloc.dart';
import '../cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_state.dart';
import '../loggers.dart';

class ONDCOrderCancelAndReturnRepository with LogMixin {
  Future<List<ReasonsModel>> getReasons({bool? isReturn}) async {
    final url = isReturn ?? false
        ? Uri.parse('${AppUrl().baseUrl}/santhe/ondc/return/reasons')
        : Uri.parse('${AppUrl().baseUrl}/santhe/ondc/cancel/reasons');

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    try {
      warningLog(url.toString());

      final response = await http.get(url, headers: header);

      warningLog('${response.statusCode} and also ${response.body}');

      final responseBody = await json.decode(response.body)['data']['rows'];

      // List<ReasonsModel> data =  []; //SingleOrderModel.fromJson(responseBody);
      // data.add(ReasonsModel.fromJson(responseBody));
      List<ReasonsModel> data = ReasonsModel.fromList(responseBody);
      return data;
    } catch (e) {
      isReturn ?? false
          ? throw OrderCancelErrorState(message: "Return :${e.toString()}")
          : throw OrderCancelErrorState(
              message: e.toString(),
            );
    }
  }

  Future<String> fullOrderCancelPost(
      {required String code, required String orderId}) async {
    final url = Uri.parse('${AppUrl().baseUrl}/santhe/ondc/cancel?orderId='
        '$orderId&code=$code');

    warningLog("Reason Code $code also orderId $orderId and url $url");

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    try {
      final response = await http.post(
        url,
        headers: header,
      );

      warningLog('checking for response body ${response.body}');

      ///final responseBody = json.decode(response.body)["message"]["ack"]['status'];

      String responseString = "";

      final responseType = await json.decode(response.body)["type"];

      final responseMessage = await json.decode(response.body)["message"];

      warningLog('RESPONSE TYPE IS $responseType');

      warningLog('RESPONSE MESSAGE IS $responseMessage');

      if (responseType.toString() == "SUCCESS") {
        responseString = responseType.toString();

        return responseString;
      } else if (responseMessage
          .toString()
          .contains("Seller is not responding , Please try later")) {
        responseString = responseMessage.toString();

        return responseString;
      } else {
        responseString = responseMessage.toString();
        throw (OrderCancelErrorState(message: responseString));
      }
    } catch (e) {
      throw OrderCancelErrorState(
        message: e.toString(),
      );
    }
  }

  Future<String> uploadImage({required String imgPath}) async {
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    try {
      final url = Uri.parse('${AppUrl().baseUrl}/santhe/ondc/upload');

      var request = http.MultipartRequest("POST", url);

      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath("file", imgPath);

      request.files.add(multipartFile);

      request.headers.addAll(header);

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      var imgUrl = json.decode(response.body)["data"]["Location"];

      warningLog(
          'checking for response body AFTER UPLOADING IMAGE ${response.statusCode}'
          'and URL $imgUrl');

      return imgUrl;
    } catch (e) {
      throw OrderCancelErrorState(
        message: "Upload Image :${e.toString()}",
      );
    }
  }

  Future<String> requestReturnOrPartialCancel(
      {required String orderId,
      required String code,
      required String cartItemPricesId,
      required List<String> images,
      required String quantity,
      required bool isReturn}) async {
    final url = Uri.parse('${AppUrl().baseUrl}/santhe/ondc/update');

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    try {
      warningLog(
          'requestReturnOrPartialCancel isReturn $isReturn and url = $url');
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {
            "order_id": orderId,
            "cartItemIds": [
              {
                "id": cartItemPricesId,
                "images": images,
                "quantity": quantity,
                "reasonCode": code,
                "isReturn": isReturn
              }
            ],
          },
        ),
      );

      warningLog('${response.statusCode}');

      String responseString = "";

      final responseType = await json.decode(response.body)["type"];

      final responseMessage = await json.decode(response.body)["message"];

      warningLog('RESPONSE TYPE IS $responseType');

      warningLog('RESPONSE MESSAGE IS $responseMessage');

      if (responseType.toString() == "SUCCESS") {
        responseString = responseType.toString();

        return responseString;
      } else if (responseMessage
          .toString()
          .contains("Seller is not responding , Please try later")) {
        responseString = responseMessage.toString();

        return responseString;
      } else {
        responseString = responseMessage.toString();
        throw (OrderCancelErrorState(message: responseString));
      }
    } catch (e) {
      warningLog(e.toString());
      rethrow;
    }
  }
}
