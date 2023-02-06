// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_question_mark
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FinalCostingModel extends Equatable {
  final dynamic itemCost;
  final dynamic discount;
  final dynamic miscCost;
  final dynamic tax;
  final dynamic deliveryCost;
  const FinalCostingModel({
    required this.itemCost,
    required this.discount,
    required this.miscCost,
    required this.tax,
    required this.deliveryCost,
  });

  FinalCostingModel copyWith({
    dynamic? itemCost,
    dynamic? discount,
    dynamic? miscCost,
    dynamic? tax,
    dynamic? deliveryCost,
  }) {
    return FinalCostingModel(
      itemCost: itemCost ?? this.itemCost,
      discount: discount ?? this.discount,
      miscCost: miscCost ?? this.miscCost,
      tax: tax ?? this.tax,
      deliveryCost: deliveryCost ?? this.deliveryCost,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemCost': itemCost,
      'discount': discount,
      'miscCost': miscCost,
      'tax': tax,
      'deliveryCost': deliveryCost,
    };
  }

  factory FinalCostingModel.fromMap(Map<String, dynamic> map) {
    return FinalCostingModel(
      itemCost: map['itemCost'] != null ? map['itemCost'] as dynamic : null,
      discount: map['discount'] != null ? map['discount'] as dynamic : null,
      miscCost: map['miscCost'] != null ? map['miscCost'] as dynamic : null,
      tax: map['tax'] != null ? map['tax'] as dynamic : null,
      deliveryCost:
          map['deliveryCost'] != null ? map['deliveryCost'] as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FinalCostingModel.fromJson(String source) =>
      FinalCostingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      itemCost,
      discount,
      miscCost,
      tax,
      deliveryCost,
    ];
  }
}
