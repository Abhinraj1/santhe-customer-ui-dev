// ignore_for_file: public_member_api_docs, sort_constructors_first
library product_description_ondc_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';

import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart';
import 'package:santhe/widgets/ondc_widgets/ondc_product_carousel.dart';

part 'product_description_ondc_desktop.dart';
part 'product_description_ondc_mobile.dart';
part 'product_description_ondc_tablet.dart';

class ProductDescriptionOndcView extends StatelessWidget {
  final ProductOndcModel productOndcModel;
  const ProductDescriptionOndcView({
    Key? key,
    required this.productOndcModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _ProductDescriptionOndcMobile(
          productOndcModel: productOndcModel,
        ),
        desktop: _ProductDescriptionOndcDesktop(),
        tablet: _ProductDescriptionOndcTablet(),
      );
    });
  }
}
