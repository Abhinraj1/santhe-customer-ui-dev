import 'package:hive/hive.dart';

part 'santhe_cache_refresh.g.dart';

@HiveType(typeId: 5)
class CacheRefresh {
  @HiveField(0)
  final DateTime catUpdate;
  @HiveField(1)
  final DateTime dbStructure;
  @HiveField(2)
  final DateTime itemUpdate;
  @HiveField(3)
  final DateTime aboutUsUpdate;
  @HiveField(4)
  final DateTime custFaqUpdate;
  @HiveField(5)
  final DateTime termsUpdate;

  CacheRefresh({
    required this.catUpdate,
    required this.dbStructure,
    required this.itemUpdate,
    required this.aboutUsUpdate,
    required this.termsUpdate,
    required this.custFaqUpdate,
  });

  factory CacheRefresh.fromJson(json) {
    return CacheRefresh(
      aboutUsUpdate: DateTime.parse(json['aboutUsUpdate']['timestampValue']),
      catUpdate: DateTime.parse(json['catUpdate']['timestampValue']),
      custFaqUpdate: DateTime.parse(json['custFaqUpdate']['timestampValue']),
      dbStructure: DateTime.parse(json['dbStructure']['timestampValue']),
      itemUpdate: DateTime.parse(json['itemUpdate']['timestampValue']),
      termsUpdate: DateTime.parse(json['termsUpdate']['timestampValue']),
    );
  }
}
