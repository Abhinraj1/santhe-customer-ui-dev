// To parse this JSON data, do
//
//     final newListResponseModel = newListResponseModelFromJson(jsonString);

import 'dart:convert';

List<NewListResponseModel> newListResponseModelFromJson(String str) => List<NewListResponseModel>.from(json.decode(str).map((x) => NewListResponseModel.fromJson(x)));

class NewListResponseModel {
  NewListResponseModel({
    required this.document,
    required this.readTime,
  });

  Document document;
  DateTime readTime;

  factory NewListResponseModel.fromJson(Map<String, dynamic> json) => NewListResponseModel(
    document: Document.fromJson(json["document"]),
    readTime: DateTime.parse(json["readTime"]),
  );
}

class Document {
  Document({
    required this.name,
    required this.fields,
    required this.createTime,
    required this.updateTime,
  });

  String name;
  DocumentFields fields;
  DateTime createTime;
  DateTime updateTime;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    name: json["name"],
    fields: DocumentFields.fromJson(json["fields"]),
    createTime: DateTime.parse(json["createTime"]),
    updateTime: DateTime.parse(json["updateTime"]),
  );
}

class DocumentFields {
  DocumentFields({
    required this.custListSentTime,
    required this.listId,
    required this.items,
    required this.custListStatus,
    required this.processStatus,
    required this.updateListTime,
    required this.listOfferCounter,
    required this.listName,
    required this.custId,
    required this.custOfferWaitTime,
    required this.dealProcess,
    required this.notificationProcess,
    required this.createListTime,
    required this.listUpdateTime,
  });

  Time custListSentTime;
  ListId listId;
  Items items;
  CustListStatus custListStatus;
  CustListStatus processStatus;
  Time updateListTime;
  ListId listOfferCounter;
  CustListStatus listName;
  Id custId;
  Time custOfferWaitTime;
  DealProcess dealProcess;
  CustListStatus notificationProcess;
  Time createListTime;
  Time? listUpdateTime;

  factory DocumentFields.fromJson(Map<String, dynamic> json) => DocumentFields(
    custListSentTime: Time.fromJson(json["custListSentTime"]),
    listId: ListId.fromJson(json["listId"]),
    items: Items.fromJson(json["items"]),
    custListStatus: CustListStatus.fromJson(json["custListStatus"]),
    processStatus: CustListStatus.fromJson(json["processStatus"]),
    updateListTime: Time.fromJson(json["updateListTime"]),
    listOfferCounter: ListId.fromJson(json["listOfferCounter"]),
    listName: CustListStatus.fromJson(json["listName"]),
    custId: Id.fromJson(json["custId"]),
    custOfferWaitTime: Time.fromJson(json["custOfferWaitTime"]),
    dealProcess: DealProcess.fromJson(json["dealProcess"]),
    notificationProcess: CustListStatus.fromJson(json["notificationProcess"]),
    createListTime: Time.fromJson(json["createListTime"]),
    listUpdateTime: json["listUpdateTime"] == null ? null : Time.fromJson(json["listUpdateTime"]),
  );
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

class CustListStatus {
  CustListStatus({
    required this.stringValue,
  });

  String stringValue;

  factory CustListStatus.fromJson(Map<String, dynamic> json) => CustListStatus(
    stringValue: json["stringValue"],
  );

  Map<String, dynamic> toJson() => {
    "stringValue": stringValue,
  };
}

class DealProcess {
  DealProcess({
    required this.booleanValue,
  });

  bool booleanValue;

  factory DealProcess.fromJson(Map<String, dynamic> json) => DealProcess(
    booleanValue: json["booleanValue"],
  );

  Map<String, dynamic> toJson() => {
    "booleanValue": booleanValue,
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
}

class ArrayValue {
  ArrayValue({
    required this.values,
  });

  List<Value>? values;

  factory ArrayValue.fromJson(Map<String, dynamic> json) => ArrayValue(
    values: json["values"] == null ? null : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
  );
}

class Value {
  Value({
    required this.mapValue,
  });

  MapValue mapValue;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    mapValue: MapValue.fromJson(json["mapValue"]),
  );

  Map<String, dynamic> toJson() => {
    "mapValue": mapValue.toJson(),
  };
}

class MapValue {
  MapValue({
    required this.fields,
  });

  MapValueFields fields;

  factory MapValue.fromJson(Map<String, dynamic> json) => MapValue(
    fields: MapValueFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class MapValueFields {
  MapValueFields({
    required this.quantity,
    required this.itemImageId,
    required this.itemId,
    required this.unit,
    required this.brandType,
    required this.catId,
    required this.notes,
    required this.itemSeqNum,
    required this.catName,
    required this.itemName,
  });

  Quantity quantity;
  CustListStatus itemImageId;
  Id itemId;
  CustListStatus unit;
  CustListStatus brandType;
  Id catId;
  CustListStatus notes;
  ListId itemSeqNum;
  CustListStatus catName;
  CustListStatus itemName;

  factory MapValueFields.fromJson(Map<String, dynamic> json) => MapValueFields(
    quantity: Quantity.fromJson(json["quantity"]),
    itemImageId: CustListStatus.fromJson(json["itemImageId"]),
    itemId: Id.fromJson(json["itemId"]),
    unit: CustListStatus.fromJson(json["unit"]),
    brandType: CustListStatus.fromJson(json["brandType"]),
    catId: Id.fromJson(json["catId"]),
    notes: CustListStatus.fromJson(json["notes"]),
    itemSeqNum: ListId.fromJson(json["itemSeqNum"]),
    catName: CustListStatus.fromJson(json["catName"]),
    itemName: CustListStatus.fromJson(json["itemName"]),
  );

  Map<String, dynamic> toJson() => {
    "quantity": quantity.toJson(),
    "itemImageId": itemImageId.toJson(),
    "itemId": itemId.toJson(),
    "unit": unit.toJson(),
    "brandType": brandType.toJson(),
    "catId": catId.toJson(),
    "notes": notes.toJson(),
    "itemSeqNum": itemSeqNum.toJson(),
    "catName": catName.toJson(),
    "itemName": itemName.toJson(),
  };
}

class ListId {
  ListId({
    required this.integerValue,
  });

  String integerValue;

  factory ListId.fromJson(Map<String, dynamic> json) => ListId(
    integerValue: json["integerValue"],
  );

  Map<String, dynamic> toJson() => {
    "integerValue": integerValue,
  };
}

class Quantity {
  Quantity({
    required this.doubleValue,
  });

  double doubleValue;

  factory Quantity.fromJson(Map<String, dynamic> json) => Quantity(
    doubleValue: json["doubleValue"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "doubleValue": doubleValue,
  };
}
