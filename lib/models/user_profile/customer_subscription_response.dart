// To parse this JSON data, do
//
//     final customerSubscriptionResponse = customerSubscriptionResponseFromJson(jsonString);

import 'dart:convert';

CustomerSubscriptionResponse customerSubscriptionResponseFromJson(String str) => CustomerSubscriptionResponse.fromJson(json.decode(str));

String customerSubscriptionResponseToJson(CustomerSubscriptionResponse data) => json.encode(data.toJson());

class CustomerSubscriptionResponse {
  CustomerSubscriptionResponse({
    required this.fields,
  });

  CustomerSubscriptionResponseFields fields;

  factory CustomerSubscriptionResponse.fromJson(Map<String, dynamic> json) => CustomerSubscriptionResponse(
    fields: CustomerSubscriptionResponseFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class CustomerSubscriptionResponseFields {
  CustomerSubscriptionResponseFields({
    required this.subscription,
  });

  Subscription subscription;

  factory CustomerSubscriptionResponseFields.fromJson(Map<String, dynamic> json) => CustomerSubscriptionResponseFields(
    subscription: Subscription.fromJson(json["subscription"]),
  );

  Map<String, dynamic> toJson() => {
    "subscription": subscription.toJson(),
  };
}

class Subscription {
  Subscription({
    required this.mapValue,
  });

  SubscriptionMapValue mapValue;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    mapValue: SubscriptionMapValue.fromJson(json["mapValue"]),
  );

  Map<String, dynamic> toJson() => {
    "mapValue": mapValue.toJson(),
  };
}

class SubscriptionMapValue {
  SubscriptionMapValue({
    required this.fields,
  });

  PurpleFields fields;

  factory SubscriptionMapValue.fromJson(Map<String, dynamic> json) => SubscriptionMapValue(
    fields: PurpleFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class PurpleFields {
  PurpleFields({
    required this.custSubscription,
    required this.merchSubscription,
  });

  CustSubscriptionClass custSubscription;
  CustSubscriptionClass merchSubscription;

  factory PurpleFields.fromJson(Map<String, dynamic> json) => PurpleFields(
    custSubscription: CustSubscriptionClass.fromJson(json["custSubscription"]),
    merchSubscription: CustSubscriptionClass.fromJson(json["merchSubscription"]),
  );

  Map<String, dynamic> toJson() => {
    "custSubscription": custSubscription.toJson(),
    "merchSubscription": merchSubscription.toJson(),
  };
}

class CustSubscriptionClass {
  CustSubscriptionClass({
    required this.mapValue,
  });

  CustSubscriptionMapValue mapValue;

  factory CustSubscriptionClass.fromJson(Map<String, dynamic> json) => CustSubscriptionClass(
    mapValue: CustSubscriptionMapValue.fromJson(json["mapValue"]),
  );

  Map<String, dynamic> toJson() => {
    "mapValue": mapValue.toJson(),
  };
}

class CustSubscriptionMapValue {
  CustSubscriptionMapValue({
    required this.fields,
  });

  FluffyFields fields;

  factory CustSubscriptionMapValue.fromJson(Map<String, dynamic> json) => CustSubscriptionMapValue(
    fields: FluffyFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class FluffyFields {
  FluffyFields({
    required this.planB,
    required this.planA,
    required this.fieldsDefault,
  });

  Default planB;
  Default planA;
  Default fieldsDefault;

  factory FluffyFields.fromJson(Map<String, dynamic> json) => FluffyFields(
    planB: Default.fromJson(json["planB"]),
    planA: Default.fromJson(json["planA"]),
    fieldsDefault: Default.fromJson(json["default"]),
  );

  Map<String, dynamic> toJson() => {
    "planB": planB.toJson(),
    "planA": planA.toJson(),
    "default": fieldsDefault.toJson(),
  };
}

class Default {
  Default({
    required this.integerValue,
  });

  String integerValue;

  factory Default.fromJson(Map<String, dynamic> json) => Default(
    integerValue: json["integerValue"],
  );

  Map<String, dynamic> toJson() => {
    "integerValue": integerValue,
  };
}
