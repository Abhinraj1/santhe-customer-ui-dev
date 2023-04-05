import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as ge;
import 'package:get/get_core/src/get_main.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/blocs/ondc/ondc_order_history_bloc/ondc_order_history_bloc.dart';
import '../../../../manager/font_manager.dart';
import '../../../../models/ondc/shop_model.dart';
import '../../../../models/ondc/single_order_model.dart';
import '../../../../widgets/custom_widgets/customScaffold.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../../widgets/ondc_contact_support_widgets/shop_contact_support_card.dart';
import '../../../../widgets/ondc_customer_order_history_widgets/order_history_list.dart';
import '../../ondc_order_details_screen/ondc_order_details_view.dart';


class ONDCContactSupportShopContactDetailsScreen extends StatefulWidget {
  final SingleOrderModel model;
  const ONDCContactSupportShopContactDetailsScreen(
      {Key? key, required this.model})
      : super(key: key);

  @override
  State<ONDCContactSupportShopContactDetailsScreen> createState() => _ONDCContactSupportShopContactDetailsScreenState();
}

class _ONDCContactSupportShopContactDetailsScreenState extends State<ONDCContactSupportShopContactDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<OrderHistoryBloc>(context).add
      (const LoadPastOrderDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    String orderId = widget.model.orderNumber.toString();

    goBack(){
      Get.to(() =>   ONDCOrderDetailsView(
        onBackButtonTap: (){
         Navigator.pop(context);
        },),transition: ge.Transition.leftToRight);
    }
    return CustomScaffold(
        backgroundColor: AppColors().grey20,
        trailingButton: homeIconButton(),
        onBackButtonTap: (){
          //Navigator.pop(context);
         // return true;
          goBack();
        },
        body: Column(
          children: [
             CustomTitleWithBackButton(
                 title: "Contact Support",
            onTapBackButton: (){
                  // Navigator.pop(context);
              goBack();
            }),
            Center(
              child: SizedBox(
                width: 250,
                child: Text(
                  "Order ID  : $orderId",
                  style: FontStyleManager().s16fw700,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Below are the contact details of the seller ."
                  " Please reach out to the seller using below details to report your issues. ",
                  textAlign: TextAlign.center,
                  style: FontStyleManager().s16fw500,
                ),
              ),
            ),
            ShopContactSupportCard(model: widget.model),
            CustomButton(
                verticalPadding: 50,
                onTap: () {
                  goBack();
                 /// Navigator.pop(context);
                },
                buttonTitle: "Back")
          ],
        ));
  }
}
