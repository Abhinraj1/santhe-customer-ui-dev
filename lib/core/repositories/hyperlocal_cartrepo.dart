import 'dart:convert';

import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_cart/hyperlocal_cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_cartmodel.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_productmodel.dart';
import 'package:http/http.dart' as http;

import '../app_url.dart';

class HyperLocalCartRepository with LogMixin {
  List<HyperLocalCartModel> cartModels = [];

  dynamic cartCountLocal;

  dynamic get cartCount {
    return cartCountLocal;
  }

  addToCart(
      {required final HyperLocalProductModel hyperLocalProductModel}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };

    final body = json.encode({
      "firebase_id": firebaseId,
      "quantity": "${hyperLocalProductModel.quantity}",
      "product_id": "${hyperLocalProductModel.id}",
      "storeDescription_id": "${hyperLocalProductModel.storeDescriptionId}"
    });
    final url =
        Uri.parse('${AppUrl().baseUrl}/santhe/hyperlocal/cart/add/item');
    try {
      warningLog('body being sent $body to url $url');
      final response = await http.post(url, headers: header, body: body);
      warningLog('Add to Cart api HyperLocal ${response.statusCode}');
      final responseBody = json.decode(response.body);
      final type = responseBody['type'];
      warningLog('body of the add to cart Api $type $responseBody ');
      if (type.toString().contains('ERROR')) {
        throw const AddToCartHyperLocalErrorState(message: 'Error');
      }
    } catch (e) {
      //AppHelpers.crashlyticsLog(response.body.toString());
      throw AddToCartHyperLocalErrorState(
        message: e.toString(),
      );
    }
  }

  Future<List<HyperLocalCartModel>> getCart(
      {required String storeDescriptionId}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url = Uri.parse(
        '${AppUrl().baseUrl}/santhe/hyperlocal/cart/list?firebase_id=$firebaseId&storeDescription_id=$storeDescriptionId');
    try {
      warningLog('url for getting cart $url');
      final response = await http.get(url);
      warningLog(
          'status Code for getting cart ${response.statusCode} and body ${response.body}');
      final responseBody = json.decode(response.body)['data']['data'] as List;
      warningLog('Getting cart body ${responseBody.length} $responseBody');
      cartModels = [];
      for (var element in responseBody) {
        cartModels.add(
          HyperLocalCartModel.fromMap(element),
        );
      }
      warningLog('cart item models ${cartModels.length}');
      return cartModels;
    } catch (e) {
      throw GetHyperLocalCartErrorState(
        message: e.toString(),
      );
    }
  }

  deleteCartItem({required HyperLocalCartModel hyperLocalCartModel}) async {
    final url =
        Uri.parse('${AppUrl().baseUrl}/santhe/hyperlocal/cart/delete/item');
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
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
            "product_id": hyperLocalCartModel.productId,
            "firebase_id": firebaseId
          },
        ),
      );
      warningLog(
          'Delete Item ${response.statusCode} and body ${response.body}');
      final responseBody = json.decode(response.body);
      warningLog('$responseBody');
    } catch (e) {
      throw DeleteHyperLocalCartItemErrorState(
        message: e.toString(),
      );
    }
  }

  updateCartItemQuantity(
      {required HyperLocalCartModel hyperLocalCartModel}) async {
    final firebaseId = AppHelpers().getPhoneNumberWithoutCountryCode;
    final url =
        Uri.parse('${AppUrl().baseUrl}/santhe/hyperlocal/cart/update/quantity');
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
            "quantity": hyperLocalCartModel.quantity,
            "firebase_id": firebaseId,
            "product_id": hyperLocalCartModel.productId
          },
        ),
      );
      warningLog(
          'Status Code  of update ${response.statusCode} ${response.body}');
      final responseBody = json.decode(response.body);
      warningLog('Updated Cart Item $responseBody');
    } catch (e) {
      throw UpdateQuantityHyperLocalCartItemErrorState(
        message: e.toString(),
      );
    }
  }
}
