// To parse this JSON data, do
//
//     final merchantOfferResponse = merchantOfferResponseFromJson(jsonString);

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
    required this.custStatus,
    required this.custId,
    required this.custOfferResponse,
    required this.listId,
    required this.custDistance,
    required this.merchId,
    required this.contactEnabled,
    required this.requestForDay,
    required this.eventExpiryTime,
    required this.chatEnabled,
    required this.listEventId,
    required this.merchResponse,
    required this.items,
  });

  CustStatus custStatus;
  Id custId;
  CustOfferResponse custOfferResponse;
  Id listId;
  CustDistance custDistance;
  Id merchId;
  ChatEnabled contactEnabled;
  CustDistance requestForDay;
  Time eventExpiryTime;
  ChatEnabled chatEnabled;
  CustStatus listEventId;
  MerchResponse merchResponse;
  Items items;

  factory MerchantOfferResponseFields.fromJson(Map<String, dynamic> json) => MerchantOfferResponseFields(
    custStatus: CustStatus.fromJson(json["custStatus"]),
    custId: Id.fromJson(json["custId"]),
    custOfferResponse: CustOfferResponse.fromJson(json["custOfferResponse"]),
    listId: Id.fromJson(json["listId"]),
    custDistance: CustDistance.fromJson(json["custDistance"]),
    merchId: Id.fromJson(json["merchId"]),
    contactEnabled: ChatEnabled.fromJson(json["contactEnabled"]),
    requestForDay: CustDistance.fromJson(json["requestForDay"]),
    eventExpiryTime: Time.fromJson(json["eventExpiryTime"]),
    chatEnabled: ChatEnabled.fromJson(json["chatEnabled"]),
    listEventId: CustStatus.fromJson(json["listEventId"]),
    merchResponse: MerchResponse.fromJson(json["merchResponse"]),
    items: Items.fromJson(json["items"]),
  );

  Map<String, dynamic> toJson() => {
    "custStatus": custStatus.toJson(),
    "custId": custId.toJson(),
    "custOfferResponse": custOfferResponse.toJson(),
    "listId": listId.toJson(),
    "custDistance": custDistance.toJson(),
    "merchId": merchId.toJson(),
    "contactEnabled": contactEnabled.toJson(),
    "requestForDay": requestForDay.toJson(),
    "eventExpiryTime": eventExpiryTime.toJson(),
    "chatEnabled": chatEnabled.toJson(),
    "listEventId": listEventId.toJson(),
    "merchResponse": merchResponse.toJson(),
    "items": items.toJson(),
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
    required this.catName,
    required this.merchNotes,
    required this.brandType,
    required this.itemId,
    required this.itemSeqNum,
    required this.quantity,
    required this.merchAvailability,
    required this.itemImageId,
    required this.unit,
    required this.merchPrice,
    required this.itemName,
    required this.itemNotes,
  });

  CustStatus catName;
  CustStatus merchNotes;
  CustStatus brandType;
  Id itemId;
  CustDistance itemSeqNum;
  CustStatus quantity;
  ChatEnabled merchAvailability;
  CustStatus itemImageId;
  CustStatus unit;
  CustStatus merchPrice;
  CustStatus itemName;
  CustStatus itemNotes;

  factory FluffyFields.fromJson(Map<String, dynamic> json) => FluffyFields(
    catName: CustStatus.fromJson(json["catName"]),
    merchNotes: CustStatus.fromJson(json["merchNotes"]),
    brandType: CustStatus.fromJson(json["brandType"]),
    itemId: Id.fromJson(json["itemId"]),
    itemSeqNum: CustDistance.fromJson(json["itemSeqNum"]),
    quantity: CustStatus.fromJson(json["quantity"]),
    merchAvailability: ChatEnabled.fromJson(json["merchAvailability"]),
    itemImageId: CustStatus.fromJson(json["itemImageId"]),
    unit: CustStatus.fromJson(json["unit"]),
    merchPrice: CustStatus.fromJson(json["merchPrice"]),
    itemName: CustStatus.fromJson(json["itemName"]),
    itemNotes: CustStatus.fromJson(json["itemNotes"]),
  );

  Map<String, dynamic> toJson() => {
    "catName": catName.toJson(),
    "merchNotes": merchNotes.toJson(),
    "brandType": brandType.toJson(),
    "itemId": itemId.toJson(),
    "itemSeqNum": itemSeqNum.toJson(),
    "quantity": quantity.toJson(),
    "merchAvailability": merchAvailability.toJson(),
    "itemImageId": itemImageId.toJson(),
    "unit": unit.toJson(),
    "merchPrice": merchPrice.toJson(),
    "itemName": itemName.toJson(),
    "itemNotes": itemNotes.toJson(),
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
    required this.merchResponseStatus,
    required this.merchTotalPrice,
    required this.merchListStatus,
    required this.merchFulfillmentResponse,
    required this.merchOfferQuantity,
    required this.merchUpdateTime,
    required this.merchDelivery,
  });

  CustStatus merchResponseStatus;
  CustStatus merchTotalPrice;
  CustStatus merchListStatus;
  ChatEnabled merchFulfillmentResponse;
  CustDistance merchOfferQuantity;
  Time merchUpdateTime;
  ChatEnabled merchDelivery;

  factory TentacledFields.fromJson(Map<String, dynamic> json) => TentacledFields(
    merchResponseStatus: CustStatus.fromJson(json["merchResponseStatus"]),
    merchTotalPrice: CustStatus.fromJson(json["merchTotalPrice"]),
    merchListStatus: CustStatus.fromJson(json["merchListStatus"]),
    merchFulfillmentResponse: ChatEnabled.fromJson(json["merchFulfillmentResponse"]),
    merchOfferQuantity: CustDistance.fromJson(json["merchOfferQuantity"]),
    merchUpdateTime: Time.fromJson(json["merchUpdateTime"]),
    merchDelivery: ChatEnabled.fromJson(json["merchDelivery"]),
  );

  Map<String, dynamic> toJson() => {
    "merchResponseStatus": merchResponseStatus.toJson(),
    "merchTotalPrice": merchTotalPrice.toJson(),
    "merchListStatus": merchListStatus.toJson(),
    "merchFulfillmentResponse": merchFulfillmentResponse.toJson(),
    "merchOfferQuantity": merchOfferQuantity.toJson(),
    "merchUpdateTime": merchUpdateTime.toJson(),
    "merchDelivery": merchDelivery.toJson(),
  };
}
