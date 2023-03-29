library map_text_billing_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:santhe/API/addressSearchAPI.dart';

part 'map_text_billing_mobile.dart';
part 'map_text_billing_tablet.dart';
part 'map_text_billing_desktop.dart';

class MapTextBillingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _MapTextBillingMobile(),
        desktop: _MapTextBillingDesktop(),
        tablet: _MapTextBillingTablet(),
      );
    });
  }
}
