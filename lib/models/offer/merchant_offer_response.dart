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
    required this.items,
    required this.custOfferResponse,
    required this.custId,
    required this.merchId,
    required this.merchResponse,
    required this.custDistance,
    required this.custStatus,
    required this.eventExpiryTime,
    required this.contactEnabled,
    required this.listEventId,
    required this.chatEnabled,
    required this.listId,
  });

  Items items;
  CustOfferResponse custOfferResponse;
  Id custId;
  Id merchId;
  MerchResponse merchResponse;
  CustDistance custDistance;
  CustStatus custStatus;
  Time eventExpiryTime;
  ChatEnabled contactEnabled;
  CustStatus listEventId;
  ChatEnabled chatEnabled;
  Id listId;

  factory MerchantOfferResponseFields.fromJson(Map<String, dynamic> json) => MerchantOfferResponseFields(
    items: Items.fromJson(json["items"]),
    custOfferResponse: CustOfferResponse.fromJson(json["custOfferResponse"]),
    custId: Id.fromJson(json["custId"]),
    merchId: Id.fromJson(json["merchId"]),
    merchResponse: MerchResponse.fromJson(json["merchResponse"]),
    custDistance: CustDistance.fromJson(json["custDistance"]),
    custStatus: CustStatus.fromJson(json["custStatus"]),
    eventExpiryTime: Time.fromJson(json["eventExpiryTime"]),
    contactEnabled: ChatEnabled.fromJson(json["contactEnabled"]),
    listEventId: CustStatus.fromJson(json["listEventId"]),
    chatEnabled: ChatEnabled.fromJson(json["chatEnabled"]),
    listId: Id.fromJson(json["listId"]),
  );

  Map<String, dynamic> toJson() => {
    "items": items.toJson(),
    "custOfferResponse": custOfferResponse.toJson(),
    "custId": custId.toJson(),
    "merchId": merchId.toJson(),
    "merchResponse": merchResponse.toJson(),
    "custDistance": custDistance.toJson(),
    "custStatus": custStatus.toJson(),
    "eventExpiryTime": eventExpiryTime.toJson(),
    "contactEnabled": contactEnabled.toJson(),
    "listEventId": listEventId.toJson(),
    "chatEnabled": chatEnabled.toJson(),
    "listId": listId.toJson(),
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
    required this.custDeal,
    required this.custUpdateTime,
    required this.custOfferStatus,
  });

  CustStatus custDeal;
  Time custUpdateTime;
  CustStatus custOfferStatus;

  factory PurpleFields.fromJson(Map<String, dynamic> json) => PurpleFields(
    custDeal: CustStatus.fromJson(json["custDeal"]),
    custUpdateTime: Time.fromJson(json["custUpdateTime"]),
    custOfferStatus: CustStatus.fromJson(json["custOfferStatus"]),
  );

  Map<String, dynamic> toJson() => {
    "custDeal": custDeal.toJson(),
    "custUpdateTime": custUpdateTime.toJson(),
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
    required this.merchAvailability,
    required this.itemName,
    required this.itemId,
    required this.merchNotes,
    required this.brandType,
    required this.catName,
    required this.itemSeqNum,
    required this.itemNotes,
    required this.unit,
    required this.merchPrice,
    required this.itemImageId,
    required this.quantity,
  });

  ChatEnabled merchAvailability;
  CustStatus itemName;
  Id itemId;
  CustStatus merchNotes;
  CustStatus brandType;
  CustStatus catName;
  CustDistance itemSeqNum;
  CustStatus itemNotes;
  CustStatus unit;
  CustStatus merchPrice;
  CustStatus itemImageId;
  CustStatus quantity;

  factory FluffyFields.fromJson(Map<String, dynamic> json) => FluffyFields(
    merchAvailability: ChatEnabled.fromJson(json["merchAvailability"]),
    itemName: CustStatus.fromJson(json["itemName"]),
    itemId: Id.fromJson(json["itemId"]),
    merchNotes: CustStatus.fromJson(json["merchNotes"]),
    brandType: CustStatus.fromJson(json["brandType"]),
    catName: CustStatus.fromJson(json["catName"]),
    itemSeqNum: CustDistance.fromJson(json["itemSeqNum"]),
    itemNotes: CustStatus.fromJson(json["itemNotes"]),
    unit: CustStatus.fromJson(json["unit"]),
    merchPrice: CustStatus.fromJson(json["merchPrice"]),
    itemImageId: CustStatus.fromJson(json["itemImageId"]),
    quantity: CustStatus.fromJson(json["quantity"]),
  );

  Map<String, dynamic> toJson() => {
    "merchAvailability": merchAvailability.toJson(),
    "itemName": itemName.toJson(),
    "itemId": itemId.toJson(),
    "merchNotes": merchNotes.toJson(),
    "brandType": brandType.toJson(),
    "catName": catName.toJson(),
    "itemSeqNum": itemSeqNum.toJson(),
    "itemNotes": itemNotes.toJson(),
    "unit": unit.toJson(),
    "merchPrice": merchPrice.toJson(),
    "itemImageId": itemImageId.toJson(),
    "quantity": quantity.toJson(),
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
    required this.merchFulfillmentResponse,
    required this.merchTotalPrice,
    required this.merchDelivery,
    required this.merchListStatus,
    required this.merchOfferQuantity,
    required this.merchUpdateTime,
    required this.merchResponseStatus,
  });

  ChatEnabled merchFulfillmentResponse;
  CustStatus merchTotalPrice;
  ChatEnabled merchDelivery;
  CustStatus merchListStatus;
  CustDistance merchOfferQuantity;
  Time merchUpdateTime;
  CustStatus merchResponseStatus;

  factory TentacledFields.fromJson(Map<String, dynamic> json) => TentacledFields(
    merchFulfillmentResponse: ChatEnabled.fromJson(json["merchFulfillmentResponse"]),
    merchTotalPrice: CustStatus.fromJson(json["merchTotalPrice"]),
    merchDelivery: ChatEnabled.fromJson(json["merchDelivery"]),
    merchListStatus: CustStatus.fromJson(json["merchListStatus"]),
    merchOfferQuantity: CustDistance.fromJson(json["merchOfferQuantity"]),
    merchUpdateTime: Time.fromJson(json["merchUpdateTime"]),
    merchResponseStatus: CustStatus.fromJson(json["merchResponseStatus"]),
  );

  Map<String, dynamic> toJson() => {
    "merchFulfillmentResponse": merchFulfillmentResponse.toJson(),
    "merchTotalPrice": merchTotalPrice.toJson(),
    "merchDelivery": merchDelivery.toJson(),
    "merchListStatus": merchListStatus.toJson(),
    "merchOfferQuantity": merchOfferQuantity.toJson(),
    "merchUpdateTime": merchUpdateTime.toJson(),
    "merchResponseStatus": merchResponseStatus.toJson(),
  };
}
