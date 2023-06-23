import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/manager/font_manager.dart';

import '../../pages/ondc/ondc_webview_screen/ondc_webview_screen_view.dart';

class OrderListTable extends StatelessWidget {
  final String redTextButtonTitle,
      firstTitle,
      firstData,
      secondTitle,
      secondData,
      thirdTitle,
      thirdData,
      date;

  final String? invoiceUrl;

  final TextStyle? thirdDataTextStyle;
  final double? horizontalPadding, verticalPadding;

  const OrderListTable(
      {Key? key,
        required this.redTextButtonTitle,
        required this.firstTitle,
        required this.firstData,
        required this.secondTitle,
        required this.secondData,
        required this.thirdTitle,
        required this.thirdData,
        required this.date,
        this.horizontalPadding,
        this.verticalPadding,
        this.thirdDataTextStyle,
        this.invoiceUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 15.0,
          vertical: verticalPadding ?? 0.0),
      child: Table(
        children: [
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Date",
                style: FontStyleManager().s14fw800Grey,
              ),
            ),
            Text(date ?? " ",
                style: FontStyleManager().s14fw700Grey,
                textAlign: TextAlign.right),
          ]),
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                firstTitle,
                style: FontStyleManager().s14fw800Grey,
              ),
            ),
            Text(firstData,
                style: FontStyleManager().s14fw700Grey,
                textAlign: TextAlign.right),
          ]),
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                secondTitle,
                style: FontStyleManager().s14fw800Grey,
              ),
            ),
            Text(secondData,
                style: FontStyleManager().s14fw700Grey,
                textAlign: TextAlign.right),
          ]),
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                thirdTitle,
                style: FontStyleManager().s14fw800Grey,
              ),
            ),
            Text(thirdData,
                style: thirdDataTextStyle ?? FontStyleManager().s14fw700Grey,
                textAlign: TextAlign.right),
          ]),
          TableRow(children: [
            const SizedBox(),
            invoiceUrl != null
                ? InkWell(
              onTap: () {
                Get.to(() => ONDCWebviewView(
                  url: invoiceUrl ?? "",
                  title: "DownLoad Invoice",
                ));
              },
              child: Text(redTextButtonTitle,
                  style: FontStyleManager().s12fw500Red,
                  textAlign: TextAlign.right),
            )
                : Text(redTextButtonTitle,
                style: FontStyleManager().s12fw500Red,
                textAlign: TextAlign.right),
          ]),
        ],
      ),
    );
  }
}
