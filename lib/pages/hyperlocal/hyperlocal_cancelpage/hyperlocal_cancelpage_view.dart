// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_cancelpage_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as ge;
import 'package:responsive_builder/responsive_builder.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_cancelReturn/hyperlocal_cancel_return_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_cancel.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_cancelreason/hyperlocal_cancelreason_view.dart';
import 'package:santhe/widgets/hyperlocal_widgets/hyperlocal_cancelwidget.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

part 'hyperlocal_cancelpage_desktop.dart';
part 'hyperlocal_cancelpage_mobile.dart';
part 'hyperlocal_cancelpage_tablet.dart';

class HyperlocalCancelpageView extends StatelessWidget {
  final String orderId;
  const HyperlocalCancelpageView({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalCancelpageMobile(
          orderID: orderId,
        ),
        desktop: _HyperlocalCancelpageDesktop(),
        tablet: _HyperlocalCancelpageTablet(),
      );
    });
  }
}
