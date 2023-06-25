import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../core/app_colors.dart';
import '../../pages/hyperlocal/hyperlocal_shophome/hyperlocal_shophome_view.dart';
import '../../pages/ondc/ondc_intro/ondc_intro_view.dart';



Widget homeIconButton({bool? toHyperLocalHome}){
  return
    IconButton(
        onPressed: (){
          ///Navigate to Home
          if(toHyperLocalHome ?? false){
            Get.offAll(() => const HyperlocalShophomeView(),
                transition: Transition.rightToLeft);
          }else{
            Get.offAll(()=>const OndcIntroView(),
                transition: Transition.rightToLeft);
          }
        },
        icon: const Icon( Icons.home,size: 28));
}