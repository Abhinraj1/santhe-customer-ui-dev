import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';

import '../../../core/blocs/ondc/ondc_order_history_bloc/ondc_order_history_bloc.dart';
import '../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../widgets/ondc_customer_order_history_widgets/order_history_list.dart';
import '../../../widgets/ondc_customer_order_history_widgets/select_date_filter.dart';
import '../ondc_intro/ondc_intro_view.dart';


class ONDCOrderHistoryMobile extends StatelessWidget {
  const ONDCOrderHistoryMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: AppColors().grey10,
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
             child:
             Text("Below are the orders your have placed on ONDC Shops",
               style: FontStyleManager().s14fw700Orange,),
    ),

            Divider(
              thickness: 1,
              color: AppColors().grey40,
            ),

            const SelectDateFilter(),
             OrderHistoryList(),

            Obx( () {
              if(myOrdersLoading.value){
                return const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator(),
                );
              }else{
                return const SizedBox();
              }

              }
            ),
           // CircularProgressIndicator()
          ],
        )
    );
  }
}
