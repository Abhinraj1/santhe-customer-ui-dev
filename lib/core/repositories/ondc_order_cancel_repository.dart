import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:santhe/models/ondc/order_cancel_reasons_model.dart';
import '../app_helpers.dart';
import '../blocs/checkout/checkout_bloc.dart';
import '../blocs/ondc/ondc_order_cancel_bloc/ondc_order_cancel_bloc.dart';
import '../loggers.dart';




class ONDCOrderCancelRepository with LogMixin {


 Future<List<ReasonsModel>> getOrderCancelReasons() async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/cancel/reasons');

    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    try {

      warningLog(url.toString());

      final response = await http.get(url, headers: header);

      warningLog('${response.statusCode} and also ${response.body}');

      final responseBody =
      await json.decode(response.body)['data']['rows'] ;

      // List<ReasonsModel> data =  []; //SingleOrderModel.fromJson(responseBody);
      // data.add(ReasonsModel.fromJson(responseBody));
      List<ReasonsModel> data = ReasonsModel.fromList(responseBody);
      return data;

    } catch (e) {
      throw OrderCancelErrorState(
        message: e.toString(),
      );
    }
  }

 Future<String> fullOrderCancelPost(
     {required String code, required String orderId}) async {

   final url = Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/'
       'cancel?orderId=$orderId&code=$code');

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

     final responseBody = json.decode(response.body)["message"]["ack"]['status'];

     warningLog("####################################################"
         "##3 BODY STATUS ==== $responseBody");

     final status = responseBody;

     return status;

   } catch (e) {
     throw OrderCancelErrorState(
       message: e.toString(),
     );
   }
 }

}