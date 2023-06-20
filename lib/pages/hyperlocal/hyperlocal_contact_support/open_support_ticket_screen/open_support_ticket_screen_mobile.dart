import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_button.dart';
import 'package:santhe/widgets/custom_widgets/custom_testField.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';

import '../../../../core/cubits/hyperlocal_deals_cubit/hyperlocal_contact_support_cubit/contact_support_cubit.dart';
import '../../../../core/repositories/hyperlocal_checkoutrepository.dart';
import '../../../../manager/font_manager.dart';


class OpenSupportTicketScreenMobile extends StatelessWidget {
  final String orderId;
  const OpenSupportTicketScreenMobile({Key? key,
    required this.orderId,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController queryController = TextEditingController();

    return CustomScaffold(
      backgroundColor: AppColors().backgroundGrey,
        body: ListView(
          children: [
            const CustomTitleWithBackButton(title: "Contact Support"),

            Center(
              child: Text("Order ID  : ${RepositoryProvider.of<
                  HyperLocalCheckoutRepository>(context).userOrderId}",
                  style: FontStyleManager().s16fw700,
                  textAlign: TextAlign.center),
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

            CustomTextField(
              controller: queryController,
              hintText: "Enter your Query",
              labelText: " ",
              readOnly: false,
              maxLines: 10,
              validate: (String? val) {
                if (val == "") {
                  return "Please Enter Description";
                }
                return null;
              },
            ),

            CustomButton(
              verticalPadding: 40,
                onTap: (){
                BlocProvider.of<ContactSupportCubit>(context).
                submitContactSupport(
                    reason: queryController.text,
                    orderId: orderId);
                },
                buttonTitle: "SUBMIT ")
          ],
        )
    );
  }
}
