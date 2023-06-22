// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/hyperlocal_checkoutrepository.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/manager/imageManager.dart';

import 'package:santhe/models/hyperlocal_models/hyperlocal_previewmodel.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_returnreason/hyperlocal_returnreason_view.dart';

import 'hyperlocal_text_expanded_dialog.dart';

class HyperlocalPreviewWidget extends StatefulWidget {
  final HyperLocalPreviewModel hyperLocalPreviewModel;
  const HyperlocalPreviewWidget({
    Key? key,
    required this.hyperLocalPreviewModel,
  }) : super(key: key);

  @override
  State<HyperlocalPreviewWidget> createState() =>
      _HyperlocalPreviewWidgetState();
}

class _HyperlocalPreviewWidgetState extends State<HyperlocalPreviewWidget>
    with LogMixin {
  late final Map quantity;
  late final dynamic mapQuantity;
  getQuantity() {
    quantity = json.decode(
      widget.hyperLocalPreviewModel.quantity.toString(),
    );
    errorLog('Quantity $quantity');
    mapQuantity = quantity['value'].toString() + quantity['unit'];
    errorLog('Final quantity $mapQuantity');
  }

  @override
  void initState() {
    super.initState();
    getQuantity();
  }

  @override
  Widget build(BuildContext context) {
    warningLog(
        'Order Status ${RepositoryProvider.of<HyperLocalCheckoutRepository>(context).shopOrderStatus} checking for returnable ${widget.hyperLocalPreviewModel.returnable} and checking for status ${widget.hyperLocalPreviewModel.status}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Card(
        color: CupertinoColors.systemBackground,
        shadowColor: CupertinoColors.systemBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        // elevation: 8.0,
        // margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // const SizedBox(
            //   height: 100,
            // ),
            widget.hyperLocalPreviewModel.symbol != null &&
                    widget.hyperLocalPreviewModel.symbol != ""
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.hyperLocalPreviewModel.symbol,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        ImgManager().santheIcon,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      ImgManager().santheIcon,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.hyperLocalPreviewModel.status
                                .toString()
                                .contains('Delivered') &&
                            widget.hyperLocalPreviewModel.returnable
                                .toString()
                                .contains('true')
                        ? const SizedBox(
                            height: 10,
                          )
                        : const SizedBox(
                            height: 10,
                          ),
                    SizedBox(
                        width: 120,
                        child: AutoSizeText(
                          widget.hyperLocalPreviewModel.title,
                          style: FontStyleManager().s12fw700Brown,
                          maxLines: 2,
                        )),

                    Text(
                      '${widget.hyperLocalPreviewModel.units} * $mapQuantity',
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
                      height: 3,
                    ),
                    widget.hyperLocalPreviewModel.status
                            .toString()
                            .contains('Created')
                        ? const SizedBox()
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              'Status: ${widget.hyperLocalPreviewModel.status}',
                              style: FontStyleManager().s10fw500Brown,
                            ),
                          ),
                    widget.hyperLocalPreviewModel.reason != null
                        ? InkWell(
                      onTap: (){
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return textExpandFunction(text:widget.hyperLocalPreviewModel.reason);
                          },
                        );
                      },
                          child: Expanded(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: AutoSizeText(
                                  'Reason: ${widget.hyperLocalPreviewModel.reason}',
                                  style: TextStyle(color: AppColors().grey100,),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                        )
                        : const SizedBox(),
                    widget.hyperLocalPreviewModel.status
                                .toString()
                                .contains('Delivered') &&
                            widget.hyperLocalPreviewModel.returnable
                                .toString()
                                .contains('true')
                        ? Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  HyperlocalReturnreasonView(
                                    hyperlocalPreviewModel:
                                        widget.hyperLocalPreviewModel,
                                  ),
                                );
                              },
                              child: Text('Return',
                                  style: FontStyleManager().s14fwUnderline),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Center(
                child: SizedBox(
                  width: 70,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(
                      "₹ ${widget.hyperLocalPreviewModel.price}",
                      maxFontSize: 14,
                      minFontSize: 12,
                      style: FontStyleManager().s16fw600Grey,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
