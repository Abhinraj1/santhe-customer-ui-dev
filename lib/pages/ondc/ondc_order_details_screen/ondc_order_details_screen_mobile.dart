import 'package:flutter/material.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/widgets/cancel_order_button.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/widgets/customer_support_button.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/widgets/invoice_table.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/widgets/order_details_table.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/widgets/shipments_card.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/home_icon_button.dart';

import '../../../core/app_colors.dart';
import '../../../manager/font_manager.dart';
import '../../../widgets/custom_widgets/custom_title_with_back_button.dart';

class ONDCOrderDetailsScreen extends StatelessWidget {
  const ONDCOrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = "You have initiated return "
        "for one or more items in this order."
        " Waiting for return confirmation from seller";

    bool showCancelButton = true;
    return  CustomScaffold(
       trailingButton: homeIconButton(),
        backgroundColor: AppColors().grey10,
        body: ListView(
          children: [

            customTitleWithBackButton(
                title: "ORDER DETAILS",
                context: context
            ),
            orderDetailsTable(
              onTap: (){},
              firstTitle: "Shop",
              firstData: "Shop Name",
              secondTitle: "Oder ID",
              secondData: "0123456",
              thirdTitle: "Order status",
              thirdData: "created",
              fourthTitle: "Payment status",
              fourthData: "paid",
              redTextButtonTitle: "Download invoice"
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 20),
              child: Text(message,
                style: FontStyleManager().s16fw500,),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 10),
              child: Center(
                child: Text("Items",
                  style: FontStyleManager().s16fw600Orange,),
              ),
            ),

            shipmentCard(shipmentNumber: 1),
            invoiceTable(),
            customerSupportButton(
              onTap: (){}
            ),
            showCancelButton ?
            cancelOrderButton(
                onTap: (){}
            ) :
            const SizedBox(
              height: 20,
            ),


          ],
        )
    );
  }
}
