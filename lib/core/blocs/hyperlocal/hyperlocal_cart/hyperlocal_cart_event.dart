// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hyperlocal_cart_bloc.dart';

abstract class HyperlocalCartEvent extends Equatable {
  const HyperlocalCartEvent();

  @override
  List<Object> get props => [];
}

class AddToCartHyperLocalEvent extends HyperlocalCartEvent {
  final HyperLocalProductModel hyperLocalProductModel;
  const AddToCartHyperLocalEvent({
    required this.hyperLocalProductModel,
  });
  @override
  List<Object> get props => [hyperLocalProductModel];
}

class UpdateHyperLocalCartEvent extends HyperlocalCartEvent {
  final List<HyperLocalCartModel> cartModels;
  const UpdateHyperLocalCartEvent({
    required this.cartModels,
  });
  @override
  List<Object> get props => [cartModels];
}

class ResetHyperCartEvent extends HyperlocalCartEvent {}

class DeleteHyperCartItemEvent extends HyperlocalCartEvent {
  final HyperLocalCartModel cartModel;
  const DeleteHyperCartItemEvent({
    required this.cartModel,
  });
  @override
  List<Object> get props => [cartModel];
}

class OnAppRefreshHyperLocalCartEvent extends HyperlocalCartEvent {
  final String storeDescriptionId;
  const OnAppRefreshHyperLocalCartEvent({
    required this.storeDescriptionId,
  });
  @override
  List<Object> get props => [storeDescriptionId];
}

class UpdateCartItemQuantityEvent extends HyperlocalCartEvent {
  final HyperLocalCartModel cartModel;
  const UpdateCartItemQuantityEvent({
    required this.cartModel,
  });
  @override
  List<Object> get props => [cartModel];
}
