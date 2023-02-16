// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:santhe/models/ondc/product_ondc.dart';

class CartitemModel {
  final ProductOndcModel productModel;
  int quantity;
  bool isAddedToCart;
  CartitemModel({
    required this.productModel,
    required this.quantity,
    required this.isAddedToCart,
  });

  CartitemModel copyWith({
    ProductOndcModel? productModel,
    int? quantity,
    bool? isAddedToCart,
  }) {
    return CartitemModel(
      productModel: productModel ?? this.productModel,
      quantity: quantity ?? this.quantity,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productModel': productModel.toMap(),
      'quantity': quantity,
      'isAddedToCart': isAddedToCart,
    };
  }

  factory CartitemModel.fromMap(Map<String, dynamic> map) {
    return CartitemModel(
      productModel: ProductOndcModel.fromNewMap(
          map['productModel'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      isAddedToCart: map['isAddedToCart'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartitemModel.fromJson(String source) =>
      CartitemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartitemModel(productModel: $productModel, quantity: $quantity, isAddedToCart: $isAddedToCart)';

  @override
  bool operator ==(covariant CartitemModel other) {
    if (identical(this, other)) return true;

    return other.productModel == productModel &&
        other.quantity == quantity &&
        other.isAddedToCart == isAddedToCart;
  }

  @override
  int get hashCode =>
      productModel.hashCode ^ quantity.hashCode ^ isAddedToCart.hashCode;
}
