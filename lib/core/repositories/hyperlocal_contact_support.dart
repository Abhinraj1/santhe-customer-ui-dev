import 'dart:convert';

import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/loggers.dart';
import 'package:http/http.dart' as http;

import '../../models/hyperlocal_models/hyperlocal_cancel.dart';
import '../../widgets/custom_widgets/custom_snackBar.dart';



class HyperlocalContactSupportRepository with LogMixin {



  Future<dynamic> getSupportDetails({required String supportId}) async {
    final url = Uri.parse(
        'https://ondcstaging.santhe.in/santhe/hyperlocal/support'
            '/get?support_id=$supportId');
    try {
      final response = await http.get(url);
      warningLog('${response.statusCode}');
      final responseBody = json.decode(response.body)['data'] as List;

      warningLog('Responsebody Cancel flow$responseBody');


      return "cancelModelLoc";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> postRaiseTicket({required String reason,
    required String orderId}) async {
    final url =
    Uri.parse('https://ondcstaging.santhe.in/santhe/hyperlocal/support/raise');
    String firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;

    print("BODY ===${json.encode({"order_id":orderId,"firebase_id":firebaseId,"message": reason,
        "imagesArr":[]
      },
    )}");

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
            "order_id":orderId,
            "firebase_id":firebaseId,
            "message": reason,
            "imagesArr":[]
          },
        ),
      );
      warningLog('${response.statusCode}');
      final responseBody = json.decode(response.body);
      final type = responseBody["type"];
      warningLog('Response Body $responseBody and TYPE == $type');

      if(response.statusCode == 500){
        customSnackBar(
            isErrorMessage: true,
            message: "Something Went Wrong. Please Try Later.");
      }
      return type;
    } catch (e) {
      rethrow;
    }
  }
}
