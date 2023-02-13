// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark, must_be_immutable, prefer_if_null_operators
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/core/loggers.dart';

class ProductOndcModel extends Equatable with LogMixin {
  final dynamic id;
  final dynamic transaction_id;
  final dynamic ondc_item_id;
  final dynamic name;
  final dynamic short_description;
  final dynamic long_description;
  final dynamic returnable;
  final dynamic isVeg;
  final dynamic time_to_ship;
  final dynamic rating;
  final dynamic storeId;
  final dynamic customer_care;
  final dynamic return_window;
  final dynamic seller_pickup_return;
  final dynamic symbol;
  final dynamic available;
  final dynamic maximum;
  final dynamic itemPriceId;
  final dynamic itemPriceCurrency;
  final dynamic estimated_value;
  final dynamic computed_value;
  final dynamic listed_value;
  final dynamic offered_value;
  final dynamic minimum_value;
  final dynamic maximum_value;
  final dynamic value;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final dynamic itemId;
  bool? isAddedToCart = false;
  dynamic quantity = 1;
  dynamic total;
  final List<dynamic>? images;
  ProductOndcModel({
    required this.id,
    required this.transaction_id,
    required this.ondc_item_id,
    required this.name,
    required this.short_description,
    required this.long_description,
    required this.returnable,
    required this.isVeg,
    required this.time_to_ship,
    required this.rating,
    required this.storeId,
    required this.customer_care,
    required this.return_window,
    required this.seller_pickup_return,
    required this.symbol,
    required this.available,
    required this.maximum,
    required this.itemPriceId,
    required this.itemPriceCurrency,
    required this.estimated_value,
    required this.computed_value,
    required this.listed_value,
    required this.offered_value,
    required this.minimum_value,
    required this.maximum_value,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.itemId,
    this.isAddedToCart,
    this.quantity,
    this.total,
    required this.images,
  });

  ProductOndcModel copyWith({
    dynamic? id,
    dynamic? transaction_id,
    dynamic? ondc_item_id,
    dynamic? name,
    dynamic? short_description,
    dynamic? long_description,
    dynamic? returnable,
    dynamic? isVeg,
    dynamic? time_to_ship,
    dynamic? rating,
    dynamic? storeId,
    dynamic? customer_care,
    dynamic? return_window,
    dynamic? seller_pickup_return,
    dynamic? symbol,
    dynamic? available,
    dynamic? maximum,
    dynamic? itemPriceId,
    dynamic? itemPriceCurrency,
    dynamic? estimated_value,
    dynamic? computed_value,
    dynamic? listed_value,
    dynamic? offered_value,
    dynamic? minimum_value,
    dynamic? maximum_value,
    dynamic? value,
    dynamic? createdAt,
    dynamic? updatedAt,
    dynamic? deletedAt,
    dynamic? itemId,
    bool? isAddedToCart,
    dynamic? quantity,
    dynamic? total,
    List<dynamic>? images,
  }) {
    return ProductOndcModel(
      id: id ?? this.id,
      transaction_id: transaction_id ?? this.transaction_id,
      ondc_item_id: ondc_item_id ?? this.ondc_item_id,
      name: name ?? this.name,
      short_description: short_description ?? this.short_description,
      long_description: long_description ?? this.long_description,
      returnable: returnable ?? this.returnable,
      isVeg: isVeg ?? this.isVeg,
      time_to_ship: time_to_ship ?? this.time_to_ship,
      rating: rating ?? this.rating,
      storeId: storeId ?? this.storeId,
      customer_care: customer_care ?? this.customer_care,
      return_window: return_window ?? this.return_window,
      seller_pickup_return: seller_pickup_return ?? this.seller_pickup_return,
      symbol: symbol ?? this.symbol,
      available: available ?? this.available,
      maximum: maximum ?? this.maximum,
      itemPriceId: itemPriceId ?? this.itemPriceId,
      itemPriceCurrency: itemPriceCurrency ?? this.itemPriceCurrency,
      estimated_value: estimated_value ?? this.estimated_value,
      computed_value: computed_value ?? this.computed_value,
      listed_value: listed_value ?? this.listed_value,
      offered_value: offered_value ?? this.offered_value,
      minimum_value: minimum_value ?? this.minimum_value,
      maximum_value: maximum_value ?? this.maximum_value,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      itemId: itemId ?? this.itemId,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      quantity: quantity ?? this.quantity,
      images: images ?? this.images,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'transaction_id': transaction_id,
      'ondc_item_id': ondc_item_id,
      'name': name,
      'short_description': short_description,
      'long_description': long_description,
      'returnable': returnable,
      'isVeg': isVeg,
      'time_to_ship': time_to_ship,
      'rating': rating,
      'storeId': storeId,
      'customer_care': customer_care,
      'return_window': return_window,
      'seller_pickup_return': seller_pickup_return,
      'symbol': symbol,
      'available': available,
      'maximum': maximum,
      'itemPriceId': itemPriceId,
      'itemPriceCurrency': itemPriceCurrency,
      'estimated_value': estimated_value,
      'computed_value': computed_value,
      'listed_value': listed_value,
      'offered_value': offered_value,
      'minimum_value': minimum_value,
      'maximum_value': maximum_value,
      'value': value,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'itemId': itemId,
      'images': images,
      'quantity': quantity,
      'isAddedToCart': isAddedToCart,
      'total': total
    };
  }

  factory ProductOndcModel.fromNewMap(Map<String, dynamic> map) {
    return ProductOndcModel(
      id: map['id'] != null ? map['id'] as dynamic : null,
      quantity: map['quantity'] != null ? map['quantity'] as dynamic : 0,
      isAddedToCart:
          map['isAddedToCart'] != null ? map['isAddedToCart'] as bool : false,
      transaction_id: map['transaction_id'] != null
          ? map['transaction_id'] as dynamic
          : null,
      ondc_item_id:
          map['ondc_item_id'] != null ? map['ondc_item_id'] as dynamic : null,
      name: map['name'] != null ? map['name'] as dynamic : null,
      short_description: map['short_description'] != null
          ? map['short_description'] as dynamic
          : null,
      long_description: map['long_description'] != null
          ? map['long_description'] as dynamic
          : null,
      returnable:
          map['returnable'] != null ? map['returnable'] as dynamic : null,
      isVeg: map['isVeg'] != null ? map['isVeg'] as dynamic : null,
      time_to_ship:
          map['time_to_ship'] != null ? map['time_to_ship'] as dynamic : null,
      rating: map['rating'] != null ? map['rating'] as dynamic : null,
      storeId: map['storeId'] != null ? map['storeId'] as dynamic : null,
      customer_care:
          map['customer_care'] != null ? map['customer_care'] as dynamic : null,
      return_window:
          map['return_window'] != null ? map['return_window'] as dynamic : null,
      seller_pickup_return: map['seller_pickup_return'] != null
          ? map['seller_pickup_return'] as dynamic
          : null,
      symbol: map['symbol'] != null ? map['symbol'] as dynamic : null,
      available: map['available'] != null ? map['available'] as dynamic : null,
      maximum: map['maximum'] != null ? map['maximum'] as dynamic : null,
      itemPriceId: map['itemPriceId'] != null ? map['itemPriceId'] : null,
      itemPriceCurrency:
          map['itemPriceCurrency'] != null ? map['itemPriceCurrency'] : null,
      estimated_value:
          map['estimated_value'] != null ? map['estimated_value'] : null,
      computed_value:
          map['computed_value'] != null ? map['computed_value'] : null,
      listed_value: map['listed_value'] != null ? map['listed_value'] : null,
      offered_value: map['offered_value'] != null ? map['offered_value'] : null,
      minimum_value:
          map['minimum_value'] != null ? map['minimum_value'] != null : null,
      maximum_value: map['maximum_value'] != null ? map['maximum_value'] : null,
      value: map['value'] != null ? map['value'] : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] : null,
      itemId: map['itemId'] != null ? map['itemId'] : null,
      images: map['images'] != null ? map['images'] as List<dynamic> : null,
      total: map['total'] != null ? map['total'] as dynamic : null,
    );
  }

  factory ProductOndcModel.fromMap(Map<String, dynamic> map) {
    return ProductOndcModel(
      id: map['id'] != null ? map['id'] as dynamic : null,
      quantity: map['quantity'] != null ? map['quantity'] as dynamic : 0,
      isAddedToCart:
          map['isAddedToCart'] != null ? map['isAddedToCart'] as bool : false,
      transaction_id: map['transaction_id'] != null
          ? map['transaction_id'] as dynamic
          : null,
      ondc_item_id:
          map['ondc_item_id'] != null ? map['ondc_item_id'] as dynamic : null,
      name: map['name'] != null ? map['name'] as dynamic : null,
      short_description: map['short_description'] != null
          ? map['short_description'] as dynamic
          : null,
      long_description: map['long_description'] != null
          ? map['long_description'] as dynamic
          : null,
      returnable:
          map['returnable'] != null ? map['returnable'] as dynamic : null,
      isVeg: map['isVeg'] != null ? map['isVeg'] as dynamic : null,
      time_to_ship:
          map['time_to_ship'] != null ? map['time_to_ship'] as dynamic : null,
      rating: map['rating'] != null ? map['rating'] as dynamic : null,
      storeId: map['storeId'] != null ? map['storeId'] as dynamic : null,
      customer_care:
          map['customer_care'] != null ? map['customer_care'] as dynamic : null,
      return_window:
          map['return_window'] != null ? map['return_window'] as dynamic : null,
      seller_pickup_return: map['seller_pickup_return'] != null
          ? map['seller_pickup_return'] as dynamic
          : null,
      symbol: map['symbol'] != null ? map['symbol'] as dynamic : null,
      available: map['available'] != null ? map['available'] as dynamic : null,
      maximum: map['maximum'] != null ? map['maximum'] as dynamic : null,
      itemPriceId: map['itemPrice'] != null
          ? map['itemPrice']['id'] != null
              ? map['itemPrice']['id'] as dynamic
              : null
          : null,
      itemPriceCurrency: map['itemPrice'] != null
          ? map['itemPrice']['currency'] != null
              ? map['itemPrice']['currency'] as dynamic
              : null
          : null,
      estimated_value: map['itemPrice'] != null
          ? map['itemPrice']['estimated_value'] != null
              ? map['itemPrice']['estimated_value'] as dynamic
              : null
          : null,
      computed_value: map['itemPrice'] != null
          ? map['itemPrice']['computed_value'] != null
              ? map['itemPrice']['computed_value'] as dynamic
              : null
          : null,
      listed_value: map['itemPrice'] != null
          ? map['itemPrice']['listed_value'] != null
              ? map['itemPrice']['listed_value'] as dynamic
              : null
          : null,
      offered_value: map['itemPrice'] != null
          ? map['itemPrice']['offered_value'] != null
              ? map['itemPrice']['offered_value'] as dynamic
              : null
          : null,
      minimum_value: map['itemPrice'] != null
          ? map['itemPrice']['minimum_value'] != null
              ? map['itemPrice']['minimum_value'] as dynamic
              : null
          : null,
      maximum_value: map['itemPrice'] != null
          ? map['itemPrice']['maximum_value'] != null
              ? map['itemPrice']['maximum_value'] as dynamic
              : null
          : null,
      value: map['itemPrice'] != null
          ? map['itemPrice']['value'] != null
              ? map['itemPrice']['value'] as dynamic
              : null
          : null,
      createdAt: map['itemPrice'] != null
          ? map['itemPrice']['createdAt'] != null
              ? map['itemPrice']['createdAt'] as dynamic
              : null
          : null,
      updatedAt: map['itemPrice'] != null
          ? map['itemPrice']['updatedAt'] != null
              ? map['itemPrice']['updatedAt'] as dynamic
              : null
          : null,
      deletedAt: map['itemPrice'] != null
          ? map['itemPrice']['deletedAt'] != null
              ? map['itemPrice']['deletedAt'] as dynamic
              : null
          : null,
      itemId: map['itemPrice'] != null
          ? map['itemPrice']['itemId'] != null
              ? map['itemPrice']['itemId'] as dynamic
              : null
          : null,
      images: map['images'] != null ? map['images'] as List<dynamic> : null,
      total: map['total'] != null ? map['total'] as dynamic : null,
    );
  }

  add() {
    if (quantity < available) {
      quantity = quantity + 1;
      getTotal();
    }
  }

  bool addToCart() {
    if (available > 0) {
      quantity = 1;
      isAddedToCart = true;
      getTotal();
      return true;
    }
    return false;
  }

  minus() {
    if (quantity != 1) {
      quantity = quantity - 1;
      getTotal();
    }
  }

  removeFromCart() {
    isAddedToCart = false;
    quantity = 0;
  }

  getTotal() {
    total = quantity * value;
    warningLog('$total');
  }

  String toJson() => json.encode(toMap());

  factory ProductOndcModel.fromJson(String source) => ProductOndcModel.fromMap(
        json.decode(source),
      );

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      transaction_id,
      ondc_item_id,
      name,
      short_description,
      long_description,
      returnable,
      isVeg,
      time_to_ship,
      rating,
      storeId,
      customer_care,
      return_window,
      seller_pickup_return,
      symbol,
      available,
      maximum,
      itemPriceId,
      itemPriceCurrency,
      estimated_value,
      computed_value,
      listed_value,
      offered_value,
      minimum_value,
      maximum_value,
      value,
      createdAt,
      updatedAt,
      deletedAt,
      itemId,
      isAddedToCart,
      quantity,
      images,
      total,
    ];
  }
}
