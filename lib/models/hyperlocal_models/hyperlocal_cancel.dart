// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_question_mark
import 'dart:convert';

import 'package:equatable/equatable.dart';

class HyperlocalCancelModel extends Equatable {
  final dynamic id;
  final dynamic type;
  final dynamic reason;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  bool isSelected = false;
  HyperlocalCancelModel({
    required this.id,
    required this.type,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.isSelected,
  });

  HyperlocalCancelModel copyWith({
    dynamic? id,
    dynamic? type,
    dynamic? reason,
    dynamic? createdAt,
    dynamic? updatedAt,
    dynamic? deletedAt,
    bool? isSelected,
  }) {
    return HyperlocalCancelModel(
      id: id ?? this.id,
      type: type ?? this.type,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'reason': reason,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'isSelected': isSelected,
    };
  }

  factory HyperlocalCancelModel.fromMap(Map<String, dynamic> map) {
    return HyperlocalCancelModel(
      id: map['id'] as dynamic,
      type: map['type'] as dynamic,
      reason: map['reason'] as dynamic,
      createdAt: map['createdAt'] as dynamic,
      updatedAt: map['updatedAt'] as dynamic,
      deletedAt: map['deletedAt'] as dynamic,
      isSelected: map['isSelected'] != null ? map['isSelected'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory HyperlocalCancelModel.fromJson(String source) =>
      HyperlocalCancelModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      type,
      reason,
      createdAt,
      updatedAt,
      deletedAt,
      isSelected,
    ];
  }
}
