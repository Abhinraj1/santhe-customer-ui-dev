// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
part of 'hyperlocal_checkout_bloc.dart';

abstract class HyperlocalCheckoutEvent extends Equatable {
  const HyperlocalCheckoutEvent();

  @override
  List<Object?> get props => [];
}

class GetOrderInfoEvent extends HyperlocalCheckoutEvent {
  final String orderId;
  const GetOrderInfoEvent({
    required this.orderId,
  });
  @override
  List<Object> get props => [orderId];
}

class GetOrderInfoPostEvent extends HyperlocalCheckoutEvent {
  final String storeDescription_id;
  const GetOrderInfoPostEvent({
    required this.storeDescription_id,
  });
  @override
  List<Object> get props => [storeDescription_id];
}

class PostPaymentCheckoutEvent extends HyperlocalCheckoutEvent {
  final String orderId;
  final String targetApp;
  final bool isUpiPayment;
  const PostPaymentCheckoutEvent({
    required this.orderId,
    required this.targetApp,
    required this.isUpiPayment
  });
  @override
  List<Object> get props => [orderId];
}

// class PostUPIPaymentCheckoutEvent extends HyperlocalCheckoutEvent {
//   final String orderId;
//   const PostUPIPaymentCheckoutEvent({
//     required this.orderId,
//   });
//   @override
//   List<Object> get props => [orderId];
// }

class VerifyPaymentEventHyperlocal extends HyperlocalCheckoutEvent {
  final String orderId;
  final bool isUpiPayment;
  const VerifyPaymentEventHyperlocal({
    required this.orderId,
    required this.isUpiPayment
  });
  @override
  List<Object?> get props =>
      [orderId];
}
