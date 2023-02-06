// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:equatable/equatable.dart';

class CheckoutCartModel extends Equatable {
  final dynamic id;
  final dynamic transaction_id;
  final dynamic message_id;
  final dynamic currency;
  final dynamic total_price;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final dynamic orderId;
  final dynamic storeId;
  const CheckoutCartModel({
    required this.id,
    required this.transaction_id,
    required this.message_id,
    required this.currency,
    required this.total_price,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.orderId,
    required this.storeId,
  });

  CheckoutCartModel copyWith({
    dynamic? id,
    dynamic? transaction_id,
    dynamic? message_id,
    dynamic? currency,
    dynamic? total_price,
    dynamic? createdAt,
    dynamic? updatedAt,
    dynamic? deletedAt,
    dynamic? orderId,
    dynamic? storeId,
  }) {
    return CheckoutCartModel(
      id: id ?? this.id,
      transaction_id: transaction_id ?? this.transaction_id,
      message_id: message_id ?? this.message_id,
      currency: currency ?? this.currency,
      total_price: total_price ?? this.total_price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      orderId: orderId ?? this.orderId,
      storeId: storeId ?? this.storeId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'transaction_id': transaction_id,
      'message_id': message_id,
      'currency': currency,
      'total_price': total_price,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'orderId': orderId,
      'storeId': storeId,
    };
  }

  factory CheckoutCartModel.fromMap(Map<String, dynamic> map) {
    return CheckoutCartModel(
      id: map['id'] != null ? map['id'] as dynamic : null,
      transaction_id: map['transaction_id'] != null
          ? map['transaction_id'] as dynamic
          : null,
      message_id:
          map['message_id'] != null ? map['message_id'] as dynamic : null,
      currency: map['currency'] != null ? map['currency'] as dynamic : null,
      total_price:
          map['total_price'] != null ? map['total_price'] as dynamic : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as dynamic : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as dynamic : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as dynamic : null,
      orderId: map['orderId'] != null ? map['orderId'] as dynamic : null,
      storeId: map['storeId'] != null ? map['storeId'] as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckoutCartModel.fromJson(String source) =>
      CheckoutCartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      transaction_id,
      message_id,
      currency,
      total_price,
      createdAt,
      updatedAt,
      deletedAt,
      orderId,
      storeId,
    ];
  }
}
