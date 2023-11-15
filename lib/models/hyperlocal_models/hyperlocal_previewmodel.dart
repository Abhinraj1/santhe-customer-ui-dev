// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';

class HyperLocalPreviewModel extends Equatable {
  final dynamic id;
  final dynamic units;
  final dynamic quantity;
  final dynamic delivery_time;
  final dynamic price;
  final dynamic convenience_fee;
  final dynamic delivery_status;
  final dynamic returnable;
  final dynamic cancellable;
  final dynamic santheOrderId;
  final dynamic productId;
  final dynamic symbol;
  final dynamic title;
  final dynamic mrp;
  final dynamic offer_price;
  final dynamic active;
  final dynamic storeDescriptionId;
  final dynamic status;
  final dynamic reason;
  const HyperLocalPreviewModel({
    required this.id,
    required this.units,
    required this.quantity,
    required this.delivery_time,
    required this.price,
    required this.convenience_fee,
    required this.delivery_status,
    required this.returnable,
    required this.cancellable,
    required this.santheOrderId,
    required this.productId,
    required this.symbol,
    required this.title,
    required this.mrp,
    required this.offer_price,
    required this.active,
    required this.storeDescriptionId,
    required this.status,
    required this.reason,
  });

  HyperLocalPreviewModel copyWith({
    dynamic? id,
    dynamic? units,
    dynamic? quantity,
    dynamic? delivery_time,
    dynamic? price,
    dynamic? convenience_fee,
    dynamic? delivery_status,
    dynamic? returnable,
    dynamic? cancellable,
    dynamic? santheOrderId,
    dynamic? productId,
    dynamic? symbol,
    dynamic? title,
    dynamic? mrp,
    dynamic? offer_price,
    dynamic? active,
    dynamic? storeDescriptionId,
    dynamic? status,
    dynamic? reason,
  }) {
    return HyperLocalPreviewModel(
      id: id ?? this.id,
      units: units ?? this.units,
      quantity: quantity ?? this.quantity,
      delivery_time: delivery_time ?? this.delivery_time,
      price: price ?? this.price,
      convenience_fee: convenience_fee ?? this.convenience_fee,
      delivery_status: delivery_status ?? this.delivery_status,
      returnable: returnable ?? this.returnable,
      cancellable: cancellable ?? this.cancellable,
      santheOrderId: santheOrderId ?? this.santheOrderId,
      productId: productId ?? this.productId,
      symbol: symbol ?? this.symbol,
      title: title ?? this.title,
      mrp: mrp ?? this.mrp,
      offer_price: offer_price ?? this.offer_price,
      active: active ?? this.active,
      storeDescriptionId: storeDescriptionId ?? this.storeDescriptionId,
      status: status ?? this.status,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'units': units,
      'quantity': quantity,
      'delivery_time': delivery_time,
      'price': price,
      'convenience_fee': convenience_fee,
      'delivery_status': delivery_status,
      'returnable': returnable,
      'cancellable': cancellable,
      'santheOrderId': santheOrderId,
      'productId': productId,
      'symbol': symbol,
      'title': title,
      'status': status,
      'reason': reason
    };
  }

  factory HyperLocalPreviewModel.fromMap(Map<String, dynamic> map) {
    List states = map['states'] as List;
    // log('$states returnable ${map['returnable']}',
    //     name: 'HyperLocalPreviewModel.fromMap');
    return HyperLocalPreviewModel(
        id: map['id'] != null ? map['id'] as dynamic : null,
        units: map['units'] != null ? map['units'] as dynamic : null,
        quantity: map['quantity'] != null ? map['quantity'] as dynamic : null,
        delivery_time: map['delivery_time'] != null
            ? map['delivery_time'] as dynamic
            : null,
        price: map['price'] != null ? map['price'] as dynamic : null,
        convenience_fee: map['convenience_fee'] != null
            ? map['convenience_fee'] as dynamic
            : null,
        delivery_status: map['delivery_status'] != null
            ? map['delivery_status'] as dynamic
            : null,
        returnable:
            map['returnable'] != null ? map['returnable'] as dynamic : null,
        cancellable:
            map['cancellable'] != null ? map['cancellable'] as dynamic : null,
        santheOrderId: map['santheOrderId'] != null
            ? map['santheOrderId'] as dynamic
            : null,
        productId:
            map['productId'] != null ? map['productId'] as dynamic : null,
        symbol: map['product']['display_image'] != null
            ? map['product']['display_image'] as dynamic
            : null,
        title: map['product']['name'] != null
            ? map['product']['name'] as dynamic
            : null,
        mrp: map['product']['mrp'] != null
            ? map['product']['mrp'] as dynamic
            : null,
        offer_price: map['product']['offer_price'] != null
            ? map['product']['offer_price'] as dynamic
            : null,
        active: map['product']['active'] != null
            ? map['product']['active'] as dynamic
            : null,
        storeDescriptionId: map['product']['storeDescriptionId'] != null
            ? map['product']['storeDescriptionId'] as dynamic
            : null,
        status: states.first['title'] as dynamic,
        reason: states.first['reason'] as dynamic);
  }

  String toJson() => json.encode(toMap());

  factory HyperLocalPreviewModel.fromJson(String source) =>
      HyperLocalPreviewModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      units,
      quantity,
      delivery_time,
      price,
      convenience_fee,
      delivery_status,
      returnable,
      cancellable,
      santheOrderId,
      productId,
      symbol,
      title,
      mrp,
      offer_price,
      active,
      storeDescriptionId,
      status,
      reason,
    ];
  }
}
