// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hyperlocal_orderhistory_bloc.dart';

abstract class HyperlocalOrderhistoryEvent extends Equatable {
  const HyperlocalOrderhistoryEvent();

  @override
  List<Object> get props => [];
}

class GetHyperlocalOrderHistoryEvent extends HyperlocalOrderhistoryEvent {}

class SevenDaysFilterHyperLocalOrderEvent extends HyperlocalOrderhistoryEvent {
  final List<HyperlocalOrderDetailModel> orderModels;
  const SevenDaysFilterHyperLocalOrderEvent({
    required this.orderModels,
  });
  @override
  List<Object> get props => [orderModels];
}

class ThirtyDaysFilterHyperLocalOrderEvent
    extends GetHyperlocalOrderHistoryEvent {
  final List<HyperlocalOrderDetailModel> orderModels;
  ThirtyDaysFilterHyperLocalOrderEvent({
    required this.orderModels,
  });
  @override
  List<Object> get props => [orderModels];
}

class CustomDaysFilterHyperLocalOrderEvent
    extends GetHyperlocalOrderHistoryEvent {
  final List<HyperlocalOrderDetailModel> orderModels;
  final List<DateTime?> selectedDates;
  CustomDaysFilterHyperLocalOrderEvent(
      {required this.orderModels, required this.selectedDates});
  @override
  List<Object> get props => [orderModels, selectedDates];
}

class ResetOrderHistoryEvent extends GetHyperlocalOrderHistoryEvent {}
