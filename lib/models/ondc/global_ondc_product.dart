// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark

import 'dart:convert';

import 'package:equatable/equatable.dart';

class ProductOndcGlobalModel extends Equatable {
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
  const ProductOndcGlobalModel({
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
  });

  ProductOndcGlobalModel copyWith({
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
  }) {
    return ProductOndcGlobalModel(
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
    };
  }

  factory ProductOndcGlobalModel.fromMap(Map<String, dynamic> map) {
    return ProductOndcGlobalModel(
      id: map['id'] as dynamic,
      transaction_id: map['transaction_id'] as dynamic,
      ondc_item_id: map['ondc_item_id'] as dynamic,
      name: map['name'] as dynamic,
      short_description: map['short_description'] as dynamic,
      long_description: map['long_description'] as dynamic,
      returnable: map['returnable'] as dynamic,
      isVeg: map['isVeg'] as dynamic,
      time_to_ship: map['time_to_ship'] as dynamic,
      rating: map['rating'] as dynamic,
      storeId: map['storeId'] as dynamic,
      customer_care: map['customer_care'] as dynamic,
      return_window: map['return_window'] as dynamic,
      seller_pickup_return: map['seller_pickup_return'] as dynamic,
      symbol: map['symbol'] as dynamic,
      available: map['available'] as dynamic,
      maximum: map['maximum'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOndcGlobalModel.fromJson(String source) =>
      ProductOndcGlobalModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
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
    ];
  }
}
