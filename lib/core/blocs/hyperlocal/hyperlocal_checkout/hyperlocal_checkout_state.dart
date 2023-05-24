// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hyperlocal_checkout_bloc.dart';

abstract class HyperlocalCheckoutState extends Equatable {
  const HyperlocalCheckoutState();

  @override
  List<Object> get props => [];
}

class HyperlocalCheckoutInitial extends HyperlocalCheckoutState {}

class GetOrderInfoLoadingState extends HyperlocalCheckoutState {}

class GetOrderInfoSuccessState extends HyperlocalCheckoutState {
  final List<HyperLocalPreviewModel> hyperLocalPreviewModels;
  const GetOrderInfoSuccessState({
    required this.hyperLocalPreviewModels,
  });
  @override
  List<Object> get props => [hyperLocalPreviewModels];
}

class GetOrderInfoErrorState extends HyperlocalCheckoutState {
  final String message;
  const GetOrderInfoErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class GetOrderInfoPostLoadingState extends HyperlocalCheckoutState {}

class GetOrderInfoPostSuccessState extends HyperlocalCheckoutState {
  final String orderId;
  const GetOrderInfoPostSuccessState({
    required this.orderId,
  });
  @override
  List<Object> get props => [orderId];
}

class GetOrderInfoPostErrorState extends HyperlocalCheckoutState {
  final String message;
  const GetOrderInfoPostErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class PostPaymentHyperlocalLoadingState extends HyperlocalCheckoutState {}

class PostPaymentHyperlocalSuccessState extends HyperlocalCheckoutState {
  final HyperlocalPaymentInfoModel hyperlocalPaymentInfo;
  const PostPaymentHyperlocalSuccessState({
    required this.hyperlocalPaymentInfo,
  });
  @override
  List<Object> get props => [hyperlocalPaymentInfo];
}

class PostPaymentHyperlocalErrorState extends HyperlocalCheckoutState {
  final String message;
  const PostPaymentHyperlocalErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class VerifyPaymentHyperlocalLoadingState extends HyperlocalCheckoutState {}

class VerifyPaymentHyperlocalSuccessState extends HyperlocalCheckoutState {
  final String message;
  const VerifyPaymentHyperlocalSuccessState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class VerifyPaymentHyperlocalErrorState extends HyperlocalCheckoutState {
  final String message;
  const VerifyPaymentHyperlocalErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
