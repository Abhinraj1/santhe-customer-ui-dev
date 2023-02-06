library payment_buffer_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'payment_buffer_mobile.dart';
part 'payment_buffer_tablet.dart';
part 'payment_buffer_desktop.dart';

class PaymentBufferView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _PaymentBufferMobile(),
        desktop: _PaymentBufferDesktop(),
        tablet: _PaymentBufferTablet(),
      );
    });
  }
}
