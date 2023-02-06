// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class GetCartPriceEventPost extends CheckoutEvent {
  final String transactionId;
  const GetCartPriceEventPost({
    required this.transactionId,
  });
  @override
  List<Object> get props => [transactionId];
}

class GetFinalItemsEvent extends CheckoutEvent {
  final String transactionId;
  final String messageId;
  const GetFinalItemsEvent({
    required this.transactionId,
    required this.messageId,
  });
  @override
  List<Object> get props => [transactionId, messageId];
}

class GetCartPriceEventGet extends CheckoutEvent {
  final String transactionId;
  final String messageId;
  const GetCartPriceEventGet({
    required this.transactionId,
    required this.messageId,
  });
  @override
  List<Object> get props => [messageId, transactionId];
}

class InitializeCartEvent extends CheckoutEvent {
  final String messageId;
  final String customerId;
  const InitializeCartEvent({
    required this.messageId,
    required this.customerId,
  });
  @override
  List<Object> get props => [messageId, customerId];
}

class VerifyPaymentEvent extends CheckoutEvent {
  final String razorpayOrderIdFromRazor;
  final String razorpayPaymentIdFromRazor;
  final String razorpaySignature;
  const VerifyPaymentEvent({
    required this.razorpayOrderIdFromRazor,
    required this.razorpayPaymentIdFromRazor,
    required this.razorpaySignature,
  });
  @override
  List<Object> get props =>
      [razorpayOrderIdFromRazor, razorpayPaymentIdFromRazor, razorpaySignature];
}
