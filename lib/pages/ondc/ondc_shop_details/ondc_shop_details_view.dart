// ignore_for_file: public_member_api_docs, sort_constructors_first
library ondc_shop_details_view;

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as ge;
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/ondc/ondc_bloc.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/ondc_cart_repository.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/models/ondc/shop_model.dart';
import 'package:santhe/pages/ondc/ondc_cart/ondc_cart_view.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart';
import 'package:badges/badges.dart' as badges;
import '../../../widgets/ondc_widgets/ondc_product_widget.dart';
import '../ondc_contact_support/ondc_contact_support_enter_query_screen/ondc_contact_support_enter_query_screen_mobile.dart';
import '../ondc_contact_support/ondc_contact_support_shop_contact_details_screen/ondc_contact_support_shop_contact_details_screen_mobile.dart';
part 'ondc_shop_details_desktop.dart';
part 'ondc_shop_details_tablet.dart';
part 'ondc_shop_details_mobile.dart';

class OndcShopDetailsView extends StatelessWidget {
  final ShopModel shopModel;
  const OndcShopDetailsView({
    Key? key,
    required this.shopModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _OndcShopDetailsMobile(
          shopModel: shopModel,
        ),
        desktop: const _OndcShopDetailsDesktop(),
        tablet: const _OndcShopDetailsTablet(),
      );
    });
  }
}
