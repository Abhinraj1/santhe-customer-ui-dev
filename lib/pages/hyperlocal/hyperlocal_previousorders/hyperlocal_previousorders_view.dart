library hyperlocal_previousorders_view;

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_orderhistory/hyperlocal_orderhistory_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_orderdetail.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_shophome/hyperlocal_shophome_view.dart';
import 'package:santhe/widgets/hyperlocal_widgets/hyperlocal_orderdetailwidget.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart';

import '../../../manager/font_manager.dart';

part 'hyperlocal_previousorders_mobile.dart';
part 'hyperlocal_previousorders_tablet.dart';
part 'hyperlocal_previousorders_desktop.dart';

class HyperlocalPreviousordersView extends StatelessWidget {
  const HyperlocalPreviousordersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalPreviousordersMobile(),
        desktop: _HyperlocalPreviousordersDesktop(),
        tablet: _HyperlocalPreviousordersTablet(),
      );
    });
  }
}
