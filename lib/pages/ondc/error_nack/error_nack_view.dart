// ignore_for_file: public_member_api_docs, sort_constructors_first
library error_nack_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/blocs/checkout/checkout_bloc.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

part 'error_nack_desktop.dart';
part 'error_nack_mobile.dart';
part 'error_nack_tablet.dart';

class ErrorNackView extends StatelessWidget {
  final String message;
  const ErrorNackView({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _ErrorNackMobile(message: message),
        desktop: _ErrorNackDesktop(),
        tablet: _ErrorNackTablet(),
      );
    });
  }
}
