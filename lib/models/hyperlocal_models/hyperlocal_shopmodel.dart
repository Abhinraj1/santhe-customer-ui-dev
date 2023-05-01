// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, unnecessary_question_mark
import 'dart:convert';

import 'package:equatable/equatable.dart';

class HyperLocalShopModel extends Equatable {
  final dynamic id;
  final dynamic name;
  final dynamic upi_id;
  final dynamic bank_account_no;
  final dynamic bank_ifsc;
  final dynamic beneficiary_name;
  final dynamic gstin;
  final dynamic fulfillment_type;
  final dynamic description;
  final dynamic email;
  final dynamic address;
  final dynamic display_image;
  final dynamic images;
  final dynamic itemCount;
  const HyperLocalShopModel({
    required this.id,
    required this.name,
    required this.upi_id,
    required this.bank_account_no,
    required this.bank_ifsc,
    required this.beneficiary_name,
    required this.gstin,
    required this.fulfillment_type,
    required this.description,
    required this.email,
    required this.address,
    required this.display_image,
    required this.images,
    required this.itemCount,
  });

  HyperLocalShopModel copyWith({
    dynamic? id,
    dynamic? name,
    dynamic? upi_id,
    dynamic? bank_account_no,
    dynamic? bank_ifsc,
    dynamic? beneficiary_name,
    dynamic? gstin,
    dynamic? fulfillment_type,
    dynamic? description,
    dynamic? email,
    dynamic? address,
    dynamic? display_image,
    dynamic? images,
    dynamic? itemCount,
  }) {
    return HyperLocalShopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      upi_id: upi_id ?? this.upi_id,
      bank_account_no: bank_account_no ?? this.bank_account_no,
      bank_ifsc: bank_ifsc ?? this.bank_ifsc,
      beneficiary_name: beneficiary_name ?? this.beneficiary_name,
      gstin: gstin ?? this.gstin,
      fulfillment_type: fulfillment_type ?? this.fulfillment_type,
      description: description ?? this.description,
      email: email ?? this.email,
      address: address ?? this.address,
      display_image: display_image ?? this.display_image,
      images: images ?? this.images,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'upi_id': upi_id,
      'bank_account_no': bank_account_no,
      'bank_ifsc': bank_ifsc,
      'beneficiary_name': beneficiary_name,
      'gstin': gstin,
      'fulfillment_type': fulfillment_type,
      'description': description,
      'email': email,
      'address': address,
      'display_image': display_image,
      'images': images,
      'itemCount': itemCount,
    };
  }

  factory HyperLocalShopModel.fromMap(Map<String, dynamic> map) {
    return HyperLocalShopModel(
      id: map['id'] != null ? map['id'] as dynamic : null,
      name: map['name'] != null ? map['name'] as dynamic : null,
      upi_id: map['upi_id'] != null ? map['upi_id'] as dynamic : null,
      bank_account_no: map['bank_account_no'] != null
          ? map['bank_account_no'] as dynamic
          : null,
      bank_ifsc: map['bank_ifsc'] != null ? map['bank_ifsc'] as dynamic : null,
      beneficiary_name: map['beneficiary_name'] != null
          ? map['beneficiary_name'] as dynamic
          : null,
      gstin: map['gstin'] != null ? map['gstin'] as dynamic : null,
      fulfillment_type: map['fulfillment_type'] != null
          ? map['fulfillment_type'] as dynamic
          : null,
      description:
          map['description'] != null ? map['description'] as dynamic : null,
      email: map['email'] != null ? map['email'] as dynamic : null,
      address: map['address'] != null ? map['address'] as dynamic : null,
      display_image:
          map['display_image'] != null ? map['display_image'] as dynamic : null,
      images: map['images'] != null ? map['images'] as dynamic : null,
      itemCount: map['itemCount'] != null ? map['itemCount'] as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HyperLocalShopModel.fromJson(String source) =>
      HyperLocalShopModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      upi_id,
      bank_account_no,
      bank_ifsc,
      beneficiary_name,
      gstin,
      fulfillment_type,
      description,
      email,
      address,
      display_image,
      images,
      itemCount,
    ];
  }
}
