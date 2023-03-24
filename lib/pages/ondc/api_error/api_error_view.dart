library api_error_view;

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/pages/ondc/ondc_intro/ondc_intro_view.dart';

part 'api_error_mobile.dart';
part 'api_error_tablet.dart';
part 'api_error_desktop.dart';

class ApiErrorView extends StatelessWidget {
  const ApiErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _ApiErrorMobile(),
        desktop: _ApiErrorDesktop(),
        tablet: _ApiErrorTablet(),
      );
    });
  }
}
