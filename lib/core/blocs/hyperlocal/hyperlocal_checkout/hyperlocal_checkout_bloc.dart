import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/hyperlocal_checkoutrepository.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_paymentmodel.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_previewmodel.dart';
import 'package:santhe/pages/animated_loading_Screen.dart';
import 'package:santhe/pages/ondc/ondc_webview_screen/ondc_webview_screen_view.dart';
import 'package:santhe/pages/upi_screen.dart';
import 'package:santhe/widgets/custom_widgets/custom_snackBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/hyperlocal_models/hyperlocal_payment_model.dart';
import '../../../../pages/hyperlocal/hyperlocal_paymentsucess/hyperlocal_paymentsucess_view.dart';

part 'hyperlocal_checkout_event.dart';
part 'hyperlocal_checkout_state.dart';

class HyperlocalCheckoutBloc
    extends Bloc<HyperlocalCheckoutEvent, HyperlocalCheckoutState>
    with LogMixin {
  final HyperLocalCheckoutRepository hyperLocalCheckoutRepository;
  HyperlocalCheckoutBloc({required this.hyperLocalCheckoutRepository})
      : super(HyperlocalCheckoutInitial()) {
    on<HyperlocalCheckoutEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetOrderInfoEvent>((event, emit) async {
      emit(GetOrderInfoLoadingState());
      try {
        final List<HyperLocalPreviewModel> previewModels =
            await hyperLocalCheckoutRepository.getOrderdetails(
                orderId: event.orderId);
        emit(
          GetOrderInfoSuccessState(hyperLocalPreviewModels: previewModels),
        );
      } on GetOrderInfoErrorState catch (e) {
        emit(
          GetOrderInfoErrorState(message: e.message),
        );
      }
    });
    on<GetOrderInfoPostEvent>((event, emit) async {
      emit(GetOrderInfoPostLoadingState());
      try {
        final String orderIdBloc = await hyperLocalCheckoutRepository
            .postOrderInfo(storeDescriptionId: event.storeDescription_id);
        warningLog('OrderId $orderIdBloc');
        emit(GetOrderInfoPostSuccessState(orderId: orderIdBloc));
      } on GetOrderInfoPostErrorState catch (e) {
        emit(GetOrderInfoErrorState(message: e.message));
      }
    });



   // on<VerifyPaymentEventHyperlocal>((event, emit)

    verifyPaymentEventHyperlocal({required bool isUpiPayment,required String orderId }) async {
     // emit(VerifyPaymentHyperlocalLoadingState());

      Future.delayed(Duration(seconds: isUpiPayment ? 25 : 600)).then((value) async{
     //   if(Get.currentRoute.contains("AnimatedLoadingScreen") || Get.currentRoute.contains("ONDCWebviewView")){
          late bool status ;
          try {
            for(var i =0 ; i <=60; i++){
              final bool verified = await hyperLocalCheckoutRepository.verifyPayment(
                  orderID: orderId);
              if(verified){
                status = true;
                break;
              }
              // else if(!Get.currentRoute.contains("AnimatedLoadingScreen")){
              //   i = 31;
              // }
              else{
                status = false;
                await Future.delayed(const Duration(seconds: 2));
              }
            }

            // emit(
            //   VerifyPaymentHyperlocalSuccessState(message: message),
            // );
          } on VerifyPaymentHyperlocalErrorState catch (e) {
          //  emit(VerifyPaymentHyperlocalErrorState(message: e.message));
          }finally{
            if(status){
              Get.to(()=> const HyperlocalPaymentsucessView());
            }else{
             if(Get.currentRoute.contains("AnimatedLoadingScreen")){
               Get.back();
             }
              customSnackBar(message: "Payment Failed Please Try Again",
                  isErrorMessage: true,showOnTop: true);
            }
          }

      //  }

      });
    }
    //);

    on<PostPaymentCheckoutEvent>((event, emit) async {
      emit(PostPaymentHyperlocalLoadingState());
      bool hasError = false;
      try {
        //  final HyperLocalPaymentModel paymentInfoModel =
        final String intentUrl =  await hyperLocalCheckoutRepository.postPaymentCheckout(
            orderIdRec: event.orderId, targetApp: event.targetApp,isUpi: event.isUpiPayment);
        if(!intentUrl.contains("error")){
          Get.back();
          if(event.isUpiPayment){

            try{

              launchUrl(Uri.parse(intentUrl)).onError((error, stackTrace) {
                Get.back();
                hasError = true;
                customSnackBar(message: "Couldn't Find Payment Apps", isErrorMessage: true,showOnTop: true);
                return false;
              });
            }catch(e){
              print("ERRROR LAUNCHING INTENT ==$e");

            }
            if(!hasError){
              Get.to(()=> const AnimatedLoadingScreen());
              verifyPaymentEventHyperlocal(
                  orderId: event.orderId,
                  isUpiPayment: true);

            }
          }else{
            Get.to(()=>PaymentWebviewScreen(url: intentUrl));
          }

        }else{
          customSnackBar(message: "Sorry Can't Create "
              "The Order Now Please Try After Some Time",
              showOnTop: true,
              isErrorMessage: true
          );
        }

        // emit(PostPaymentHyperlocalSuccessState(
        //     hyperlocalPaymentInfo: paymentInfoModel));


      } on PostPaymentHyperlocalErrorState catch (e) {
        emit(PostPaymentHyperlocalErrorState(message: e.message));
      }
    });
    // on<PostUPIPaymentCheckoutEvent>((event,emit) async {
    //
    //   final res;
    //
    //   String upiId = "Manjunath.munegowda-1@okicici",
    //       name = "Santhe",
    //       amount="1",
    //       message="OrderId Here",
    //       currency="INR";
    //
    //  try{
    //
    //    // final HyperLocalPaymentModel paymentInfoModel =
    //    // await hyperLocalCheckoutRepository.postPaymentCheckout(
    //    //     orderIdRec: event.orderId);
    //
    //
    //    // Get.to(()=>  const UpiScreen());//UpiWebView(paymentModel: paymentInfoModel,));
    //    // res =
    //    //
    //
    //    // TODO: add your success logic here
    //
    //     // customSnackBar(
    //     //   message: "PAYMENT WAS SUCCESSFUL HERE IS THE MESSAGE "
    //     //       "${res.toString()}",
    //     //   showOnTop: true
    //     // );
    //
    //  // print("RESPONSE AFTER SUCCESSFUL PAYMENT =========== $res");
    //
    //  }catch (e) {
    //
    //      customSnackBar(message: "Something Went Wrong Please Try Again Later",
    //          isErrorMessage: true,
    //          showOnTop: true);
    //
    //    // TODO: add your exception logic here
    //  }
    // });



  }
}
