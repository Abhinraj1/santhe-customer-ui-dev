import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/pages/ondc/ondc_return_screens/widgets/return_reasons_listTile.dart';
import '../../../../manager/font_manager.dart';
import '../../../../widgets/custom_widgets/customScaffold.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';




class ONDCReturnSelectReasonScreen extends StatelessWidget {
  final bool? isFullCancellation;

  const ONDCReturnSelectReasonScreen({Key? key,
  this.isFullCancellation}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String orderId = "0123456",
        productName = "Nescafe classic coffee jar",
        productDetails = "250gm , 1  units";


    return  CustomScaffold(
      trailingButton: homeIconButton(),
      body: Column(
        children: [

          customTitleWithBackButton(
            title: "Return Request",
            context: context
          ),

          Text("Order ID  : $orderId",
          style: FontStyleManager().s16fw700,),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("You wish to return the following item: ",
                style: FontStyleManager().s16fw500,),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(productName,
                style: FontStyleManager().s16fw700Brown,),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(productDetails,
                style: FontStyleManager().s14fw500,),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 20),
            child: Text("Please select a reason for cancelling your order",
              style: FontStyleManager().s16fw500,),
          ),

         Expanded(
           child: ListView.builder(
             itemCount: 4,
               itemBuilder: (_ , index){
               return  returnReasonsListTile(
                 reason: "Product damaged or not in usable condition",
                   onTap: (){}
               );
               }),
         ),

          customButton(
            onTap: (){},
            buttonTitle: "NEXT",
            isActive: null,
            width: 200,
          )

        ],
      ),
    );
  }
}
