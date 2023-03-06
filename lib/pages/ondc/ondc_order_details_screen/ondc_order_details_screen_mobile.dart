import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_state.dart';
import 'package:santhe/models/ondc/single_order_model.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/home_icon_button.dart';

import '../../../core/app_colors.dart';
import '../../../core/blocs/ondc/ondc_order_cancel_bloc/ondc_order_cancel_bloc.dart';
import '../../../core/blocs/ondc/ondc_order_cancel_bloc/ondc_order_cancel_bloc.dart';
import '../../../core/blocs/ondc/ondc_order_cancel_bloc/ondc_order_cancel_bloc.dart';
import '../../../core/blocs/ondc/ondc_order_cancel_bloc/ondc_order_cancel_bloc.dart';
import '../../../core/blocs/ondc/ondc_single_order_details_bloc/ondc_single_order_details_bloc.dart';
import '../../../core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_cubit.dart';
import '../../../core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_state.dart';
import '../../../manager/font_manager.dart';
import '../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../widgets/ondc_order_details_widgets/cancel_order_button.dart';
import '../../../widgets/ondc_order_details_widgets/customer_support_button.dart';
import '../../../widgets/ondc_order_details_widgets/invoice_table.dart';
import '../../../widgets/ondc_order_details_widgets/order_details_table.dart';
import '../../../widgets/ondc_order_details_widgets/shipments_card.dart';
import '../ondc_return_screens/ondc_return_view.dart';

class ONDCOrderDetailsScreen extends StatefulWidget {
  const ONDCOrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ONDCOrderDetailsScreen> createState() => _ONDCOrderDetailsScreenState();
}

class _ONDCOrderDetailsScreenState extends State<ONDCOrderDetailsScreen> {
  // final String message = "You have initiated return "

  // final String message = "You have initiated return "
  //      "for one or more items in this order."
  //      " Waiting for return confirmation from seller";

  final bool showCancelButton = true;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        trailingButton: homeIconButton(),
        backgroundColor: AppColors().grey10,
        body: BlocBuilder<SingleOrderDetailsBloc, SingleOrdersDetailsState>(
          builder: (context, state) {
            if (state is DataLoadedState) {
              return body(context, state.orderDetails);
            } else if (state is SingleOrderErrorState) {
              return Text(state.message);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget body(context, List<SingleOrderModel> orderDetails) {
    String shopName = orderDetails.first.storeLocation!.store!.name.toString(),
        orderId = orderDetails.first.quotes!.first.orderId.toString(),
        orderStatus = orderDetails.first.quotes!.first.status.toString(),
        paymentStatus = (orderDetails.first.payment!.paymentStatus).toString(),
        orderNumber = orderDetails.first.orderNumber.toString();
    List<CartItemPrices> products =
        orderDetails.first.quotes!.first.cartItemPrices as List<CartItemPrices>;

    bool hasTrackingData =
        orderDetails.first.quotes!.first.tracks?.first.url == null
            ? false
            : true;

    bool hasInvoice = orderDetails.first.invoice == null ? false : true;

    double productsCount() {
      double count = 0;
      for (var i in products) {
        if (i.type == "item") {
          products.add(i);
          count++;
          return count;
        }
      }
      return count;
    }

    return ListView(children: [
      const CustomTitleWithBackButton(
        title: "ORDER DETAILS",
      ),

      OrderDetailsTable(
        firstTitle: "Shop",
        firstData: shopName,
        secondTitle: "Oder ID",
        secondData: orderNumber,
        thirdTitle: "Order status",
        thirdData: orderStatus,
        fourthTitle: "Payment status",
        fourthData: paymentStatus,
        redTextButtonTitle: hasInvoice ? "Download invoice" : "",
        thirdDataTextStyle:
            hasTrackingData ? FontStyleManager().s12fw700Blue : null,
        thirdDataOnTap: () {},
      ),

      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 20),
      //   child: Text(message,
      //     style: FontStyleManager().s16fw500,),
      // ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
        child: Center(
          child: Text(
            "Items",
            style: FontStyleManager().s16fw600Orange,
          ),
        ),
      ),

      ShipmentCard(shipmentNumber: 1, products: [
        SizedBox(
          height: productsCount() == 1 ? 80 : products.length * 87,
          child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                String productName = products[index].title.toString(),
                    productDetails = products[index].quantity.toString(),
                    productPrice = products[index].price.toString(),
                    productImg = products[index].symbol.toString(),
                    type = products[index].type.toString();

                bool isCancelable = products[index].cancellable == null
                    ? false
                    : products[index].cancellable as bool;

                isCancelable
                    ? BlocProvider.of<OrderDetailsCubit>(context)
                        .showCancelButton()
                    : BlocProvider.of<OrderDetailsCubit>(context)
                        .hideCancelButton();

                if (type == "item") {
                  return ProductCell(
                    showStatus: !isCancelable,
                    productImg: productImg,
                    status: "$isCancelable",
                    productName: productName,
                    productDetails: "$productDetails units",
                    productPrice: "₹$productPrice",
                    textButtonTitle: "Cancel",
                    textButtonOnTap: () {},
                  );
                } else {
                  return const SizedBox();
                }
              }),
        ),
        const BottomTextRow(message: "Delivered")
      ]),

      InvoiceTable(
        prices: orderDetails.first.quotes!.first.cartItemPrices
            as List<CartItemPrices>,
        totalPrice: orderDetails.first.quotes!.first.totalPrice.toString(),
      ),

      CustomerSupportButton(onTap: () {}),

      BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          builder: (context, state) {
        if (state is ShowCancelButton) {
          return CancelOrderButton(onTap: () {
            BlocProvider.of<ONDCOrderCancelBloc>(context).add(
                FullOrderCancelEvent(
                    orderId: orderId, orderNumber: orderNumber));
          });
        } else {
          return const SizedBox(
            height: 20,
          );
        }
      })
    ]);
  }
}
