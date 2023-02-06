// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  String name;
  String district;
  String region;
  String state;
  LocationModel({
    required this.name,
    required this.district,
    required this.region,
    required this.state,
  });

  LocationModel copyWith({
    String? name,
    String? district,
    String? region,
    String? state,
  }) {
    return LocationModel(
      name: name ?? this.name,
      district: district ?? this.district,
      region: region ?? this.region,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'district': district,
      'region': region,
      'state': state,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      name: map['Name'] as String,
      district: map['District'] as String,
      region: map['Region'] as String,
      state: map['State'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name, district, region, state];
}
