library ondc_cart_view;

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/ondc_cart_repository.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/pages/ondc/ondc_checkout_screen/ondc_checkout_screen_view.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart';
import 'package:santhe/widgets/ondc_widgets/ondc_cart_item.dart';
import 'package:share_plus/share_plus.dart';
part 'ondc_cart_mobile.dart';
part 'ondc_cart_tablet.dart';
part 'ondc_cart_desktop.dart';

class OndcCartView extends StatelessWidget {
  const OndcCartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const _OndcCartMobile(),
        desktop: const _OndcCartDesktop(),
        tablet: _OndcCartTablet(),
      );
    });
  }
}
