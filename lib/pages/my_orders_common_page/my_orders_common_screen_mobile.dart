import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/app_colors.dart';
import '../../manager/font_manager.dart';
import '../../manager/imageManager.dart';
import '../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../widgets/custom_widgets/home_icon_button.dart';
import '../hyperlocal/hyperlocal_previousorders/hyperlocal_previousorders_view.dart';
import '../ondc/ondc_customer_order_history_screen/ondc_order_history_view.dart';


class MyOrdersCommonScreen extends StatefulWidget {
  const MyOrdersCommonScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersCommonScreen> createState() =>
      _MyOrdersCommonScreenState();
}

class _MyOrdersCommonScreenState
    extends State<MyOrdersCommonScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:  Scaffold(
        resizeToAvoidBottomInset: false,
        key: _key,
        appBar: AppBar(
          title:
          AutoSizeText("Santhe", style: FontStyleManager().kAppNameStyle),
          bottom: TabBar(
            labelStyle: FontStyleManager().s18fw700White,
            indicatorColor: AppColors().white100,
            labelPadding: const EdgeInsets.symmetric(vertical: 10),
            indicatorWeight: 5,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 23),
            tabs: const [
              Text(
                "HyperLocal Orders",
              ),
              Text(
                "ONDC Orders",
              )
            ],
          ),
          actions: [homeIconButton()],
          leadingWidth: 30,
          leading: const CustomBackButton(invertColors: true),

        ),
       // drawer: CustomDrawer(),
        body: const TabBarView(
          children: [HyperlocalPreviousordersView(), ONDCOrderHistoryView()],
        ),
      ),
    );
  }
}
