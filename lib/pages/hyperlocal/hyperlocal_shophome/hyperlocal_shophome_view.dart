library hyperlocal_shophome_view;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:santhe/core/blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';

part 'hyperlocal_shophome_mobile.dart';
part 'hyperlocal_shophome_tablet.dart';
part 'hyperlocal_shophome_desktop.dart';

class HyperlocalShophomeView extends StatelessWidget {
  const HyperlocalShophomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _HyperlocalShophomeMobile(),
        desktop: _HyperlocalShophomeDesktop(),
        tablet: _HyperlocalShophomeTablet(),
      );
    });
  }
}
