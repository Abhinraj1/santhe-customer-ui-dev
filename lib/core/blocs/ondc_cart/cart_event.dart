// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final ProductOndcModel productOndcModel;
  const AddToCartEvent({
    required this.productOndcModel,
  });
  @override
  List<Object> get props => [productOndcModel];
}

class UpdateQuantityEvent extends CartEvent {
  final CartitemModel cartModel;
  const UpdateQuantityEvent({
    required this.cartModel,
  });
  @override
  List<Object> get props => [cartModel];
}

class ErrorGettingCartEvent extends CartEvent {
  final String message;
  const ErrorGettingCartEvent({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ErrorAddingToCartEvent extends CartEvent {
  final String message;
  const ErrorAddingToCartEvent({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ErrorAddingQuantityEvent extends CartEvent {
  final String message;
  const ErrorAddingQuantityEvent({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class UpdateCartEvent extends CartEvent {
  final List<CartitemModel> productOndcModels;
  const UpdateCartEvent({required this.productOndcModels});
  @override
  List<Object> get props => [productOndcModels];
}

class OnAppRefreshEvent extends CartEvent {
  final String storeLocationId;
  const OnAppRefreshEvent({
    required this.storeLocationId,
  });
  @override
  List<Object> get props => [storeLocationId];
}

class DeleteCartItemEvent extends CartEvent {
  final CartitemModel productOndcModel;
  const DeleteCartItemEvent({
    required this.productOndcModel,
  });
  @override
  List<Object> get props => [productOndcModel];
}

class ResetCartEvent extends CartEvent {}

class GetCartItemsEvents extends CartEvent {
  final ShopModel shopModel;
  const GetCartItemsEvents({
    required this.shopModel,
  });
  @override
  List<Object> get props => [shopModel];
}
