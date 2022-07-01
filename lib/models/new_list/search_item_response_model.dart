// To parse this JSON data, do
//
//     final searchItemResponseModel = searchItemResponseModelFromJson(jsonString);

import 'dart:convert';

import 'list_item_model.dart';

List<SearchItemResponseModel> searchItemResponseModelFromJson(String str) => List<SearchItemResponseModel>.from(json.decode(str).map((x) => SearchItemResponseModel.fromJson(x)));

class SearchItemResponseModel {
  SearchItemResponseModel({
    required this.itemName,
    required this.catId,
    required this.dBrandType,
    required this.dItemNotes,
    required this.dQuantity,
    required this.dUnit,
    required this.itemAlias,
    required this.itemId,
    required this.itemImageId,
    required this.itemImageTn,
    required this.status,
    required this.unit,
  });

  String itemName;
  String catId;
  String dBrandType;
  String dItemNotes;
  int dQuantity;
  Unit? dUnit;
  String itemAlias;
  int itemId;
  String itemImageId;
  String? itemImageTn;
  String status;
  List<Unit> unit;

  factory SearchItemResponseModel.fromJson(Map<String, dynamic> json) => SearchItemResponseModel(
    itemName: json["itemName"],
    catId: json["catId"],
    dBrandType: json["dBrandType"],
    dItemNotes: json["dItemNotes"],
    dQuantity: json["dQuantity"],
    dUnit: unitValues.map[json["dUnit"]],
    itemAlias: json["itemAlias"],
    itemId: json["itemId"],
    itemImageId: json["itemImageId"],
    itemImageTn: json["itemImageTn"],
    status: json["status"],
    unit: List<Unit>.from(json["unit"].map((x) => unitValues.map[x])),
  );
}

enum Unit { KG, GMS, UNIT_GMS }

final unitValues = EnumValues({
  " gms": Unit.GMS,
  "kg": Unit.KG,
  "gms": Unit.UNIT_GMS
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
