import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';

import '../../../../constants.dart';
import '../../../../manager/font_manager.dart';
import '../../../../widgets/ondc_order_details_widgets/order_details_table.dart';

class OrderHistoryList extends StatelessWidget {
  const OrderHistoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Expanded(
      child: SizedBox(
        width: 300,
        child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index){
              return OrderHistoryCell(
                onTap: () {  },
              );
            }),
      ),
    );
  }
}


class OrderHistoryCell extends StatelessWidget {
  final Function() onTap;
  const OrderHistoryCell({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Container(
      width: 320,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors().white100,
        borderRadius: BorderRadius.circular(kTextFieldCircularBorderRadius),
      ),
      child: OrderDetailsTable(
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
}



