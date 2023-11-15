import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/constants.dart';
import '../../../models/ondc/shop_model.dart';
import '../../../models/ondc/single_order_model.dart';
import '../../../models/ondc/support_contact_models.dart';
import '../../../pages/ondc/ondc_acknowledgement_screen/ondc_acknowledgement_screen_mobile.dart';
import '../../../pages/ondc/ondc_contact_support/ondc_contact_support_enter_query_screen/ondc_contact_support_enter_query_screen_mobile.dart';
import '../../../pages/ondc/ondc_contact_support/ondc_contact_support_shop_contact_details_screen/ondc_contact_support_shop_contact_details_screen_mobile.dart';
import '../../repositories/ondc_repository.dart';
import 'customer_contact_state.dart';

class CustomerContactCubit extends Cubit<CustomerContactState> {
  CustomerContactCubit() : super(CustomerContactInitialState());

  late List<CategoryModel> category = [];

  late List<CategoryModel> subCategory = [];

  late String _orderNumber = "";

  String selectedCategoryCode = "";

  String selectedSubCategoryCode = "";

  OndcRepository repo = OndcRepository();

  resetCustomerContactState(){
    emit(CustomerContactInitialState());
  }

  void getAllCategories({required String orderNumber}) async {
    _orderNumber = orderNumber;

    emit(CustomerContactLoadingState());

    try {
      category = await repo.getCategoryForContactSupport();

      subCategory = await repo.getSubCategoryForContactSupport();

      if (category.isNotEmpty && subCategory.isNotEmpty) {
        emit(CustomerContactLoadedState(
            category: category, subCategory: subCategory));
      }
    } catch (e) {
      emit(CustomerContactErrorState(message: e.toString()));
    }
  }

  submitContactSupportDetails(
      {required String orderId,
      required String longDescription,
      required List<String> cartItemPricesId,
      required List<String> images,
      String? shortDescription,
      required String categoryCode,
      required String subCategoryCode}) async {
    try {
      String response = await repo.raiseIssue(
          orderId: orderId,
          longDescription: longDescription,
          cartItemPricesId: cartItemPricesId,
          images: images,
          shortDescription: shortDescription,
          categoryCode: categoryCode,
          subCategoryCode: subCategoryCode);

      if (response == "SUCCESS") {
        selectedCartItemPriceId.clear();
        imageListForContactSupport.clear();

        Get.off(() => ONDCAcknowledgementScreenMobile(
              title: "Contact Support",
              orderNumber: _orderNumber,
              message: "Thanks for contacting support."
                  " We have created a ticket for your query "
                  "and sent you an email with details. "
                  "Please check your email for "
                  "follow up and come back to this screen for get latest updates  ",
              onBack: () {
                Get.close(4);
              },
            ));
        return emit(CustomerContactSentSuccessfulState());
      }
    } catch (e) {}
  }

  void customerContact({required SingleOrderModel model}) {
    String mail = (model.storeLocation?.store?.email).toString();
    String phone = (model.storeLocation?.store?.phone).toString();

    if (mail != "null" && mail != "" && phone != "null" && phone != "") {
      ///Navigate to contact details

      Get.to(() => ONDCContactSupportShopContactDetailsScreen(
            model: model,
          ));
    } else {
      ///Navigate to query screen
      Get.to(() => ONDCContactSupportEnterQueryScreenMobile(
            store: model,
          ));
    }
  }


}
