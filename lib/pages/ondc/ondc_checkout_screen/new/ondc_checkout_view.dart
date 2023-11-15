import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/pages/ondc/ondc_checkout_screen/new/ondc_checkout_screen_mobile.dart';



class ONDCCheckOutView extends StatelessWidget {
  const ONDCCheckOutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const OndcCheckOutScreenMobile(),
        // desktop: _OndcProductGlobalDesktop(),
        // tablet: _OndcProductGlobalTablet(),
      );
    });
  }
}
