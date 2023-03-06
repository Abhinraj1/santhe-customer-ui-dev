import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../ondc_return_screens/ondc_return_select_reason_screen/ondc_return_select_reason_screen_mobile.dart';
import 'ondc_order_cancel_select_reason_screen/ondc_order_cancel_select_reason_screen_mobile.dart';

class ONDCOrderCancelView extends StatelessWidget {
  const ONDCOrderCancelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Builder(builder: (context) {
        return ScreenTypeLayout(
          mobile: const ONDCFullOrderCancelScreen(
          ),

          // desktop: _OndcProductGlobalDesktop(),
          // tablet: _OndcProductGlobalTablet(),
        );
      });
  }
}
