// To parse this JSON data, do
//
//     final merchantOfferResponse = merchantOfferResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MerchantOfferResponse merchantOfferResponseFromJson(String str) => MerchantOfferResponse.fromJson(json.decode(str));

String merchantOfferResponseToJson(MerchantOfferResponse data) => json.encode(data.toJson());

class MerchantOfferResponse {
  MerchantOfferResponse({
    required this.name,
    required this.fields,
    required this.createTime,
    required this.updateTime,
  });

  String name;
  MerchantOfferResponseFields fields;
  DateTime createTime;
  DateTime updateTime;

  factory MerchantOfferResponse.fromJson(Map<String, dynamic> json) => MerchantOfferResponse(
    name: json["name"],
    fields: MerchantOfferResponseFields.fromJson(json["fields"]),
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

class MerchantOfferResponseFields {
  MerchantOfferResponseFields({
    required this.custId,
    required this.merchResponse,
    required this.listId,
    required this.listEventId,
    required this.chatEnabled,
    required this.custStatus,
    required this.custDistance,
    required this.merchId,
    required this.items,
    required this.custOfferResponse,
    required this.eventExpiryTime,
    required this.contactEnabled,
  });

  Id custId;
  MerchResponse merchResponse;
  Id listId;
  CustStatus listEventId;
  ChatEnabled chatEnabled;
  CustStatus custStatus;
  CustDistance custDistance;
  Id merchId;
  Items items;
  CustOfferResponse custOfferResponse;
  Time eventExpiryTime;
  ChatEnabled contactEnabled;

  factory MerchantOfferResponseFields.fromJson(Map<String, dynamic> json) => MerchantOfferResponseFields(
    custId: Id.fromJson(json["custId"]),
    merchResponse: MerchResponse.fromJson(json["merchResponse"]),
    listId: Id.fromJson(json["listId"]),
    listEventId: CustStatus.fromJson(json["listEventId"]),
    chatEnabled: ChatEnabled.fromJson(json["chatEnabled"]),
    custStatus: CustStatus.fromJson(json["custStatus"]),
    custDistance: CustDistance.fromJson(json["custDistance"]),
    merchId: Id.fromJson(json["merchId"]),
    items: Items.fromJson(json["items"]),
    custOfferResponse: CustOfferResponse.fromJson(json["custOfferResponse"]),
    eventExpiryTime: Time.fromJson(json["eventExpiryTime"]),
    contactEnabled: ChatEnabled.fromJson(json["contactEnabled"]),
  );

  Map<String, dynamic> toJson() => {
    "custId": custId.toJson(),
    "merchResponse": merchResponse.toJson(),
    "listId": listId.toJson(),
    "listEventId": listEventId.toJson(),
    "chatEnabled": chatEnabled.toJson(),
    "custStatus": custStatus.toJson(),
    "custDistance": custDistance.toJson(),
    "merchId": merchId.toJson(),
    "items": items.toJson(),
    "custOfferResponse": custOfferResponse.toJson(),
    "eventExpiryTime": eventExpiryTime.toJson(),
    "contactEnabled": contactEnabled.toJson(),
  };
}

class ChatEnabled {
  ChatEnabled({
    required this.booleanValue,
  });

  bool booleanValue;

  factory ChatEnabled.fromJson(Map<String, dynamic> json) => ChatEnabled(
    booleanValue: json["booleanValue"],
  );

  Map<String, dynamic> toJson() => {
    "booleanValue": booleanValue,
  };
}

class CustDistance {
  CustDistance({
    required this.integerValue,
  });

  String integerValue;

  factory CustDistance.fromJson(Map<String, dynamic> json) => CustDistance(
    integerValue: json["integerValue"],
  );

  Map<String, dynamic> toJson() => {
    "integerValue": integerValue,
  };
}

class Id {
  Id({
    required this.referenceValue,
  });

  String referenceValue;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    referenceValue: json["referenceValue"],
  );

  Map<String, dynamic> toJson() => {
    "referenceValue": referenceValue,
  };
}

class CustOfferResponse {
  CustOfferResponse({
    required this.mapValue,
  });

  CustOfferResponseMapValue mapValue;

  factory CustOfferResponse.fromJson(Map<String, dynamic> json) => CustOfferResponse(
    mapValue: CustOfferResponseMapValue.fromJson(json["mapValue"]),
  );

  Map<String, dynamic> toJson() => {
    "mapValue": mapValue.toJson(),
  };
}

class CustOfferResponseMapValue {
  CustOfferResponseMapValue({
    required this.fields,
  });

  PurpleFields fields;

  factory CustOfferResponseMapValue.fromJson(Map<String, dynamic> json) => CustOfferResponseMapValue(
    fields: PurpleFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class PurpleFields {
  PurpleFields({
    required this.custUpdateTime,
    required this.custDeal,
    required this.custOfferStatus,
  });

  Time custUpdateTime;
  CustStatus custDeal;
  CustStatus custOfferStatus;

  factory PurpleFields.fromJson(Map<String, dynamic> json) => PurpleFields(
    custUpdateTime: Time.fromJson(json["custUpdateTime"]),
    custDeal: CustStatus.fromJson(json["custDeal"]),
    custOfferStatus: CustStatus.fromJson(json["custOfferStatus"]),
  );

  Map<String, dynamic> toJson() => {
    "custUpdateTime": custUpdateTime.toJson(),
    "custDeal": custDeal.toJson(),
    "custOfferStatus": custOfferStatus.toJson(),
  };
}

class CustStatus {
  CustStatus({
    required this.stringValue,
  });

  String stringValue;

  factory CustStatus.fromJson(Map<String, dynamic> json) => CustStatus(
    stringValue: json["stringValue"],
  );

  Map<String, dynamic> toJson() => {
    "stringValue": stringValue,
  };
}

class Time {
  Time({
    required this.timestampValue,
  });

  DateTime timestampValue;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    timestampValue: DateTime.parse(json["timestampValue"]),
  );

  Map<String, dynamic> toJson() => {
    "timestampValue": timestampValue.toIso8601String(),
  };
}

class Items {
  Items({
    required this.arrayValue,
  });

  ArrayValue arrayValue;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
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

  FluffyFields fields;

  factory ValueMapValue.fromJson(Map<String, dynamic> json) => ValueMapValue(
    fields: FluffyFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class FluffyFields {
  FluffyFields({
    required this.merchNotes,
    required this.catName,
    required this.unit,
    required this.itemImageId,
    required this.merchPrice,
    required this.quantity,
    required this.merchAvailability,
    required this.itemSeqNum,
    required this.itemId,
    required this.itemName,
    required this.itemNotes,
    required this.brandType,
  });

  CustStatus merchNotes;
  CustStatus catName;
  CustStatus unit;
  CustStatus itemImageId;
  CustStatus merchPrice;
  CustStatus quantity;
  ChatEnabled merchAvailability;
  CustDistance itemSeqNum;
  Id itemId;
  CustStatus itemName;
  CustStatus itemNotes;
  CustStatus brandType;

  factory FluffyFields.fromJson(Map<String, dynamic> json) => FluffyFields(
    merchNotes: CustStatus.fromJson(json["merchNotes"]),
    catName: CustStatus.fromJson(json["catName"]),
    unit: CustStatus.fromJson(json["unit"]),
    itemImageId: CustStatus.fromJson(json["itemImageId"]),
    merchPrice: CustStatus.fromJson(json["merchPrice"]),
    quantity: CustStatus.fromJson(json["quantity"]),
    merchAvailability: ChatEnabled.fromJson(json["merchAvailability"]),
    itemSeqNum: CustDistance.fromJson(json["itemSeqNum"]),
    itemId: Id.fromJson(json["itemId"]),
    itemName: CustStatus.fromJson(json["itemName"]),
    itemNotes: CustStatus.fromJson(json["itemNotes"]),
    brandType: CustStatus.fromJson(json["brandType"]),
  );

  Map<String, dynamic> toJson() => {
    "merchNotes": merchNotes.toJson(),
    "catName": catName.toJson(),
    "unit": unit.toJson(),
    "itemImageId": itemImageId.toJson(),
    "merchPrice": merchPrice.toJson(),
    "quantity": quantity.toJson(),
    "merchAvailability": merchAvailability.toJson(),
    "itemSeqNum": itemSeqNum.toJson(),
    "itemId": itemId.toJson(),
    "itemName": itemName.toJson(),
    "itemNotes": itemNotes.toJson(),
    "brandType": brandType.toJson(),
  };
}

class MerchResponse {
  MerchResponse({
    required this.mapValue,
  });

  MerchResponseMapValue mapValue;

  factory MerchResponse.fromJson(Map<String, dynamic> json) => MerchResponse(
    mapValue: MerchResponseMapValue.fromJson(json["mapValue"]),
  );

  Map<String, dynamic> toJson() => {
    "mapValue": mapValue.toJson(),
  };
}

class MerchResponseMapValue {
  MerchResponseMapValue({
    required this.fields,
  });

  TentacledFields fields;

  factory MerchResponseMapValue.fromJson(Map<String, dynamic> json) => MerchResponseMapValue(
    fields: TentacledFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class TentacledFields {
  TentacledFields({
    required this.merchOfferQuantity,
    required this.merchTotalPrice,
    required this.merchFulfillmentResponse,
    required this.merchDelivery,
    required this.merchUpdateTime,
    required this.merchResponseStatus,
    required this.merchListStatus,
  });

  CustDistance merchOfferQuantity;
  CustStatus merchTotalPrice;
  ChatEnabled merchFulfillmentResponse;
  ChatEnabled merchDelivery;
  Time merchUpdateTime;
  CustStatus merchResponseStatus;
  CustStatus merchListStatus;

  factory TentacledFields.fromJson(Map<String, dynamic> json) => TentacledFields(
    merchOfferQuantity: CustDistance.fromJson(json["merchOfferQuantity"]),
    merchTotalPrice: CustStatus.fromJson(json["merchTotalPrice"]),
    merchFulfillmentResponse: ChatEnabled.fromJson(json["merchFulfillmentResponse"]),
    merchDelivery: ChatEnabled.fromJson(json["merchDelivery"]),
    merchUpdateTime: Time.fromJson(json["merchUpdateTime"]),
    merchResponseStatus: CustStatus.fromJson(json["merchResponseStatus"]),
    merchListStatus: CustStatus.fromJson(json["merchListStatus"]),
  );

  Map<String, dynamic> toJson() => {
    "merchOfferQuantity": merchOfferQuantity.toJson(),
    "merchTotalPrice": merchTotalPrice.toJson(),
    "merchFulfillmentResponse": merchFulfillmentResponse.toJson(),
    "merchDelivery": merchDelivery.toJson(),
    "merchUpdateTime": merchUpdateTime.toJson(),
    "merchResponseStatus": merchResponseStatus.toJson(),
    "merchListStatus": merchListStatus.toJson(),
  };
}
