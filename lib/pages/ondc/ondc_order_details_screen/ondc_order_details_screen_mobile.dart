import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/models/ondc/past_cart_items_model.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/widgets/cancel_order_button.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/widgets/customer_support_button.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/widgets/invoice_table.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/widgets/order_details_table.dart';
import 'package:santhe/pages/ondc/ondc_order_details_screen/widgets/shipments_card.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/home_icon_button.dart';

import '../../../core/app_colors.dart';
import '../../../core/blocs/ondc/ondc_past_order_details_bloc/ondc_past_order_details_bloc.dart';
import '../../../manager/font_manager.dart';
import '../../../widgets/custom_widgets/custom_title_with_back_button.dart';

class ONDCOrderDetailsScreen extends StatelessWidget {
  const ONDCOrderDetailsScreen({Key? key}) : super(key: key);

 // final String message = "You have initiated return "
 //      "for one or more items in this order."
 //      " Waiting for return confirmation from seller";

  final bool showCancelButton = true;
  @override
  Widget build(BuildContext context) {

    return  CustomScaffold(
       trailingButton: homeIconButton(),
        backgroundColor: AppColors().grey10,

        body: BlocBuilder<PastOrderDetailsBloc,PastOrdersDetailsState>(
          builder: (context,state){
             if(state is DataLoadedState){
              return body(context,state.orderDetails);
            }else{
              return const Center(child: CircularProgressIndicator()) ;
            }
          },




        )
    );
  }

  Widget body( context, List<PastOrderRow> orderDetails){
    String ShopName = "Shop Nam",
        orderId = orderDetails.first.quotes!.first.orderId.toString(),
    OrderStatus = orderDetails.first.quotes!.first.status.toString(),
    PaymentStatus = orderDetails.first.status.toString();
    List<CartItemPrices> products = orderDetails.first.quotes!.
    first.cartItemPrices as List<CartItemPrices>;

    return
      ListView(
      children: [

        customTitleWithBackButton(
            title: orderDetails.first.status ?? "ORDER DETAILS",
            context: context
        ),
        orderDetailsTable(
            onTap: (){},
            firstTitle: "Shop",
            firstData: "Shop Name",
            secondTitle: "Oder ID",
            secondData: orderId,
            thirdTitle: "Order status",
            thirdData: OrderStatus,
            fourthTitle: "Payment status",
            fourthData: PaymentStatus,
            redTextButtonTitle: "Download invoice",
        ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 20),
        //   child: Text(message,
        //     style: FontStyleManager().s16fw500,),
        // ),


        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 10),
          child: Center(
            child: Text("Items",
              style: FontStyleManager().s16fw600Orange,),
          ),
        ),

        shipmentCard(shipmentNumber: 1,
            products:
            [
              SizedBox(
              height: products.length == 1 ? 80 : 160,
              child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context,index){

                            String productName = products[index].title.toString(),
                                    productDetails = products[index].type.toString(),
                                    productPrice = products[index].price.toString(),
                                    productImg = products[index].symbol.toString();

                            return productCell(
                            showStatus: true,
                            productImg: productImg,
                            status: products[index].status,
                            productName : productName,
                            productDetails : productDetails,
                            productPrice : productPrice
    );

    }),
              ),

              bottomTextRow(
                  message: "Delivered"
              )
            ]
        ),
        invoiceTable(
            subTotal : "₹425",
            deliveryCharger : "₹30",
            taxesCGST : "₹8",
            taxesSGST : "₹12",
            total : "₹475"
        ),
        customerSupportButton(
            onTap: (){}
        ),
        showCancelButton ?
        cancelOrderButton(
            onTap: (){}
        ) :
        const SizedBox(
          height: 20,
        ),


      ],
    );
  }
}

