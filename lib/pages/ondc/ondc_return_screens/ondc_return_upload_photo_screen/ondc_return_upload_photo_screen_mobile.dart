import 'package:flutter/material.dart';
import 'package:santhe/pages/ondc/ondc_return_screens/widgets/image_grid.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import '../../../../manager/font_manager.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';



class ONDCOrderUploadPhotoScreenMobile extends StatelessWidget {
  final bool? isFullCancellation;
  const ONDCOrderUploadPhotoScreenMobile({Key? key,
  this.isFullCancellation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String orderId = "0123456",
     productName = "Nescafe classic coffee jar",
    productDetails = "250gm , 1  units";

    return
      CustomScaffold(
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
                padding: const EdgeInsets.only(top: 30),
                child: Text("Upload Pictures",
                  style: FontStyleManager().s16fw700,),
              ),

              imageGrid(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Please upload at least one picture "
                      "of the product showing any defects or damage",
                    style: FontStyleManager().s16fw500,),
                ),
              ),

              customButton(
                buttonTile: "RETURN ITEM",
                onTap: (){},
                isActive: false,
                width: 160,
                verticalPadding: 20
              )
            ],
          )
      );
  }
}
