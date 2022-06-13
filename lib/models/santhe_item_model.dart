import 'package:hive/hive.dart';

part 'santhe_item_model.g.dart';

@HiveType(typeId: 7)
class Item {
  @HiveField(0)
  final String catId;
  @HiveField(1)
  final int createUser;
  @HiveField(2)
  final String dBrandType;
  @HiveField(3)
  final String dItemNotes;
  @HiveField(4)
  final num dQuantity;
  @HiveField(5)
  final List<String> unit;
  @HiveField(6)
  final String itemAlias;
  @HiveField(7)
  final int itemId;
  @HiveField(8)
  final String itemImageId;
  @HiveField(9)
  final String itemImageTn;
  @HiveField(10)
  final String itemName;
  @HiveField(11)
  final String status;
  @HiveField(12)
  final String dUnit;
  @HiveField(13)
  final int updateUser;

  Item({
    required this.dBrandType,
    required this.dItemNotes,
    required this.itemImageTn,
    required this.catId,
    required this.createUser,
    required this.dQuantity,
    required this.dUnit,
    required this.itemAlias,
    required this.itemId,
    required this.itemImageId,
    required this.itemName,
    required this.status,
    required this.unit,
    required this.updateUser,
  });

  factory Item.fromFirebaseRestApi(Map data) {
    List<String> unit = [];

    for (int i = 0; i < data['unit']['arrayValue']['values'].length; i++) {
      unit.add(data['unit']['arrayValue']['values'][i]['stringValue']
          .toString()
          .replaceAll(' ', ''));
    }

    return Item(
      status: data['status']['stringValue'],
      updateUser: int.parse(data['updateUser']['integerValue']),
      createUser: int.parse(data['createUser']['integerValue']),
      itemName: data['itemName']['stringValue'],
      dQuantity: double.parse(data['dQuantity']['integerValue']),
      dItemNotes: data['dItemNotes']['stringValue'],
      dBrandType: data['dBrandType']['stringValue'],
      itemImageId: data['itemImageId']['stringValue'],
      catId: data['catId']['referenceValue'],
      dUnit: data['dUnit']['stringValue'],
      itemId: int.parse(data['itemId']['integerValue']),
      unit: unit,
      itemAlias: data['itemAlias']['stringValue'],
      // itemImageTn: data['itemImageTn']['stringValue'],
      itemImageTn: 'as',
    );
  }

  factory Item.fromJson(data) {
    List<String> unit = [];

    for (int i = 0; i < data['unit'].length; i++) {
      unit.add(data['unit'][i].toString().replaceAll(' ', ''));
    }

    return Item(
      status: data['status'],
      updateUser: int.parse(data['updateUser'] ?? '404'),
      createUser: int.parse(data['createUser'] ?? '404'),
      itemName: data['itemName'],
      dQuantity: double.parse('${data['dQuantity']}'),
      dItemNotes: data['dItemNotes'],
      dBrandType: data['dBrandType'],
      itemImageId: data['itemImageId'],
      catId: data['catId'],
      dUnit: data['dUnit'],
      itemId: int.parse('${data['itemId']}'),
      unit: unit,
      itemAlias: data['itemAlias'],
      itemImageTn: data['itemImageTn'] ?? 'blank',
    );
  }
}
