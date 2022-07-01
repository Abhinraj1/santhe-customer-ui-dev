// To parse this JSON data, do
//
//     final customerResponseModel = customerResponseModelFromJson(jsonString);

import 'dart:convert';

CustomerResponseModel customerResponseModelFromJson(String str) => CustomerResponseModel.fromJson(json.decode(str));

String customerResponseModelToJson(CustomerResponseModel data) => json.encode(data.toJson());

class CustomerResponseModel {
  CustomerResponseModel({
    required this.name,
    required this.fields,
    required this.createTime,
    required this.updateTime,
  });

  String name;
  CustomerResponseModelFields fields;
  DateTime createTime;
  DateTime updateTime;

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) => CustomerResponseModel(
    name: json["name"],
    fields: CustomerResponseModelFields.fromJson(json["fields"]),
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

class CustomerResponseModelFields {
  CustomerResponseModelFields({
    required this.custName,
    required this.custReferal,
    required this.custId,
    required this.custPlan,
    required this.custLoginTime,
    required this.custRatings,
    required this.custStatus,
    required this.contact,
  });

  CustName custName;
  CustId custReferal;
  CustId custId;
  CustName custPlan;
  CustLoginTime custLoginTime;
  CustRatings custRatings;
  CustName custStatus;
  Contact contact;

  factory CustomerResponseModelFields.fromJson(Map<String, dynamic> json) => CustomerResponseModelFields(
    custName: CustName.fromJson(json["custName"]),
    custReferal: CustId.fromJson(json["custReferal"]),
    custId: CustId.fromJson(json["custId"]),
    custPlan: CustName.fromJson(json["custPlan"]),
    custLoginTime: CustLoginTime.fromJson(json["custLoginTime"]),
    custRatings: CustRatings.fromJson(json["custRatings"]),
    custStatus: CustName.fromJson(json["custStatus"]),
    contact: Contact.fromJson(json["contact"]),
  );

  Map<String, dynamic> toJson() => {
    "custName": custName.toJson(),
    "custReferal": custReferal.toJson(),
    "custId": custId.toJson(),
    "custPlan": custPlan.toJson(),
    "custLoginTime": custLoginTime.toJson(),
    "custRatings": custRatings.toJson(),
    "custStatus": custStatus.toJson(),
    "contact": contact.toJson(),
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

  PurpleFields fields;

  factory ContactMapValue.fromJson(Map<String, dynamic> json) => ContactMapValue(
    fields: PurpleFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class PurpleFields {
  PurpleFields({
    required this.emailId,
    required this.address,
    required this.phoneNumber,
    required this.pincode,
    required this.howToReach,
    required this.location,
  });

  CustName emailId;
  CustName address;
  CustId phoneNumber;
  CustId pincode;
  CustName howToReach;
  Location location;

  factory PurpleFields.fromJson(Map<String, dynamic> json) => PurpleFields(
    emailId: CustName.fromJson(json["emailId"]),
    address: CustName.fromJson(json["address"]),
    phoneNumber: CustId.fromJson(json["phoneNumber"]),
    pincode: CustId.fromJson(json["pincode"]),
    howToReach: CustName.fromJson(json["howToReach"]),
    location: Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "emailId": emailId.toJson(),
    "address": address.toJson(),
    "phoneNumber": phoneNumber.toJson(),
    "pincode": pincode.toJson(),
    "howToReach": howToReach.toJson(),
    "location": location.toJson(),
  };
}

class CustName {
  CustName({
    required this.stringValue,
  });

  String stringValue;

  factory CustName.fromJson(Map<String, dynamic> json) => CustName(
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

  FluffyFields fields;

  factory LocationMapValue.fromJson(Map<String, dynamic> json) => LocationMapValue(
    fields: FluffyFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class FluffyFields {
  FluffyFields({
    required this.lat,
    required this.lng,
  });

  CustRatings lat;
  CustRatings lng;

  factory FluffyFields.fromJson(Map<String, dynamic> json) => FluffyFields(
    lat: CustRatings.fromJson(json["lat"]),
    lng: CustRatings.fromJson(json["lng"]),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat.toJson(),
    "lng": lng.toJson(),
  };
}

class CustRatings {
  CustRatings({
    required this.doubleValue,
  });

  double doubleValue;

  factory CustRatings.fromJson(Map<String, dynamic> json) => CustRatings(
    doubleValue: json["doubleValue"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "doubleValue": doubleValue,
  };
}

class CustId {
  CustId({
    required this.integerValue,
  });

  String integerValue;

  factory CustId.fromJson(Map<String, dynamic> json) => CustId(
    integerValue: json["integerValue"],
  );

  Map<String, dynamic> toJson() => {
    "integerValue": integerValue,
  };
}

class CustLoginTime {
  CustLoginTime({
    required this.timestampValue,
  });

  DateTime timestampValue;

  factory CustLoginTime.fromJson(Map<String, dynamic> json) => CustLoginTime(
    timestampValue: DateTime.parse(json["timestampValue"]),
  );

  Map<String, dynamic> toJson() => {
    "timestampValue": timestampValue.toIso8601String(),
  };
}
