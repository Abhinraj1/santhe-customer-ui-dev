import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/cubits/customer_contact_cubit/customer_contact_state.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/cubits/customer_contact_cubit/customer_contact_cubit.dart';
import '../../../../manager/font_manager.dart';
import '../../../../models/ondc/single_order_model.dart';
import '../../../../widgets/custom_widgets/customScaffold.dart';
import '../../../../widgets/custom_widgets/custom_button.dart';
import '../../../../widgets/custom_widgets/custom_title_with_back_button.dart';
import '../../../../widgets/custom_widgets/home_icon_button.dart';
import '../../../../widgets/custom_widgets/custom_testField.dart';
import '../../../../widgets/ondc_contact_support_widgets/add_items_DialogBox.dart';
import '../../../../widgets/ondc_contact_support_widgets/drop_down_button.dart';
import '../../../../widgets/ondc_contact_support_widgets/image_attachment_textButton.dart';


class ONDCContactSupportEnterQueryScreenMobile extends StatefulWidget {
  final SingleOrderModel store;

  const ONDCContactSupportEnterQueryScreenMobile({Key? key, required this.store})
      : super(key: key);

  @override
  State<ONDCContactSupportEnterQueryScreenMobile> createState() => _ONDCContactSupportEnterQueryScreenMobileState();
}

class _ONDCContactSupportEnterQueryScreenMobileState extends State<ONDCContactSupportEnterQueryScreenMobile> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String orderId = widget.store.orderNumber.toString();
    String selectedCatCode = "";
    String selectedSubCatCode = "";
    TextEditingController descriptionController = TextEditingController();



    return CustomScaffold(
        backgroundColor: AppColors().grey20,
        trailingButton: homeIconButton(),
        body: BlocBuilder<CustomerContactCubit, CustomerContactState>(
          builder: (context, state) {
            if(state is CustomerContactLoadedState){

              return ListView(
                children: [
                  const CustomTitleWithBackButton(
                      title: "Contact Support"),
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
                  //  TextFieldForQuery(controller: textEditingController),
                  CustomDropDownButton(
                    title: "Category",
                   list: state.category,
                    selectedCode: (selected) {

                        selectedCatCode = selected;


                      print("RETURNED VALUE CAT =$selected");
                    },
                  ),
                  CustomDropDownButton(
                    title: "Subcategory",
                    list: state.subCategory,
                    selectedCode: (selected) {
                      selectedSubCatCode = selected;
                    },
                  ),
                  AddItems(
                    store: widget.store,
                  ),


                  CustomTextField(
                    controller: descriptionController,
                    hintText: " ",
                    labelText: "Description",
                    readOnly: false,
                    maxLines: 10,
                    validate: (String? val) {
                      if (val == "") {
                        return "Please Enter Description";
                      }
                      return null;
                    },
                  ),

                  const ImageAttachmentTextButton(),

                  Obx(
                     () {
                       if(isImageLoading.value){
                         return const Center(
                           child: CircularProgressIndicator(),
                         );
                       }else{
                         return
                           CustomButton(
                             onTap: () {

                               BlocProvider.of<CustomerContactCubit>(context)
                                   .submitContactSupportDetails(
                                   orderId: widget.store.quotes!.
                                   first.orderId.toString(),

                                   longDescription: descriptionController.text,
                                   cartItemPricesId: selectedCartItemPriceId,
                                   images: imageListForContactSupport,
                                   categoryCode: selectedCatCode,
                                   subCategoryCode: selectedSubCatCode);
                             },
                             buttonTitle: "SUBMIT");
                       }
                    }
                  ),



                  const SizedBox(
                    height: 40,
                  )
                ],
              );
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
