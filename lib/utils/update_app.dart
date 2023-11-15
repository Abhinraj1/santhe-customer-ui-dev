import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_update/in_app_update.dart';


updateApp() async{

  final bool forceUpdateUser = true;
  /// Android
  if (Platform.isAndroid) {

    if(forceUpdateUser){
     await InAppUpdate.performImmediateUpdate(
      ).then((info) {
      }).catchError((e) {
        print("ERROR UPDATING THE APP == ${e.toString()}");
      });
    }else{
     await InAppUpdate.startFlexibleUpdate(
      ).then((info) {
      }).catchError((e) {
        print("ERROR UPDATING THE APP == ${e.toString()}");
      });
    }
  }
}