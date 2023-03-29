part of "ondc_order_cancel_and_return_bloc.dart";



abstract class ONDCOrderCancelAndReturnState extends Equatable {
  const ONDCOrderCancelAndReturnState();

  @override
  List<Object?> get props => [];
}

class Loading extends ONDCOrderCancelAndReturnState{}

class EnableNextButtonState extends ONDCOrderCancelAndReturnState{}


class ReasonsLoadedFullOrderCancelState extends ONDCOrderCancelAndReturnState {

  final List<ReasonsModel> reasons;

  final String orderId;

  final String orderNumber;

  const ReasonsLoadedFullOrderCancelState( {required this.reasons ,required this.orderId, required this.orderNumber,});
  @override
  List<Object?> get props => [reasons,orderNumber,orderId];
}

class ReasonsLoadedForReturnState extends ONDCOrderCancelAndReturnState {

  final List<ReasonsModel> reasons;

  final String orderId;

  final String orderNumber;

  const ReasonsLoadedForReturnState( {required this.reasons ,required this.orderId, required this.orderNumber,});
  @override
  List<Object?> get props => [reasons,orderNumber,orderId];
}


class ReasonsLoadedPartialOrderCancelState extends ONDCOrderCancelAndReturnState {

  final List<ReasonsModel> reasons;

  final String orderId;

  final String orderNumber;

  const ReasonsLoadedPartialOrderCancelState( {required this.reasons ,required this.orderId, required this.orderNumber,});
  @override
  List<Object?> get props => [reasons,orderNumber,orderId];
}

class ReasonsLoaded extends ONDCOrderCancelAndReturnState {

  final List<ReasonsModel> reasons;

  const ReasonsLoaded({required this.reasons});

}



class SelectedCodeState extends ONDCOrderCancelAndReturnState{

  final String code;

  final List<ReasonsModel> reasons;

  final String orderId;

  final String orderNumber;

  const SelectedCodeState({
    required this.code, required this.orderId,
    required this.orderNumber, required this.reasons
  });

  @override
  List<Object?> get props => [code,reasons,orderNumber,orderId];
}

class SelectedCodeForPartialOrderCancelState extends ONDCOrderCancelAndReturnState{

  final String code;

  final List<ReasonsModel> reasons;

  final String orderId;

  final String orderNumber;

  const SelectedCodeForPartialOrderCancelState({
    required this.code, required this.orderId,
    required this.orderNumber, required this.reasons
  });

  @override
  List<Object?> get props => [code,reasons,orderNumber,orderId];
}

class SelectedCodeForReturnState extends ONDCOrderCancelAndReturnState{

  final String code;

  final List<ReasonsModel> reasons;

  final String orderId;

  final String orderNumber;

  final PreviewWidgetModel returnProduct;

  const SelectedCodeForReturnState({
    required this.code, required this.orderId,
    required this.orderNumber, required this.reasons,
    required this.returnProduct

  });

  @override
  List<Object?> get props => [code,reasons,orderNumber,orderId];
}



class OrderCancelRequestSentState extends ONDCOrderCancelAndReturnState{}

class OrderCancelErrorState extends ONDCOrderCancelAndReturnState{
  final String message;

  const OrderCancelErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}