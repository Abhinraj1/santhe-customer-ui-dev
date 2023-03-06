library error_nack_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

part 'error_nack_mobile.dart';
part 'error_nack_tablet.dart';
part 'error_nack_desktop.dart';

class ErrorNackView extends StatelessWidget {
  const ErrorNackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _ErrorNackMobile(),
        desktop: _ErrorNackDesktop(),
        tablet: _ErrorNackTablet(),
      );
    });
  }
}
