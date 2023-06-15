// ignore_for_file: public_member_api_docs, sort_constructors_first
library map_address_ondc_view;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as ge;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:santhe/API/addressSearchAPI.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/error_user_fallback.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/controllers/location_controller.dart';
import 'package:santhe/controllers/registrationController.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/address/address_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/address_repository.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_shophome/hyperlocal_shophome_view.dart';
import 'package:santhe/pages/ondc/ondc_shop_list/ondc_shop_list_view.dart';

import '../../../widgets/registration_widgets/textFieldRegistration.dart';

part 'map_address_ondc_desktop.dart';
part 'map_address_ondc_mobile.dart';
part 'map_address_ondc_tablet.dart';

class MapAddressOndcView extends StatelessWidget {
  final double lat;
  final double lng;
  final String? whichScreen;
  const MapAddressOndcView({
    Key? key,
    required this.lat,
    required this.lng,
    this.whichScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _MapAddressOndcMobile(
          lat: lat,
          lng: lng,
          whichScreen: whichScreen,
        ),
        desktop: _MapAddressOndcDesktop(),
        tablet: _MapAddressOndcTablet(),
      );
    });
  }
}
