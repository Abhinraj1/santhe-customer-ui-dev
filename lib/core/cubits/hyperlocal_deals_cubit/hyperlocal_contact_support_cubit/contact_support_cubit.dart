import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:meta/meta.dart';
import 'package:santhe/widgets/custom_widgets/custom_snackBar.dart';

import '../../../repositories/hyperlocal_contact_support.dart';

part 'contact_support_state.dart';

class ContactSupportCubit extends Cubit<ContactSupportState> {
final HyperlocalContactSupportRepository repo;
  ContactSupportCubit({required this.repo}) : super(ContactSupportInitial());

  submitContactSupport({required String reason,
    required String orderId,
  }) async{

    try{

    String type =  await HyperlocalContactSupportRepository().postRaiseTicket(
          reason: reason, orderId: orderId, );

    if(type.contains("SUCCESS")){
      Get.back();
    }else{
      customSnackBar(
        isErrorMessage: true,
          message: "Something Went Wrong. Please Try Later.");
    }

    }catch(e){

      print("ERROR IN ContactSupportCubit = $e");

    }
  }

}
