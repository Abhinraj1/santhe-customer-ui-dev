import 'package:hive/hive.dart';
import 'package:santhe/core/app_url.dart';
part 'santhe_list_item_model.g.dart';

@HiveType(typeId: 0)
class ListItem {
  @HiveField(0)
  final String brandType;

  @HiveField(1)
  final String catName;

  @HiveField(2)
  final String itemId; //more like item reference

  @HiveField(3)
  final String itemImageId;

  @HiveField(4)
  final String itemName;

  @HiveField(5)
  final String notes;

  @HiveField(6)
  final num quantity;

  @HiveField(7)
  final String unit;

  @HiveField(8)
  final int catId;

  @HiveField(9)
  final List<String> possibleUnits;

  ListItem({
    required this.brandType,
    required this.itemId,
    required this.notes,
    required this.quantity,
    required this.itemName,
    required this.itemImageId,
    required this.unit,
    required this.catName,
    required this.catId,
    required this.possibleUnits,
  });

  factory ListItem.fromJson(data) {
    return ListItem(
      brandType: data['brandType']['stringValue'],
      itemId: data['itemId']['referenceValue'],
      notes: data['notes']['stringValue'],
      quantity: data['quantity']['doubleValue'] ?? 0,
      itemName: data['itemName']['stringValue'],
      itemImageId: data['itemImageId']['stringValue'],
      unit: data['unit']['stringValue'],
      possibleUnits: [data['unit']['stringValue']],
      catName: data['catName']['stringValue'],
      catId: int.parse(data['catId']['referenceValue'].toString().replaceAll(
          'projects/${AppUrl.envType}/databases/(default)/documents/category/', '')),
    );
  }
}
