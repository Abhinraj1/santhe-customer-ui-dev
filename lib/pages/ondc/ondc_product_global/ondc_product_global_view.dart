// ignore_for_file: public_member_api_docs, sort_constructors_first
library ondc_product_global_view;

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as ge;
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/ondc/ondc_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/widgets/ondc_widgets/ondc_shop_widget.dart';

import '../../../widgets/navigation_drawer_widget.dart';
import '../../../widgets/ondc_widgets/ondc_product_widget.dart';

part 'ondc_product_global_desktop.dart';
part 'ondc_product_global_mobile.dart';
part 'ondc_product_global_tablet.dart';

class OndcProductGlobalView extends StatelessWidget {
  final CustomerModel customerModel;
  final List<OndcProductWidget> productWidget;
  final List<ProductOndcModel> productOndcModel;
  String productName;
  OndcProductGlobalView({
    Key? key,
    required this.customerModel,
    required this.productWidget,
    required this.productOndcModel,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _OndcProductGlobalMobile(
          customerModel: customerModel,
          productWidget: productWidget,
          productOndcModel: productOndcModel,
          productName: productName,
        ),
        desktop: _OndcProductGlobalDesktop(),
        tablet: _OndcProductGlobalTablet(),
      );
    });
  }
}
