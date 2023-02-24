// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
library ondc_checkout_screen_view;

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:share_plus/share_plus.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/controllers/error_user_fallback.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/blocs/ondc_cart/cart_bloc.dart';
import 'package:santhe/core/cubits/customer_contact_cubit/customer_contact_cubit.dart';
import 'package:santhe/core/cubits/customer_contact_cubit/customer_contact_state.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/ondc_cart_repository.dart';
import 'package:santhe/core/repositories/ondc_checkout_repository.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import 'package:santhe/models/ondc/final_costing.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/ondc/payment_success/payment_success_view.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;
import 'package:santhe/widgets/ondc_widgets/preview_widget.dart';

import '../../../../core/blocs/checkout/checkout_bloc.dart';
import '../new/ondc_checkout_screen_mobile.dart';

part 'ondc_checkout_screen_desktop.dart';
part 'ondc_checkout_screen_mobile.dart';
part 'ondc_checkout_screen_tablet.dart';

class OndcCheckoutScreenView extends StatelessWidget {
  final String storeLocation_id;
  const OndcCheckoutScreenView({
    Key? key,
    required this.storeLocation_id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _OndcCheckoutScreenMobile(
          storeLocation_id: storeLocation_id,
        ),
        desktop: _OndcCheckoutScreenDesktop(),
        tablet: _OndcCheckoutScreenTablet(),
      );
    });
  }
}
