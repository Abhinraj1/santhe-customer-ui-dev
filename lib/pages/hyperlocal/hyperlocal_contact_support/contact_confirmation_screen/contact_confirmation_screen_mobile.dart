import 'package:flutter/material.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_button.dart';

import '../../../../manager/font_manager.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';





class HyperlocalContactConfirmationScreenMobile extends StatelessWidget {
  final String message;
  final String orderNumber;


  const HyperlocalContactConfirmationScreenMobile({Key? key,
    required this.message,
    required this.orderNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
        trailingButton: homeIconButton(),
        body: Column(
          children: [
            const CustomTitleWithBackButton(
              title: "Contact Support",
              // onTapBackButton: (){
              // //  onBack();
              // },
            ),
            Text(
              "Order ID  : $orderNumber",
              style: FontStyleManager().s16fw700,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 50
              ),
              child: Text(
                "Thanks for contacting support. We have created a "
                    "ticket for your query and sent you an email with details.",
                style: FontStyleManager().s16fw500,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "*Minimum Resolution time 72 hours",
              style: FontStyleManager().s18fw400ItalicGrey,
            ),
            const Spacer(),
            CustomButton(
              onTap: () {
               // onBack();
              },
              width: 160,
              verticalPadding: 40,
              buttonTitle: "Back",
            )
          ],
        ));
  }
}
