// ignore_for_file: public_member_api_docs, sort_constructors_first
library ondc_shop_list_view;

import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as ge;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/core/blocs/address/address_bloc.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/ondc/ondc_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/address_repository.dart';
import 'package:santhe/models/ondc/location_model.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/models/ondc/shop_model.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/ondc/api_error/api_error_view.dart';
import 'package:santhe/pages/ondc/map_text/map_text_view.dart';
import 'package:santhe/pages/ondc/ondc_intro/ondc_intro_view.dart';
import 'package:santhe/pages/ondc/ondc_product_global/ondc_product_global_view.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart';
import 'package:santhe/widgets/ondc_widgets/ondc_shop_widget.dart';
import 'package:santhe/widgets/ondc_widgets/ondc_shop_widget.dart';
import '../../../widgets/ondc_widgets/ondc_product_widget.dart';

import '../ondc_checkout_screen/new/ondc_checkout_screen_mobile.dart';

part 'ondc_shop_list_desktop.dart';
part 'ondc_shop_list_mobile.dart';
part 'ondc_shop_list_tablet.dart';

class OndcShopListView extends StatelessWidget {
  final CustomerModel customerModel;

  const OndcShopListView({
    Key? key,
    required this.customerModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _OndcShopListMobile(
          customerModel: customerModel,
        ),
        desktop: const _OndcShopListDesktop(),
        tablet: _OndcShopListTablet(),
      );
    });
  }
}
