import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
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
import '../../../utils/format_status_with_under_score.dart';
import '../../../utils/priceFormatter.dart';
import '../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../widgets/ondc_order_details_widgets/cancel_order_button.dart';
import '../../../widgets/ondc_order_details_widgets/customer_support_button.dart';
import '../../../widgets/ondc_order_details_widgets/invoice_table.dart';
import '../../../widgets/ondc_order_details_widgets/order_details_table.dart';
import '../../../widgets/ondc_order_details_widgets/shipments_card.dart';
import '../../../widgets/ondc_widgets/error_container_widget.dart';
import '../../../widgets/ondc_widgets/preview_widget.dart';
import '../ondc_contact_support/ondc_contact_support_enter_query_screen/ondc_contact_support_enter_query_screen_mobile.dart';
import '../ondc_contact_support/ondc_contact_support_ticket_screen/ondc_contact_support_ticket_screen_mobile.dart';


class ONDCOrderDetailsScreen extends StatefulWidget {
  final Function()? onBackButtonTap;
  const ONDCOrderDetailsScreen({Key? key,
   this.onBackButtonTap}) : super(key: key);

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
  int numberOfProducts = 0;

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


    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.87,
       // margin: const EdgeInsets.symmetric(horizontal: 14),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        trailingButton: homeIconButton(),
        backgroundColor: CupertinoColors.systemBackground,
        onBackButtonTap: (){
          if(widget.onBackButtonTap != null){
            widget.onBackButtonTap!();
          }
        },

        body: BlocConsumer<OrderDetailsScreenCubit, OrderDetailsScreenState>(
          listener: (context, state) {

            if(state is OrderDetailsErrorState){
              print("ERROR### =${state.message}");
              Get.to(()=>const ApiErrorView());
            }
            // TODO: implement listener
          },
          builder: (context, state) {

                if (state is OrderDetailsDataLoadedState) {
                  return body(context: context, orderDetails: state.orderDetails);
                } else if(state is OrderDetailsSellerNotRespondedErrorState){
                  return body(
                    context: context,
                    orderDetails: state.orderDetails,
                    errorMessage: state.message,

                  );
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                }
          },
        )
    );
  }

  body({
    required BuildContext context,
    required Data orderDetails,
    String? errorMessage}) {

    _controller = GroupedItemScrollController();
    DateTime createdDate = DateTime.parse(
        orderDetails.singleOrderModel!.createdAt.toString());

    String shopName = orderDetails.singleOrderModel!.storeLocation!.store!.name
        .toString(),
        orderId = orderDetails.singleOrderModel!.quotes!.first.orderId
            .toString(),
        orderStatus = orderDetails.singleOrderModel!.status.toString(),
        orderNumber = orderDetails.singleOrderModel!.orderNumber.toString(),
        orderDate = DateFormat.yMd().format(createdDate);

    List<CartItemPrices> products =
    orderDetails.singleOrderModel!.quotes!.first.cartItemPrices
    as List<CartItemPrices>;

    String? message = orderDetails.message;

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
    print("##############################################################"
        " INSIDE INVOICE = ${orderDetails.singleOrderModel!.invoice}");



    isAllCancellable({required CartItemPrices element}) {


      if (element.cancellable != null &&
          element.cancellable == true &&
          orderDetails.singleOrderModel!.quotes!.first.tracks!.isNotEmpty
      ) {

        for (var track in orderDetails.singleOrderModel!.quotes!.first
            .tracks!) {

          if (track.fulfillmentId.toString() ==
              element.deliveryFulfillment!.fulfillmentId.toString()) {
            if (track.state.toString() == "Pending" ||
                track.state.toString() == "Packed" ) {

              BlocProvider.of<OrderDetailsButtonCubit>(context)
                  .showCancelButton();

            }else{
              BlocProvider.of<OrderDetailsButtonCubit>(context)
                  .hideCancelButton();

              break;
            }

          } else {
            BlocProvider.of<OrderDetailsButtonCubit>(context)
                .hideCancelButton();

            break;
          }
        }
      } else {
        BlocProvider.of<OrderDetailsButtonCubit>(context).hideCancelButton();
      }
   ///   BlocProvider.of<OrderDetailsButtonCubit>(context).hideCancelButton();
    }


    isSingleCancellable({required PreviewWidgetModel element}) {

      print("####################################################"
          "STATUS IN ISINGLE CANCELLALE = ${element.status}");

      if (element.cancellable != null &&
          element.cancellable == true &&
         numberOfProducts != 1 &&
          orderDetails.singleOrderModel!.quotes!.first.tracks!.isNotEmpty
      ) {

        for (var track in orderDetails.singleOrderModel!.quotes!.first
            .tracks!) {

          if (track.fulfillmentId.toString() ==
              element.fulfillment_id.toString()) {
            if ((track.state).toString() == "Pending" ||
                (track.state).toString() == "Packed" ) {

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
            if ((track.state).toString() == "Order-delivered") {
              return
                InkWell(
                  onTap: () {
                    ///Navigate to upload screen

                    BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>
                      (context).add(
                        LoadReasonsForReturnEvent(
                            orderId: orderId,
                            orderNumber: orderNumber,
                            product: element));
                  },
                  child: Text(
                      "Return", style: FontStyleManager()
                      .s14fw700GreyUnderLne),
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

      //ToDo:Remove Below comments
      // if (element.isCancelled != null &&
      //     element.isCancelled == true) {
      //   return Text("Cancelled",
      //     style: FontStyleManager().s14fw700Red,);
      // } else if (element.isReturned != null &&
      //     element.isReturned == true) {
      //   return Text("Return Approved",
      //     style: FontStyleManager().s14fw700Grey,);
      // } else if(){}else {
      //   return null;
      // }

      if(element.cartPriceItemStatus.toString() != "null" &&
          element.cartPriceItemStatus.toString() != "" ){
            return Text(statusFormatter(value: element.cartPriceItemStatus.toString()),
              style: FontStyleManager().s12fw700Grey,);
      }

      return null;
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
                  status: orderDetails.singleOrderModel!.status,
                  quantity: element.quantity,
                  quoteId: element.quoteId,
                  returnable: element.returnable,
                  isReturned: element.isReturned,
                  isCancelled: element.isCancelled,
                  serviceable: "N/A",
                  provider_name: "N/A",
                  fulfillment_id: element.deliveryFulfillment?.fulfillmentId ?? "",
                  category: "N/A",
                  message_id: "N/A",
                  cartPriceItemStatus: element.status,
                  tat: "N/A")),
        );
      }
    }

    ///sort products based on prices
    previewItems.sort(((a, b) {
       return  double.parse(
           a.previewWidgetModel.price).
       compareTo(double.parse(b.previewWidgetModel.price));
    }));

    previewWidgetItems = previewItems;
    numberOfProducts = previewItems.length;

    print("#######################################################"
        "Number OF PRODUCTS IS = $numberOfProducts");

    return ListView(
        children: [
       CustomTitleWithBackButton(
        title: "ORDER DETAILS",
        onTapBackButton: (){
          if(widget.onBackButtonTap != null){
            widget.onBackButtonTap!();
          }
        },

      ),

      OrderDetailsTable(
        horizontalPadding: 8,
        date: orderDate,
        firstTitle: "Shop",
        firstData: shopName,
        secondTitle: "Oder ID",
        secondData: orderNumber,
        thirdTitle: "Order status",
        thirdData: statusFormatter(value: orderStatus),
        fourthTitle: "Payment status",
        fourthData: paymentStatus,
        redTextButtonTitle: hasInvoice ? "Download invoice" : "",
        invoiceUrl: hasInvoice ?  orderDetails.singleOrderModel!.invoice.toString() :
                        "",
      ),

      errorMessage != null ?
          ErrorContainerWidget(message: errorMessage,):
        const SizedBox(),

          message != null && message != ""?
          ErrorContainerWidget(
            message: message,
            nonErrorMessage: true,):
          const SizedBox(),

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
          log('${previewWidget.previewWidgetModel.deliveryFulfillmentId ?? ""}',
              name: 'Sorting method Order_Detail_Screen.Dart');
          return previewWidget.previewWidgetModel.deliveryFulfillmentId ?? "";
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
          return 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 8.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 100,
                    width: 5,
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
                      ImgManager().emptyCart,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(
                            width: 185,
                            child: AutoSizeText(
                              previewWidgetModel.previewWidgetModel.title,
                              style: FontStyleManager().s14fw500Brown,
                              minFontSize: 12,
                              maxFontSize: 14,
                              maxLines: 2,
                            )
                        ),


                        /// Row to Show Net Quantity and Units
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              previewWidgetModel.previewWidgetModel
                                  .net_quantity != null ?
                              '${previewWidgetModel.previewWidgetModel
                                  .net_quantity.toString()} , ' :
                              "",
                              style: FontStyleManager().s10fw500Brown,
                            ),

                            Text(
                              '${previewWidgetModel.previewWidgetModel
                                  .quantity} units',
                              style: FontStyleManager().s10fw500Brown,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        //! new field for cancel...check for tracking status and packing state




                        isAlreadyCancelledOrReturned(
                            element: previewWidgetModel.previewWidgetModel) == null ?
                           isSingleCancellable(
                            element: previewWidgetModel.previewWidgetModel) ??
                            const SizedBox() : const SizedBox(),


                        isAlreadyCancelledOrReturned(
                            element: previewWidgetModel.previewWidgetModel) == null ?
                        isReturnable(
                            element: previewWidgetModel.previewWidgetModel) ??
                            const SizedBox() : const SizedBox(),

                        isAlreadyCancelledOrReturned(
                            element: previewWidgetModel.previewWidgetModel) ??
                            const SizedBox(),
                      ],
                    ),
                  ),

                 const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(left: 2.0,right: 5),
                    child: SizedBox(
                      width: 50,
                      child: AutoSizeText(
                       "₹${priceFormatter(value: previewWidgetModel.
                       previewWidgetModel.price.
                        toString())}",
                        maxFontSize: 16,
                        minFontSize: 10,
                        style: FontStyleManager().s16fw600Grey,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                 // const SizedBox(width: 6),
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
        amountInCents: orderDetails.singleOrderModel!.payment!.amountInCents.toString(),
      ),
          orderDetails.singleOrderModel!.support == null ?
      CustomerSupportButton(
          onTap: () {
            BlocProvider.of<CustomerContactCubit>(context)
                .customerContact(model: orderDetails.singleOrderModel!);
            // Get.to(()=>const ONDCContactSupportView());
          }) : SizedBox(),

          orderDetails.singleOrderModel!.support != null ?
          CustomerSupportButton(
            onTap: (){
          Get.to(ONDCContactSupportTicketScreenMobile(
            support: orderDetails.singleOrderModel!.support!,));
            },
            title: "CONTACT SANTHE SUPPORT",
          ) : SizedBox(),

    orderDetails.singleOrderModel!.support == null ?
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
          }) :
        SizedBox()
    ]);
  }

}

