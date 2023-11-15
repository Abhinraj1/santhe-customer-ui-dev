library razorpaybuffer_view;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/blocs/checkout/checkout_bloc.dart';
import 'package:santhe/core/loggers.dart';

part 'razorpaybuffer_mobile.dart';
part 'razorpaybuffer_tablet.dart';
part 'razorpaybuffer_desktop.dart';

class RazorpaybufferView extends StatelessWidget {
  const RazorpaybufferView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _RazorpaybufferMobile(),
        desktop: _RazorpaybufferDesktop(),
        tablet: _RazorpaybufferTablet(),
      );
    });
  }
}
