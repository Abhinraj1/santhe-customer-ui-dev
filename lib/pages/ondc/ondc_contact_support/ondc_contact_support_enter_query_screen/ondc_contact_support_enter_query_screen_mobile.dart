import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/cubits/customer_contact_cubit/customer_contact_cubit.dart';
import '../../../../manager/font_manager.dart';
import '../../../../models/ondc/single_order_model.dart';
import '../../../../widgets/custom_widgets/customScaffold.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../../widgets/ondc_contact_support_widgets/textField_for_query.dart';

class ONDCContactSupportEnterQueryScreenMobile extends StatelessWidget {
  final SingleOrderModel store;
   ONDCContactSupportEnterQueryScreenMobile(
      {Key? key, required this.store})
      : super(key: key);



  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String orderId = store.orderNumber.toString();

    return CustomScaffold(
        backgroundColor: AppColors().grey20,
        trailingButton: homeIconButton(),
        body: ListView(
          children: [
            const CustomTitleWithBackButton(title: "Contact Support"),
            Center(
              child: SizedBox(
                width: 250,
                child: Text("Order ID  : $orderId",
                    style: FontStyleManager().s16fw700,
                    textAlign: TextAlign.center),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please enter your query and  enter Submit",
                  textAlign: TextAlign.center,
                  style: FontStyleManager().s16fw500,
                ),
              ),
            ),
            TextFieldForQuery(controller: textEditingController),
            CustomButton(
                verticalPadding: 70,
                onTap: () {
                  BlocProvider.of<CustomerContactCubit>(context).sendQuery(
                      orderNumber: orderId, message: textEditingController.text);
                },
                buttonTitle: "SUBMIT")
          ],
        ));
  }
}
