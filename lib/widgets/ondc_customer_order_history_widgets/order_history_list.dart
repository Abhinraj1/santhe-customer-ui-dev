import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/ondc_order_details_view.dart';
import '../../../../constants.dart';
import '../../../../manager/font_manager.dart';
import '../../../../widgets/ondc_order_details_widgets/order_details_table.dart';
import '../../core/blocs/ondc/ondc_order_history_bloc/ondc_order_history_bloc.dart';
import '../../core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_cubit.dart';
import '../../models/ondc/single_order_model.dart';
import '../../pages/ondc/api_error/api_error_view.dart';

class OrderHistoryList extends StatelessWidget {
  const OrderHistoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Expanded(
        child: BlocConsumer<OrderHistoryBloc, OrderHistoryState>(
          listener: (context, state) {
            // TODO: implement listener

            if(state is SingleOrderErrorState){

              Get.to(()=> const ApiErrorView(),);

            }
          },
          builder: (context, state) {

                  if (state is SingleOrderErrorState) {
                    return Center(child: Text(state.message));
                  }
                  else if (state is PastOrderDataLoadedState) {
                    return listBody(orderDetails: state.orderDetails);
                  } else if (state is SevenDaysFilterState) {
                    return listBody(orderDetails: state.orderDetails);
                  } else if (state is ThirtyDaysFilterState) {
                    return listBody(orderDetails: state.orderDetails);
                  } else if (state is CustomDaysFilterState) {
                    return listBody(orderDetails: state.orderDetails);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
          },
        ),
      );
  }

  Widget listBody({required List<SingleOrderModel> orderDetails}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        child: ListView.builder(
            itemCount: orderDetails.length,
            itemBuilder: (context, index) {
              return OrderHistoryCell(
                orderDetails: orderDetails[index],
              );
            }),
      ),
    );
  }
}


class OrderHistoryCell extends StatelessWidget {
  final SingleOrderModel orderDetails;

  const OrderHistoryCell({Key? key,
    required this.orderDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(
        orderDetails.quotes!.first.createdAt.toString());
    String orderNo = orderDetails.orderNumber.toString(),
        orderStatus = orderDetails.status.toString(),
        shopName = orderDetails.storeLocation!.store!.name.toString(),
        orderId = orderDetails.quotes!.first.orderId.toString(),
        orderDate = DateFormat.yMd().format(date);


    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors().white100,
        borderRadius: BorderRadius.circular(kTextFieldCircularBorderRadius),
      ),
      child: InkWell(
        onTap: () {
          print(
              "###################################################3 $orderId");
          BlocProvider.of<OrderDetailsScreenCubit>(context)
              .loadOrderDetails(
              orderId: orderId);

          Get.to(() =>  const ONDCOrderDetailsView());
        },

        child: OrderDetailsTable(
            firstTitle: "Shop",
            firstData: shopName,
            secondTitle: "Oder ID",
            secondData: orderNo,
            thirdTitle: "Order status",
            thirdData: orderStatus,
            fourthTitle: "Order Date",
            fourthData: orderDate,
            redTextButtonTitle: "Details",
            horizontalPadding: 15,
            verticalPadding: 10.0
        ),
      ),
    );
  }
}



