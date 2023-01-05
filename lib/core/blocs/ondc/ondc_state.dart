// ignore_for_file: public_member_api_docs, sort_constructors_first
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
