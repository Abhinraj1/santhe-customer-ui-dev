library hyperlocal_errornack_view;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/widgets/navigation_drawer_widget.dart' as nv;

part 'hyperlocal_errornack_mobile.dart';
part 'hyperlocal_errornack_tablet.dart';
part 'hyperlocal_errornack_desktop.dart';

class HyperlocalErrornackView extends StatelessWidget {
  const HyperlocalErrornackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalErrornackMobile(),
        desktop: _HyperlocalErrornackDesktop(),
        tablet: _HyperlocalErrornackTablet(),
      );
    });
  }
}
