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

class ThirtyDaysFilterHyperlocalOrderState extends HyperlocalOrderhistoryState {
  List<HyperlocalOrderDetailModel> orderDetailsModels;
  ThirtyDaysFilterHyperlocalOrderState({
    required this.orderDetailsModels,
  });
  @override
  List<Object> get props => [orderDetailsModels];
}

class CustomDaysFilterHyperlocalOrderState extends HyperlocalOrderhistoryState {
  List<HyperlocalOrderDetailModel> orderDetailsModels;
  CustomDaysFilterHyperlocalOrderState({
    required this.orderDetailsModels,
  });
  @override
  List<Object> get props => [orderDetailsModels];
}
