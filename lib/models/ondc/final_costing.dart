// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_question_mark
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FinalCostingModel extends Equatable {
  final dynamic value;
  final dynamic lable;
  const FinalCostingModel({
    required this.value,
    required this.lable,
  });
  // final dynamic itemCost;
  // final dynamic discount;
  // final dynamic miscCost;
  // final dynamic tax;
  // final dynamic deliveryCost;
  // final dynamic totalCost;
  // const FinalCostingModel({
  //   required this.itemCost,
  //   required this.discount,
  //   required this.miscCost,
  //   required this.tax,
  //   required this.deliveryCost,
  //   required this.totalCost,
  // });

  // FinalCostingModel copyWith({
  //   dynamic? itemCost,
  //   dynamic? discount,
  //   dynamic? miscCost,
  //   dynamic? tax,
  //   dynamic? deliveryCost,
  //   dynamic? totalCost,
  // }) {
  //   return FinalCostingModel(
  //     itemCost: itemCost ?? this.itemCost,
  //     discount: discount ?? this.discount,
  //     miscCost: miscCost ?? this.miscCost,
  //     tax: tax ?? this.tax,
  //     deliveryCost: deliveryCost ?? this.deliveryCost,
  //     totalCost: totalCost ?? this.totalCost,
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'itemCost': itemCost,
  //     'discount': discount,
  //     'miscCost': miscCost,
  //     'tax': tax,
  //     'deliveryCost': deliveryCost,
  //     'totalCost': totalCost,
  //   };
  // }

  // factory FinalCostingModel.fromMap(Map<String, dynamic> map) {
  //   return FinalCostingModel(
  //     itemCost: map['itemCost'] != null ? map['itemCost'] as dynamic : null,
  //     discount: map['discount'] != null ? map['discount'] as dynamic : null,
  //     miscCost: map['miscCost'] != null ? map['miscCost'] as dynamic : null,
  //     tax: map['tax'] != null ? map['tax'] as dynamic : null,
  //     deliveryCost:
  //         map['deliveryCost'] != null ? map['deliveryCost'] as dynamic : null,
  //     totalCost: map['totalCost'] != null ? map['totalCost'] as dynamic : null,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory FinalCostingModel.fromJson(String source) =>
  //     FinalCostingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // bool get stringify => true;

  // @override
  // List<Object> get props {
  //   return [
  //     itemCost,
  //     discount,
  //     miscCost,
  //     tax,
  //     deliveryCost,
  //     totalCost,
  //   ];
  // }

  FinalCostingModel copyWith({
    dynamic? value,
    dynamic? lable,
  }) {
    return FinalCostingModel(
      value: value ?? this.value,
      lable: lable ?? this.lable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'lable': lable,
    };
  }

  factory FinalCostingModel.fromMap(Map<String, dynamic> map) {
    return FinalCostingModel(
      value: map['value'] != null ? map['value'] as dynamic : null,
      lable: map['lable'] != null ? map['lable'] as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FinalCostingModel.fromJson(String source) =>
      FinalCostingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [value, lable];
}
