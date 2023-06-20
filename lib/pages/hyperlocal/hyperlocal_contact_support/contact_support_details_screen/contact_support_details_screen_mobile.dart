import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_orders_model.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_orders_model.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import 'package:santhe/widgets/custom_widgets/table_generator.dart';

import '../../../../core/repositories/hyperlocal_checkoutrepository.dart';
import '../../../../manager/font_manager.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../../widgets/ondc_contact_support_widgets/images_list_textButton.dart';



class HyperlocalContactSupportDetailsScreenMobile extends StatelessWidget {
  const HyperlocalContactSupportDetailsScreenMobile({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

   OrderInfo orderInfo =  RepositoryProvider.of<
        HyperLocalCheckoutRepository>(
        context).orderInfo;

   OrderInfoSupport support = orderInfo.data!.support as OrderInfoSupport ;


    return CustomScaffold(
        trailingButton: homeIconButton(),
        body: ListView(
          children: [
            const CustomTitleWithBackButton(
              title: 'Support Ticket',
            ),
            TableGenerator(
              horizontalPadding: 10,
              tableRows: [
                TableModel(
                    title: "Order ID :",
                    data:
                RepositoryProvider.of<
                    HyperLocalCheckoutRepository>(
                    context).userOrderId),
                TableModel(title: "Ticket ID :", data: support.id ?? "N/A"),
                TableModel(title:support.longDescription != null
                    ? "Description :" : ""),
              ],
            ),
            support.longDescription != null
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                support.longDescription.toString(),
                style: FontStyleManager().s14fw600Grey,
              ),
            )
                : const SizedBox(),
            support.resolutionRemarks!= null ?
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                "Request update notes:",
                style: FontStyleManager().s14fw600Grey,
              ),
            ) :
            SizedBox(),
            support.resolutionRemarks!= null ?
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                support.resolutionRemarks.toString(),
                style: FontStyleManager().s14fw600Grey,
              ),
            ) :
            SizedBox(),

            TableGenerator(
              horizontalPadding: 10,
              tableRows: [
                TableModel(
                    title: "Status :",
                    data: support.status ?? "N/A",
                    dataTextStyle: FontStyleManager().s14fw800Grey),
                TableModel(
                    title: "Resolution :",
                    data: support.resolution ?? "N/A",
                    dataTextStyle: FontStyleManager().s14fw800Grey),
                TableModel(
                    title: support.resolutionRemarks != null
                        ? "Resolution Remarks :"
                        : "")
              ],
            ),
            support.resolutionRemarks != null
                ? Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                support.resolutionRemarks.toString(),
                style: FontStyleManager().s14fw800Grey,
              ),
            )
                : const SizedBox(),


            CustomButton(
              verticalPadding: 20,
              onTap: () {
                Navigator.pop(context);
              },
              buttonTitle: "BACK",
              width: 180,
            ),
            // _showRequestUpdateButton(support: support) ?
            // CustomButton(
            //   verticalPadding: 10,
            //   isActive: false,
            //   onTapEvenIfActiveIsFalse: true,
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            //   buttonTitle: "REQUEST UPDATE",
            //   width: 180,
            // ) :
            //     const SizedBox(),

            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                "*This ticket will be closed after 24 hours",
                style: FontStyleManager().s14fw400ItalicGrey,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ));
  }
  bool _showRequestUpdateButton({required OrderInfoSupport support}){
    DateTime createdAt = DateTime.parse(support.createdAt.toString());
    DateTime today = DateTime.now();

    if(today.isAfter(createdAt.add(Duration(days: 2))) &&
        support.status.toString() != "Resolved"){
      return true;

    }else{
      return false;
    }
  }
}
