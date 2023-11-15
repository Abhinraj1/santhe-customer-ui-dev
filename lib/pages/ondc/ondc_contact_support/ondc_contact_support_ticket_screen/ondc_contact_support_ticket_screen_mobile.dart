import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:santhe/models/ondc/single_order_model.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import 'package:santhe/widgets/custom_widgets/table_generator.dart';

import '../../../../manager/font_manager.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../../widgets/ondc_contact_support_widgets/images_list_textButton.dart';

class ONDCContactSupportTicketScreenMobile extends StatelessWidget {
  final Support support;
  const ONDCContactSupportTicketScreenMobile({Key? key, required this.support})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

List<String> img = [];
support.images!.forEach((element) {
  img.add(  element.toString());
});
     return CustomScaffold(
        trailingButton: homeIconButton(),
        body: ListView(
      children: [
        const CustomTitleWithBackButton(
          title: 'Support Ticket',
        ),
        TableGenerator(
          tableRows: [
            TableModel(title: "Order ID :", data: support.orderId.toString()),
            TableModel(title: "Ticket ID :", data: support.id ?? "N/A"),
            TableModel(title: "Category :", data: support.category),
            TableModel(title: "Subcategory :", data: support.subCategory),
            TableModel(title:support.longDescription != null
                ? "Description :" : ""),
          ],
        ),
        support.longDescription != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  support.longDescription.toString(),
                  style: FontStyleManager().s14fw600Grey,
                ),
              )
            : const SizedBox(),
        support.images!.isNotEmpty
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  "Attachments :",
                  style: FontStyleManager().s14fw600Grey,
                ),
              )
            : const SizedBox(),

        support.images!.isNotEmpty ?
         ImagesListTextButton(imgList:  img,)
            : SizedBox(),

        TableGenerator(
          tableRows: [
            TableModel(
                title: "Status :",
                data: support.status.toString(),
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
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  support.resolutionRemarks.toString(),
                  style: FontStyleManager().s14fw800Grey,
                ),
              )
            : const SizedBox(),
        TableGenerator(
          tableRows: [
            TableModel(
                title: "Processing Entity :",
                dataTextStyle: FontStyleManager().s14fw800Grey),
            TableModel(
                title: "Org :",
                data: support.organisationName ?? "N/A",
                dataTextStyle: FontStyleManager().s14fw800Grey),
            TableModel(
                title: "Phone :", data: support.organisationPhone ?? "N/A"),
            TableModel(
                title: "Email :",
                data: support.organisationEmail ?? "N/A",
                dataTextStyle: FontStyleManager().s14fw800Grey),
            TableModel(
                title: "In case of further grievance please contact :",
                dataTextStyle: FontStyleManager().s14fw800Grey),
            TableModel(title: "Name :", data: support.groName ?? "N/A"),
            TableModel(
                title: "Phone :",
                data: support.groPhone ?? "N/A",
                dataTextStyle: FontStyleManager().s14fw800Grey),
            TableModel(
                title: "Email :",
                data: support.groEmail ?? "N/A",
                dataTextStyle: FontStyleManager().s14fw800Grey),
          ],
        ),
        CustomButton(
          onTap: () {
            Navigator.pop(context);
          },
          buttonTitle: "BACK",
          width: 180,
        ),
        const SizedBox(
          height: 30,
        )
      ],
    ));
  }
}
