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
    on<GetHyperlocalOrderHistoryEvent>((event, emit) async {
      log('Called', name: 'GetHyperlocalOrderHistoryEvent');
      emit(GetHyperlocalOrderHistoryLoadingState());
      try {
        List<HyperlocalOrderDetailModel> orderDetail =
            await hyperLocalOrderHistoryRepository.getOrderList();
        emit(
          GetHyperlocalOrderHistorySuccessState(orderDetail: orderDetail),
        );
      } on GetHyperlocalOrderHistoryErrorState catch (e) {
        emit(GetHyperlocalOrderHistoryErrorState(message: e.message));
      }
    });

    on<ResetOrderHistoryEvent>((event, emit) {
      emit(HyperlocalOrderhistoryInitial());
    });

    on<SevenDaysFilterHyperLocalOrderEvent>((event, emit) {
      DateTime today = DateTime.now();
      DateTime startingDate = today.subtract(const Duration(days: 8));
      List<HyperlocalOrderDetailModel> filteredModels = [];
      for (var element in event.orderModels) {
        if (DateTime.parse(element.createdAt.toString())
            .isAfter(startingDate)) {
          filteredModels.add(element);
        }
      }
      emit(SevenDaysFilterHyperlocalOrderState(
          orderDetailsModels: filteredModels));
    });

    on<ThirtyDaysFilterHyperLocalOrderEvent>((event, emit) {
      DateTime today = DateTime.now();
      DateTime startingDate = today.subtract(const Duration(days: 31));
      List<HyperlocalOrderDetailModel> filteredModels = [];
      for (var element in event.orderModels) {
        if (DateTime.parse(element.createdAt.toString())
            .isAfter(startingDate)) {
          filteredModels.add(element);
        }
      }
      emit(ThirtyDaysFilterHyperlocalOrderState(
          orderDetailsModels: filteredModels));
    });

    on<CustomDaysFilterHyperLocalOrderEvent>((event, emit) {
      List<HyperlocalOrderDetailModel> filteredModels = [];
      for (var element in event.orderModels) {
        if (DateTime.parse(element.createdAt.toString()).isAfter(
                (event.selectedDates.first)!
                    .subtract(const Duration(days: 1))) &&
            DateTime.parse(element.createdAt.toString()).isBefore(
                (event.selectedDates.last)!
                    .subtract(const Duration(days: 1)))) {
          filteredModels.add(element);
        }
      }
      emit(
        CustomDaysFilterHyperlocalOrderState(
            orderDetailsModels: filteredModels),
      );
    });
  }
}
