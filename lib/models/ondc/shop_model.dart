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
  final dynamic delivery;
  final dynamic ondc_location_id;
  final dynamic ondc_store_id;
  final dynamic storeId;
  final dynamic storeId1;
  final dynamic state;
  final dynamic bpp_id;
  final dynamic bpp_uri;
  final dynamic email;
  final dynamic phone;
  final dynamic symbol;
  final dynamic message_id;
  final dynamic transaction_id;
  final dynamic id;
  final dynamic items;
  final dynamic days;
  final dynamic frequency;
  final dynamic storeOpenTime;
  final dynamic storeClosingTime;
  final dynamic times;
  final dynamic short_description;
  final dynamic long_description;
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
    required this.delivery,
    required this.ondc_location_id,
    required this.ondc_store_id,
    required this.storeId,
    required this.storeId1,
    required this.state,
    required this.bpp_id,
    required this.bpp_uri,
    required this.email,
    required this.phone,
    required this.symbol,
    required this.message_id,
    required this.transaction_id,
    required this.id,
    required this.items,
    required this.days,
    required this.frequency,
    required this.storeOpenTime,
    required this.storeClosingTime,
    required this.times,
    required this.short_description,
    required this.long_description,
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
    dynamic? delivery,
    dynamic? ondc_location_id,
    dynamic? ondc_store_id,
    dynamic? storeId,
    dynamic? storeId1,
    dynamic? state,
    dynamic? bpp_id,
    dynamic? bpp_uri,
    dynamic? email,
    dynamic? phone,
    dynamic? symbol,
    dynamic? message_id,
    dynamic? transaction_id,
    dynamic? id,
    dynamic? items,
    dynamic? days,
    dynamic? frequency,
    dynamic? storeOpenTime,
    dynamic? storeClosingTime,
    dynamic? times,
    dynamic? short_description,
    dynamic? long_description,
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
      delivery: delivery ?? this.delivery,
      ondc_location_id: ondc_location_id ?? this.ondc_location_id,
      ondc_store_id: ondc_store_id ?? this.ondc_store_id,
      storeId: storeId ?? this.storeId,
      storeId1: storeId1 ?? this.storeId1,
      state: state ?? this.state,
      bpp_id: bpp_id ?? this.bpp_id,
      bpp_uri: bpp_uri ?? this.bpp_uri,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      symbol: symbol ?? this.symbol,
      message_id: message_id ?? this.message_id,
      transaction_id: transaction_id ?? this.transaction_id,
      id: id ?? this.id,
      items: items ?? this.items,
      days: days ?? this.days,
      frequency: frequency ?? this.frequency,
      storeOpenTime: storeOpenTime ?? this.storeOpenTime,
      storeClosingTime: storeClosingTime ?? this.storeClosingTime,
      times: times ?? this.times,
      short_description: short_description ?? this.short_description,
      long_description: long_description ?? this.long_description,
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
      'email': email,
      'phone': phone,
      'storeId': storeId,
      'storeId1': storeId1,
      'long_description': long_description,
      'short_description': short_description,
      'frequency': frequency,
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      name:
          map['store']['name'] != null ? map['store']['name'] as dynamic : null,
      address: map['address'] != null ? map['address'] as dynamic : null,
      city: map['city'] != null ? map['city'] as dynamic : null,
      pincode: map['pincode'] != null ? map['pincode'] as dynamic : null,
      storeId1: map['storeId'] != null ? map['storeId'] as dynamic : null,
      item_count:
          map['item_count'] != null ? map['item_count'] as dynamic : null,
      distance: map['distance'] != null ? map['distance'] as dynamic : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as dynamic : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as dynamic : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as dynamic : null,
      delivery: map['delivery'] != null ? map['delivery'] as dynamic : null,
      ondc_location_id: map['ondc_location_id'] != null
          ? map['ondc_location_id'] as dynamic
          : null,
      ondc_store_id: map['store'] != null
          ? map['store']['ondc_store_id'] != null
              ? map['store']['ondc_store_id'] as dynamic
              : null
          : null,
      storeId: map['store'] != null
          ? map['store']['id'] != null
              ? map['store']['id'] as dynamic
              : null
          : null,
      state: map['state'] != null ? map['state'] as dynamic : null,
      bpp_id: map['store'] != null
          ? map['store']['bpp_id'] != null
              ? map['store']['bpp_id'] as dynamic
              : null
          : null,
      bpp_uri: map['store'] != null
          ? map['store']['bpp_uri'] != null
              ? map['store']['bpp_uri'] as dynamic
              : null
          : null,
      symbol: map['store'] != null
          ? map['store']['symbol'] != null
              ? map['store']['symbol'] as dynamic
              : null
          : null,
      message_id: map['store'] != null
          ? map['store']['message_id'] != null
              ? map['store']['message_id'] as dynamic
              : null
          : null,
      transaction_id: map['store'] != null
          ? map['store']['transaction_id'] != null
              ? map['store']['transaction_id'] as dynamic
              : null
          : null,
      id: map['id'] != null ? map['id'] as dynamic : null,
      items: map['items'] != null ? map['items'] as dynamic : null,
      email: map['store'] != null
          ? map['store']['email'] != null
              ? map['store']['email'] as dynamic
              : null
          : null,
      phone: map['store'] != null
          ? map['store']['phone'] != null
              ? map['store']['phone'] as dynamic
              : null
          : null,
      days: map['days'] != null ? map['days'] as dynamic : null,
      frequency: map['frequency'] != null ? map['frequency'] as dynamic : null,
      storeOpenTime:
          map['storeOpenTime'] != null ? map['storeOpenTime'] as dynamic : null,
      storeClosingTime: map['storeCloseTime'] != null
          ? map['storeCloseTime'] as dynamic
          : null,
      times: map['times'] != null ? map['times'] as dynamic : null,
      short_description: map['store'] != null
          ? map['store']['short_description'] != null
              ? map['store']['short_description'] as dynamic
              : null
          : null,
      long_description: map['store'] != null
          ? map['store']['long_description'] != null
              ? map['store']['long_description'] as dynamic
              : null
          : null,
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
      delivery,
      ondc_location_id,
      ondc_store_id,
      storeId,
      storeId1,
      state,
      bpp_id,
      bpp_uri,
      email,
      phone,
      symbol,
      message_id,
      transaction_id,
      id,
      items,
      days,
      frequency,
      storeOpenTime,
      storeClosingTime,
      times,
      short_description,
      long_description,
    ];
  }
}
