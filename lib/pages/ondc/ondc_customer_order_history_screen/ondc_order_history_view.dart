import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/pages/ondc/ondc_customer_order_history_screen/ondc_order_history_mobile.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/ondc_order_details_screen_mobile.dart';


class ONDCOrderHistoryView extends StatelessWidget {
  const ONDCOrderHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const ONDCOrderHistoryMobile()
        // desktop: _OndcProductGlobalDesktop(),
        // tablet: _OndcProductGlobalTablet(),
      );
    });
  }
}
