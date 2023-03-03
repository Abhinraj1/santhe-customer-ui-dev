// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
library product_description_ondc_view;

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/ondc/ondc_bloc.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/ondc_cart_repository.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:santhe/pages/ondc/ondc_cart/ondc_cart_view.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;
import 'package:santhe/widgets/ondc_widgets/expandable_text.dart';
import 'package:santhe/widgets/ondc_widgets/ondc_cart_item.dart';
import 'package:santhe/widgets/ondc_widgets/ondc_product_carousel.dart';

import '../product_long_description/product_long_description_view.dart';

part 'product_description_ondc_desktop.dart';
part 'product_description_ondc_mobile.dart';
part 'product_description_ondc_tablet.dart';

class ProductDescriptionOndcView extends StatelessWidget {
  final ProductOndcModel productOndcModel;
  int value;
  ProductDescriptionOndcView({
    Key? key,
    required this.productOndcModel,
    required this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _ProductDescriptionOndcMobile(
          productOndcModel: productOndcModel,
          value: value,
        ),
        desktop: _ProductDescriptionOndcDesktop(),
        tablet: _ProductDescriptionOndcTablet(),
      );
    });
  }
}
