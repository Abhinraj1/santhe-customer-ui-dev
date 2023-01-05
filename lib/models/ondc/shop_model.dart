// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ShopModel extends Equatable {
  final dynamic name;
  final dynamic address;
  final dynamic city;
  final dynamic pincode;
  final dynamic item_count;
  final dynamic distance;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final dynamic description;
  final dynamic delivery;
  final dynamic ondc_location_id;
  final dynamic ondc_store_id;
  final dynamic state;
  final dynamic bpp_id;
  final dynamic bpp_uri;
  final dynamic symbol;
  final dynamic message_id;
  final dynamic transaction_id;
  final dynamic id;
  final dynamic items;
  const ShopModel({
    required this.name,
    required this.address,
    required this.city,
    required this.pincode,
    required this.item_count,
    required this.distance,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.description,
    required this.delivery,
    required this.ondc_location_id,
    required this.ondc_store_id,
    required this.state,
    required this.bpp_id,
    required this.bpp_uri,
    required this.symbol,
    required this.message_id,
    required this.transaction_id,
    required this.id,
    required this.items,
  });

  ShopModel copyWith({
    dynamic? name,
    dynamic? address,
    dynamic? city,
    dynamic? pincode,
    dynamic? item_count,
    dynamic? distance,
    dynamic? createdAt,
    dynamic? updatedAt,
    dynamic? deletedAt,
    dynamic? description,
    dynamic? delivery,
    dynamic? ondc_location_id,
    dynamic? ondc_store_id,
    dynamic? state,
    dynamic? bpp_id,
    dynamic? bpp_uri,
    dynamic? symbol,
    dynamic? message_id,
    dynamic? transaction_id,
    dynamic? id,
    dynamic? items,
  }) {
    return ShopModel(
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      item_count: item_count ?? this.item_count,
      distance: distance ?? this.distance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      description: description ?? this.description,
      delivery: delivery ?? this.delivery,
      ondc_location_id: ondc_location_id ?? this.ondc_location_id,
      ondc_store_id: ondc_store_id ?? this.ondc_store_id,
      state: state ?? this.state,
      bpp_id: bpp_id ?? this.bpp_id,
      bpp_uri: bpp_uri ?? this.bpp_uri,
      symbol: symbol ?? this.symbol,
      message_id: message_id ?? this.message_id,
      transaction_id: transaction_id ?? this.transaction_id,
      id: id ?? this.id,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'city': city,
      'pincode': pincode,
      'item_count': item_count,
      'distance': distance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'description': description,
      'delivery': delivery,
      'ondc_location_id': ondc_location_id,
      'ondc_store_id': ondc_store_id,
      'state': state,
      'bpp_id': bpp_id,
      'bpp_uri': bpp_uri,
      'symbol': symbol,
      'message_id': message_id,
      'transaction_id': transaction_id,
      'id': id,
      'items': items,
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      name: map['name'] != null ? map['name'] as dynamic : null,
      address: map['address'] != null ? map['address'] as dynamic : null,
      city: map['city'] != null ? map['city'] as dynamic : null,
      pincode: map['pincode'] != null ? map['pincode'] as dynamic : null,
      item_count:
          map['item_count'] != null ? map['item_count'] as dynamic : null,
      distance: map['distance'] != null ? map['distance'] as dynamic : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as dynamic : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as dynamic : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as dynamic : null,
      description:
          map['description'] != null ? map['description'] as dynamic : null,
      delivery: map['delivery'] != null ? map['delivery'] as dynamic : null,
      ondc_location_id: map['ondc_location_id'] != null
          ? map['ondc_location_id'] as dynamic
          : null,
      ondc_store_id:
          map['ondc_store_id'] != null ? map['ondc_store_id'] as dynamic : null,
      state: map['state'] != null ? map['state'] as dynamic : null,
      bpp_id: map['bpp_id'] != null ? map['bpp_id'] as dynamic : null,
      bpp_uri: map['bpp_uri'] != null ? map['bpp_uri'] as dynamic : null,
      symbol: map['symbol'] != null ? map['symbol'] as dynamic : null,
      message_id:
          map['message_id'] != null ? map['message_id'] as dynamic : null,
      transaction_id: map['transaction_id'] != null
          ? map['transaction_id'] as dynamic
          : null,
      id: map['id'] != null ? map['id'] as dynamic : null,
      items: map['items'] != null ? map['items'] as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopModel.fromJson(String source) =>
      ShopModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      name,
      address,
      city,
      pincode,
      item_count,
      distance,
      createdAt,
      updatedAt,
      deletedAt,
      description,
      delivery,
      ondc_location_id,
      ondc_store_id,
      state,
      bpp_id,
      bpp_uri,
      symbol,
      message_id,
      transaction_id,
      id,
      items,
    ];
  }
}
