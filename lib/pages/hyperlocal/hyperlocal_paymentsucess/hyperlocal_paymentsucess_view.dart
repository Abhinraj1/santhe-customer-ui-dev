// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_paymentsucess_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/repositories/hyperlocal_checkoutrepository.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_orderdetail/hyperlocal_orderdetail_view.dart';
import 'package:santhe/widgets/custom_widgets/custom_button.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

part 'hyperlocal_paymentsucess_desktop.dart';
part 'hyperlocal_paymentsucess_mobile.dart';
part 'hyperlocal_paymentsucess_tablet.dart';

class HyperlocalPaymentsucessView extends StatelessWidget {
  final String storeDescriptionId;
  const HyperlocalPaymentsucessView({
    Key? key,
    required this.storeDescriptionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalPaymentsucessMobile(
          storeDescriptionId: storeDescriptionId,
        ),
        desktop: _HyperlocalPaymentsucessDesktop(),
        tablet: _HyperlocalPaymentsucessTablet(),
      );
    });
  }
}
