import 'dart:convert';

import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/cubits/hyperlocal_image_return_request_cubit/hyperlocal_image_return_request_cubit.dart';
import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;

import '../../models/hyperlocal_models/hyperlocal_cancel.dart';
import '../blocs/hyperlocal/hyperlocal_cancelReturn/hyperlocal_cancel_return_bloc.dart';

class HyperlocalCancelReturnRepository with LogMixin {
  List<HyperlocalCancelModel> cancelModelLoc = [];
  List<HyperlocalCancelModel> returnModelLoc = [];
  dynamic messageCancelLoc;
  bool returnedLoc = false;

  bool get returned {
    return returnedLoc;
  }

  dynamic get messageCancel {
    return messageCancelLoc;
  }

  List<HyperlocalCancelModel> get returnModel {
    return returnModelLoc;
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
      warningLog('Cancel Models $cancelModelLoc');
      return cancelModelLoc;
    } catch (e) {
      throw GetHyperlocalCancelReasonsErrorState(
        message: e.toString(),
      );
    }
  }

  Future<List<HyperlocalCancelModel>> getReturnReasons() async {
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/hyperlocal/return/reasons');
    try {
      final response = await http.get(url);
      warningLog('Status code ${response.statusCode}');
      final responseBody = json.decode(response.body)['data'] as List;
      returnModelLoc = [];
      warningLog('Responsebody Return flow$responseBody');
      for (var element in responseBody) {
        returnModelLoc.add(HyperlocalCancelModel.fromMap(element));
      }
      warningLog('Cancel Models $returnModelLoc');
      return returnModelLoc;
    } catch (e) {
      throw GetHyperlocalReturnReasonsErrorState(
        message: e.toString(),
      );
    }
  }

  Future<String> uploadImage({required String imgPath}) async {
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    final url = Uri.parse('https://ondcstaging.santhe.in/santhe/ondc/upload');
    debugLog('Image Path $imgPath');
    try {
      var request = http.MultipartRequest("POST", url);

      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath("file", imgPath);

      request.files.add(multipartFile);

      request.headers.addAll(header);
      errorLog('Before upload $url, $multipartFile');

      var streamedResponse = await request.send();
      errorLog(
          'Streamed response ${streamedResponse.stream} ${streamedResponse.statusCode}');

      var response = await http.Response.fromStream(streamedResponse);
      warningLog(
          'final response ${response.statusCode} and body ${response.body}');

      var imgUrl = json.decode(response.body)["data"]["Location"];

      warningLog(
          'checking for response body AFTER UPLOADING IMAGE ${response.statusCode}'
          'and URL $imgUrl');

      return imgUrl;
    } catch (e) {
      throw HyperlocalUploadImagesAndReturnErrorState(
        message: "Upload Image :${e.toString()}",
      );
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
      throw PostHyperlocalCancelReasonErrorState(
        message: e.toString(),
      );
    }
  }
}
