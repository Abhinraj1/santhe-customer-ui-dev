// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/loggers.dart';

import 'package:santhe/core/repositories/ondc_checkout_repository.dart';
import 'package:santhe/models/ondc/checkout_cart.dart';
import 'package:santhe/models/ondc/final_costing.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> with LogMixin {
  final OndcCheckoutRepository ondcCheckoutRepository;
  CheckoutBloc({required this.ondcCheckoutRepository})
      : super(CheckoutInitial()) {
    on<CheckoutEvent>((event, emit) {});

    on<GetCartPriceEventPost>((event, emit) async {
      emit(CheckoutPostLoading());
      debugLog('store id ${event.storeLocation_id}');
      try {
        final String messageId =
            await ondcCheckoutRepository.proceedToCheckoutMethodPost(
                transactionId: event.transactionId,
                storeLocation_id: event.storeLocation_id);
        emit(
          CheckoutPostSuccess(messageId: messageId),
        );
      } on CheckoutPostError catch (e) {
        emit(
          CheckoutPostError(
            message: e.toString(),
          ),
        );
      }
    });
    on<GetCartPriceEventGet>((event, emit) async {
      emit(CheckoutGetLoading());
      try {
        List<CheckoutCartModel> models =
            await ondcCheckoutRepository.proceedToCheckoutGet(
                transactionId: event.transactionId, messageId: event.messageId);
        warningLog('models $models');
        emit(
          CheckoutGetSuccess(cartModels: models),
        );
      } on CheckoutGetError catch (e) {
        emit(CheckoutGetError(message: e.message));
      }
    });

    on<GetFinalItemsEvent>((event, emit) async {
      try {
        final FinalCostingModel? finalCostingModel =
            await ondcCheckoutRepository.proceedToCheckoutFinalCart(
          transactionid: event.transactionId,
          storeLocation_id: event.storeLocation_id,
          messageId: event.messageId,
        );
        emit(
          FinalizeProductSuccessState(finalCostingModel: finalCostingModel),
        );
      } on FinalizeProductErrorState catch (e) {
        emit(
          FinalizeProductErrorState(message: e.message),
        );
      }
    });

    on<InitializePostEvent>((event, emit) async {
      emit(InitializePostLoadingState());
      try {
        final dynamic status = await ondcCheckoutRepository.initPost(
            messageId: event.message_id, order_id: event.order_id);
        emit(
          InitializePostSuccessState(status: status),
        );
      } on InitializePostErrorState catch (e) {
        emit(
          InitializePostErrorState(message: e.message),
        );
      }
    });

    on<InitializeGetEvent>((event, emit) async {
      emit(InitializeGetLoadingState());
      try {
        final String status =
            await ondcCheckoutRepository.initGet(order_Id: event.order_id);
        warningLog('checking for status $status');
        emit(
          InitializeGetSuccessState(status: status),
        );
      } on InitializeGetErrorState catch (e) {
        emit(InitializeGetErrorState(message: e.message));
      }
    });

    on<InitializeCartEvent>((event, emit) async {
      try {
        final String orderId = await ondcCheckoutRepository.initializeCart(
          firebaseId: AppHelpers().getPhoneNumberWithoutCountryCode,
          messageId: event.messageId,
        );
        emit(
          InitializeCartSuccessState(
            orderId: orderId,
          ),
        );
      } on InitializeCartFailureState catch (e) {
        emit(
          InitializeCartFailureState(message: e.message),
        );
      }
    });

    on<VerifyPaymentEvent>((event, emit) async {
      emit(FinalizePaymentLoading());
      try {
        await ondcCheckoutRepository.verifyPayment(
          razorpayOrderIDLocal: event.razorpayOrderIdFromRazor,
          razorpayPaymentId: event.razorpayPaymentIdFromRazor,
          razorpaySignature: event.razorpaySignature,
        );
        emit(FinalizePaymentSuccessState());
      } on FinalizeProductErrorState catch (e) {
        emit(
          FinalizeProductErrorState(message: e.message),
        );
      }
    });
  }
}
