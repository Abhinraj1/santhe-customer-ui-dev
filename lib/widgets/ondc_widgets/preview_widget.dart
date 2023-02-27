// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:santhe/core/app_colors.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/manager/imageManager.dart';
import 'package:santhe/models/ondc/preview_ondc_cart_model.dart';

class PreviewWidgetOndcItem extends StatelessWidget {
  final PreviewWidgetModel previewWidgetModel;
  const PreviewWidgetOndcItem({
    Key? key,
    required this.previewWidgetModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            previewWidgetModel.symbol != null && previewWidgetModel.symbol != ""
                ? Image.network(
                    previewWidgetModel.symbol,
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
                        previewWidgetModel.title,
                        style: FontStyleManager().s12fw700Brown,
                        maxLines: 2,
                      )),

                  Text(
                    '${previewWidgetModel.quantity}',
                    style: FontStyleManager().s10fw500Brown,
                  ),
                  //  showStatus ?? false ?
                  //  Text(status.toString(),style: FontStyleManager().s12fw500Grey,) :
                  //  textButtonTitle != null && textButtonOnTap != null ?
                  //      TextButton(
                  //          onPressed: (){
                  //            textButtonOnTap();
                  //          },
                  //          child: Text(textButtonTitle,
                  //          style: FontStyleManager().s12fw500Red,),) :
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: 50,
                child: AutoSizeText(
                  "${previewWidgetModel.price}",
                  maxFontSize: 16,
                  minFontSize: 12,
                  style: FontStyleManager().s16fw600Grey,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
