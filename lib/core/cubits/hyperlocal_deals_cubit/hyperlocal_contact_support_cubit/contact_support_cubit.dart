import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:meta/meta.dart';
import 'package:santhe/models/ondc/single_order_model.dart';
import 'package:santhe/widgets/custom_widgets/custom_snackBar.dart';

import '../../../../models/hyperlocal_models/hyperlocal_orders_model.dart';
import '../../../repositories/hyperlocal_contact_support.dart';

part 'contact_support_state.dart';

class ContactSupportCubit extends Cubit<ContactSupportState> {
final HyperlocalContactSupportRepository repo;
  ContactSupportCubit({required this.repo}) : super(ContactSupportInitial());


  resetContactSupportCubit(){
    emit(ContactSupportInitial());
  }
  submitContactSupport({required String reason,
    required String orderId,
  }) async{

    try{

      emit(ContactSupportLoading());

    String type =  await HyperlocalContactSupportRepository().postRaiseTicket(
          reason: reason, orderId: orderId, );

    if(type.contains("SUCCESS")){
      Get.back(result: "refreshScreen");
      customSnackBar(
          message: "Support Ticket Raised");
    }else{
      customSnackBar(
        isErrorMessage: true,
          message: "Something Went Wrong. Please Try Later.");
    }

    emit(ContactSupportInitial());
    }catch(e){

      print("ERROR IN ContactSupportCubit = $e");

    }

    }

loadSupportTicketDetails({required String supportId}) async{

  emit(ContactSupportLoading());

  try{

    OrderInfoSupport support = await repo.getSupportDetails(
        supportId: supportId);

    emit(ContactSupportDetailsLoaded(support: support));

  }catch(e){

  }
}
  }


