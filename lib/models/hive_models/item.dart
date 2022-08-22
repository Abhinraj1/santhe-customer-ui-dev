import 'package:hive/hive.dart';
import 'dart:convert';

part 'item.g.dart';

List<Item> itemFromJson(String str) =>
    List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 8)
class Item {
  Item({
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
    required this.createUser,
    required this.updateUser,
  });
  @HiveField(0)
  final String itemName;
  @HiveField(1)
  final String catId;
  @HiveField(2)
  final String dBrandType;
  @HiveField(3)
  final String dItemNotes;
  @HiveField(4)
  final int dQuantity;
  @HiveField(5)
  final String dUnit;
  @HiveField(6)
  final String itemAlias;
  @HiveField(7)
  final int itemId;
  @HiveField(8)
  final String itemImageId;
  @HiveField(9)
  final String itemImageTn;
  @HiveField(10)
  final String status;
  @HiveField(11)
  final List<String> unit;
  @HiveField(12)
  final int createUser;
  @HiveField(13)
  final int updateUser;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemName: json["itemName"],
        catId: json["catId"],
        dBrandType: json["dBrandType"],
        dItemNotes: json["dItemNotes"],
        dQuantity: json["dQuantity"],
        dUnit: json["dUnit"],
        itemAlias: json["itemAlias"],
        itemId: json["itemId"],
        itemImageId: json["itemImageId"] ?? '',
        itemImageTn: json["itemImageTn"] ?? '',
        status: json["status"],
        unit: List<String>.from(json["unit"].map((x) => x)),
        createUser: json["createUser"] ?? 0,
        updateUser: json["updateUser"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "catId": catId,
        "dBrandType": dBrandType,
        "dItemNotes": dItemNotes,
        "dQuantity": dQuantity,
        "dUnit": dUnit,
        "itemAlias": itemAlias,
        "itemId": itemId,
        "itemImageId": itemImageId,
        "itemImageTn": itemImageTn,
        "status": status,
        "unit": List<dynamic>.from(unit.map((x) => x)),
        "createUser": createUser,
        "updateUser": updateUser,
      };
}
