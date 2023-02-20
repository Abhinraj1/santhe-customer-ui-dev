import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/pages/ondc/ondc_checkout_screen/new/widgets/address_column.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_button.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/blocs/address/address_bloc.dart';
import '../../../../core/repositories/address_repository.dart';
import '../../map_text/map_text_view.dart';
import '../../ondc_order_details_screen/widgets/invoice_table.dart';
import '../../ondc_order_details_screen/widgets/shipments_card.dart';



class OndcCheckOutScreenMobile extends StatefulWidget {
  const OndcCheckOutScreenMobile({Key? key}) : super(key: key);

  @override
  State<OndcCheckOutScreenMobile> createState() => _OndcCheckOutScreenMobileState();
}


class _OndcCheckOutScreenMobileState extends State<OndcCheckOutScreenMobile> {
  @override
  void initState() {
    super.initState();

    context.read<AddressBloc>().add(
      GetAddressListEvent(),
    );

  }
  @override
  Widget build(BuildContext context) {

    String shopName = "Shop Name is shown here",
    numberOfItems = "3";

    return CustomScaffold(
      trailingButton: IconButton(
        onPressed: (){
          ///
          /// Navigate to home

        },
        icon: Icon(Icons.home_filled,color: AppColors().white100,size: 30),
      ),
        body: ListView(
          children: [
            customTitleWithBackButton(
                context: context,
                title: "Checkout"),

            Padding(
              padding: const EdgeInsets.only(bottom: 20.0,top: 5),
              child: Center(
                child: Text(
                  'Shop: $shopName',
                  style: FontStyleManager().s18fw700Orange,
                ),
              ),
            ),


            addressColumn(
                title: "Shipping Details",
                addressType: "Delivering to:",
                address: "Ramanathan Asthana, No123, 1 cross,Bangalore 560064 ",
            ),


            const SizedBox(
              height: 10,
            ),


            addressColumn(
              title: "Payment Details",
              addressType: "Billing Address:",
              address: (RepositoryProvider.of<AddressRepository>(context).deliveryModel?.flat).toString(),
              hasEditButton: true,
              onTap: (){
                Get.to(
                      () => const MapTextView(),
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 10),
              child: Center(
                child: Text("$numberOfItems Items",
                  style: FontStyleManager().s16fw600Orange,),
              ),
            ),

            shipmentCard(

                shipmentNumber: 1,

            products: [

              productCell(
                showStatus: true,
                status: "Cancelled",
                  productImg: "assets/app_icon/icon.png",
                productName : "Bru Original mixed coffee",
                productDetails : "250gm , 1  units",
                productPrice : "₹250"),

              productCell(
                  showStatus: true,
                  status: "Cancelled",
                  productImg: "assets/app_icon/icon.png",
                  productName : "Bru Original mixed coffee",
                  productDetails : "250gm , 1  units",
                  productPrice : "₹250"),

              bottomTextRow(
                title: "Delivery in",
                  message: "3 Days"
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

         customButton(
             onTap: (){},
             width: 300,
             horizontalPadding: 20,
             buttonTile: "PROCEED TO PAY")
          ],
        )
    );
  }
}
