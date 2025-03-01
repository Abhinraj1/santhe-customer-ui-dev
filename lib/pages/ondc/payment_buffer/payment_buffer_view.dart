// ignore_for_file: public_member_api_docs, sort_constructors_first
library payment_buffer_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/checkout/checkout_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/ondc_cart_repository.dart';
import 'package:santhe/pages/ondc/error_nack/error_nack_view.dart';
import 'package:santhe/pages/ondc/payment_success/payment_success_view.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

part 'payment_buffer_desktop.dart';
part 'payment_buffer_mobile.dart';
part 'payment_buffer_tablet.dart';

class PaymentBufferView extends StatelessWidget {
  final String messageId;
  const PaymentBufferView({
    Key? key,
    required this.messageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _PaymentBufferMobile(
          messageID: messageId,
        ),
        desktop: _PaymentBufferDesktop(),
        tablet: _PaymentBufferTablet(),
      );
    });
  }
}
