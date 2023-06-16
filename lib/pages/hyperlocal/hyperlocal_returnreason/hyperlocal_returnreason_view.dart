library hyperlocal_returnreason_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'hyperlocal_returnreason_mobile.dart';
part 'hyperlocal_returnreason_tablet.dart';
part 'hyperlocal_returnreason_desktop.dart';

class HyperlocalReturnreasonView extends StatelessWidget {
  const HyperlocalReturnreasonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalReturnreasonMobile(),
        desktop: _HyperlocalReturnreasonDesktop(),
        tablet: _HyperlocalReturnreasonTablet(),
      );
    });
  }
}
