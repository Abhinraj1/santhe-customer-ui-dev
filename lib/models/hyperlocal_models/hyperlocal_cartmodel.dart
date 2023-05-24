// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';

class HyperLocalCartModel extends Equatable {
  final dynamic symbol;
  final dynamic net_quantity;
  dynamic quantity;
  final dynamic productId;
  final dynamic product_name;
  final dynamic offer_price;
  final dynamic returnable;
  final dynamic cancellable;
  final dynamic mrp;
  final dynamic description;
  final dynamic display_image;
  final dynamic store_name;
  dynamic value;
  double? valueM;
  double? maximum_valueM;
  dynamic maximum_value;
  double? quantityL;
  HyperLocalCartModel({
    required this.symbol,
    required this.net_quantity,
    required this.quantity,
    required this.productId,
    required this.product_name,
    required this.offer_price,
    required this.returnable,
    required this.cancellable,
    required this.mrp,
    required this.description,
    required this.display_image,
    required this.store_name,
    this.value,
    this.valueM,
    this.maximum_valueM,
    this.maximum_value,
    this.quantityL,
  });

  HyperLocalCartModel copyWith({
    dynamic? symbol,
    dynamic? net_quantity,
    dynamic? quantity,
    dynamic? productId,
    dynamic? product_name,
    dynamic? offer_price,
    dynamic? returnable,
    dynamic? cancellable,
    dynamic? mrp,
    dynamic? description,
    dynamic? display_image,
    dynamic? store_name,
    dynamic? value,
    double? valueM,
    double? maximum_valueM,
    dynamic? maximum_value,
    double? quantityL,
  }) {
    return HyperLocalCartModel(
      symbol: symbol ?? this.symbol,
      net_quantity: net_quantity ?? this.net_quantity,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
      product_name: product_name ?? this.product_name,
      offer_price: offer_price ?? this.offer_price,
      returnable: returnable ?? this.returnable,
      cancellable: cancellable ?? this.cancellable,
      mrp: mrp ?? this.mrp,
      description: description ?? this.description,
      display_image: display_image ?? this.display_image,
      store_name: store_name ?? this.store_name,
      value: value ?? this.value,
      valueM: valueM ?? this.valueM,
      maximum_valueM: maximum_valueM ?? this.maximum_valueM,
      maximum_value: maximum_value ?? this.maximum_value,
      quantityL: quantityL ?? this.quantityL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'symbol': symbol,
      'net_quantity': net_quantity,
      'quantity': quantity,
      'productId': productId,
      'product_name': product_name,
      'offer_price': offer_price,
      'returnable': returnable,
      'cancellable': cancellable,
      'mrp': mrp,
      'description': description,
      'display_image': display_image,
      'store_name': store_name,
    };
  }

  add() {
    log('add $quantity $value $maximum_value', name: 'cart item model');
    // quantityL = int.parse(quantity);
    // log('$quantity and also $quantityL', name: 'cart item model');
    quantity++;
    valueM = 0;
    maximum_valueM = 0;
    valueM = double.parse(offer_price.toString()) *
        double.parse(quantity.toString());
    maximum_valueM =
        double.parse(mrp.toString()) * double.parse(quantity.toString());
    // getTotal();
    log('Checking for values $valueM $maximum_valueM',
        name: 'Cart_Item_Model.dart');
  }

  getTotal() {
    quantityL = double.parse(quantity.toString()) *
        double.parse(offer_price.toString());
    log('$quantityL', name: 'cart_item_model.dart');
  }

  minus() {
    if (quantity != 1) {
      log('minus $quantity', name: 'cart item model');
      quantity--;
      log('after minus $quantity');
      valueM = 0;
      maximum_valueM = 0;
      valueM = double.parse(offer_price.toString()) *
          double.parse(quantity.toString());
      maximum_valueM =
          double.parse(mrp.toString()) * double.parse(quantity.toString());
      getTotal();
      log('Checking for values Minus $valueM $maximum_valueM',
          name: 'Cart_Item_Model.dart');
    }
  }

  factory HyperLocalCartModel.fromMap(Map<String, dynamic> map) {
    return HyperLocalCartModel(
      symbol: map['symbol'] != null ? map['symbol'] as dynamic : null,
      net_quantity:
          map['net_quantity'] != null ? map['net_quantity'] as dynamic : null,
      quantity: map['quantity'] != null
          ? int.parse(map['quantity']) as dynamic
          : null,
      productId: map['productId'] != null ? map['productId'] as dynamic : null,
      product_name:
          map['product_name'] != null ? map['product_name'] as dynamic : null,
      offer_price:
          map['offer_price'] != null ? map['offer_price'] as dynamic : null,
      returnable:
          map['returnable'] != null ? map['returnable'] as dynamic : null,
      cancellable:
          map['cancellable'] != null ? map['cancellable'] as dynamic : null,
      mrp: map['mrp'] != null ? map['mrp'] as dynamic : null,
      description:
          map['description'] != null ? map['description'] as dynamic : null,
      display_image:
          map['display_image'] != null ? map['display_image'] as dynamic : null,
      store_name:
          map['store_name'] != null ? map['store_name'] as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HyperLocalCartModel.fromJson(String source) =>
      HyperLocalCartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      symbol,
      net_quantity,
      quantity,
      productId,
      product_name,
      offer_price,
      returnable,
      cancellable,
      mrp,
      description,
      display_image,
      store_name,
    ];
  }
}
