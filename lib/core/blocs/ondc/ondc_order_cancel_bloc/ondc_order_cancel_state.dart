part of "ondc_order_cancel_bloc.dart";



abstract class ONDCOrderCancelState extends Equatable {
  const ONDCOrderCancelState();

  @override
  List<Object?> get props => [];
}

class Loading extends ONDCOrderCancelState{}

class EnableNextButtonState extends ONDCOrderCancelState{}


class ReasonsLoadedFullOrderCancelState extends ONDCOrderCancelState {

  final List<ReasonsModel> reasons;

  final String orderId;

  final String orderNumber;

  const ReasonsLoadedFullOrderCancelState( {required this.reasons ,required this.orderId, required this.orderNumber,});
  @override
  List<Object?> get props => [reasons,orderNumber,orderId];
}

class ReasonsLoadedPartialOrderCancelState extends ONDCOrderCancelState {

  final List<ReasonsModel> reasons;

  final String orderId;

  final String orderNumber;

  const ReasonsLoadedPartialOrderCancelState( {required this.reasons ,required this.orderId, required this.orderNumber,});
  @override
  List<Object?> get props => [reasons,orderNumber,orderId];
}

class ReasonsLoaded extends ONDCOrderCancelState {

  final List<ReasonsModel> reasons;

  const ReasonsLoaded({required this.reasons});

}


class ReasonsLoadedSingleOrderCancelState extends ONDCOrderCancelState{

  final List<ReasonsModel> reasons;

  final String orderId;

  final String orderNumber;

  const ReasonsLoadedSingleOrderCancelState( {required this.reasons ,required this.orderId, required this.orderNumber,});
  @override
  List<Object?> get props => [reasons,orderNumber,orderId];
}


class SelectedCodeState extends ONDCOrderCancelState{

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


class FullOrderCancelRequestSentState extends ONDCOrderCancelState{}

class OrderCancelErrorState extends ONDCOrderCancelState{
  final String message;

  const OrderCancelErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}