import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as ge;
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/core/repositories/ondc_order_cancel_and_return_repository.dart';
import 'package:santhe/pages/ondc/ondc_customer_order_history_screen/ondc_order_history_view.dart';
import '../../../../constants.dart';
import '../../../../models/ondc/order_cancel_reasons_model.dart';
import '../../../../models/ondc/preview_ondc_cart_model.dart';
import '../../../../models/ondc/single_order_model.dart';
import '../../../../pages/ondc/ondc_acknowledgement_screen/ondc_acknowledgement_view.dart';
import '../../../../pages/ondc/ondc_intro/ondc_intro_view.dart';
import '../../../../pages/ondc/ondc_order_cancel_screen/ondc_order_cancel_view.dart';
import '../../../../pages/ondc/ondc_order_details_screen/ondc_order_details_view.dart';
import '../../../../pages/ondc/ondc_return_screens/ondc_return_view.dart';
import '../../../../pages/ondc/ondc_shop_list/ondc_shop_list_view.dart';
import '../../../../utils/order_details_screen_routing_logic.dart';
import '../../../cubits/customer_contact_cubit/customer_contact_cubit.dart';
import '../../../cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_cubit.dart';
import '../../../cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_state.dart';
import '../../../cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_cubit.dart';
import '../../../loggers.dart';
import 'package:bloc/bloc.dart';
import '../../../repositories/ondc_repository.dart';
part 'ondc_order_cancel_and return_event.dart';
part 'ondc_order_cancel_and_return_state.dart';




class ONDCOrderCancelAndReturnReasonsBloc extends Bloc<ONDCOrderCancelAndReturnEvent,
    ONDCOrderCancelAndReturnState> with LogMixin {

  final ONDCOrderCancelAndReturnRepository orderCancelRepository;
   List<ReasonsModel> reasons = [];
    String selectedCode = "";
    String orderId = "";
    String orderNumber = "";
  late PreviewWidgetModel _product;
  late PreviewWidgetModel _partialCancelProduct;

  ONDCOrderCancelAndReturnReasonsBloc({
    required this.orderCancelRepository,
  }) : super(Loading()) {

    on<ONDCOrderCancelAndReturnEvent>((event, emit) {});


    on<LoadReasonsForFullOrderCancelEvent>((event, emit) async {


      Get.to(()=> const ONDCOrderCancelView());


      emit(Loading());

      try{
        reasons = await orderCancelRepository.getReasons();
        orderId = event.orderId;
        orderNumber = event.orderNumber;
        emit(ReasonsLoadedFullOrderCancelState(
            reasons: reasons,
            orderId: event.orderId,
            orderNumber: event.orderNumber));

      }catch(e){

        emit(OrderCancelErrorState(message: e.toString()));
      }

    });







    on<LoadReasonsForPartialOrderCancelEvent>((event, emit) async {



      emit(Loading());

      try{
        reasons = await orderCancelRepository.getReasons();
        orderId = event.orderId;
        orderNumber = event.orderNumber;
        _partialCancelProduct = event.previewWidgetModel;

        emit(ReasonsLoadedPartialOrderCancelState(
            reasons: reasons,
            orderId: event.orderId,
            orderNumber: event.orderNumber));

        if(state is ReasonsLoadedPartialOrderCancelState){

          Get.to(()=> const ONDCOrderCancelView());
        }

      }catch(e){

        emit(OrderCancelErrorState(message: e.toString()));
      }

    });



    on<LoadReasonsForReturnEvent>((event, emit) async {

      _product = event.product;

      Get.to(()=> const ONDCOrderCancelView());

      emit(Loading());

      try{
        reasons = await orderCancelRepository.getReasons(isReturn: true);
        orderId = event.orderId;
        orderNumber = event.orderNumber;
        emit(
            ReasonsLoadedForReturnState(
            reasons: reasons,
            orderId: event.orderId,
            orderNumber: event.orderNumber));

      }catch(e){
        emit(OrderCancelErrorState(message: "Return Error //${e.toString()}"));
      }
    });


    on<PartialCancelOrderRequestEvent>((event, emit) async{

      print("Selected code iss ##############################"
          "################ $selectedCode");

      emit(Loading());

      try{
  print("#################### orderId = $orderId CartPriceItemId = "
    "${_partialCancelProduct.id} ");

        String status =
        await orderCancelRepository.requestReturnOrPartialCancel(
            code: selectedCode,
            orderId: orderId,
            cartItemPricesId: _partialCancelProduct.id.toString(),
            images: [],
            quantity: _partialCancelProduct.quantity.toString(),
            isReturn: false);

        print("#####################################"
            "###############3 STATUS IS $status");

        if(status == "SUCCESS" ){

          emit(OrderCancelRequestSentState());

          if(state is OrderCancelRequestSentState ){
            Get.to(()=> ONDCAcknowledgementView(
                title: "Cancel Order",
                message: "Your cancellation request is received,"
                    " Once we have received a confirmation from"
                    " the seller you will get an update from us "
                    "on your cancellation status and refund details",

                onTap: (){

                  BlocProvider.of<OrderDetailsScreenCubit>(event.context)
                      .loadOrderDetails(
                      orderId: orderId);

                  Get.offAll(()=> ONDCOrderDetailsView(
                    onBackButtonTap: (){
                      orderDetailsScreenRoutingLogic();
                    },
                  ),
                      transition: ge.Transition.leftToRight);

                  // if(isUserFromMyOrders ?? false){
                  //   Get.to(()=>const ONDCOrderHistoryView());
                  // }else{
                  //   Get.to(OndcShopListView(customerModel: customerModel,));
                  // }
                },

                orderNumber: orderNumber));
          }

        }else if (status.toString().
        contains("Seller is not responding , Please try later")){
          Get.back();
          BlocProvider.of<OrderDetailsScreenCubit>(event.context).
          sellerNotResponded(
              message: "Seller is not responding , Please try later");
        }

      }catch(e){
        emit(OrderCancelErrorState(message: e.toString()));
      }

    });


  on<CancelFullOrderRequestEvent>((event, emit) async{

    print("Selected code iss #########################"
        "##################### $selectedCode");

    emit(Loading());

    try{


      String status = await orderCancelRepository.fullOrderCancelPost(
          code: selectedCode,
          orderId: orderId);


         if(status == "SUCCESS" ){
        Get.to(()=> ONDCAcknowledgementView(
            title: "Cancel Order",
            message: "Your cancellation request is received,"
                " Once we have received a confirmation from"
                " the seller you will get an update from us "
                "on your cancellation status and refund details",


            onTap: (){
              BlocProvider.of<OrderDetailsScreenCubit>(event.context)
                  .loadOrderDetails(
                  orderId: orderId);

              Get.offAll(()=> ONDCOrderDetailsView(
                onBackButtonTap: (){
                  orderDetailsScreenRoutingLogic();
                },
              ),
                  transition: ge.Transition.leftToRight);

              // if(isUserFromMyOrders ?? false){
              //
              //   Get.to(()=>const ONDCOrderHistoryView());
              // }else{
              //   Get.to(OndcShopListView(customerModel: customerModel,));
              // }
            },
            orderNumber: orderNumber));

        emit(OrderCancelRequestSentState());

      }else if (status.toString().
         contains("Seller is not responding , Please try later")){
           Get.back();
           BlocProvider.of<OrderDetailsScreenCubit>(event.context).
           sellerNotResponded(
               message: "Seller is not responding , Please try later");
         }

    }catch(e){
      emit(OrderCancelErrorState(message: e.toString()));
    }

  });

    on<SelectedCodeEvent>((event, emit) {


      if(event.code != "null" || event.code != ""){
        selectedCode = event.code;

        emit( SelectedCodeState(
            code: event.code.toString(),
            orderNumber: orderNumber,
            orderId:orderId,
            reasons: reasons
        ));

      }
    });

    on<SelectedCodeForPartialOrderCancelEvent>((event, emit) {

      if(event.code != "null" || event.code != ""){
        selectedCode = event.code;

        emit( SelectedCodeForPartialOrderCancelState(
            code: event.code.toString(),
            orderNumber: orderNumber,
            orderId:orderId,
            reasons: reasons
        ));

      }
    });

    on<SelectedCodeForReturnEvent>((event, emit) {


      if(event.code != "null" || event.code != ""){
        selectedCode = event.code;

        BlocProvider.of<UploadImageAndReturnRequestCubit>
          (event.context).getPrerequisiteData(
            orderId: orderId, orderNumber: orderNumber,
            returnProduct: _product,
            code: event.code);

        emit( SelectedCodeForReturnState(
            code: event.code.toString(),
            orderNumber: orderNumber,
            orderId:orderId,
            reasons: reasons,
            returnProduct: _product,
        ));

      }
    });
  }}