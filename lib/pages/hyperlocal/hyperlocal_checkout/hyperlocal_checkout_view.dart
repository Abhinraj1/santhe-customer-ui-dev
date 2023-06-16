// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
library hyperlocal_checkout_view;

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/controllers/error_user_fallback.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_checkout/hyperlocal_checkout_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/address_repository.dart';
import 'package:santhe/core/repositories/hyperlocal_checkoutrepository.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_paymentmodel.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_previewmodel.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_errornack/hyperlocal_errornack_view.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_paymentsucess/hyperlocal_paymentsucess_view.dart';
import 'package:santhe/pages/ondc/map_text/map_text_view.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import 'package:santhe/widgets/hyperlocal_widgets/hyperlocal_previewwidget.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;
import 'package:santhe/widgets/ondc_checkout_widgets/address_column.dart';

part 'hyperlocal_checkout_desktop.dart';
part 'hyperlocal_checkout_mobile.dart';
part 'hyperlocal_checkout_tablet.dart';

class HyperlocalCheckoutView extends StatelessWidget {
  final String storeDescription_id;
  final String storeName;
  const HyperlocalCheckoutView({
    Key? key,
    required this.storeDescription_id,
    required this.storeName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalCheckoutMobile(
          storeDescription_id: storeDescription_id,
          storeName: storeName,
        ),
        desktop: const _HyperlocalCheckoutDesktop(),
        tablet: const _HyperlocalCheckoutTablet(),
      );
    });
  }
}
