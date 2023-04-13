// ignore_for_file: public_member_api_docs, sort_constructors_first
library product_long_description_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';

import 'package:santhe/models/ondc/product_ondc.dart';

import '../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../widgets/navigation_drawer_widget.dart' as nv;

part 'product_long_description_desktop.dart';
part 'product_long_description_mobile.dart';
part 'product_long_description_tablet.dart';

class ProductLongDescriptionView extends StatelessWidget {
  final ProductOndcModel productOndcModel;
  const ProductLongDescriptionView({
    Key? key,
    required this.productOndcModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile:
            _ProductLongDescriptionMobile(productOndcModel: productOndcModel),
        desktop: _ProductLongDescriptionDesktop(),
        tablet: _ProductLongDescriptionTablet(),
      );
    });
  }
}
