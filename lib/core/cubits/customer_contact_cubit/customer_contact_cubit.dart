import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../models/ondc/shop_model.dart';
import '../../../models/ondc/single_order_model.dart';
import '../../../pages/ondc/ondc_acknowledgement_screen/ondc_acknowledgement_screen_mobile.dart';
import '../../../pages/ondc/ondc_contact_support/ondc_contact_support_enter_query_screen/ondc_contact_support_enter_query_screen_mobile.dart';
import '../../../pages/ondc/ondc_contact_support/ondc_contact_support_shop_contact_details_screen/ondc_contact_support_shop_contact_details_screen_mobile.dart';
import '../../repositories/ondc_repository.dart';
import 'customer_contact_state.dart';




class CustomerContactCubit extends Cubit<CustomerContactState>{
  CustomerContactCubit() :
        super(CustomerContactInitialState());

  void sendQuery({required String orderNumber, required String message}) async{

    emit(CustomerContactLoadingState());

   try{
     int statusCode = await OndcRepository().
     sendContactSupportQuery(
         orderId: orderNumber,
         message: message
     );

     if(statusCode == 200){

       Get.to(()=> ONDCAcknowledgementScreenMobile(
         title: "Contact Support",
         orderNumber: orderNumber,
         message: "Thanks for contacting support."
             " We have created a ticket for your query"
             " and sent you an email with details. "
             "Please check your email for follow up. ",

         onTap: (){

         },

       ));
       return emit(CustomerContactSentSuccessfulState());
     

     }

   }catch(e){

     emit(CustomerContactErrorState(message: e.toString()));
   }

  }

  void customerContact({required SingleOrderModel model}){

    String mail = (model.storeLocation?.store?.email).toString();
    String phone = (model.storeLocation?.store?.phone).toString();

    if( mail != "null" && mail != "" && phone != "null" && phone != ""){
      ///Navigate to contact details

      Get.to(()=>  ONDCContactSupportShopContactDetailsScreen(
        model: model,
      ));

    }else{
      ///Navigate to query screen
      Get.to(()=>  ONDCContactSupportEnterQueryScreenMobile(
        store: model,
      ));

    }
  }

}