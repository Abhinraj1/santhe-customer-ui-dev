// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_shophome_view;

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/constants.dart';
import 'package:flutter/services.dart' as sv;
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/controllers/home_controller.dart';
import 'package:santhe/controllers/notification_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/address/address_bloc.dart';

import 'package:santhe/core/blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/address_repository.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';
import 'package:santhe/models/ondc/single_order_model.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/network_call/network_call.dart';
import 'package:santhe/pages/ondc/map_text/map_text_view.dart';
import 'package:santhe/pages/ondc/ondc_checkout_screen/new/ondc_checkout_screen_mobile.dart';
import 'package:santhe/pages/ondc/ondc_intro/ondc_intro_view.dart';

import 'package:santhe/widgets/hyperlocal_widgets/hyperlocal_shopwidget.dart';

import '../../../core/app_url.dart';
import '../../../core/blocs/hyperlocal/hyperlocal_orderhistory/hyperlocal_orderhistory_bloc.dart';
import '../../../models/hyperlocal_models/text_formatter.dart';
import '../../../widgets/navigation_drawer_widget.dart';
import '../hyperlocal_contact_support/contact_confirmation_screen/contact_confirmation_screen_mobile.dart';
import '../hyperlocal_contact_support/contact_support_details_screen/contact_support_details_screen_mobile.dart';
import '../hyperlocal_contact_support/open_support_ticket_screen/open_support_ticket_screen_mobile.dart';

part 'hyperlocal_shophome_desktop.dart';
part 'hyperlocal_shophome_mobile.dart';
part 'hyperlocal_shophome_tablet.dart';

class HyperlocalShophomeView extends StatelessWidget {
  final String? lat;
  final String? lng;
  const HyperlocalShophomeView({
    Key? key,
    this.lat,
    this.lng,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalShophomeMobile(
          // lat: lat,
          // lng: lng,
        ),
        desktop: _HyperlocalShophomeDesktop(),
        tablet: _HyperlocalShophomeTablet(),
      );
    });
  }
}
