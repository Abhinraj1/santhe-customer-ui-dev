import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../core/app_colors.dart';



Widget homeIconButton(){
  return
    IconButton(
        onPressed: (){
          ///Navigate to Home
          // Get.offAll(()=>const OndcIntroView(),
          // transition: Transition.rightToLeft);
        },
        icon: const Icon( Icons.home,size: 28));
}