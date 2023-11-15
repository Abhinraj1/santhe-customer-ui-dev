// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hyperlocal_cart_bloc.dart';

abstract class HyperlocalCartState extends Equatable {
  const HyperlocalCartState();

  @override
  List<Object> get props => [];
}

class HyperlocalCartInitial extends HyperlocalCartState {}

class AddToCartHyperLocalState extends HyperlocalCartState {}

class AddToCartHyperLocalLoadingState extends HyperlocalCartState {}

class AddToCartHyperLocalErrorState extends HyperlocalCartState {
  final String message;
  const AddToCartHyperLocalErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class GetHyperLocalCartStateLoadingState extends HyperlocalCartState {}

class GotHyperLocalCartState extends HyperlocalCartState {
  final List<HyperLocalCartModel> cartModels;
  const GotHyperLocalCartState({
    required this.cartModels,
  });
  @override
  List<Object> get props => [cartModels];
}

class GetHyperLocalCartErrorState extends HyperlocalCartState {
  final String message;
  const GetHyperLocalCartErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ResetHyperLocalCartState extends HyperlocalCartState {}

class UpdatedHyperLocalCartLoadingState extends HyperlocalCartState {}

class UpdatedHyperLocalCartErrorState extends HyperlocalCartState {
  final String message;
  const UpdatedHyperLocalCartErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class UpdatedHyperLocalCartState extends HyperlocalCartState {
  final List<HyperLocalCartModel> cartModels;
  const UpdatedHyperLocalCartState({
    required this.cartModels,
  });
  @override
  List<Object> get props => [cartModels];
}

class DeleteHyperLocalCartItemLoadingState extends HyperlocalCartState {}

class DeleteHyperLocalCartItemErrorState extends HyperlocalCartState {
  final String message;
  const DeleteHyperLocalCartItemErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class DeleteHyperLocalCartItemState extends HyperlocalCartState {
  final HyperLocalCartModel cartModel;
  const DeleteHyperLocalCartItemState({
    required this.cartModel,
  });
  @override
  List<Object> get props => [cartModel];
}

class UpdateQuantityHyperLocalCartItemState extends HyperlocalCartState {
  final HyperLocalCartModel cartModel;
  const UpdateQuantityHyperLocalCartItemState({
    required this.cartModel,
  });
  @override
  List<Object> get props => [cartModel];
}

class UpdateQuantityHyperLocalCartItemLoadingState
    extends HyperlocalCartState {}

class UpdateQuantityHyperLocalCartItemErrorState extends HyperlocalCartState {
  final String message;
  const UpdateQuantityHyperLocalCartItemErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
