import 'package:flutter/material.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_button.dart';

import '../../../../manager/font_manager.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';

class ONDCReturnAcknowledgement extends StatelessWidget {
  final String? message;
  final String? title;
  const ONDCReturnAcknowledgement({Key? key, this.message, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String orderId = "0123456",
        message1 = "Your return request is received,"
            " Once we have received a confirmation from "
            "the seller you will get an update from us on"
            " the return  status and refund details";

    return CustomScaffold(
        trailingButton: homeIconButton(),
        body: Column(
          children: [
            CustomTitleWithBackButton(
              title: title ?? "Return Request",
            ),
            Text(
              "Order ID  : $orderId",
              style: FontStyleManager().s16fw700,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
              ),
              child: Text(
                message ?? message1,
                style: FontStyleManager().s16fw500,
              ),
            ),
            const Spacer(),
            CustomButton(
              onTap: () {},
              width: 160,
              verticalPadding: 40,
              buttonTitle: "Back",
            )
          ],
        ));
  }
}
