import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AppHelpers{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void updateName(String name) => _firebaseAuth.currentUser!.updateDisplayName(name);

  void updateEmail(String email) => _firebaseAuth.currentUser!.updateEmail(email);

  String get getPhoneNumber => _firebaseAuth.currentUser?.phoneNumber ?? '';

  Future<String> get getToken async => await FirebaseMessaging.instance.getToken() ?? '';

  Future<String> getDeviceId() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.toMap()['androidId'];
    }
    else{
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.toMap()['identifierForVendor'];
    }
  }
}