// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_shopdetails_view;

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as ge;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_cart/hyperlocal_cart_bloc.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/address_repository.dart';
import 'package:santhe/core/repositories/hyperlocal_cartrepo.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/core/repositories/hyperlocal_repository.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_productmodel.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';
import 'package:santhe/models/hyperlocal_models/text_formatter.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_cart/hyperlocal_cart_view.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_shophome/hyperlocal_shophome_view.dart';
import 'package:santhe/pages/ondc/ondc_intro/ondc_intro_view.dart';
import 'package:santhe/widgets/hyperlocal_widgets/hyperlocal_productwidget.dart';

import '../../../controllers/getx/profile_controller.dart';
import '../../../core/app_url.dart';
import '../../../core/cubits/hyperlocal_shopDetails_cubit/hyperlocal_shop_details_cubit.dart';
import '../../../widgets/hyperlocal_widgets/hyperlocal_shop_home_body.dart';
import '../../../widgets/navigation_drawer_widget.dart';
import '../../ondc/ondc_checkout_screen/new/ondc_checkout_screen_mobile.dart';
import 'package:badges/badges.dart' as badges;
part 'hyperlocal_shopdetails_desktop.dart';
// part 'hyperlocal_shopdetails_mobile.dart';
part 'hyperlocal_shopdetails_tablet.dart';

class HyperlocalShopdetailsView extends StatelessWidget {
  final HyperLocalShopModel hyperLocalShopModel;
  final String? searchItem;
  const HyperlocalShopdetailsView({
    Key? key,
    required this.hyperLocalShopModel, this.searchItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: HyperLocalShopDetailsScreen(
          searchItem: searchItem,
          hyperLocalShopModel: hyperLocalShopModel,
        ),
        desktop: _HyperlocalShopdetailsDesktop(),
        tablet: _HyperlocalShopdetailsTablet(),
      );
    });
  }
}
