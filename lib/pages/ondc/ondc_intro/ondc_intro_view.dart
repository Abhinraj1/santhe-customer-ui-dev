library ondc_intro_view;

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' as sv;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/error_user_fallback.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/controllers/home_controller.dart';
import 'package:santhe/controllers/notification_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_shophome/hyperlocal_shophome_view.dart';
import 'package:santhe/pages/map_merch.dart';
import 'package:santhe/pages/ondc/ondc_shop_list/ondc_shop_list_view.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/api_service_controller.dart';
import '../../../core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_cubit.dart';

part 'ondc_intro_mobile.dart';
part 'ondc_intro_tablet.dart';
part 'ondc_intro_desktop.dart';

class OndcIntroView extends StatelessWidget {
  const OndcIntroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _OndcIntroMobile(),
        desktop: _OndcIntroDesktop(),
        tablet: _OndcIntroTablet(),
      );
    });
  }
}
