library hyperlocal_returnscreen_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'hyperlocal_returnscreen_mobile.dart';
part 'hyperlocal_returnscreen_tablet.dart';
part 'hyperlocal_returnscreen_desktop.dart';

class HyperlocalReturnscreenView extends StatelessWidget {
  const HyperlocalReturnscreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalReturnscreenMobile(),
        desktop: _HyperlocalReturnscreenDesktop(),
        tablet: _HyperlocalReturnscreenTablet(),
      );
    });
  }
}
