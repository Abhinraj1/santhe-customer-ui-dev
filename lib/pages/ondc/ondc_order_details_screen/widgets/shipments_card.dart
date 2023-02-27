import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/manager/imageManager.dart';
import '../../../../constants.dart';
import '../../../../core/app_colors.dart';

///
Widget shipmentCard(
    {required int shipmentNumber, required List<Widget> products}) {
  return Center(
    child: Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors().grey100, width: 1),
              borderRadius: BorderRadius.circular(customButtonBorderRadius)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: products,
            ),
          ),
        ),
        Positioned(
            top: -2,
            left: 30,
            child: Container(
                height: 20,
                width: 85,
                color: AppColors().grey10,
                child: Center(
                    child: Text(
                  "Shipment $shipmentNumber",
                  style: FontStyleManager().s14fw600Grey,
                )))),
      ],
    ),
  );
}

Widget productCell(
    {required String productName,
    required String productDetails,
    required String productPrice,
    required String productImg,
    bool? showStatus,
    String? status,
    String? textButtonTitle,
    Function()? textButtonOnTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          productImg != "null" && productImg != ""
              ? Image.network(
                  productImg,
                  width: 50,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  ImgManager().santheIcon,
                  width: 50,
                  height: 60,
                  fit: BoxFit.cover,
                ),
          SizedBox(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 200,
                    child: AutoSizeText(
                      productName,
                      style: FontStyleManager().s12fw700Brown,
                      maxLines: 2,
                    )),
                Text(
                  productDetails,
                  style: FontStyleManager().s10fw500Brown,
                ),
                showStatus ?? false
                    ? Text(
                        status.toString(),
                        style: FontStyleManager().s12fw500Grey,
                      )
                    : textButtonTitle != null && textButtonOnTap != null
                        ? TextButton(
                            onPressed: () {
                              textButtonOnTap();
                            },
                            child: Text(
                              textButtonTitle,
                              style: FontStyleManager().s12fw500Red,
                            ))
                        : const SizedBox(
                            height: 5,
                          ),
              ],
            ),
          ),
          Center(
              child: SizedBox(
            width: 50,
            child: AutoSizeText(
              productPrice,
              maxFontSize: 16,
              minFontSize: 12,
              style: FontStyleManager().s16fw600Grey,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )),
        ],
      ),
    ),
  );
}

Widget bottomTextRow({String? title, required String message}) {
  return Table(
    children: [
      TableRow(children: [
        Text(
          title ?? "Fulfilment status",
          style: FontStyleManager().s14fw600Grey,
        ),
        Text(
          message,
          style: FontStyleManager().s14fw600Grey,
          textAlign: TextAlign.right,
        ),
      ])
    ],
  );
}
