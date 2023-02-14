import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';

import '../../../../constants.dart';
import '../../../../manager/font_manager.dart';
import '../../ondc_order_details_screen/widgets/order_details_table.dart';

Widget orderHistoryList({required BuildContext context}){
  
  return Expanded(
    child: SizedBox(
      width: 300,
      child: ListView.builder(
        itemCount: 4,
          itemBuilder: (context, index){
          return orderHistoryCell(
            () {},
          );
          }),
    ),
  );
}

Widget orderHistoryCell(Function() onTap){

  return Container(
    width: 300,
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
    color: AppColors().white100,
    borderRadius: BorderRadius.circular(kTextFieldCircularBorderRadius),
    ),
    child: orderDetailsTable(
        onTap: (){},
        firstTitle: "Shop",
        firstData: "Shop Name",
        secondTitle: "Oder ID",
        secondData: "0123456",
        thirdTitle: "Order status",
        thirdData: "created",
        fourthTitle: "Order Date",
        fourthData: "09/2/2023",
        redTextButtonTitle: "Details",
      horizontalPadding: 15,
      verticalPadding: 10.0
    ),
  );
}