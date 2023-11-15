import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/pages/ondc/ondc_contact_support/ondc_contact_support_enter_query_screen/ondc_contact_support_enter_query_screen_mobile.dart';

import '../../../models/ondc/single_order_model.dart';
import 'ondc_contact_support_shop_contact_details_screen/ondc_contact_support_shop_contact_details_screen_mobile.dart';


class ONDCContactSupportView extends StatelessWidget {
  final SingleOrderModel orderModel;
  const ONDCContactSupportView({Key? key, required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: ONDCContactSupportShopContactDetailsScreen(model: orderModel,),
        // desktop: _OdcProductGlobalDesktop(),
        // tablet: _OndcProductGlobalTablet(),
      );
    });
  }
}
