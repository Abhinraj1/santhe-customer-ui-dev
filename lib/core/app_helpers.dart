import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

class AppHelpers {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void updateName(String name) =>
      _firebaseAuth.currentUser!.updateDisplayName(name);

  void updateEmail(String email) =>
      _firebaseAuth.currentUser!.updateEmail(email);

  String get getPhoneNumber => _firebaseAuth.currentUser?.phoneNumber ?? '';

  String get getPhoneNumberWithoutCountryCode => getPhoneNumber.replaceAll('+91', '');

  Future<String> get getToken async =>
      await FirebaseMessaging.instance.getToken() ?? '';

  String get playStoreLink => appStoreLink;
  String get appStoreLink => '''Hey,

Santhe Merchant App is an app built for supporting local economy. The app helps local merchants to grow their business by getting access to customers via online channel. Install the app now and grow your business.

Get it for free at https://santhe.in''';

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.toMap()['androidId'];
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.toMap()['identifierForVendor'];
    }
  }

  static bool isInBetween(num compare, num a, num b){
    if(compare>=a && compare<b){
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
    } on SocketException catch(_) {
      hasConnection = false;
    }
    return hasConnection;
  }

  static String replaceDecimalZero(String value){
    final data = value.split('.');
    if(data.length>1){
      if(data[1]!='0'){
        return value;
      }else{
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
