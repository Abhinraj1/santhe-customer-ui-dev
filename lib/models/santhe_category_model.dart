import 'package:hive/hive.dart';

part 'santhe_category_model.g.dart';

@HiveType(typeId: 4)
class Category {
  @HiveField(0)
  final int catId;
  @HiveField(1)
  final String catImageId;
  @HiveField(2)
  final String catImageTn;
  @HiveField(3)
  final String catName;
  @HiveField(4)
  final String catNotes;
  @HiveField(5)
  final String status;
  @HiveField(6)
  final int userCreate;
  @HiveField(7)
  final int userUpdate;

  Category({
    required this.catId,
    required this.catImageId,
    required this.catImageTn,
    required this.catName,
    required this.catNotes,
    required this.status,
    required this.userCreate,
    required this.userUpdate,
  });

  factory Category.fromJson(Map data) {
    return Category(
      catId: int.parse(data['catId']['integerValue']),
      catImageId: data['catImageId']['stringValue'],
      catImageTn: data['catImageTn']['stringValue'],
      catName: data['catName']['stringValue'],
      catNotes: data['catNotes']['stringValue'],
      status: data['status']['stringValue'],
      userCreate: int.parse(data['userCreate']['integerValue'] ?? '404'),
      userUpdate: int.parse(data['userUpdate']['integerValue'] ?? '404'),
    );
  }
}
