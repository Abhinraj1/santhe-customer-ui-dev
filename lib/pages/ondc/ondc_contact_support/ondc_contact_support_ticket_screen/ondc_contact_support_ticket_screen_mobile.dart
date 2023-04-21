import 'package:flutter/material.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import 'package:santhe/widgets/custom_widgets/table_generator.dart';

import '../../../../manager/font_manager.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/ondc_contact_support_widgets/images_list_textButton.dart';


class ONDCContactSupportTicketScreenMobile extends StatelessWidget {
  const ONDCContactSupportTicketScreenMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String description = "Item was received in damaged status "
        "and is not usable and some extended description about the issue as"
        " reported by the customer will be shown here in multiple lines  ";

    return  CustomScaffold(
        body: ListView(
          children:  [
            const CustomTitleWithBackButton(
              title: 'Support Ticket',
            ),
            TableGenerator(
              tableRows: [
                TableModel(title: "Order ID :", data: "data"),
                TableModel(title: "Ticket ID :", data: "data"),
                TableModel(title: "Category :", data: "data"),
                TableModel(title: "Subcategory :", data: "data"),
                TableModel(title: "Description :"),

              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(description,style:  FontStyleManager().s14fw600Grey,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
              child: Text("Attachments :",style:  FontStyleManager().s14fw600Grey,),
            ),
            const ImagesListTextButton(),
            TableGenerator(
              tableRows: [
                TableModel(title: "Status :", data: "data",
                    dataTextStyle: FontStyleManager().s14fw800Grey),
                TableModel(title: "Resolution :", data: "data",
                    dataTextStyle: FontStyleManager().s14fw800Grey),
                TableModel(title: "Resolution Remarks :"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
              child: Text("Refund request is raised outside the return time"
                  " limit. Return request and refund cannot be processed as per policy  ",
                style:  FontStyleManager().s14fw800Grey,),
            ),

            TableGenerator(
              tableRows: [
                TableModel(title: "Processing Entity :",
                    dataTextStyle: FontStyleManager().s14fw800Grey),
                TableModel(title: "Org :", data: "data",
                    dataTextStyle: FontStyleManager().s14fw800Grey),
                TableModel(title: "Phone :",data: "data"),
                TableModel(title: "Email :", data: "transactioncounterpartyapp@tcapp.com",
                    dataTextStyle: FontStyleManager().s14fw800Grey),
                TableModel(title: "In case of further grievance please contact :",
                    dataTextStyle: FontStyleManager().s14fw800Grey),
                TableModel(title: "Name :", data: "data"),
                TableModel(title: "Phone :", data: "data",
                    dataTextStyle: FontStyleManager().s14fw800Grey),
                TableModel(title: "Email :", data: "data",
                    dataTextStyle: FontStyleManager().s14fw800Grey),
                TableModel(title: "Resolution Remarks :"),
              ],
            ),
            CustomButton(
              onTap: (){},
              buttonTitle: "BACK",
              width: 180,
            ),
            const SizedBox(
              height: 30,
            )

          ],
        )
    );
  }
}
