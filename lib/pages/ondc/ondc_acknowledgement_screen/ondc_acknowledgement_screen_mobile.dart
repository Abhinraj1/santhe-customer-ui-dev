import 'package:flutter/material.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_button.dart';

import '../../../manager/font_manager.dart';
import '../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../widgets/custom_widgets/home_icon_button.dart';



class ONDCAcknowledgementScreenMobile extends StatelessWidget {
  final String message;
  final String title;
  final String orderNumber;
  final Function() onTap;

  const ONDCAcknowledgementScreenMobile({Key? key,
    required this.message,
    required this.title,
    required this.onTap,
    required this.orderNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
        trailingButton: homeIconButton(),
        body: Column(
          children: [
            CustomTitleWithBackButton(
              title: title,
              onTapBackButton: (){
                onTap();
              },
            ),
            Text(
              "Order ID  : $orderNumber",
              style: FontStyleManager().s16fw700,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
              ),
              child: Text(
                message,
                style: FontStyleManager().s16fw500,
              ),
            ),
            const Spacer(),
            CustomButton(
              onTap: () {
                onTap();
              },
              width: 160,
              verticalPadding: 40,
              buttonTitle: "Back",
            )
          ],
        ));
  }
}
