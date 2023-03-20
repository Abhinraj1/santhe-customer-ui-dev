// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'ondc_bloc.dart';

abstract class OndcState extends Equatable {
  const OndcState();

  @override
  List<Object?> get props => [];
}

class OndcInitial extends OndcState {}

class OndcLoadingState extends OndcState {}

class OndcFetchShopLoading extends OndcState {}

class OndcFetchProductLoading extends OndcState {}

class OndcFetchProductsLocalLoading extends OndcState {}

class OndcFetchProductsGlobalLoading extends OndcState {}

class ResetOndcState extends OndcState {
  final int cartCount;
  const ResetOndcState({
    required this.cartCount,
  });
  @override
  List<Object?> get props => [cartCount];
}

class ClearSearchState extends OndcState {
  List<ShopModel>? ondcShopModels;
  ClearSearchState({
    this.ondcShopModels,
  });
  @override
  List<Object?> get props => [ondcShopModels];
}

class ClearStateLoading extends OndcState {}

class ClearStateErrorState extends OndcState {
  final String message;
  const ClearStateErrorState({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}

class ErrorFetchingGlobalProducts extends OndcState {
  final String message;
  const ErrorFetchingGlobalProducts({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ErrorFetchingShops extends OndcState {
  final String message;
  const ErrorFetchingShops({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ErrorFetchingProductsOfShops extends OndcState {
  final String message;
  const ErrorFetchingProductsOfShops({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class OndcLoadingForShopsModelState extends OndcState {
  final String? transactionId;
  const OndcLoadingForShopsModelState({
    required this.transactionId,
  });
  @override
  List<Object?> get props => [transactionId];
}

class OndcShopModelsLoaded extends OndcState {
  final List<ShopModel> shopModels;
  const OndcShopModelsLoaded({
    required this.shopModels,
  });
  @override
  List<Object> get props => [shopModels];
}

class FetchedItemsInLocalShop extends OndcState {
  final List<ProductOndcModel> productModels;
  const FetchedItemsInLocalShop({
    required this.productModels,
  });
  @override
  List<Object> get props => [productModels];
}

class FetchedItemsInGlobal extends OndcState {
  final List<ProductOndcModel> productModels;
  const FetchedItemsInGlobal({
    required this.productModels,
  });
  @override
  List<Object> get props => [productModels];
}

class OndcProductsOfShopsLoaded extends OndcState {
  final List<ProductOndcModel> productModels;
  const OndcProductsOfShopsLoaded({
    required this.productModels,
  });
  @override
  List<Object> get props => [productModels];
}

class SearchItem extends OndcState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SearchItemLoaded extends OndcState {
  final List<ShopModel> shopsList;

  const SearchItemLoaded({required this.shopsList});
  @override
  // TODO: implement props
  List<Object?> get props => [shopsList];
}
