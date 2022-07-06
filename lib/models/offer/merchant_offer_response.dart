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
    required this.custDistance,
    required this.listId,
    required this.eventExpiryTime,
    required this.requestForDay,
    required this.items,
    required this.merchResponse,
    required this.custStatus,
    required this.chatEnabled,
    required this.custId,
    required this.contactEnabled,
    required this.merchId,
    required this.custOfferResponse,
    required this.listEventId,
  });

  CustDistance custDistance;
  Id listId;
  Time eventExpiryTime;
  CustDistance requestForDay;
  Items items;
  MerchResponse merchResponse;
  CustStatus custStatus;
  ChatEnabled chatEnabled;
  Id custId;
  ChatEnabled contactEnabled;
  Id merchId;
  CustOfferResponse custOfferResponse;
  CustStatus listEventId;

  factory MerchantOfferResponseFields.fromJson(Map<String, dynamic> json) => MerchantOfferResponseFields(
    custDistance: CustDistance.fromJson(json["custDistance"]),
    listId: Id.fromJson(json["listId"]),
    eventExpiryTime: Time.fromJson(json["eventExpiryTime"]),
    requestForDay: CustDistance.fromJson(json["requestForDay"]),
    items: Items.fromJson(json["items"]),
    merchResponse: MerchResponse.fromJson(json["merchResponse"]),
    custStatus: CustStatus.fromJson(json["custStatus"]),
    chatEnabled: ChatEnabled.fromJson(json["chatEnabled"]),
    custId: Id.fromJson(json["custId"]),
    contactEnabled: ChatEnabled.fromJson(json["contactEnabled"]),
    merchId: Id.fromJson(json["merchId"]),
    custOfferResponse: CustOfferResponse.fromJson(json["custOfferResponse"]),
    listEventId: CustStatus.fromJson(json["listEventId"]),
  );

  Map<String, dynamic> toJson() => {
    "custDistance": custDistance.toJson(),
    "listId": listId.toJson(),
    "eventExpiryTime": eventExpiryTime.toJson(),
    "requestForDay": requestForDay.toJson(),
    "items": items.toJson(),
    "merchResponse": merchResponse.toJson(),
    "custStatus": custStatus.toJson(),
    "chatEnabled": chatEnabled.toJson(),
    "custId": custId.toJson(),
    "contactEnabled": contactEnabled.toJson(),
    "merchId": merchId.toJson(),
    "custOfferResponse": custOfferResponse.toJson(),
    "listEventId": listEventId.toJson(),
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
    required this.itemImageId,
    required this.itemSeqNum,
    required this.unit,
    required this.merchPrice,
    required this.itemNotes,
    required this.catName,
    required this.merchAvailability,
    required this.quantity,
    required this.merchNotes,
    required this.brandType,
    required this.itemName,
    required this.itemId,
  });

  CustStatus itemImageId;
  CustDistance itemSeqNum;
  CustStatus unit;
  CustStatus merchPrice;
  CustStatus itemNotes;
  CustStatus catName;
  ChatEnabled merchAvailability;
  CustDistance quantity;
  CustStatus merchNotes;
  CustStatus brandType;
  CustStatus itemName;
  Id itemId;

  factory FluffyFields.fromJson(Map<String, dynamic> json) => FluffyFields(
    itemImageId: CustStatus.fromJson(json["itemImageId"]),
    itemSeqNum: CustDistance.fromJson(json["itemSeqNum"]),
    unit: CustStatus.fromJson(json["unit"]),
    merchPrice: CustStatus.fromJson(json["merchPrice"]),
    itemNotes: CustStatus.fromJson(json["itemNotes"]),
    catName: CustStatus.fromJson(json["catName"]),
    merchAvailability: ChatEnabled.fromJson(json["merchAvailability"]),
    quantity: CustDistance.fromJson(json["quantity"]),
    merchNotes: CustStatus.fromJson(json["merchNotes"]),
    brandType: CustStatus.fromJson(json["brandType"]),
    itemName: CustStatus.fromJson(json["itemName"]),
    itemId: Id.fromJson(json["itemId"]),
  );

  Map<String, dynamic> toJson() => {
    "itemImageId": itemImageId.toJson(),
    "itemSeqNum": itemSeqNum.toJson(),
    "unit": unit.toJson(),
    "merchPrice": merchPrice.toJson(),
    "itemNotes": itemNotes.toJson(),
    "catName": catName.toJson(),
    "merchAvailability": merchAvailability.toJson(),
    "quantity": quantity.toJson(),
    "merchNotes": merchNotes.toJson(),
    "brandType": brandType.toJson(),
    "itemName": itemName.toJson(),
    "itemId": itemId.toJson(),
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
    required this.merchTotalPrice,
    required this.merchListStatus,
    required this.merchUpdateTime,
    required this.merchDelivery,
    required this.merchFulfillmentResponse,
    required this.merchOfferQuantity,
    required this.merchResponseStatus,
  });

  CustStatus merchTotalPrice;
  CustStatus merchListStatus;
  Time merchUpdateTime;
  ChatEnabled merchDelivery;
  ChatEnabled merchFulfillmentResponse;
  CustDistance merchOfferQuantity;
  CustStatus merchResponseStatus;

  factory TentacledFields.fromJson(Map<String, dynamic> json) => TentacledFields(
    merchTotalPrice: CustStatus.fromJson(json["merchTotalPrice"]),
    merchListStatus: CustStatus.fromJson(json["merchListStatus"]),
    merchUpdateTime: Time.fromJson(json["merchUpdateTime"]),
    merchDelivery: ChatEnabled.fromJson(json["merchDelivery"]),
    merchFulfillmentResponse: ChatEnabled.fromJson(json["merchFulfillmentResponse"]),
    merchOfferQuantity: CustDistance.fromJson(json["merchOfferQuantity"]),
    merchResponseStatus: CustStatus.fromJson(json["merchResponseStatus"]),
  );

  Map<String, dynamic> toJson() => {
    "merchTotalPrice": merchTotalPrice.toJson(),
    "merchListStatus": merchListStatus.toJson(),
    "merchUpdateTime": merchUpdateTime.toJson(),
    "merchDelivery": merchDelivery.toJson(),
    "merchFulfillmentResponse": merchFulfillmentResponse.toJson(),
    "merchOfferQuantity": merchOfferQuantity.toJson(),
    "merchResponseStatus": merchResponseStatus.toJson(),
  };
}
