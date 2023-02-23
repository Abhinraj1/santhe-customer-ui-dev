import 'dart:convert';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/ondc/cart_item_model.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/widgets/ondc_widgets/ondc_cart_item.dart';
import 'package:http/http.dart' as http;

class OndcCartRepository with LogMixin {
  List<ProductOndcModel> productModels = [];
  List<OndcCartItem> ondcCartItem = [];
  int quantityOfItems = 1;
  bool isAddedToCart = false;
  double total = 0;

  List<ProductOndcModel> get cartOndcModels {
    return productModels;
  }

  int get globalCartQuantity {
    return quantityOfItems;
  }

  double get totalCart {
    warningLog('$total');
    return total;
  }

  bool get addedToCart {
    return isAddedToCart;
  }

  deleteCartItem({required CartitemModel productOndcModelLocal}) async {
    final url =
        Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/cart/delete/item');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      warningLog('${productOndcModelLocal.id}');
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {
            'item_id': productOndcModelLocal.id,
            'firebase_id': AppHelpers().getPhoneNumberWithoutCountryCode,
          },
        ),
      );
      warningLog('${response.statusCode}');
      final responseBody = await json.decode(response.body);
      warningLog('$responseBody');
      // productModels
      //     .removeWhere((value) => value.id == productOndcModelLocal.id);
      // warningLog('${productModels.length}');
      // total = 0;
      // productModels.forEach((model) {
      //   total = total + model.total;
      // });
      // return productModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductOndcModel>> addToCart(
      {required ProductOndcModel productOndcModel,
      List<ProductOndcModel>? productList}) async {
    final url =
        Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/cart/add/item');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    final dynamic firebaseID = AppHelpers().getPhoneNumberWithoutCountryCode;
    warningLog(
        '$firebaseID,quantity ${productOndcModel.quantity}, item_id ${productOndcModel.id}, store id${productOndcModel.storeLocationId} ');
    try {
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {
            "quantity": productOndcModel.quantity,
            "firebase_id": firebaseID,
            "item_id": productOndcModel.id,
            "storeLocation_id": productOndcModel.storeLocationId,
          },
        ),
      );
      warningLog('response ${response.statusCode}');
      final responseBody = await json.decode(response.body);
      warningLog('checking for response body in add to cart$responseBody');
      bool contains = productModels.contains(productOndcModel.id);
      contains ? productModels : productModels.add(productOndcModel);
      total = 0;
      productModels.forEach((model) {
        total = total + model.total;
      });
      return productModels;
    } catch (e) {
      throw ErrorAddingItemToCartState(
        message: e.toString(),
      );
    }
  }

  Future<List<CartitemModel>> getCart({required String storeLocationId}) async {
    final String firebaseID = AppHelpers().getPhoneNumberWithoutCountryCode;
    warningLog('$storeLocationId, and firebaseId $firebaseID');
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/cart/list?firebase_id=$firebaseID&storeLocation_id=$storeLocationId');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      final response = await http.get(url, headers: header);
      warningLog('$response and url $url');
      final responseBody = await json.decode(response.body);
      final cartItemBody = responseBody['data']['data'];
      final cartItemCount = responseBody['data']['count'];
      warningLog('$cartItemCount and body $cartItemBody');
      if (cartItemCount == 0) {
        productModels.clear();
      }
      warningLog('getting cart data$responseBody');
      List<CartitemModel> models = [];
      for (var element in cartItemBody) {
        models.add(
          CartitemModel.fromMap(
            element,
          ),
        );
      }
      errorLog('$models');
      return models;
    } catch (e) {
      throw ErrorGettingCartListState(message: e.toString());
    }
  }

  updateQuantityOfItems({required CartitemModel productOndcModel}) async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/cart/update/quantity');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      errorLog('${productOndcModel.quantity}');
      final response = await http.post(
        url,
        headers: header,
        body: json.encode({
          "quantity": productOndcModel.quantity,
          "firebase_id": AppHelpers().getPhoneNumberWithoutCountryCode,
          "item_id": productOndcModel.id
        }),
      );
      warningLog('${response.statusCode}');
      final responseBody = await json.decode(response.body);
      warningLog('checking for response body$responseBody');
    } catch (e) {
      throw ErrorUpdatingQuantityState(
        message: e.toString(),
      );
    }
  }
}
