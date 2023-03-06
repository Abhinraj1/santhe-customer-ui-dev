import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../manager/font_manager.dart';
import '../../../../models/ondc/shop_model.dart';
import '../../../../widgets/custom_widgets/customScaffold.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
<<<<<<< HEAD
import '../../../../widgets/ondc_contact_support_widgets/shop_contact_support_card.dart';

=======
import '../widgets/shop_contact_support_card.dart';
>>>>>>> 878f2e9d5bbeb479e3e3b69b99b20d00d6d16657


class ONDCContactSupportShopContactDetailsScreen extends StatelessWidget {
 final ShopModel shopModel;
  const ONDCContactSupportShopContactDetailsScreen({Key? key,
  required this.shopModel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String orderId = "0123456";

    return CustomScaffold(
      backgroundColor: AppColors().grey20,
        body: Column(
      children: [
<<<<<<< HEAD
        const CustomTitleWithBackButton(
=======
        customTitleWithBackButton(
          context: context,
>>>>>>> 878f2e9d5bbeb479e3e3b69b99b20d00d6d16657
          title: "Contact Support"
        ),

        Center(
          child: SizedBox(
            width: 250,
            child: Text("Order ID  : $orderId",
              style: FontStyleManager().s16fw700,
            textAlign: TextAlign.center,),
          ),
        ),


        Padding(
          padding: const EdgeInsets.symmetric(vertical:30.0,horizontal: 50),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Below are the contact details of the seller ."
                " Please reach out to the seller using below details to report your issues. ",
              textAlign: TextAlign.center,
              style: FontStyleManager().s16fw500,),
          ),
        ),

<<<<<<< HEAD
        ShopContactSupportCard(
          model: shopModel
        ),

        CustomButton(
=======
        shopContactSupportCard(
          model: shopModel
        ),

        customButton(
>>>>>>> 878f2e9d5bbeb479e3e3b69b99b20d00d6d16657
          verticalPadding: 50,
          onTap: (){},
          buttonTitle: "Back"
        )
      ],
    ));
  }
}
