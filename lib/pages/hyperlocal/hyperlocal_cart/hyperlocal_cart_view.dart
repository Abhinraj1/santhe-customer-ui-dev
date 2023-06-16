// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_cart_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/constants.dart';
import 'package:get/get.dart' as ge;
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_cart/hyperlocal_cart_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/hyperlocal_cartrepo.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_cartmodel.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_checkout/hyperlocal_checkout_view.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import 'package:santhe/widgets/hyperlocal_widgets/hyperlocal_cartwidget.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

import '../hyperlocal_shophome/hyperlocal_shophome_view.dart';

part 'hyperlocal_cart_desktop.dart';
part 'hyperlocal_cart_mobile.dart';
part 'hyperlocal_cart_tablet.dart';

class HyperlocalCartView extends StatelessWidget {
  final String storeDescriptionId;
  const HyperlocalCartView({
    Key? key,
    required this.storeDescriptionId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (child) {
      return ScreenTypeLayout(
        mobile: _HyperlocalCartMobile(
          storeDescriptionId: storeDescriptionId,
        ),
        desktop: _HyperlocalCartDesktop(),
        tablet: _HyperlocalCartTablet(),
      );
    });
  }
}
