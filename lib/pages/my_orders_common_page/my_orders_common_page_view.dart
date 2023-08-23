import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'my_orders_common_screen_mobile.dart';



class MyOrdersCommonPageView extends StatelessWidget {
  const MyOrdersCommonPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const MyOrdersCommonScreen(),
        // desktop: _HyperlocalPreviousordersDesktop(),
        // tablet: _HyperlocalPreviousordersTablet(),
      );
    });
  }
}
