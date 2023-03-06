// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';

class PreviewWidgetModel extends Equatable {
  final dynamic id;
  final dynamic price;
  final dynamic title;
  final dynamic type;
  final dynamic quantity;
  final dynamic ondc_item_id;
  final dynamic status;
  final dynamic cancellable;
  final dynamic symbol;
  final dynamic createdAt;
  final dynamic deletedAt;
  final dynamic updatedAt;
  final dynamic quoteId;
  final dynamic deliveryFulfillmentId;
  final dynamic fulfillment_id;
  final dynamic provider_name;
  final dynamic category;
  final dynamic tat;
  final dynamic serviceable;
  final dynamic message_id;
  const PreviewWidgetModel({
    required this.id,
    required this.price,
    required this.title,
    required this.type,
    required this.quantity,
    required this.ondc_item_id,
    required this.status,
    required this.cancellable,
    required this.symbol,
    required this.createdAt,
    required this.deletedAt,
    required this.updatedAt,
    required this.quoteId,
    required this.deliveryFulfillmentId,
    required this.fulfillment_id,
    required this.provider_name,
    required this.category,
    required this.tat,
    required this.serviceable,
    required this.message_id,
  });

  PreviewWidgetModel copyWith({
    dynamic? id,
    dynamic? price,
    dynamic? title,
    dynamic? type,
    dynamic? quantity,
    dynamic? ondc_item_id,
    dynamic? status,
    dynamic? cancellable,
    dynamic? symbol,
    dynamic? createdAt,
    dynamic? deletedAt,
    dynamic? updatedAt,
    dynamic? quoteId,
    dynamic? deliveryFulfillmentId,
    dynamic? fulfillment_id,
    dynamic? provider_name,
    dynamic? category,
    dynamic? tat,
    dynamic? serviceable,
    dynamic? message_id,
  }) {
    return PreviewWidgetModel(
      id: id ?? this.id,
      price: price ?? this.price,
      title: title ?? this.title,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      ondc_item_id: ondc_item_id ?? this.ondc_item_id,
      status: status ?? this.status,
      cancellable: cancellable ?? this.cancellable,
      symbol: symbol ?? this.symbol,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      quoteId: quoteId ?? this.quoteId,
      deliveryFulfillmentId:
          deliveryFulfillmentId ?? this.deliveryFulfillmentId,
      fulfillment_id: fulfillment_id ?? this.fulfillment_id,
      provider_name: provider_name ?? this.provider_name,
      category: category ?? this.category,
      tat: tat ?? this.tat,
      serviceable: serviceable ?? this.serviceable,
      message_id: message_id ?? this.message_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'price': price,
      'title': title,
      'type': type,
      'quantity': quantity,
      'ondc_item_id': ondc_item_id,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
      'updatedAt': updatedAt,
      'quoteId': quoteId,
      'status': status,
      'cancellable': cancellable,
      'symbol': symbol,
      'deliveryFulfillmentId': deliveryFulfillmentId,
      'fulfillment_id': fulfillment_id,
      'provider_name': provider_name,
      'category': category,
      'tat': tat,
      'serviceable': serviceable,
      'message_id': message_id,
    };
  }

  factory PreviewWidgetModel.fromMap(Map<String, dynamic> map) {
    // log('$map', name: 'PreviewWidgetModel.fromMap');
    return PreviewWidgetModel(
      id: map['id'] != null ? map['id'] as dynamic : null,
      symbol: map['symbol'] != null ? map['symbol'] as dynamic : null,
      status: map['status'] != null ? map['status'] as dynamic : null,
      cancellable:
          map['cancellable'] != null ? map['cancellable'] as dynamic : null,
      price: map['price'] != null ? map['price'] as dynamic : null,
      title: map['title'] != null ? map['title'] as dynamic : null,
      type: map['type'] != null ? map['type'] as dynamic : null,
      quantity: map['quantity'] != null ? map['quantity'] as dynamic : null,
      ondc_item_id:
          map['ondc_item_id'] != null ? map['ondc_item_id'] as dynamic : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as dynamic : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as dynamic : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as dynamic : null,
      quoteId: map['quoteId'] != null ? map['quoteId'] as dynamic : null,
      deliveryFulfillmentId: map['deliveryFulfillmentId'] != null
          ? map['deliveryFulfillmentId'] as dynamic
          : null,
      fulfillment_id: map['deliveryFulfillment'] != null
          ? map['deliveryFulfillment']['fulfillment_id'] != null
              ? map['deliveryFulfillment']['fulfillment_id'] as dynamic
              : null
          : null,
      provider_name: map['deliveryFulfillment'] != null
          ? map['deliveryFulfillment']['provider_name'] != null
              ? map['deliveryFulfillment']['provider_name'] as dynamic
              : null
          : null,
      category: map['deliveryFulfillment'] != null
          ? map['deliveryFulfillment']['category'] != null
              ? map['deliveryFulfillment']['category'] as dynamic
              : null
          : null,
      tat: map['deliveryFulfillment'] != null
          ? map['deliveryFulfillment']['tat'] != null
              ? map['deliveryFulfillment']['tat'] as dynamic
              : null
          : null,
      serviceable: map['deliveryFulfillment'] != null
          ? map['deliveryFulfillment']['serviceable'] != null
              ? map['deliveryFulfillment']['serviceable'] as dynamic
              : null
          : null,
      message_id: map['deliveryFulfillment'] != null
          ? map['deliveryFulfillment']['message_id'] != null
              ? map['deliveryFulfillment']['message_id'] as dynamic
              : null
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PreviewWidgetModel.fromJson(String source) =>
      PreviewWidgetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      price,
      title,
      type,
      quantity,
      ondc_item_id,
      status,
      cancellable,
      symbol,
      createdAt,
      deletedAt,
      updatedAt,
      quoteId,
      deliveryFulfillmentId,
      fulfillment_id,
      provider_name,
      category,
      tat,
      serviceable,
      message_id,
    ];
  }
}
