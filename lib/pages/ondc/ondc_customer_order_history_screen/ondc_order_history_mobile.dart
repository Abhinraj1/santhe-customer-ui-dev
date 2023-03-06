import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';

import '../../../widgets/ondc_customer_order_history_widgets/order_history_list.dart';
import '../../../widgets/ondc_customer_order_history_widgets/select_date_filter.dart';


class ONDCOrderHistoryMobile extends StatelessWidget {
  const ONDCOrderHistoryMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return  CustomScaffold(
      backgroundColor: AppColors().grey10,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0,
                  vertical: 30
              ),
              child: Text("Below are the orders your have placed on Santhe",
              style: FontStyleManager().s14fw700Orange,),
            ),
            Divider(
              thickness: 1,
              color: AppColors().grey40,
            ),
            const SelectDateFilter(),
            const OrderHistoryList()
          ],
        )
    );
  }
}
