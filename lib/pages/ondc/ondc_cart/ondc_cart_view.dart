// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
library ondc_cart_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as ge;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/blocs/checkout/checkout_bloc.dart';
import 'package:santhe/pages/ondc/ondc_intro/ondc_intro_view.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/ondc_cart_repository.dart';
import 'package:santhe/models/ondc/cart_item_model.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;
import 'package:santhe/widgets/ondc_widgets/ondc_cart_item.dart';

import '../../hyperlocal/hyperlocal_shophome/hyperlocal_shophome_view.dart';
import '../ondc_checkout_screen/old/ondc_checkout_screen_view.dart';

part 'ondc_cart_desktop.dart';
part 'ondc_cart_mobile.dart';
part 'ondc_cart_tablet.dart';

class OndcCartView extends StatelessWidget {
  final String storeLocation_id;
  const OndcCartView({
    Key? key,
    required this.storeLocation_id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _OndcCartMobile(
          storeLocation_id: storeLocation_id,
        ),
        desktop: const _OndcCartDesktop(),
        tablet: _OndcCartTablet(),
      );
    });
  }
}
