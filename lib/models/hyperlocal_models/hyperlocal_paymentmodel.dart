// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark
import 'dart:convert';

import 'package:equatable/equatable.dart';

class HyperlocalPaymentInfoModel extends Equatable {
  final dynamic id;
  final dynamic entity;
  final dynamic amount;
  final dynamic amount_paid;
  final dynamic amount_due;
  final dynamic currency;
  final dynamic receipt;
  final dynamic offer_id;
  final dynamic status;
  final dynamic attempts;
  final dynamic notes;
  final dynamic created_at;
  final dynamic message;
  final dynamic type;
  const HyperlocalPaymentInfoModel({
    required this.id,
    required this.entity,
    required this.amount,
    required this.amount_paid,
    required this.amount_due,
    required this.currency,
    required this.receipt,
    required this.offer_id,
    required this.status,
    required this.attempts,
    required this.notes,
    required this.created_at,
    required this.message,
    required this.type,
  });

  HyperlocalPaymentInfoModel copyWith({
    dynamic? id,
    dynamic? entity,
    dynamic? amount,
    dynamic? amount_paid,
    dynamic? amount_due,
    dynamic? currency,
    dynamic? receipt,
    dynamic? offer_id,
    dynamic? status,
    dynamic? attempts,
    dynamic? notes,
    dynamic? created_at,
    dynamic? message,
    dynamic? type,
  }) {
    return HyperlocalPaymentInfoModel(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      amount: amount ?? this.amount,
      amount_paid: amount_paid ?? this.amount_paid,
      amount_due: amount_due ?? this.amount_due,
      currency: currency ?? this.currency,
      receipt: receipt ?? this.receipt,
      offer_id: offer_id ?? this.offer_id,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      message: message ?? this.message,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'entity': entity,
      'amount': amount,
      'amount_paid': amount_paid,
      'amount_due': amount_due,
      'currency': currency,
      'receipt': receipt,
      'offer_id': offer_id,
      'status': status,
      'attempts': attempts,
      'notes': notes,
      'created_at': created_at,
      'message': message,
      'type': type,
    };
  }

  factory HyperlocalPaymentInfoModel.fromMap(Map<String, dynamic> map) {
    return HyperlocalPaymentInfoModel(
      id: map['id'] as dynamic,
      entity: map['entity'] as dynamic,
      amount: map['amount'] as dynamic,
      amount_paid: map['amount_paid'] as dynamic,
      amount_due: map['amount_due'] as dynamic,
      currency: map['currency'] as dynamic,
      receipt: map['receipt'] as dynamic,
      offer_id: map['offer_id'] as dynamic,
      status: map['status'] as dynamic,
      attempts: map['attempts'] as dynamic,
      notes: map['notes'] as dynamic,
      created_at: map['created_at'] as dynamic,
      message: map['message'] as dynamic,
      type: map['type'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory HyperlocalPaymentInfoModel.fromJson(String source) =>
      HyperlocalPaymentInfoModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      entity,
      amount,
      amount_paid,
      amount_due,
      currency,
      receipt,
      offer_id,
      status,
      attempts,
      notes,
      created_at,
      message,
      type,
    ];
  }
}
