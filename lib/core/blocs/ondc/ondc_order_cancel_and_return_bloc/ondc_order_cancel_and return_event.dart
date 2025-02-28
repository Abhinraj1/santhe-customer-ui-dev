

part of "ondc_order_cancel_and_return_bloc.dart";

abstract class ONDCOrderCancelAndReturnEvent extends Equatable {
  const ONDCOrderCancelAndReturnEvent();

  @override
  List<Object?> get props => [];
}

class LoadReasons extends ONDCOrderCancelAndReturnEvent{}

// class PartialCancelEvent extends ONDCOrderCancelAndReturnEvent{
//
//   final String orderId;
//   final String orderNumber;
//
//   const PartialCancelEvent({required this.orderId,required this.orderNumber});
//
//   @override
//   List<Object?> get props => [orderId,orderNumber,orderId];
// }

class CancelFullOrderRequestEvent extends ONDCOrderCancelAndReturnEvent{
  final BuildContext context;
  const CancelFullOrderRequestEvent({required this.context});
}


class PartialCancelOrderRequestEvent extends ONDCOrderCancelAndReturnEvent{
  final BuildContext context;
  const PartialCancelOrderRequestEvent({required this.context});

}


class LoadReasonsForFullOrderCancelEvent extends ONDCOrderCancelAndReturnEvent{
  final String orderId;
  final String orderNumber;

  const LoadReasonsForFullOrderCancelEvent({required this.orderId,required this.orderNumber});

  @override
  List<Object?> get props => [orderId,orderNumber,orderId];
}

class LoadReasonsForReturnEvent extends ONDCOrderCancelAndReturnEvent{
  final PreviewWidgetModel product;
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
  final PreviewWidgetModel previewWidgetModel;

  const LoadReasonsForPartialOrderCancelEvent({
    required this.orderId,
    required this.orderNumber,
    required this.previewWidgetModel});

  @override
  List<Object?> get props => [orderId,orderNumber,previewWidgetModel];
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
 final BuildContext context;
  final String code;


  const SelectedCodeForReturnEvent({
    required this.code,
    required this.context,
  });

  @override
  List<Object?> get props => [code];
}

class SelectedCodeForPartialOrderCancelEvent extends ONDCOrderCancelAndReturnEvent{
  final String code;


  const SelectedCodeForPartialOrderCancelEvent({
    required this.code,
  });

  @override
  List<Object?> get props => [code];
}