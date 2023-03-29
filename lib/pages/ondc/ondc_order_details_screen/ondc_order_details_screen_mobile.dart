import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_state.dart';
import 'package:santhe/models/ondc/single_order_model.dart';
import 'package:santhe/pages/ondc/api_error/api_error_view.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/home_icon_button.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import '../../../core/app_colors.dart';
import '../../../core/blocs/ondc/ondc_order_cancel_and_return_bloc/ondc_order_cancel_and_return_bloc.dart';
import '../../../core/cubits/customer_contact_cubit/customer_contact_cubit.dart';
import '../../../core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_cubit.dart';
import '../../../manager/font_manager.dart';
import '../../../manager/imageManager.dart';
import '../../../models/ondc/preview_ondc_cart_model.dart';
import '../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../widgets/ondc_order_details_widgets/cancel_order_button.dart';
import '../../../widgets/ondc_order_details_widgets/customer_support_button.dart';
import '../../../widgets/ondc_order_details_widgets/invoice_table.dart';
import '../../../widgets/ondc_order_details_widgets/order_details_table.dart';
import '../../../widgets/ondc_order_details_widgets/shipments_card.dart';
import '../../../widgets/ondc_widgets/preview_widget.dart';

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

  List<PreviewWidgetOndcItem> previewWidgetItems = [];
  late GroupedItemScrollController _controller;
  final bool showCancelButton = true;
  int countNumber = 0;

  Widget _getGroupSeparator(PreviewWidgetOndcItem element,
      SingleOrderModel orderDetails,
      String? fulfillmentWidget,
      int countNum) {
    bool? isTrackingURLNull() {
      if (orderDetails.quotes!.first.tracks!.isNotEmpty) {
        for (var track in orderDetails.quotes!.first.tracks!) {
          if (track.fulfillmentId.toString() ==
              element.previewWidgetModel.fulfillment_id) {
            if ((track.url).toString() != "" &&
                track.url != null) {
              return true;
            }
          }
        }
      }
      return null;
    }


    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.87,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          border: Border.all(
            color: CupertinoColors.systemBackground,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Shipment No $countNumber',
                textAlign: TextAlign.left,
                style: TextStyle(color: AppColors().brandDark),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            fulfillmentWidget!.isEmpty
                ? const SizedBox()
                : SizedBox(
                    child: BottomTextRow(
                message: fulfillmentWidget,
                hasTrackingData: isTrackingURLNull() ?? false,
                onTap: () {
                  ///
                  /// Navigate to map screen
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        trailingButton: homeIconButton(),
        backgroundColor: CupertinoColors.systemBackground,

        body: BlocConsumer<OrderDetailsScreenCubit, OrderDetailsScreenState>(
          listener: (context, state) {

            if(state is OrderDetailsErrorState){

              Get.to(()=>const ApiErrorView());
            }
            // TODO: implement listener
          },
          builder: (context, state) {

                if (state is OrderDetailsDataLoadedState) {
                  return body(context, state.orderDetails);
                } else if (state is OrderDetailsErrorState) {
                  return Text(state.message);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
          },
        )
    );
  }

  body(context, Data orderDetails) {
    _controller = GroupedItemScrollController();

    String shopName = orderDetails.singleOrderModel!.storeLocation!.store!.name
        .toString(),
        orderId = orderDetails.singleOrderModel!.quotes!.first.orderId
            .toString(),
        orderStatus = orderDetails.singleOrderModel!.status.toString(),
        orderNumber = orderDetails.singleOrderModel!.orderNumber.toString();

    List<CartItemPrices> products =
    orderDetails.singleOrderModel!.quotes!.first.cartItemPrices
    as List<CartItemPrices>;

    String? paymentStatusFunction() {
      if (orderDetails.singleOrderModel!.
      payment!.paymentStatus != null) {
        if (
        (orderDetails.singleOrderModel!.payment!.paymentStatus)
        as bool != false
        ) {
          return "Paid";
        }
      }
      return null;
    }

    String paymentStatus = paymentStatusFunction() ?? "Not Paid";

    bool hasInvoice = orderDetails.singleOrderModel!.invoice == null ?
    false : true;
    print("##############################################################3"
        " INSIDE INVOICE = ${orderDetails.singleOrderModel!.invoice}");

    isAllCancellable({required CartItemPrices element}) {
      if (element.cancellable != null &&
          element.cancellable == true &&
          orderDetails.singleOrderModel!.quotes!.first.tracks!.isNotEmpty) {
        for (var track in orderDetails.singleOrderModel!.quotes!.first
            .tracks!) {
          if (track.fulfillmentId.toString() ==
              element.deliveryFulfillment!.fulfillmentId.toString()) {
            if ((track.state).toString() == "PENDING" ||
                (track.state).toString() == "PACKED" ||
                (track.state).toString() == "Pending" ||
                (track.state).toString() == "Packed") {
              BlocProvider.of<OrderDetailsButtonCubit>(context)
                  .showCancelButton();
            } else {
              BlocProvider.of<OrderDetailsButtonCubit>(context)
                  .hideCancelButton();
            }
          } else {
            BlocProvider.of<OrderDetailsButtonCubit>(context)
                .hideCancelButton();
          }
        }
      } else {
        BlocProvider.of<OrderDetailsButtonCubit>(context).hideCancelButton();
      }
    }

    isSingleCancellable({required PreviewWidgetModel element}) {
      if (element.cancellable != null &&
          element.cancellable == true &&
          orderDetails.singleOrderModel!.quotes!.first.tracks!.isNotEmpty) {
        for (var track in orderDetails.singleOrderModel!.quotes!.first
            .tracks!) {
          if (track.fulfillmentId.toString() ==
              element.fulfillment_id.toString()) {
            if ((track.state).toString() == "PENDING" ||
                (track.state).toString() == "PACKED" ||
                (track.state).toString() == "Pending" ||
                (track.state).toString() == "Packed") {
              return InkWell(
                onTap: () {

                  ///CANCEL SINGLE ORDER
                  BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(context)
                      .add(
                      LoadReasonsForPartialOrderCancelEvent(
                          orderId: orderDetails.singleOrderModel!.
                          quotes!.first.orderId.toString(),
                          orderNumber: orderDetails.singleOrderModel!.
                          orderNumber.toString(),

                          previewWidgetModel: element));

                },
                child: Text("Cancel", style: FontStyleManager().s14fw700Red,),
              );
            } else {
              return null;
            }
          } else {
            return null;
          }
        }
      } else {
        return null;
      }
    }

    isReturnable({required PreviewWidgetModel element}) {
      if (
      element.returnable != null &&
          element.returnable == true &&
          orderDetails.singleOrderModel!.quotes!.first.tracks!.isNotEmpty) {
        for (var track in orderDetails.singleOrderModel!.quotes!.first
            .tracks!) {
          if (track.fulfillmentId.toString() ==
              element.fulfillment_id.toString()) {
            if ((track.state).toString() == "Delivered" ||
                (track.state).toString() == "DELIVERED" ||
                (track.state).toString() == "delivered") {
              return
                InkWell(
                  onTap: () {
                    ///Navigate to upload screen
                    ///change products to previewWidgetModel
                    BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>
                      (context).add(
                        LoadReasonsForReturnEvent(
                            orderId: orderId,
                            orderNumber: orderNumber,
                            product: element));
                  },
                  child: Text(
                      "Return", style: FontStyleManager().s14fw700GreyUnderLne),
                );
            } else {
              return null;
            }
          } else {
            return null;
          }
        }
      } else {
        return null;
      }
    }

    isAlreadyCancelledOrReturned({required PreviewWidgetModel element}) {
      if (element.isCancelled != null &&
          element.isCancelled == true) {
        return Text("Cancelled",
          style: FontStyleManager().s14fw700Red,);
      } else if (element.isReturned != null &&
          element.isReturned == true) {
        return Text("Return Approved",
          style: FontStyleManager().s14fw700Grey,);
      } else {
        return null;
      }
    }
    List<PreviewWidgetOndcItem> previewItems = [];


    for (var element in products) {
      if (element.type == "item") {
        isAllCancellable(element: element);

        previewItems.add(
          PreviewWidgetOndcItem(
              previewWidgetModel: PreviewWidgetModel(
                  title: element.title,
                  updatedAt: element.updatedAt,
                  symbol: element.symbol,
                  id: element.id,
                  deletedAt: element.deletedAt,
                  createdAt: element.createdAt,
                  cancellable: element.cancellable,
                  deliveryFulfillmentId: element.deliveryFulfillmentId,
                  ondc_item_id: element.ondcItemId,
                  type: element.type,
                  price: element.price,
                  status: element.status,
                  quantity: element.quantity,
                  quoteId: element.quoteId,
                  returnable: element.returnable,
                  isReturned: element.isReturned,
                  isCancelled: element.isCancelled,
                  serviceable: "N/A",
                  provider_name: "N/A",
                  fulfillment_id: element.deliveryFulfillment?.fulfillmentId,
                  category: "N/A",
                  message_id: "N/A",
                  tat: "N/A")),
        );
      }
    }

    previewWidgetItems = previewItems;


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
        invoiceUrl: hasInvoice ?  orderDetails.singleOrderModel!.invoice.toString() :
                        "",
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
        child: Center(
          child: Text(
            "Items",
            style: FontStyleManager().s16fw600Orange,
          ),
        ),
      ),

      StickyGroupedListView<PreviewWidgetOndcItem, String>(
        shrinkWrap: true,
        elements: previewWidgetItems,
        itemScrollController: _controller,
        stickyHeaderBackgroundColor: CupertinoColors.systemBackground,
        groupBy: (PreviewWidgetOndcItem previewWidget) {
          log('${previewWidget.previewWidgetModel.deliveryFulfillmentId}',
              name: 'Sorting method Order_Detail_Screen.Dart');
          return previewWidget.previewWidgetModel.deliveryFulfillmentId;
        },
        groupSeparatorBuilder: (PreviewWidgetOndcItem previewWidget) {
          //! track fullfillment id matches the product fullfillment id ...then we take the track state and send it in the _getgroupSeparator


          String? fulfillmentState() {
            for (var i in orderDetails.singleOrderModel!.quotes!.first
                .tracks!) {
              if (i.fulfillmentId ==
                  previewWidget.previewWidgetModel.fulfillment_id) {
                print("########################################### STATE =${i
                    .state}");
                return i.state.toString();
              }
            }
            return null;
          }
          countNumber = countNumber + 1;
          return _getGroupSeparator(
              previewWidget, orderDetails.singleOrderModel!,
              fulfillmentState() ?? "",
              countNumber
          );
        },
        itemBuilder: (context, previewWidgetModel) {
          print('Length passed into builder ${previewWidgetItems.length}');

          //! preview widget ui start
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  previewWidgetModel.previewWidgetModel.symbol != null &&
                      previewWidgetModel.previewWidgetModel.symbol != ""
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                      previewWidgetModel.previewWidgetModel.symbol,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(
                              width: 200,
                              child: AutoSizeText(
                                previewWidgetModel.previewWidgetModel.title,
                                style: FontStyleManager().s14fw700Brown,
                                minFontSize: 12,
                                maxFontSize: 14,
                                maxLines: 2,
                              )
                          ),

                          Text(
                            '${previewWidgetModel.previewWidgetModel
                                .quantity} units',
                            style: FontStyleManager().s10fw500Brown,
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          //! new field for cancel...check for tracking status and packing state
                          isSingleCancellable(
                              element: previewWidgetModel.previewWidgetModel) ??
                              const SizedBox(),

                          isReturnable(
                              element: previewWidgetModel.previewWidgetModel) ??
                              const SizedBox(),

                          isAlreadyCancelledOrReturned(
                              element: previewWidgetModel.previewWidgetModel) ??
                              const SizedBox(),

                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: SizedBox(
                        width: 50,
                        child: AutoSizeText(
                          "₹${previewWidgetModel.previewWidgetModel.price.
                          toString().characters.take(5)}",
                          maxFontSize: 16,
                          minFontSize: 12,
                          style: FontStyleManager().s16fw600Grey,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          //! preview widget ui end
        },
      ),

      InvoiceTable(
        prices: orderDetails.finalCosting as List<FinalCosting>,
        totalPrice: orderDetails.singleOrderModel!.quotes!.first.totalPrice
            .toString(),
      ),

      CustomerSupportButton(
          onTap: () {
            BlocProvider.of<CustomerContactCubit>(context)
                .customerContact(model: orderDetails.singleOrderModel!);
            // Get.to(()=>const ONDCContactSupportView());
          }),

      BlocBuilder<OrderDetailsButtonCubit, OrderDetailsButtonState>(
          builder: (context, state) {
            if (state is ShowCancelButton) {
              return CancelOrderButton(onTap: () {
                BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(context)
                    .add(
                    LoadReasonsForFullOrderCancelEvent(
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

