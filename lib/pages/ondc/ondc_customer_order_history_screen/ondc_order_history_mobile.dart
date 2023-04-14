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


class ONDCOrderHistoryMobile extends StatefulWidget {
  const ONDCOrderHistoryMobile({Key? key}) : super(key: key);

  @override
  State<ONDCOrderHistoryMobile> createState() => _ONDCOrderHistoryMobileState();
}

class _ONDCOrderHistoryMobileState extends State<ONDCOrderHistoryMobile> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<OrderHistoryBloc>(context).add
      (const LoadPastOrderDataEvent());
  }
  @override
  Widget build(BuildContext context) {

    return  CustomScaffold(
      backgroundColor: AppColors().grey10,
        trailingButton:  homeIconButton(),
        body: Column(
          children: [
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
             child: Row(
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: AppColors().brandDark,
              radius: 13,
              child: const Padding(
                padding: EdgeInsets.only(left: 7.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),

          SizedBox(
            width: 270,
            child: Text("Below are the orders your have placed on Santhe",
              style: FontStyleManager().s14fw700Orange,),
          ),
          const Spacer(),
        ],
      ),
    ),

            Divider(
              thickness: 1,
              color: AppColors().grey40,
            ),

            ///Need to be removed
            // ElevatedButton(
            //     onPressed: (){
            //
            //     },
            //     child: Text("PRESS")),


            const SelectDateFilter(),
            const OrderHistoryList()
          ],
        )
    );
  }
}
