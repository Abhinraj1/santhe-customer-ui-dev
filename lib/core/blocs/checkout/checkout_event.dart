// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class GetCartPriceEventPost extends CheckoutEvent {
  final String storeLocation_id;
  const GetCartPriceEventPost({
    required this.storeLocation_id,
  });
  @override
  List<Object> get props => [storeLocation_id];
}

class GetFinalItemsEvent extends CheckoutEvent {
  final String storeLocation_id;
  final String messageId;
  const GetFinalItemsEvent({
    required this.storeLocation_id,
    required this.messageId,
  });
  @override
  List<Object> get props => [messageId, storeLocation_id];
}

class InitializePostEvent extends CheckoutEvent {
  final String order_id;
  const InitializePostEvent({
    required this.order_id,
  });
  @override
  List<Object> get props => [order_id];
}

class InitializeGetEvent extends CheckoutEvent {
  final String order_id;
  const InitializeGetEvent({
    required this.order_id,
  });
  @override
  List<Object> get props => [order_id];
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
  final String messageId;
  const VerifyPaymentEvent({
    required this.razorpayOrderIdFromRazor,
    required this.razorpayPaymentIdFromRazor,
    required this.razorpaySignature,
    required this.messageId,
  });
  @override
  List<Object> get props => [
        razorpayOrderIdFromRazor,
        razorpayPaymentIdFromRazor,
        razorpaySignature,
        messageId
      ];
}
