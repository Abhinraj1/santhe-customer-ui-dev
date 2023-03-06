import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/core/app_colors.dart';
import '../../../../core/blocs/ondc/ondc_bloc.dart';
import '../../../../manager/font_manager.dart';
import '../../../../models/ondc/order_cancel_reasons_model.dart';
import '../../../../widgets/custom_widgets/customScaffold.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../../widgets/ondc_return_widgets/return_reasons_listTile.dart';




class ONDCReturnSelectReasonScreen extends StatelessWidget {
  const ONDCReturnSelectReasonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String orderId = "0123456",
        productName = "Nescafe classic coffee jar",
        productDetails = "250gm , 1  units";


    return  CustomScaffold(
      trailingButton: homeIconButton(),
      body: Column(
        children: [

          const CustomTitleWithBackButton(
            title: "Return Request",
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

         // Expanded(
         //   child: ListView.builder(
         //     itemCount: 4,
         //       itemBuilder: (_ , index){
         //       return  ReturnReasonsListTile(
         //         reason: "Product damaged or not in usable condition",
         //           onTap: (){},
         //       );
         //       }),
         // ),
        Expanded(
          child: ReturnReasonsListTile(

            reasons:[ ReasonsModel()],
          ),
        ),
          CustomButton(
            onTap: (){

            },
            buttonTitle: "NEXT",
            isActive: null,
            width: 200,
          )

        ],
      ),
    );
  }
}
