// ignore_for_file: public_member_api_docs, sort_constructors_first
library hyperlocal_orderdetail_view;

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_checkout/hyperlocal_checkout_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/hyperlocal_checkoutrepository.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_previewmodel.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;
import 'package:santhe/widgets/ondc_order_details_widgets/cancel_order_button.dart';
import 'package:santhe/widgets/ondc_order_details_widgets/customer_support_button.dart';

import '../../../widgets/hyperlocal_widgets/hyperlocal_previewwidget.dart';

part 'hyperlocal_orderdetail_desktop.dart';
part 'hyperlocal_orderdetail_mobile.dart';
part 'hyperlocal_orderdetail_tablet.dart';

class HyperlocalOrderdetailView extends StatelessWidget {
  final String storeDescriptionId;
  const HyperlocalOrderdetailView({
    Key? key,
    required this.storeDescriptionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalOrderdetailMobile(
          shopDescriptionId: storeDescriptionId,
        ),
        desktop: const _HyperlocalOrderdetailDesktop(),
        tablet: const _HyperlocalOrderdetailTablet(),
      );
    });
  }
}
