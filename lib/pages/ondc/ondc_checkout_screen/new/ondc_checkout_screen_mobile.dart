import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_button.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/blocs/address/address_bloc.dart';
import '../../../../core/blocs/checkout/checkout_bloc.dart';
import '../../../../core/repositories/address_repository.dart';
import '../../../../widgets/ondc_checkout_widgets/address_column.dart';
import '../../../../widgets/ondc_order_details_widgets/invoice_table.dart';
import '../../../../widgets/ondc_order_details_widgets/shipments_card.dart';
import '../../map_text/map_text_view.dart';

class OndcCheckOutScreenMobile extends StatefulWidget {
  const OndcCheckOutScreenMobile({Key? key}) : super(key: key);

  @override
  State<OndcCheckOutScreenMobile> createState() =>
      _OndcCheckOutScreenMobileState();
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
    String shopName = "Shop Name is shown here", numberOfItems = "3";

    return CustomScaffold(
        trailingButton: IconButton(
          onPressed: () {
            ///
            /// Navigate to home
          },
          icon: Icon(Icons.home_filled, color: AppColors().white100, size: 30),
        ),
        body: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, state) {},
          builder: (context, state) {
            return ListView(
              children: [
                const CustomTitleWithBackButton(title: "Checkout"),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 5),
                  child: Center(
                    child: Text(
                      'Shop: $shopName',
                      style: FontStyleManager().s18fw700Orange,
                    ),
                  ),
                ),

                AddressColumn(
                  title: "Shipping Details",
                  addressType: "Delivering to:",
                  address: (RepositoryProvider.of<AddressRepository>(context)
                          .deliveryModel
                          ?.flat)
                      .toString(),
                ),

                const SizedBox(
                  height: 10,
                ),

                AddressColumn(
                    title: "Payment Details",
                    addressType: "Billing Address:",
                    address: (RepositoryProvider.of<AddressRepository>(context)
                            .billingModel
                            ?.flat)
                        .toString(),
                    hasEditButton: true,
                    onTap: () {
                      isBillingAddress = true;

                      Get.to(
                        () => const MapTextView(),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 10),
                  child: Center(
                    child: Text(
                      "$numberOfItems Items",
                      style: FontStyleManager().s16fw600Orange,
                    ),
                  ),
                ),

                const ShipmentCard(shipmentNumber: 1, products: [
                  ProductCell(
                      showStatus: true,
                      status: "Cancelled",
                      productImg: "",
                      productName: "Bru Original mixed coffee",
                      productDetails: "250gm , 1  units",
                      productPrice: "₹250"),
                  ProductCell(
                      showStatus: true,
                      status: "Cancelled",
                      productImg: "null",
                      productName: "Bru Original mixed coffee",
                      productDetails: "250gm , 1  units",
                      productPrice: "₹250"),
                  BottomTextRow(title: "Delivery in", message: "3 Days")
                ]),

                // InvoiceTable(
                //     subTotal : "₹425",
                //     deliveryCharger : "₹30",
                //     taxesCGST : "₹8",
                //     taxesSGST : "₹12",
                //     total : "₹475"
                // ),

                CustomButton(
                    onTap: () {},
                    width: 300,
                    horizontalPadding: 20,
                    buttonTitle: "PROCEED TO PAY")
              ],
            );
          },
        ));
  }
}
