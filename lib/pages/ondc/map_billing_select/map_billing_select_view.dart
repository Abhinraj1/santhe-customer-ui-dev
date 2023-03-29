library map_billing_select_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'map_billing_select_mobile.dart';
part 'map_billing_select_tablet.dart';
part 'map_billing_select_desktop.dart';

class MapBillingSelectView extends StatelessWidget {
  const MapBillingSelectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _MapBillingSelectMobile(),
        desktop: _MapBillingSelectDesktop(),
        tablet: _MapBillingSelectTablet(),
      );
    });
  }
}
