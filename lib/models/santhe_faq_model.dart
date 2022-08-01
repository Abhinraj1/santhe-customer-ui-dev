import 'package:hive/hive.dart';

part 'santhe_faq_model.g.dart';

@HiveType(typeId: 6)
class FAQ {
  @HiveField(0)
  final String quest;
  @HiveField(1)
  final String answ;

  FAQ({required this.quest, required this.answ});

  factory FAQ.fromJson(jsonData) {
    return FAQ(
        quest: jsonData['mapValue']['fields']['quest']['stringValue'],
        answ: jsonData['mapValue']['fields']['answ']['stringValue']);
  }
}
