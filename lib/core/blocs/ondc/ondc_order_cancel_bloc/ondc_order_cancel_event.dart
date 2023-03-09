

part of "ondc_order_cancel_bloc.dart";

abstract class ONDCOrderCancelEvent extends Equatable {
  const ONDCOrderCancelEvent();

  @override
  List<Object?> get props => [];
}

class LoadReasons extends ONDCOrderCancelEvent{}

class CancelSingleOrderEvent extends ONDCOrderCancelEvent{

  final String orderId;
  final String orderNumber;

  const CancelSingleOrderEvent({required this.orderId,required this.orderNumber});

  @override
  List<Object?> get props => [orderId,orderNumber,orderId];
}

class CancelFullOrderRequestEvent extends ONDCOrderCancelEvent{}


class CancelPartialOrderRequestEvent extends ONDCOrderCancelEvent{}


class LoadReasonsForFullOrderCancelEvent extends ONDCOrderCancelEvent{
  final String orderId;
  final String orderNumber;

  const LoadReasonsForFullOrderCancelEvent({required this.orderId,required this.orderNumber});

  @override
  List<Object?> get props => [orderId,orderNumber,orderId];
}

class LoadReasonsForPartialOrderCancelEvent extends ONDCOrderCancelEvent{
  final String orderId;
  final String orderNumber;

  const LoadReasonsForPartialOrderCancelEvent({required this.orderId,required this.orderNumber});

  @override
  List<Object?> get props => [orderId,orderNumber,orderId];
}

class SelectedCodeEvent extends ONDCOrderCancelEvent{

  final String code;


  const SelectedCodeEvent({
    required this.code,
  });

  @override
  List<Object?> get props => [code];
}