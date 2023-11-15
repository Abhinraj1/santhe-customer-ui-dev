import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/ondc_order_details_screen_mobile.dart';


class ONDCOrderDetailsView extends StatelessWidget {
  final Function()? onBackButtonTap;
  const ONDCOrderDetailsView({Key? key,
     this.onBackButtonTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile:  ONDCOrderDetailsScreen(
            onBackButtonTap: (){
              if(onBackButtonTap != null){
                onBackButtonTap!();
              }else{
                Get.back();
              }
        }),
        // desktop: _OndcProductGlobalDesktop(),
        // tablet: _OndcProductGlobalTablet(),
      );
    });
  }
}
