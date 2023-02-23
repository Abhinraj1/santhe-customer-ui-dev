import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../models/ondc/shop_model.dart';
import '../../../pages/ondc/ondc_contact_support/ondc_contact_support_enter_query_screen/ondc_contact_support_enter_query_screen_mobile.dart';
import '../../../pages/ondc/ondc_contact_support/ondc_contact_support_shop_contact_details_screen/ondc_contact_support_shop_contact_details_screen_mobile.dart';
import '../../../pages/ondc/ondc_return_screens/ondc_return_acknowledgement _screen/ondc_return_acknowledgement _screen_mobile.dart';
import '../../repositories/ondc_repository.dart';
import 'customer_contact_state.dart';




class CustomerContactCubit extends Cubit<CustomerContactState>{
  CustomerContactCubit() :
        super(CustomerContactInitialState());

  void sendQuery({required String orderId, required String message}) async{

    emit(CustomerContactLoadingState());

   try{
     int statusCode = await OndcRepository().
     sendContactSupportQuery(
         orderId: orderId,
         message: message
     );

     if(statusCode == 200){

       Get.to(()=>const ONDCReturnAcknowledgement(
         title: "Contact Support",
         message: "Thanks for contacting support."
             " We have created a ticket for your query"
             " and sent you an email with details. "
             "Please check your email for follow up. ",

       ));
       return emit(CustomerContactSentSuccessfulState());
     

     }

   }catch(e){

     emit(CustomerContactErrorState(message: e.toString()));
   }

  }

  void customerContact({required ShopModel model}){

    String mail = model.email.toString();
    String phone = model.phone.toString();

    if( mail != "null" && mail != "" && phone != "null" && phone != ""){
      ///Navigate to contact details

      Get.to(()=>  ONDCContactSupportShopContactDetailsScreen(
        shopModel: model,
      ));

    }else{
      ///Navigate to query screen
      Get.to(()=>  ONDCContactSupportEnterQueryScreenMobile());

    }
  }

}