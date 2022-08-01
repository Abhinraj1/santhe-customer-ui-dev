import 'package:hive/hive.dart';
part 'santhe_user_model.g.dart';

@HiveType(typeId: 3)
class User {
  @HiveField(0)
  final String address;
  @HiveField(1)
  final String emailId;
  @HiveField(2)
  final String howToReach;
  @HiveField(3)
  late final double lat;
  @HiveField(4)
  late final double lng;
  @HiveField(5)
  final int phoneNumber;
  @HiveField(6)
  final int custId;
  @HiveField(7)
  final DateTime custLoginTime;
  @HiveField(8)
  final String custName;
  @HiveField(9)
  final String custPlan;
  @HiveField(10)
  final double custRatings;
  @HiveField(11)
  final int custReferal;
  @HiveField(12)
  final String custStatus;
  @HiveField(13)
  final int pincode;

  final bool opStats;

  User({
    required this.address,
    required this.emailId,
    required this.howToReach,
    required this.lat,
    required this.lng,
    required this.phoneNumber,
    required this.custId,
    required this.custName,
    required this.custRatings,
    required this.custReferal,
    required this.custStatus,
    required this.custLoginTime,
    required this.custPlan,
    required this.pincode,
    this.opStats = false,
  });

  factory User.fromJson(Map json) {
    return User(
      address: json['contact']['mapValue']['fields']['address']['stringValue'],
      emailId: json['contact']['mapValue']['fields']['emailId']['stringValue'],
      lat: double.parse(json['contact']['mapValue']['fields']['location']
              ['mapValue']['fields']['lat']['doubleValue']
          .toString()),
      lng: double.parse(json['contact']['mapValue']['fields']['location']
              ['mapValue']['fields']['lng']['doubleValue']
          .toString()),
      pincode: int.parse(
          json['contact']['mapValue']['fields']['pincode']['integerValue']),
      phoneNumber: int.parse(
          json['contact']['mapValue']['fields']['phoneNumber']['integerValue']),
      custId: int.parse(json['custId']['integerValue']),
      custName: json['custName']['stringValue'],
      custRatings: double.parse(json['custRatings']['integerValue'] ??
          json['custRatings']['doubleValue'].toString()),
      custReferal: int.parse(json['custReferal']['integerValue']),
      custStatus: json['custStatus']['stringValue'],
      custPlan: json['custPlan']['stringValue'],
      custLoginTime: DateTime.parse(json['custLoginTime']['timestampValue']),
      howToReach: json['contact']['mapValue']['fields']['howToReach']
          ['stringValue'],
      opStats: json['opStats']['booleanValue']
    );
  }
}
