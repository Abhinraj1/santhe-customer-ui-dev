library ondc_search_global_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

part 'ondc_search_global_mobile.dart';
part 'ondc_search_global_tablet.dart';
part 'ondc_search_global_desktop.dart';

class OndcSearchGlobalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ScreenTypeLayout(
          mobile: _OndcSearchGlobalMobile(),
          desktop: _OndcSearchGlobalDesktop(),
          tablet: _OndcSearchGlobalTablet(),  
        );
      }
    );
  }
}