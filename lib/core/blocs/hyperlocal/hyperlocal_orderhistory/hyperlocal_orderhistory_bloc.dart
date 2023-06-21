import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:santhe/core/repositories/hyperlocal_orderhistoryrepo.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_orderdetail.dart';

part 'hyperlocal_orderhistory_event.dart';
part 'hyperlocal_orderhistory_state.dart';

class HyperlocalOrderhistoryBloc
    extends Bloc<HyperlocalOrderhistoryEvent, HyperlocalOrderhistoryState> {
  final HyperLocalOrderHistoryRepository hyperLocalOrderHistoryRepository;
  HyperlocalOrderhistoryBloc({required this.hyperLocalOrderHistoryRepository})
      : super(HyperlocalOrderhistoryInitial()) {
    on<HyperlocalOrderhistoryEvent>((event, emit) {
      // TODO: implement event handler
    });
    // on<GetHyperlocalOrderHistoryEvent>((event, emit) async {
    //   log('Called', name: 'GetHyperlocalOrderHistoryEvent');
    //   emit(GetHyperlocalOrderHistoryLoadingState());
    //   try {
    //     List<HyperlocalOrderDetailModel> orderDetail =
    //         await hyperLocalOrderHistoryRepository.getOrderList();
    //     emit(
    //       GetHyperlocalOrderHistorySuccessState(orderDetail: orderDetail),
    //     );
    //   } on GetHyperlocalOrderHistoryErrorState catch (e) {
    //     emit(GetHyperlocalOrderHistoryErrorState(message: e.message));
    //   }
    // });

    on<ResetOrderHistoryEvent>((event, emit) {
      emit(ResetlocalOrderhistoryState());
    });

    on<SevenDaysFilterHyperLocalOrderEvent>((event, emit) async {
      List<HyperlocalOrderDetailModel> filteredModels = [];
      emit(SevenDaysLoadingState());
      try {
        filteredModels = await hyperLocalOrderHistoryRepository
            .getSevenDaysOrderList(nSeven: event.nSeven);

        emit(SevenDaysFilterHyperlocalOrderState(
            orderDetailsModels: filteredModels));
      } on SevenDaysFilterHyperlocalOrderErrorState catch (e) {
        emit(SevenDaysFilterHyperlocalOrderErrorState(message: e.message));
      }
    });

    on<SevenDaysFilterHyperlocalOrderScrollEvent>((event, emit) async {
      emit(SevenDaysFilterHyperlocalLoadingSrollState());
      List<HyperlocalOrderDetailModel> filteredModels = [];
      try {
        filteredModels = await hyperLocalOrderHistoryRepository
            .getSevenDaysOrderList(nSeven: event.nSeven);
        emit(
          SevenDaysFilterHyperlocalOrderScrollState(
              orderDetailsModels: filteredModels),
        );
      } on SevenDaysFilterHyperlocalOrderErrorState catch (e) {
        emit(SevenDaysFilterHyperlocalLoadingScrollErrorState(
            message: e.message));
      }
    });

    on<ThirtyDaysFilterHyperLocalOrderEvent>((event, emit) async {
      List<HyperlocalOrderDetailModel> filteredModels = [];
      emit(ThirtyDaysLoadingState());
      try {
        filteredModels = await hyperLocalOrderHistoryRepository
            .getThirtyDaysOrderList(nThirty: event.nthirty);
        emit(ThirtyDaysFilterHyperlocalOrderState(
            orderDetailsModels: filteredModels));
      } on ThirtyDaysFilterHyperlocalOrderErrorState catch (e) {
        emit(ThirtyDaysFilterHyperlocalOrderErrorState(message: e.message));
      }
    });

    on<ThirtyDaysFilterScrollHyperlocalOrderEvent>((event, emit) async {
      List<HyperlocalOrderDetailModel> filteredModels = [];
      emit(ThirtyDaysFilterHyperlocalOrderScrollLoadingState());
      try {
        filteredModels = await hyperLocalOrderHistoryRepository
            .getThirtyDaysOrderList(nThirty: event.nthirty);
        emit(ThirtyDaysFilterHyperlocalOrderScrollState(
            orderDetailsModels: filteredModels));
      } on ThirtyDaysFilterHyperlocalOrderErrorState catch (e) {
        emit(ThirtyDaysFilterHyperlocalOrderScrollErrorState(
            message: e.message));
      }
    });

    on<CustomDaysFilterHyperLocalOrderEvent>((event, emit) async {
      List<HyperlocalOrderDetailModel> filteredModels = [];
      emit(ThirtyDaysLoadingState());
      try {
        filteredModels =
            await hyperLocalOrderHistoryRepository.getCustomDaysOrderList(
                valuesLoc: event.selectedDates, nCustom: event.nCustom);
        emit(
          CustomDaysFilterHyperlocalOrderState(
              orderDetailsModels: filteredModels),
        );
      } on CustomDaysFilterHyperlocalOrderErrorState catch (e) {
        emit(CustomDaysFilterHyperlocalOrderErrorState(message: e.message));
      }
    });
    on<CustomDaysScrollFilterHyperlocalOrderEvent>((event, emit) async {
      emit(CustomScrollFilterHyperlocalLoadingState());
      List<HyperlocalOrderDetailModel> filteredModels = [];
      try {
        filteredModels =
            await hyperLocalOrderHistoryRepository.getCustomDaysOrderList(
                valuesLoc: event.selectedDates, nCustom: event.nCustom);
        emit(CustomScrollFilterHyperlocalState(
            orderDetailsModels: filteredModels));
      } on CustomDaysFilterHyperlocalOrderErrorState catch (e) {
        emit(CustomScrollFilterHyperlocalErrorState(message: e.message));
      }
    });
  }
}
