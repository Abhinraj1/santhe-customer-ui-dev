import 'package:hive/hive.dart';
part 'santhe_user_credenetials_model.g.dart';

@HiveType(typeId: 2)
class UserCredential {
  @HiveField(0)
  final String idToken;

  @HiveField(1)
  final String refreshToken;

  @HiveField(2)
  final int expiresIn;

  @HiveField(3)
  final String localId;

  @HiveField(4)
  final bool isNewUser;

  @HiveField(5)
  final int phoneNumber;

  UserCredential({
    required this.idToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.localId,
    required this.isNewUser,
    required this.phoneNumber,
  });

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    // print(json['phoneNumber']);
    // print(int.parse(json['phoneNumber']
    //     .toString()
    //     .substring(0, json['phoneNumber'].toString().length)));
    // print(int.parse(json['phoneNumber']
    //     .toString()
    //     .substring(1, json['phoneNumber'].toString().length)));
    // print(int.parse(json['phoneNumber']
    //     .toString()
    //     .substring(2, json['phoneNumber'].toString().length)));
    // print(int.parse(json['phoneNumber']
    //     .toString()
    //     .substring(3, json['phoneNumber'].toString().length)));
    //phone nuber comes out like +91XXXXXXXXXX so remove first 3 digit

    return UserCredential(
      idToken: json['idToken'],
      refreshToken: json['refreshToken'],
      expiresIn: int.parse(json['expiresIn']),
      localId: json['localId'],
      isNewUser: json['isNewUser'],
      phoneNumber: int.parse(json['phoneNumber']
          .toString()
          .substring(3, json['phoneNumber'].toString().length)),
    );
  }
}
