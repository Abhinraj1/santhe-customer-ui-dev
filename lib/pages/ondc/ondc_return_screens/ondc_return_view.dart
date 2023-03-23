import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../ondc_reasons_screen/ondc_select_reason_screen_mobile.dart';

class ONDCReturnView extends StatelessWidget {
  const ONDCReturnView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Builder(builder: (context) {
      return ScreenTypeLayout(
          mobile: const ONDCReasonsScreenMobile()
        // desktop: _OndcProductGlobalDesktop(),
        // tablet: _OndcProductGlobalTablet(),
      );
    });
  }
}
