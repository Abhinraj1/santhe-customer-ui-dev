// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_shophome_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/address/address_bloc.dart';

import 'package:santhe/core/blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/address_repository.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/network_call/network_call.dart';
import 'package:santhe/pages/ondc/map_text/map_text_view.dart';
import 'package:santhe/pages/ondc/ondc_checkout_screen/new/ondc_checkout_screen_mobile.dart';
import 'package:santhe/pages/ondc/ondc_intro/ondc_intro_view.dart';

import 'package:santhe/widgets/hyperlocal_widgets/hyperlocal_shopwidget.dart';

import '../../../widgets/navigation_drawer_widget.dart';

part 'hyperlocal_shophome_desktop.dart';
part 'hyperlocal_shophome_mobile.dart';
part 'hyperlocal_shophome_tablet.dart';

class HyperlocalShophomeView extends StatelessWidget {
  final String lat;
  final String lng;
  const HyperlocalShophomeView({
    Key? key,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalShophomeMobile(
          lat: lat,
          lng: lng,
        ),
        desktop: _HyperlocalShophomeDesktop(),
        tablet: _HyperlocalShophomeTablet(),
      );
    });
  }
}
