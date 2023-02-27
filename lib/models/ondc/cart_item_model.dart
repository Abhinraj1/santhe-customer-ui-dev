// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark, must_be_immutable
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:equatable/equatable.dart';

import 'package:santhe/models/ondc/product_ondc.dart';

class CartitemModel extends Equatable {
  final dynamic symbol;
  dynamic quantity;
  final dynamic id;
  final dynamic item_name;
  final dynamic short_description;
  final dynamic time_to_ship;
  final dynamic store_name;
  final dynamic value;
  final dynamic maximum_value;
  int quantityL;
  CartitemModel({
    required this.symbol,
    required this.quantity,
    required this.id,
    required this.item_name,
    required this.short_description,
    required this.time_to_ship,
    required this.store_name,
    required this.value,
    required this.maximum_value,
    required this.quantityL,
  });

  CartitemModel copyWith({
    dynamic? symbol,
    dynamic? quantity,
    dynamic? id,
    dynamic? item_name,
    dynamic? short_description,
    dynamic? time_to_ship,
    dynamic? store_name,
    dynamic? value,
    dynamic? maximum_value,
    int? quantityL,
  }) {
    return CartitemModel(
      symbol: symbol ?? this.symbol,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
      item_name: item_name ?? this.item_name,
      short_description: short_description ?? this.short_description,
      time_to_ship: time_to_ship ?? this.time_to_ship,
      store_name: store_name ?? this.store_name,
      value: value ?? this.value,
      maximum_value: maximum_value ?? this.maximum_value,
      quantityL: quantityL ?? this.quantityL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'symbol': symbol,
      'quantity': quantity,
      'id': id,
      'item_name': item_name,
      'short_description': short_description,
      'time_to_ship': time_to_ship,
      'store_name': store_name,
      'maximum_value': maximum_value,
      'value': value,
      'quantityL': quantityL
    };
  }

  factory CartitemModel.fromMap(Map<String, dynamic> map) {
    return CartitemModel(
      symbol: map['symbol'] != null ? map['symbol'] as dynamic : null,
      value: map['value'] != null ? map['value'] as dynamic : null,
      maximum_value:
          map['maximum_value'] != null ? map['maximum_value'] as dynamic : null,
      quantity: map['quantity'] != null ? int.parse(map['quantity']) : null,
      id: map['id'] != null ? map['id'] as dynamic : null,
      item_name: map['item_name'] != null ? map['item_name'] as dynamic : null,
      short_description: map['short_description'] != null
          ? map['short_description'] as dynamic
          : null,
      time_to_ship:
          map['time_to_ship'] != null ? map['time_to_ship'] as dynamic : null,
      store_name:
          map['store_name'] != null ? map['store_name'] as dynamic : null,
      quantityL: map['quantityL'] != null ? map['quantityL'] as dynamic : 0,
    );
  }

  add() {
    log('add $quantity', name: 'cart item model');
    // quantityL = int.parse(quantity);
    // log('$quantity and also $quantityL', name: 'cart item model');
    quantity++;
    getTotal();
  }

  getTotal() {
    quantityL = quantity * value;
    log('$quantityL', name: 'cart_item_model.dart');
  }

  minus() {
    if (quantity != 1) {
      log('$quantity', name: 'cart item model');
      quantity--;
      getTotal();
    }
  }

  String toJson() => json.encode(toMap());

  factory CartitemModel.fromJson(String source) =>
      CartitemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props {
    return [
      symbol,
      quantity,
      id,
      item_name,
      short_description,
      time_to_ship,
      store_name,
      value,
      maximum_value,
      quantityL,
    ];
  }

  @override
  bool get stringify => true;
}
