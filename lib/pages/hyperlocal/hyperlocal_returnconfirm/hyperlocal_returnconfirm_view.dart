library hyperlocal_returnconfirm_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;
import 'package:get/get.dart' as ge;

import '../../../core/repositories/hyperlocal_checkoutrepository.dart';
import '../hyperlocal_orderdetail/hyperlocal_orderdetail_view.dart';

part 'hyperlocal_returnconfirm_mobile.dart';
part 'hyperlocal_returnconfirm_tablet.dart';
part 'hyperlocal_returnconfirm_desktop.dart';

class HyperlocalReturnconfirmView extends StatelessWidget {
  const HyperlocalReturnconfirmView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalReturnconfirmMobile(),
        desktop: _HyperlocalReturnconfirmDesktop(),
        tablet: _HyperlocalReturnconfirmTablet(),
      );
    });
  }
}
