// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_cancelreason_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as ge;
import 'package:responsive_builder/responsive_builder.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

part 'hyperlocal_cancelreason_desktop.dart';
part 'hyperlocal_cancelreason_mobile.dart';
part 'hyperlocal_cancelreason_tablet.dart';

class HyperlocalCancelreasonView extends StatelessWidget {
  final String orderID;
  const HyperlocalCancelreasonView({
    Key? key,
    required this.orderID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalCancelreasonMobile(
          orderId: orderID,
        ),
        desktop: _HyperlocalCancelreasonDesktop(),
        tablet: _HyperlocalCancelreasonTablet(),
      );
    });
  }
}
