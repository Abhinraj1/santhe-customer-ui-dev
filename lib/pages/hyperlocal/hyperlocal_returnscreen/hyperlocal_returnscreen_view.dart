// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_returnscreen_view;

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
import 'package:santhe/core/cubits/hyperlocal_image_return_request_cubit/hyperlocal_image_return_request_cubit.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_previewmodel.dart';
import 'package:santhe/widgets/custom_widgets/custom_button.dart';
import 'package:santhe/widgets/hyperlocal_widgets/hyperlocal_image_grid.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

import '../../../widgets/ondc_widgets/error_container_widget.dart';
import '../hyperlocal_returnconfirm/hyperlocal_returnconfirm_view.dart';

part 'hyperlocal_returnscreen_desktop.dart';
part 'hyperlocal_returnscreen_mobile.dart';
part 'hyperlocal_returnscreen_tablet.dart';

class HyperlocalReturnscreenView extends StatelessWidget {
  final HyperLocalPreviewModel hyperlocalPreviewModel;
  final String reason;
  const HyperlocalReturnscreenView({
    Key? key,
    required this.hyperlocalPreviewModel,
    required this.reason,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalReturnscreenMobile(
          hyperlocalPreviewModel: hyperlocalPreviewModel,
          reason: reason,
        ),
        desktop: _HyperlocalReturnscreenDesktop(),
        tablet: _HyperlocalReturnscreenTablet(),
      );
    });
  }
}
