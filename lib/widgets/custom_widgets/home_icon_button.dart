import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../core/app_colors.dart';
import '../../pages/ondc/ondc_intro/ondc_intro_view.dart';



Widget homeIconButton(){
  return
    IconButton(
        onPressed: (){
          ///Navigate to Home
          Get.offAll(()=>const OndcIntroView());
        },
        icon: const Icon(Icons.home_filled,size: 28));
}