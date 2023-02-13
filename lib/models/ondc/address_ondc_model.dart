// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';

class AddressOndcModel extends Equatable {
  final dynamic id;
  final dynamic address_name;
  final dynamic lat;
  final dynamic lng;
  final dynamic locality;
  final dynamic flat;
  final dynamic city;
  final dynamic state;
  final dynamic country;
  final dynamic pincode;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final dynamic customerId;
  const AddressOndcModel({
    required this.id,
    required this.address_name,
    required this.lat,
    required this.lng,
    required this.locality,
    required this.flat,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.customerId,
  });

  AddressOndcModel copyWith({
    dynamic? id,
    dynamic? address_name,
    dynamic? lat,
    dynamic? lng,
    dynamic? locality,
    dynamic? flat,
    dynamic? city,
    dynamic? state,
    dynamic? country,
    dynamic? pincode,
    dynamic? createdAt,
    dynamic? updatedAt,
    dynamic? deletedAt,
    dynamic? customerId,
  }) {
    return AddressOndcModel(
      id: id ?? this.id,
      address_name: address_name ?? this.address_name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      locality: locality ?? this.locality,
      flat: flat ?? this.flat,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      customerId: customerId ?? this.customerId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'address_name': address_name,
      'lat': lat,
      'lng': lng,
      'locality': locality,
      'flat': flat,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'customerId': customerId,
    };
  }

  factory AddressOndcModel.fromMap(Map<String, dynamic> map) {
    return AddressOndcModel(
      id: map['id'] != null ? map['id'] as dynamic : null,
      address_name:
          map['address_name'] != null ? map['address_name'] as dynamic : null,
      lat: map['lat'] != null ? map['lat'] as dynamic : null,
      lng: map['lng'] != null ? map['lng'] as dynamic : null,
      locality: map['locality'] != null ? map['locality'] as dynamic : null,
      flat: map['flat'] != null ? map['flat'] as dynamic : null,
      city: map['city'] != null ? map['city'] as dynamic : null,
      state: map['state'] != null ? map['state'] as dynamic : null,
      country: map['country'] != null ? map['country'] as dynamic : null,
      pincode: map['pincode'] != null ? map['pincode'] as dynamic : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as dynamic : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as dynamic : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as dynamic : null,
      customerId:
          map['customerId'] != null ? map['customerId'] as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressOndcModel.fromJson(String source) =>
      AddressOndcModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      address_name,
      lat,
      lng,
      locality,
      flat,
      city,
      state,
      country,
      pincode,
      createdAt,
      updatedAt,
      deletedAt,
      customerId,
    ];
  }
}
