// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:equatable/equatable.dart';

class PreviewItemModel extends Equatable {
  final String id;
  final String title;
  final String price;
  final String type;
  final String quantity;
  final String ondc_item_id;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;
  final String quoteId;
  const PreviewItemModel({
    required this.id,
    required this.title,
    required this.price,
    required this.type,
    required this.quantity,
    required this.ondc_item_id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.quoteId,
  });

  PreviewItemModel copyWith({
    String? id,
    String? title,
    String? price,
    String? type,
    String? quantity,
    String? ondc_item_id,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    String? quoteId,
  }) {
    return PreviewItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      ondc_item_id: ondc_item_id ?? this.ondc_item_id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      quoteId: quoteId ?? this.quoteId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'price': price,
      'type': type,
      'quantity': quantity,
      'ondc_item_id': ondc_item_id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'quoteId': quoteId,
    };
  }

  factory PreviewItemModel.fromMap(Map<String, dynamic> map) {
    return PreviewItemModel(
      id: map['id'] as String,
      title: map['title'] as String,
      price: map['price'] as String,
      type: map['type'] as String,
      quantity: map['quantity'] as String,
      ondc_item_id: map['ondc_item_id'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      deletedAt: map['deletedAt'] as String,
      quoteId: map['quoteId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PreviewItemModel.fromJson(String source) =>
      PreviewItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      title,
      price,
      type,
      quantity,
      ondc_item_id,
      createdAt,
      updatedAt,
      deletedAt,
      quoteId,
    ];
  }
}
