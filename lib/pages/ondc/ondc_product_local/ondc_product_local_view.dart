// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
library ondc_product_local_view;

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
import 'package:santhe/models/ondc/shop_model.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;
import 'package:santhe/widgets/ondc_widgets/ondc_product_widget.dart';

part 'ondc_product_local_desktop.dart';
part 'ondc_product_local_mobile.dart';
part 'ondc_product_local_tablet.dart';

class OndcProductLocalView extends StatelessWidget {
  final ShopModel shopModel;
  List<ProductOndcModel> productModels;
  List<OndcProductWidget> productWidget;
  String productName;
  OndcProductLocalView({
    Key? key,
    required this.shopModel,
    required this.productModels,
    required this.productWidget,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _OndcProductLocalMobile(
          shopModel: shopModel,
          productOndcModel: productModels,
          productWidget: productWidget,
          productName: productName,
        ),
        desktop: _OndcProductLocalDesktop(),
        tablet: _OndcProductLocalTablet(),
      );
    });
  }
}
