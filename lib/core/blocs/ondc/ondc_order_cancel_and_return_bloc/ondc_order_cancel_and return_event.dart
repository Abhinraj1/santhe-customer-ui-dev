

part of "ondc_order_cancel_and_return_bloc.dart";

abstract class ONDCOrderCancelAndReturnEvent extends Equatable {
  const ONDCOrderCancelAndReturnEvent();

  @override
  List<Object?> get props => [];
}

class LoadReasons extends ONDCOrderCancelAndReturnEvent{}

class CancelSingleOrderEvent extends ONDCOrderCancelAndReturnEvent{

  final String orderId;
  final String orderNumber;

  const CancelSingleOrderEvent({required this.orderId,required this.orderNumber});

  @override
  List<Object?> get props => [orderId,orderNumber,orderId];
}

class CancelFullOrderRequestEvent extends ONDCOrderCancelAndReturnEvent{}


class CancelPartialOrderRequestEvent extends ONDCOrderCancelAndReturnEvent{}


class LoadReasonsForFullOrderCancelEvent extends ONDCOrderCancelAndReturnEvent{
  final String orderId;
  final String orderNumber;

  const LoadReasonsForFullOrderCancelEvent({required this.orderId,required this.orderNumber});

  @override
  List<Object?> get props => [orderId,orderNumber,orderId];
}

class LoadReasonsForReturnEvent extends ONDCOrderCancelAndReturnEvent{
  final CartItemPrices product;
  final String orderId;
  final String orderNumber;

  const LoadReasonsForReturnEvent({required this.orderId,
    required this.product, required this.orderNumber});

  @override
  List<Object?> get props => [orderId,orderNumber,orderId];
}

class LoadReasonsForPartialOrderCancelEvent extends ONDCOrderCancelAndReturnEvent{
  final String orderId;
  final String orderNumber;

  const LoadReasonsForPartialOrderCancelEvent({required this.orderId,required this.orderNumber});

  @override
  List<Object?> get props => [orderId,orderNumber,orderId];
}

class SelectedCodeEvent extends ONDCOrderCancelAndReturnEvent{

  final String code;


  const SelectedCodeEvent({
    required this.code,
  });

  @override
  List<Object?> get props => [code];
}
class SelectedCodeForReturnEvent extends ONDCOrderCancelAndReturnEvent{

  final String code;


  const SelectedCodeForReturnEvent({
    required this.code,
  });

  @override
  List<Object?> get props => [code];
}