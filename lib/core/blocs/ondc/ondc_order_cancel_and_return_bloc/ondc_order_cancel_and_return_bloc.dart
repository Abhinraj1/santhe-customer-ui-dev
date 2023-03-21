import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/core/repositories/ondc_order_cancel_and_return_repository.dart';
import 'package:santhe/pages/ondc/ondc_order_cancel_screen/ondc_order_cancel_acknowledgement%20_screen/ondc_order_cancel_acknowledgement_view.dart';
import '../../../../models/ondc/order_cancel_reasons_model.dart';
import '../../../../models/ondc/preview_ondc_cart_model.dart';
import '../../../../models/ondc/single_order_model.dart';
import '../../../../pages/ondc/ondc_order_cancel_screen/ondc_order_cancel_acknowledgement _screen/ondc_order_cancel_acknowledgement _screen_mobile.dart';
import '../../../../pages/ondc/ondc_order_cancel_screen/ondc_order_cancel_view.dart';
import '../../../../pages/ondc/ondc_return_screens/ondc_return_view.dart';
import '../../../cubits/customer_contact_cubit/customer_contact_cubit.dart';
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
  late CartItemPrices _product;
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

      Get.to(()=> const ONDCOrderCancelView());

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

      print("Selected code iss ############################################## $selectedCode");

      emit(Loading());

      try{


        String status =
        await orderCancelRepository.requestReturnOrPartialCancel(
            code: selectedCode,
            orderId: orderId,
            quotesId: _partialCancelProduct.quoteId.toString(),
            images: _partialCancelProduct.symbol.toList(),
            quantity: '',
            isReturn: false);

        if(status == "ACK" ){

          Get.to(()=> ONDCOrderCancelAcknowledgementView(orderNumber: orderNumber));

          emit(FullOrderCancelRequestSentState());

        }

      }catch(e){
        emit(OrderCancelErrorState(message: e.toString()));
      }

    });

  on<CancelFullOrderRequestEvent>((event, emit) async{

    print("Selected code iss ############################################## $selectedCode");

    emit(Loading());

    try{


      String status = await orderCancelRepository.fullOrderCancelPost(
          code: selectedCode,
          orderId: orderId);

      if(status == "ACK" ){

        Get.to(()=> ONDCOrderCancelAcknowledgementView(orderNumber: orderNumber));

        emit(FullOrderCancelRequestSentState());

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

    on<SelectedCodeForReturnEvent>((event, emit) {


      if(event.code != "null" || event.code != ""){
        selectedCode = event.code;

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