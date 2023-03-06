import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'ondc_order_cancel_acknowledgement _screen_mobile.dart';



class ONDCOrderCancelAcknowledgementView extends StatelessWidget {
  final String orderNumber;
  const ONDCOrderCancelAcknowledgementView({Key? key, required this.orderNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Builder(builder: (context) {
        return ScreenTypeLayout(
          mobile:  ONDCOrderCancelAcknowledgement(
            orderId: orderNumber,
          ),

          // desktop: _OndcProductGlobalDesktop(),
          // tablet: _OndcProductGlobalTablet(),
        );
      });
  }
}
