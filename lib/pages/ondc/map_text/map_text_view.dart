// ignore_for_file: public_member_api_docs, sort_constructors_first
library map_text_view;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/API/addressSearchAPI.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/location_controller.dart';
import 'package:santhe/controllers/registrationController.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/repositories/address_repository.dart';
import 'package:santhe/models/ondc/address_ondc_model.dart';
import 'package:santhe/pages/ondc/map_address_ondc/map_address_ondc_view.dart';

part 'map_text_desktop.dart';
part 'map_text_mobile.dart';
part 'map_text_tablet.dart';

class MapTextView extends StatelessWidget {
  final AddressOndcModel? addressOndcModel;
  const MapTextView({
    Key? key,
    this.addressOndcModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _MapTextMobile(addressOndcModel: addressOndcModel),
        desktop: _MapTextDesktop(),
        tablet: _MapTextTablet(),
      );
    });
  }
}
