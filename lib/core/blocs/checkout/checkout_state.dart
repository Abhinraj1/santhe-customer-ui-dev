// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutPostLoading extends CheckoutState {}

class InitializePostLoadingState extends CheckoutState {}

class InitializeGetLoadingState extends CheckoutState {}

class InitializePostErrorState extends CheckoutState {
  final String message;
  const InitializePostErrorState({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}

class InitializeGetErrorState extends CheckoutState {
  final String message;
  const InitializeGetErrorState({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}

class InitializePostSuccessState extends CheckoutState {
  final dynamic status;
  const InitializePostSuccessState({
    required this.status,
  });
  @override
  List<Object?> get props => [status];
}

class InitializeGetSuccessState extends CheckoutState {
  final String status;
  const InitializeGetSuccessState({
    required this.status,
  });
  @override
  List<Object?> get props => [status];
}

class CheckoutPostError extends CheckoutState {
  final String message;
  const CheckoutPostError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class CheckoutPostSuccess extends CheckoutState {
  final String messageId;
  const CheckoutPostSuccess({
    required this.messageId,
  });
  @override
  List<Object> get props => [messageId];
}

class CheckoutGetLoading extends CheckoutState {}

class CheckoutGetError extends CheckoutState {
  final String message;
  const CheckoutGetError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class CheckoutGetSuccess extends CheckoutState {
  final List<CheckoutCartModel> cartModels;
  const CheckoutGetSuccess({
    required this.cartModels,
  });
  @override
  List<Object> get props => [cartModels];
}

class FinalizeProductLoadingState extends CheckoutState {}

class FinalizeProductErrorState extends CheckoutState {
  final String message;
  const FinalizeProductErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class FinalizeProductSuccessState extends CheckoutState {
  final FinalCostingModel? finalCostingModel;
  const FinalizeProductSuccessState({
    required this.finalCostingModel,
  });
  @override
  List<Object?> get props => [finalCostingModel];
}

class RetryPostSelectState extends CheckoutState {}

class RetryGetSelectState extends CheckoutState {}

class RetryPostInitState extends CheckoutState {}

class RetryGetInitState extends CheckoutState {}

class InitializeCartLoadingState extends CheckoutState {}

class InitializeCartFailureState extends CheckoutState {
  final String message;
  const InitializeCartFailureState({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}

class InitializeCartSuccessState extends CheckoutState {
  final String orderId;
  const InitializeCartSuccessState({
    required this.orderId,
  });
  @override
  List<Object?> get props => [
        orderId,
      ];
}

class FinalizePaymentSuccessState extends CheckoutState {}

class FinalizePaymentErrorState extends CheckoutState {
  final String message;
  const FinalizePaymentErrorState({
    required this.message,
  });
  @override
  List<Object?> get props => [
        message,
      ];
}

class FinalizePaymentLoading extends CheckoutState {}
