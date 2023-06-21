// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'hyperlocal_orderhistory_bloc.dart';

abstract class HyperlocalOrderhistoryState extends Equatable {
  const HyperlocalOrderhistoryState();

  @override
  List<Object> get props => [];
}

class HyperlocalOrderhistoryInitial extends HyperlocalOrderhistoryState {}

class GetHyperlocalOrderHistoryLoadingState
    extends HyperlocalOrderhistoryState {}

class GetHyperlocalOrderHistorySuccessState
    extends HyperlocalOrderhistoryState {
  final List<HyperlocalOrderDetailModel> orderDetail;

  const GetHyperlocalOrderHistorySuccessState({required this.orderDetail});
  @override
  List<Object> get props => [orderDetail];
}

class ResetlocalOrderhistoryState extends HyperlocalOrderhistoryState {}

class GetHyperlocalOrderHistoryErrorState extends HyperlocalOrderhistoryState {
  final String message;
  const GetHyperlocalOrderHistoryErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class SevenDaysFilterHyperlocalOrderState extends HyperlocalOrderhistoryState {
  List<HyperlocalOrderDetailModel> orderDetailsModels;
  SevenDaysFilterHyperlocalOrderState({
    required this.orderDetailsModels,
  });
  @override
  List<Object> get props => [orderDetailsModels];
}

class SevenDaysLoadingState extends HyperlocalOrderhistoryState {}

class SevenDaysFilterHyperlocalOrderErrorState
    extends HyperlocalOrderhistoryState {
  final String message;

  const SevenDaysFilterHyperlocalOrderErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class SevenDaysFilterHyperlocalOrderScrollState
    extends HyperlocalOrderhistoryState {
  List<HyperlocalOrderDetailModel> orderDetailsModels;
  SevenDaysFilterHyperlocalOrderScrollState({
    required this.orderDetailsModels,
  });
  @override
  List<Object> get props => [orderDetailsModels];
}

class SevenDaysFilterHyperlocalLoadingSrollState
    extends HyperlocalOrderhistoryState {}

class SevenDaysFilterHyperlocalLoadingScrollErrorState
    extends HyperlocalOrderhistoryState {
  final String message;

  const SevenDaysFilterHyperlocalLoadingScrollErrorState(
      {required this.message});
  @override
  List<Object> get props => [message];
}

class ThirtyDaysFilterHyperlocalOrderState extends HyperlocalOrderhistoryState {
  List<HyperlocalOrderDetailModel> orderDetailsModels;
  ThirtyDaysFilterHyperlocalOrderState({
    required this.orderDetailsModels,
  });
  @override
  List<Object> get props => [orderDetailsModels];
}

class ThirtyDaysFilterHyperlocalOrderScrollState
    extends HyperlocalOrderhistoryState {
  List<HyperlocalOrderDetailModel> orderDetailsModels;
  ThirtyDaysFilterHyperlocalOrderScrollState({
    required this.orderDetailsModels,
  });
  @override
  List<Object> get props => [orderDetailsModels];
}

class ThirtyDaysFilterHyperlocalOrderScrollLoadingState
    extends HyperlocalOrderhistoryState {}

class ThirtyDaysFilterHyperlocalOrderScrollErrorState
    extends HyperlocalOrderhistoryState {
  final String message;

  const ThirtyDaysFilterHyperlocalOrderScrollErrorState(
      {required this.message});
  @override
  List<Object> get props => [message];
}

class ThirtyDaysFilterHyperlocalOrderErrorState
    extends HyperlocalOrderhistoryState {
  final String message;

  const ThirtyDaysFilterHyperlocalOrderErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class ThirtyDaysLoadingState extends HyperlocalOrderhistoryState {}

class CustomDaysFilterHyperlocalOrderState extends HyperlocalOrderhistoryState {
  List<HyperlocalOrderDetailModel> orderDetailsModels;
  CustomDaysFilterHyperlocalOrderState({
    required this.orderDetailsModels,
  });
  @override
  List<Object> get props => [orderDetailsModels];
}

class CustomDaysFilterHyperlocalOrderErrorState
    extends HyperlocalOrderhistoryState {
  final String message;

  const CustomDaysFilterHyperlocalOrderErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class CustomDaysLoadingState extends HyperlocalOrderhistoryState {}

class CustomScrollFilterHyperlocalLoadingState
    extends HyperlocalOrderhistoryState {}

class CustomScrollFilterHyperlocalErrorState
    extends HyperlocalOrderhistoryState {
  final String message;

  const CustomScrollFilterHyperlocalErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class CustomScrollFilterHyperlocalState extends HyperlocalOrderhistoryState {
  List<HyperlocalOrderDetailModel> orderDetailsModels;
  CustomScrollFilterHyperlocalState({
    required this.orderDetailsModels,
  });
  @override
  List<Object> get props => [orderDetailsModels];
}
