import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/firebase/firebase_helper.dart';
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

  Future<List<ProductOndcModel>> deleteCartItem(
      {required ProductOndcModel productOndcModelLocal}) async {
    final url =
        Uri.parse('http://ondcstaging.santhe.in/santhe/ondc/cart/delete/item');
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
            'item_id': productOndcModelLocal.itemId,
            'firebase_id': AppHelpers().getPhoneNumberWithoutCountryCode,
          },
        ),
      );
      warningLog('${response.statusCode}');
      final responseBody = await json.decode(response.body);
      warningLog('$responseBody');
      productModels
          .removeWhere((value) => value.id == productOndcModelLocal.id);
      warningLog('${productModels.length}');
      total = 0;
      productModels.forEach((model) {
        total = total + model.total;
      });
      return productModels;
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
    try {
      final response = await http.post(
        url,
        headers: header,
        body: json.encode(
          {
            "quantity": productOndcModel.quantity,
            "firebase_id": AppHelpers().getPhoneNumberWithoutCountryCode,
            "item_id": productOndcModel.itemId
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

  Future<List<ProductOndcModel>> getCart() async {
    final url = Uri.parse(
        'http://ondcstaging.santhe.in/santhe/ondc/cart/list?firebase_id=${AppHelpers().getPhoneNumberWithoutCountryCode}');
    final header = {
      'Content-Type': 'application/json',
      "authorization": 'Bearer ${await AppHelpers().authToken}'
    };
    try {
      final response = await http.get(url, headers: header);
      warningLog('$response');
      final responseBody = await json.decode(response.body);
      final cartItemBody = responseBody['data'];
      final cartItemCount = responseBody['count'];
      warningLog('$cartItemCount and body $cartItemBody');
      if (cartItemCount == 0) {
        productModels.clear();
      }
      warningLog('getting cart data$responseBody');
      List<ProductOndcModel> models = [];
      for (var element in cartItemBody) {
        models.add(
          ProductOndcModel.fromMap(
            element['item'],
          ),
        );
      }
      errorLog('$models');
      return models;
    } catch (e) {
      throw ErrorGettingCartListState(message: e.toString());
    }
  }

  updateQuantityOfItems({required ProductOndcModel productOndcModel}) async {
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
          "item_id": productOndcModel.itemId
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
