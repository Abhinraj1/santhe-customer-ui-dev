library payment_success_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:santhe/widgets/custom_widgets/custom_button.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

import '../../../constants.dart';
import '../ondc_order_details_screen/ondc_order_details_view.dart';

part 'payment_success_mobile.dart';
part 'payment_success_tablet.dart';
part 'payment_success_desktop.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _PaymentSuccessMobile(),
        desktop: _PaymentSuccessDesktop(),
        tablet: _PaymentSuccessTablet(),
      );
    });
  }
}
