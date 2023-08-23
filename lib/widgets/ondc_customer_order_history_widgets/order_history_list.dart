import 'dart:async';
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
import '../../core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_cubit.dart';
import '../../models/ondc/single_order_model.dart';
import '../../pages/ondc/api_error/api_error_view.dart';
import '../../utils/order_details_screen_routing_logic.dart';



class OrderHistoryList extends StatelessWidget {
   OrderHistoryList({Key? key}) : super(key: key);

  List<SingleOrderModel> orderDetails = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<OrderHistoryBloc, OrderHistoryState>(
        listener: (context, state) {
          // TODO: implement listener

          if (state is SingleOrderErrorState) {
            Get.to(
              () => const ApiErrorView(),
            );
          }
        },
        builder: (context, state) {
          if (state is SingleOrderErrorState) {
            return Center(child: Text(state.message));
          }
          // else if (state is PastOrderDataLoadedState) {
          //   orderDetails = state.orderDetails;
          //
          //   return listBody(
          //       orderDetails: state.orderDetails, );
          // }
          else if (state is SevenDaysFilterState) {

            orderDetails = state.orderDetails;
            return ListBody(
                orderDetails: state.orderDetails, );
          } else if (state is ThirtyDaysFilterState) {

            orderDetails = state.orderDetails;
            return ListBody(
                orderDetails: state.orderDetails, );
          } else if (state is CustomDaysFilterState) {
            orderDetails = state.orderDetails;
            return ListBody(
                orderDetails: state.orderDetails, );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ListBody extends StatefulWidget {
  final List<SingleOrderModel> orderDetails;
  const ListBody({Key? key, required this.orderDetails}) : super(key: key);

  @override
  State<ListBody> createState() => _ListBodyState();
}


class _ListBodyState extends State<ListBody> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    scrollController.addListener(listener);

    BlocProvider.of<OrderHistoryBloc>(context)
        .add(const SevenDaysFilterEvent(offset: "0",
        alreadyFetchedList: []));
  }

  listener() {
    if (myOrdersLoading.value) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {

      myOrdersLoading.value = true;

      print("LOADING VALUE IS ================================ "
          " AFTER TRUE IS ${myOrdersLoading.value}");

      ONDCMyOrdersOffset.value = ONDCMyOrdersOffset.value + 10;

      if(sevenDaysFilter.value){

        BlocProvider.of<OrderHistoryBloc>(context).add(
            SevenDaysFilterEvent(
                offset: ONDCMyOrdersOffset.value.toString(),
                alreadyFetchedList: widget.orderDetails));

      }else if(thirtyDaysFilter.value){

        BlocProvider.of<OrderHistoryBloc>(context).add(
            ThirtyDaysFilterEvent(
                offset: ONDCMyOrdersOffset.value.toString(),
                alreadyFetchedList:  widget.orderDetails));

      }else{
        BlocProvider.of<OrderHistoryBloc>(context).add(
            CustomDaysFilterEvent(
                offset: ONDCMyOrdersOffset.value.toString(),
                alreadyFetchedList:  widget.orderDetails,
                selectedDates: []));
      }


      Future.delayed(const Duration(seconds: 1)).then((value) {
        myOrdersLoading.value = false;
      });

      setState(() {

      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: widget.orderDetails.isEmpty ?
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("No Orders Found.",
            style: FontStyleManager().s14fw700Orange,),
          ) :
      SizedBox(
        child: ListView.builder(
            controller: scrollController,
            itemCount: widget.orderDetails.length,
            itemBuilder: (context, index) {
              if (index < widget.orderDetails.length) {
                return OrderHistoryCell(
                  orderDetails: widget.orderDetails[index],
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator()
                );
              }
            }),
      ),
    );

  }
}

class OrderHistoryCell extends StatelessWidget {
  final SingleOrderModel orderDetails;

  const OrderHistoryCell({Key? key, required this.orderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime createdDate =
        DateTime.parse(orderDetails.quotes!.first.createdAt.toString());
    String orderNo = orderDetails.orderNumber.toString(),
        orderStatus = orderDetails.status.toString(),
        shopName = orderDetails.storeLocation!.store!.name.toString(),
        orderId = orderDetails.quotes!.first.orderId.toString(),
        orderDate = DateFormat.yMd().format(createdDate);

    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors().white100,
        borderRadius: BorderRadius.circular(kTextFieldCircularBorderRadius),
      ),
      child: InkWell(
        onTap: () {
          print("################################################### $orderId");
          BlocProvider.of<OrderDetailsScreenCubit>(context)
              .loadOrderDetails(orderId: orderId);

          Get.to(() => ONDCOrderDetailsView());
        },
        child: OrderDetailsTable(
            date: orderDate,
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
            verticalPadding: 10.0),
      ),
    );
  }
}
