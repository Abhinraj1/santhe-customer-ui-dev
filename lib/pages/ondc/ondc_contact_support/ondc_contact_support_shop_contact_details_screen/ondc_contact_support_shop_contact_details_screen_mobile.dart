import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/blocs/ondc/ondc_order_history_bloc/ondc_order_history_bloc.dart';
import '../../../../manager/font_manager.dart';
import '../../../../models/ondc/shop_model.dart';
import '../../../../models/ondc/single_order_model.dart';
import '../../../../widgets/custom_widgets/customScaffold.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/ondc_contact_support_widgets/shop_contact_support_card.dart';

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

    return CustomScaffold(
        backgroundColor: AppColors().grey20,
        body: Column(
          children: [
            const CustomTitleWithBackButton(title: "Contact Support"),
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
                  Navigator.pop(context);
                },
                buttonTitle: "Back")
          ],
        ));
  }
}
