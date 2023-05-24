// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_productdescription_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/constants.dart';
import 'package:badges/badges.dart' as badges;
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_cart/hyperlocal_cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/hyperlocal_cartrepo.dart';
import 'package:santhe/core/repositories/hyperlocal_repository.dart';

import 'package:santhe/models/hyperlocal_models/hyperlocal_productmodel.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_cart/hyperlocal_cart_view.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import 'package:santhe/widgets/ondc_widgets/expandable_text.dart';
import 'package:santhe/widgets/ondc_widgets/ondc_product_carousel.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

part 'hyperlocal_productdescription_desktop.dart';
part 'hyperlocal_productdescription_mobile.dart';
part 'hyperlocal_productdescription_tablet.dart';

class HyperlocalProductdescriptionView extends StatelessWidget {
  final HyperLocalProductModel productModel;
  const HyperlocalProductdescriptionView({
    required this.productModel,
  });
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalProductdescriptionMobile(
          hyperLocalProductModel: productModel,
        ),
        desktop: _HyperlocalProductdescriptionDesktop(),
        tablet: _HyperlocalProductdescriptionTablet(),
      );
    });
  }
}
