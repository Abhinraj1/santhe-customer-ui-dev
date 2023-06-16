library hyperlocal_returnconfirm_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

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
