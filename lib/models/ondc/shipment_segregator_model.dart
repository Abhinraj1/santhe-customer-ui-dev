// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ShipmentSegregatorModel extends Equatable {
  final dynamic shipmentNo;
  final dynamic id;
  final dynamic provider_name;
  final dynamic category;
  final dynamic tat;
  final dynamic serviceable;
  final dynamic message_id;
  const ShipmentSegregatorModel({
    required this.shipmentNo,
    this.id,
    this.provider_name,
    this.category,
    this.tat,
    this.serviceable,
    this.message_id,
  });

  ShipmentSegregatorModel copyWith({
    dynamic? shipmentNo,
    dynamic? id,
    dynamic? provider_name,
    dynamic? category,
    dynamic? tat,
    dynamic? serviceable,
    dynamic? message_id,
  }) {
    return ShipmentSegregatorModel(
      shipmentNo: shipmentNo ?? this.shipmentNo,
      id: id ?? this.id,
      provider_name: provider_name ?? this.provider_name,
      category: category ?? this.category,
      tat: tat ?? this.tat,
      serviceable: serviceable ?? this.serviceable,
      message_id: message_id ?? this.message_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shipmentNo': shipmentNo,
      'id': id,
      'provider_name': provider_name,
      'category': category,
      'tat': tat,
      'serviceable': serviceable,
      'message_id': message_id,
    };
  }

  factory ShipmentSegregatorModel.fromMap(Map<String, dynamic> map) {
    return ShipmentSegregatorModel(
      shipmentNo: map['deliveryFulfillment'] != null
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
      id: map['deliveryFulfillment'] != null
          ? map['deliveryFulfillment']['id'] != null
              ? map['deliveryFulfillment']['id'] as dynamic
              : null
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShipmentSegregatorModel.fromJson(String source) =>
      ShipmentSegregatorModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      shipmentNo,
      id,
      provider_name,
      category,
      tat,
      serviceable,
      message_id,
    ];
  }
}
