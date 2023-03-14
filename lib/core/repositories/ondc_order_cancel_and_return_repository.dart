import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:santhe/models/ondc/order_cancel_reasons_model.dart';
import '../app_helpers.dart';
import '../blocs/checkout/checkout_bloc.dart';
import '../blocs/ondc/ondc_order_cancel_and_return_bloc/ondc_order_cancel_and_return_bloc.dart';
import '../loggers.dart';




class ONDCOrderCancelAndReturnRepository with LogMixin {


 Future<List<ReasonsModel>> getReasons({ bool? isReturn}) async {

    final url = isReturn ?? false ?

          Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/return/reasons') :

          Uri.parse(
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

      isReturn ?? false ?

      throw OrderCancelErrorState(message: "Return :${e.toString()}") :

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



 Future<String> uploadImage(
     {required Uint8List imgInByte}) async {

   final url = Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/upload/$imgInByte');

   warningLog("Upload Image url $url");

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
         "## BODY STATUS ==== $responseBody");

     final imgUrl = responseBody;

     return imgUrl;

   } catch (e) {
     throw OrderCancelErrorState(
       message: "Upload Image :${e.toString()}",
     );
   }
 }

 Future<int> requestProductReturn(
     {required String orderId, required String code,
       required String quotesId, required List<String> images}) async {


   final url = Uri.parse('http://localhost:8081/santhe/ondc/return');

   final header = {
     'Content-Type': 'application/json',
     "authorization": 'Bearer ${await AppHelpers().authToken}'
   };

   try {
     warningLog('Send Message Customer Contact url = $url');
     final response = await http.post(
       url,
       headers: header,
       body: json.encode(
         {
           "order_id": orderId,
           "cartItemIds":[
             {
               "id": quotesId,
               "images": images
             }
           ],
           "reasonCode": code
         },
       ),
     );

     warningLog('${response.statusCode}');

     final responseBody = await json.decode(response.body);

     warningLog('$responseBody');

     return response.statusCode;
   } catch (e) {
     warningLog(e.toString());
     rethrow;
   }
 }



}