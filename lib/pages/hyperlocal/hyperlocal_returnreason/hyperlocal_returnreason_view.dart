// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_returnreason_view;

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_returnscreen/hyperlocal_returnscreen_view.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;
import 'package:get/get.dart' as ge;

import 'package:santhe/models/hyperlocal_models/hyperlocal_previewmodel.dart';

import '../../../core/blocs/hyperlocal/hyperlocal_cancelReturn/hyperlocal_cancel_return_bloc.dart';
import '../../../models/hyperlocal_models/hyperlocal_cancel.dart';
import '../../../widgets/hyperlocal_widgets/hyperlocal_cancelwidget.dart';

part 'hyperlocal_returnreason_desktop.dart';
part 'hyperlocal_returnreason_mobile.dart';
part 'hyperlocal_returnreason_tablet.dart';

class HyperlocalReturnreasonView extends StatelessWidget {
  final HyperLocalPreviewModel hyperlocalPreviewModel;
  const HyperlocalReturnreasonView({
    Key? key,
    required this.hyperlocalPreviewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalReturnreasonMobile(
          hyperlocalPreviewModel: hyperlocalPreviewModel,
        ),
        desktop: _HyperlocalReturnreasonDesktop(),
        tablet: _HyperlocalReturnreasonTablet(),
      );
    });
  }
}
