import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/countrymodel.dart';

class AppHelpers with LogMixin {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void updateName(String name) =>
      _firebaseAuth.currentUser!.updateDisplayName(name);

  void updateEmail(String email) =>
      _firebaseAuth.currentUser!.updateEmail(email);

  static void crashlyticsLog(String error) {
    final profileController = Get.find<ProfileController>();
    dev.log(error);
    final message =
        '$error\n Caused on customer id: ${profileController.customerDetails?.phoneNumber}';
    FirebaseCrashlytics.instance.log(message);
  }

  String get getPhoneNumber => _firebaseAuth.currentUser?.phoneNumber ?? '404';

  String get getPhoneNumberWithoutCountryCode =>
      getPhoneNumber.replaceAll('+91', '');

  //!country function added
  String getPhoneNumberWithoutFoundedCountryCode(String getphoneNumber) {
    Map<String, String> foundedCountryCode = {};
    for (var country in Countries.allCountries) {
      String dialCode = country["dial_code"].toString();
      if (getPhoneNumber.contains(dialCode)) foundedCountryCode = country;
    }
    warningLog('founded country with code and number$foundedCountryCode');
    if (foundedCountryCode.isNotEmpty) {
      var dialCode = getPhoneNumber.substring(
        0,
        foundedCountryCode["dial_code"]!.length,
      );
      var formattedPhoneNumber = getPhoneNumber.substring(
        foundedCountryCode["dial_code"]!.length,
      );
      warningLog(
          'formatted PhoneNumber $formattedPhoneNumber and Formatted dialCode $dialCode');
      return formattedPhoneNumber;
    }
    return getphoneNumber;
  }

  Future<String> get getToken async =>
      await FirebaseMessaging.instance.getToken() ?? '';

  Future<String> get authToken async =>
      await FirebaseAuth.instance.currentUser!.getIdToken();

  String get playStoreLink => appStoreLink;
  String get appStoreLink => '''Hi,

Santhe is an app built for getting best deals for your groceries from your local Kirana stores and retailers. Use the Free Santhe App and support local economy. 

Get it for free at https://santhe.in''';

  Future<String> getDeviceId() async {
    return FirebaseAuth.instance.currentUser!.uid;
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // if (Platform.isAndroid) {
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   return androidInfo.toMap()['androidId'];
    // } else {
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   return iosInfo.toMap()['identifierForVendor'];
    // }
  }

  static bool isInBetween(num compare, num a, num b) {
    if (compare > a && compare <= b) {
      return true;
    }
    return false;
  }

  static Future<bool> checkConnection() async {
    bool hasConnection = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }
    return hasConnection;
  }

  static String replaceDecimalZero(String value) {
    final data = value.split('.');
    if (data.length > 1) {
      if (data[1] != '0') {
        return value;
      } else {
        return data[0];
      }
    }
    return value;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: min(truncated.length, truncated.length + 1),
        extentOffset: min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
