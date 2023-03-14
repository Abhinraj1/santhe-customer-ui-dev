import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_state.dart';
import 'package:santhe/models/ondc/single_order_model.dart';
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

  Widget _getGroupSeparator(
      PreviewWidgetOndcItem element,
      SingleOrderModel orderDetails,
      String? fulfillmentWidget) {

    bool? isTrackingURLNull(){
      if (orderDetails.quotes!.first.tracks!.isNotEmpty) {
        for (var track in orderDetails.quotes!.first.tracks!) {
          if (track.fulfillmentId.toString() ==
              element.previewWidgetModel.fulfillment_id) {
            if ((track.url).toString() != "" &&
                (track.url).toString() != "null" &&
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
        width: MediaQuery.of(context).size.width * 0.87,
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
                'Shipment No ${element.previewWidgetModel.fulfillment_id}',
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
        body: BlocBuilder<OrderDetailsScreenCubit, OrderDetailsScreenState>(
          builder: (context, state) {
            if (state is OrderDetailsDataLoadedState) {
              return body(context, state.orderDetails);
            } else if (state is OrderDetailsErrorState) {
              return Text(state.message);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  body(context, Data orderDetails) {
    _controller = GroupedItemScrollController();

    String shopName = orderDetails.singleOrderModel!.storeLocation!.store!.name.toString(),
        orderId = orderDetails.singleOrderModel!.quotes!.first.orderId.toString(),
        orderStatus = orderDetails.singleOrderModel!.status.toString(),
        paymentStatus = (orderDetails.singleOrderModel!.payment!.paymentStatus).toString(),
        orderNumber = orderDetails.singleOrderModel!.orderNumber.toString();
    List<CartItemPrices> products =
        orderDetails.singleOrderModel!.quotes!.first.cartItemPrices as List<CartItemPrices>;


    bool hasInvoice = orderDetails.singleOrderModel!.invoice == null ? false : true;

    isAllCancellable({required CartItemPrices element}) {
      if (element.cancellable != null &&
          element.cancellable == true &&
          orderDetails.singleOrderModel!.quotes!.first.tracks!.isNotEmpty) {
        for (var track in orderDetails.singleOrderModel!.quotes!.first.tracks!) {
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
        for (var track in orderDetails.singleOrderModel!.quotes!.first.tracks!) {
          if (track.fulfillmentId.toString() ==
              element.fulfillment_id.toString()) {
            if ((track.state).toString() == "PENDING" ||
                (track.state).toString() == "PACKED" ||
                (track.state).toString() == "Pending" ||
                (track.state).toString() == "Packed") {

              return TextButton(
                onPressed: (){

                  ///CANCEL SINGLE ORDER
                  BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(context).add(
                      const LoadReasonsForPartialOrderCancelEvent(
                          orderId: "",
                          orderNumber: ''));

                },
                child: Text("Cancel",style: FontStyleManager().s14fw700Red,),
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
      if (element.returnable != null &&
          element.returnable == true &&
          orderDetails.singleOrderModel!.quotes!.first.tracks!.isNotEmpty) {
        for (var track in orderDetails.singleOrderModel!.quotes!.first.tracks!) {
          if (track.fulfillmentId.toString() ==
              element.fulfillment_id.toString()) {
            if ((track.state).toString() == "Delivered" ||
                (track.state).toString() == "DELIVERED" ||
                (track.state).toString() == "delivered" ) {

              return TextButton(
                onPressed: (){

                  ///Navigate to upload screen
                  ///change products to previewWidgetModel
                  // BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(context).add(
                  //      LoadReasonsForReturnEvent(
                  //         orderId: "",
                  //         orderNumber: '',
                  //      product: ));

                },
                child: Text("Return",style: FontStyleManager().s14fw700GreyUnderLne),
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


          String? fulfillmentState(){
            for(var i in orderDetails.singleOrderModel!.quotes!.first.tracks!){
              if(i.fulfillmentId == previewWidget.previewWidgetModel.fulfillment_id){
                print("########################################### STATE =${i.state}");
                return i.state.toString();

              }
            }
            return null;
          }
          return _getGroupSeparator(
              previewWidget, orderDetails.singleOrderModel!, fulfillmentState() ?? "");
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
                    width: 5,
                  ),
                  previewWidgetModel.previewWidgetModel.symbol != null &&
                          previewWidgetModel.previewWidgetModel.symbol != ""
                      ? Image.network(
                          previewWidgetModel.previewWidgetModel.symbol,
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
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 200,
                            child: AutoSizeText(
                              previewWidgetModel.previewWidgetModel.title,
                              style: FontStyleManager().s12fw700Brown,
                              maxLines: 2,
                            )),

                        Text(
                          '${previewWidgetModel.previewWidgetModel.quantity}',
                          style: FontStyleManager().s10fw500Brown,
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        //! new field for cancel...check for tracking status and packing state
                        isSingleCancellable(element: previewWidgetModel.previewWidgetModel ) ??
                        const SizedBox(),
                        isReturnable(element: previewWidgetModel.previewWidgetModel ) ??
                            const SizedBox(),

                      ],
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 50,
                      child: AutoSizeText(
                        "₹${previewWidgetModel.previewWidgetModel.price}",
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
          //! preview widget ui end
        },
      ),

      InvoiceTable(
        prices: orderDetails.finalCosting as List<FinalCosting>,
        totalPrice: orderDetails.singleOrderModel!.quotes!.first.totalPrice.toString(),
      ),

      CustomerSupportButton(onTap: () {
        BlocProvider.of<CustomerContactCubit>(context)
            .customerContact(model: orderDetails.singleOrderModel!);
        // Get.to(()=>const ONDCContactSupportView());
      }),

      BlocBuilder<OrderDetailsButtonCubit, OrderDetailsButtonState>(
          builder: (context, state) {
        if (state is ShowCancelButton) {
          return CancelOrderButton(onTap: () {
            BlocProvider.of<ONDCOrderCancelAndReturnReasonsBloc>(context).add(
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

// ShipmentCard(shipmentNumber: 1, products: [
//   SizedBox(
//     height: productsCount() == 1 ? 80 : products.length * 87,
//     child: ListView.builder(
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           String productName = products[index].title.toString(),
//               productDetails = products[index].quantity.toString(),
//               productPrice = products[index].price.toString(),
//               productImg = products[index].symbol.toString(),
//               type = products[index].type.toString();
//
//           if(products[index].type == "item"){
//
//           }else{}
//
//           bool isCancelable =
//               products[index].type == "item" ?
//               products[index].cancellable != null &&
//               products[index].cancellable == true &&
//                   orderDetails.first.quotes!.first.tracks!.isNotEmpty ?
//                   (orderDetails.first.quotes!.first.tracks?[index].state).toString() == "PENDING" ||
//                   (orderDetails.first.quotes!.first.tracks?[index].state).toString() == "PACKED" ||
//                   (orderDetails.first.quotes!.first.tracks?[index].state).toString() == "Pending" ||
//                   (orderDetails.first.quotes!.first.tracks?[index].state).toString() == "Packed"
//               ? true
//               : false : false : false;
//
//           isCancelable
//               ? BlocProvider.of<OrderDetailsButtonCubit>(context)
//                   .showCancelButton()
//               : BlocProvider.of<OrderDetailsButtonCubit>(context)
//                   .hideCancelButton();
//
//           print("############################################# IsCANCEL = $isCancelable");
//
//           if (type == "item") {
//
//             return
//
//               ProductCell(
//               showStatus: !isCancelable,
//               productImg: productImg,
//               status: "$isCancelable",
//               productName: productName,
//               productDetails: "$productDetails units",
//               productPrice: "₹$productPrice",
//               textButtonTitle: "Cancel",
//               textButtonOnTap: () {},
//             );
//           } else {
//             return const SizedBox();
//           }
//         }),
//   ),
//
//
//       orderDetails.first.quotes!.first.tracks!.isNotEmpty &&
//       orderDetails.first.quotes!.first.tracks!.first.state != null ?
// BottomTextRow(
//       message: (orderDetails.first.quotes!.first.tracks!.first.state).toString() ) :
//   const SizedBox(),
// ]),
