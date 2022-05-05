// To parse this JSON data, do
//
//     final merchantDetailsResponse = merchantDetailsResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MerchantDetailsResponse merchantDetailsResponseFromJson(String str) => MerchantDetailsResponse.fromJson(json.decode(str));

String merchantDetailsResponseToJson(MerchantDetailsResponse data) => json.encode(data.toJson());

class MerchantDetailsResponse {
  MerchantDetailsResponse({
    required this.name,
    required this.fields,
    required this.createTime,
    required this.updateTime,
  });

  String name;
  MerchantDetailsResponseFields fields;
  DateTime createTime;
  DateTime updateTime;

  factory MerchantDetailsResponse.fromJson(Map<String, dynamic> json) => MerchantDetailsResponse(
    name: json["name"],
    fields: MerchantDetailsResponseFields.fromJson(json["fields"]),
    createTime: DateTime.parse(json["createTime"]),
    updateTime: DateTime.parse(json["updateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "fields": fields.toJson(),
    "createTime": createTime.toIso8601String(),
    "updateTime": updateTime.toIso8601String(),
  };
}

class MerchantDetailsResponseFields {
  MerchantDetailsResponseFields({
    required this.delivery,
    required this.contact,
    required this.merchPlan,
    required this.merchLoginTime,
    required this.gstinNumber,
    required this.merchStatus,
    required this.merchId,
    required this.merchRatings,
    required this.merchReferal,
    required this.merchName,
    required this.catServed,
    required this.type,
  });

  Delivery delivery;
  Contact contact;
  GstinNumber merchPlan;
  MerchLoginTime merchLoginTime;
  GstinNumber gstinNumber;
  GstinNumber merchStatus;
  MerchId merchId;
  MerchId merchRatings;
  GstinNumber merchReferal;
  GstinNumber merchName;
  CatServed catServed;
  GstinNumber type;

  factory MerchantDetailsResponseFields.fromJson(Map<String, dynamic> json) => MerchantDetailsResponseFields(
    delivery: Delivery.fromJson(json["delivery"]),
    contact: Contact.fromJson(json["contact"]),
    merchPlan: GstinNumber.fromJson(json["merchPlan"]),
    merchLoginTime: MerchLoginTime.fromJson(json["merchLoginTime"]),
    gstinNumber: GstinNumber.fromJson(json["gstinNumber"]),
    merchStatus: GstinNumber.fromJson(json["merchStatus"]),
    merchId: MerchId.fromJson(json["merchId"]),
    merchRatings: MerchId.fromJson(json["merchRatings"]),
    merchReferal: GstinNumber.fromJson(json["merchReferal"]),
    merchName: GstinNumber.fromJson(json["merchName"]),
    catServed: CatServed.fromJson(json["catServed"]),
    type: GstinNumber.fromJson(json["type"]),
  );

  Map<String, dynamic> toJson() => {
    "delivery": delivery.toJson(),
    "contact": contact.toJson(),
    "merchPlan": merchPlan.toJson(),
    "merchLoginTime": merchLoginTime.toJson(),
    "gstinNumber": gstinNumber.toJson(),
    "merchStatus": merchStatus.toJson(),
    "merchId": merchId.toJson(),
    "merchRatings": merchRatings.toJson(),
    "merchReferal": merchReferal.toJson(),
    "merchName": merchName.toJson(),
    "catServed": catServed.toJson(),
    "type": type.toJson(),
  };
}

class CatServed {
  CatServed({
    required this.arrayValue,
  });

  ArrayValue arrayValue;

  factory CatServed.fromJson(Map<String, dynamic> json) => CatServed(
    arrayValue: ArrayValue.fromJson(json["arrayValue"]),
  );

  Map<String, dynamic> toJson() => {
    "arrayValue": arrayValue.toJson(),
  };
}

class ArrayValue {
  ArrayValue({
    required this.values,
  });

  List<Value> values;

  factory ArrayValue.fromJson(Map<String, dynamic> json) => ArrayValue(
    values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "values": List<dynamic>.from(values.map((x) => x.toJson())),
  };
}

class Value {
  Value({
    required this.mapValue,
  });

  ValueMapValue mapValue;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    mapValue: ValueMapValue.fromJson(json["mapValue"]),
  );

  Map<String, dynamic> toJson() => {
    "mapValue": mapValue.toJson(),
  };
}

class ValueMapValue {
  ValueMapValue({
    required this.fields,
  });

  PurpleFields fields;

  factory ValueMapValue.fromJson(Map<String, dynamic> json) => ValueMapValue(
    fields: PurpleFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class PurpleFields {
  PurpleFields({
    required this.catId,
  });

  CatId catId;

  factory PurpleFields.fromJson(Map<String, dynamic> json) => PurpleFields(
    catId: CatId.fromJson(json["catId"]),
  );

  Map<String, dynamic> toJson() => {
    "catId": catId.toJson(),
  };
}

class CatId {
  CatId({
    required this.referenceValue,
  });

  String referenceValue;

  factory CatId.fromJson(Map<String, dynamic> json) => CatId(
    referenceValue: json["referenceValue"],
  );

  Map<String, dynamic> toJson() => {
    "referenceValue": referenceValue,
  };
}

class Contact {
  Contact({
    required this.mapValue,
  });

  ContactMapValue mapValue;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    mapValue: ContactMapValue.fromJson(json["mapValue"]),
  );

  Map<String, dynamic> toJson() => {
    "mapValue": mapValue.toJson(),
  };
}

class ContactMapValue {
  ContactMapValue({
    required this.fields,
  });

  FluffyFields fields;

  factory ContactMapValue.fromJson(Map<String, dynamic> json) => ContactMapValue(
    fields: FluffyFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class FluffyFields {
  FluffyFields({
    required this.address,
    required this.pincode,
    required this.phoneNumber,
    required this.howtoReach,
    required this.emailId,
    required this.location,
  });

  GstinNumber address;
  MerchId pincode;
  MerchId phoneNumber;
  GstinNumber howtoReach;
  GstinNumber emailId;
  Location location;

  factory FluffyFields.fromJson(Map<String, dynamic> json) => FluffyFields(
    address: GstinNumber.fromJson(json["address"]),
    pincode: MerchId.fromJson(json["pincode"]),
    phoneNumber: MerchId.fromJson(json["phoneNumber"]),
    howtoReach: GstinNumber.fromJson(json["howtoReach"]),
    emailId: GstinNumber.fromJson(json["emailId"]),
    location: Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "address": address.toJson(),
    "pincode": pincode.toJson(),
    "phoneNumber": phoneNumber.toJson(),
    "howtoReach": howtoReach.toJson(),
    "emailId": emailId.toJson(),
    "location": location.toJson(),
  };
}

class GstinNumber {
  GstinNumber({
    required this.stringValue,
  });

  String stringValue;

  factory GstinNumber.fromJson(Map<String, dynamic> json) => GstinNumber(
    stringValue: json["stringValue"],
  );

  Map<String, dynamic> toJson() => {
    "stringValue": stringValue,
  };
}

class Location {
  Location({
    required this.mapValue,
  });

  LocationMapValue mapValue;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    mapValue: LocationMapValue.fromJson(json["mapValue"]),
  );

  Map<String, dynamic> toJson() => {
    "mapValue": mapValue.toJson(),
  };
}

class LocationMapValue {
  LocationMapValue({
    required this.fields,
  });

  TentacledFields fields;

  factory LocationMapValue.fromJson(Map<String, dynamic> json) => LocationMapValue(
    fields: TentacledFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class TentacledFields {
  TentacledFields({
    required this.lng,
    required this.lat,
  });

  Lat lng;
  Lat lat;

  factory TentacledFields.fromJson(Map<String, dynamic> json) => TentacledFields(
    lng: Lat.fromJson(json["lng"]),
    lat: Lat.fromJson(json["lat"]),
  );

  Map<String, dynamic> toJson() => {
    "lng": lng.toJson(),
    "lat": lat.toJson(),
  };
}

class Lat {
  Lat({
    required this.doubleValue,
  });

  double doubleValue;

  factory Lat.fromJson(Map<String, dynamic> json) => Lat(
    doubleValue: json["doubleValue"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "doubleValue": doubleValue,
  };
}

class MerchId {
  MerchId({
    required this.integerValue,
  });

  String integerValue;

  factory MerchId.fromJson(Map<String, dynamic> json) => MerchId(
    integerValue: json["integerValue"],
  );

  Map<String, dynamic> toJson() => {
    "integerValue": integerValue,
  };
}

class Delivery {
  Delivery({
    required this.booleanValue,
  });

  bool booleanValue;

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    booleanValue: json["booleanValue"],
  );

  Map<String, dynamic> toJson() => {
    "booleanValue": booleanValue,
  };
}

class MerchLoginTime {
  MerchLoginTime({
    required this.timestampValue,
  });

  DateTime timestampValue;

  factory MerchLoginTime.fromJson(Map<String, dynamic> json) => MerchLoginTime(
    timestampValue: DateTime.parse(json["timestampValue"]),
  );

  Map<String, dynamic> toJson() => {
    "timestampValue": timestampValue.toIso8601String(),
  };
}
