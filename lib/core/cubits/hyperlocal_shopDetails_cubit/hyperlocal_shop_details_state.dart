part of 'hyperlocal_shop_details_cubit.dart';

@immutable
abstract class HyperlocalShopDetailsState {}

class HyperlocalShopDetailsInitial extends HyperlocalShopDetailsState {}

class HyperlocalShopDetailsLoading extends HyperlocalShopDetailsState {}

class HyperlocalShopDetailsProductsLoaded extends
HyperlocalShopDetailsState {
  final List<HyperLocalProductModel> shopProducts;
  HyperlocalShopDetailsProductsLoaded({required this.shopProducts});
}

class HyperlocalShopDetailsSearchedProductsLoaded extends
HyperlocalShopDetailsState {
  final List<HyperLocalProductModel> searchedShopProducts;
  HyperlocalShopDetailsSearchedProductsLoaded({
    required this.searchedShopProducts});
}


class HyperlocalShopDetailsErrorState extends HyperlocalShopDetailsState {}