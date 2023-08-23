// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/app_colors.dart';

import 'package:santhe/models/hyperlocal_models/hyperlocal_orderdetail.dart';
import 'package:santhe/pages/hyperlocal/hyperlocal_orderdetail/hyperlocal_orderdetail_view.dart';
import 'package:santhe/widgets/ondc_order_details_widgets/order_details_table.dart';

import 'hyperlocal_orders_list_table.dart';

class HyperlocalOrderDetailWidget extends StatefulWidget {
  final HyperlocalOrderDetailModel hyperlocalOrderDetailModel;
  const HyperlocalOrderDetailWidget({
    Key? key,
    required this.hyperlocalOrderDetailModel,
  }) : super(key: key);

  @override
  State<HyperlocalOrderDetailWidget> createState() =>
      _HyperlocalOrderDetailWidgetState();
}

class _HyperlocalOrderDetailWidgetState
    extends State<HyperlocalOrderDetailWidget> {
  dynamic formattedDate;

  getFormattedData() {
    dynamic newFormattedDate =
        DateTime.parse(widget.hyperlocalOrderDetailModel.createdAt);
    formattedDate = DateFormat.yMd().format(newFormattedDate);
  }

  @override
  void initState() {
    widget.hyperlocalOrderDetailModel.getFormattedData();
    getFormattedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors().white100,
        borderRadius: BorderRadius.circular(kTextFieldCircularBorderRadius),
      ),
      child: InkWell(
        onTap: () {
          Get.to(
            () => HyperlocalOrderdetailView(
              // storeDescriptionId:
              //     widget.hyperlocalOrderDetailModel.storeDescriptionId,
              orderId: widget.hyperlocalOrderDetailModel.id,
            ),
          );
        },
        child:
        OrderListTable(
            date: formattedDate,
            // firstTitle: "Shop",
            // firstData: widget.hyperlocalOrderDetailModel.customerNamel,
            firstTitle: "Order ID",
            firstData: widget.hyperlocalOrderDetailModel.order_id,
            secondTitle: "Order status",
            secondData: widget.hyperlocalOrderDetailModel.statesTitle,
            thirdTitle: "Order Date",
            thirdData: formattedDate,
            redTextButtonTitle: "Details",
            horizontalPadding: 15,
            verticalPadding: 10.0),
      ),
    );
  }
}
