// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, non_constant_identifier_names
part of 'ondc_bloc.dart';

abstract class OndcEvent extends Equatable {
  const OndcEvent();

  @override
  List<Object?> get props => [];
}

class ResetOndcEvent extends OndcEvent {
  final String shopId;
  const ResetOndcEvent({
    required this.shopId,
  });
  @override
  List<Object?> get props => [shopId];
}

class FetchNearByShops extends OndcEvent {
  final String lat;
  final String lng;
  final String pincode;
  final bool isDelivery;
  const FetchNearByShops({
    required this.lat,
    required this.lng,
    required this.pincode,
    required this.isDelivery,
  });
  @override
  List<Object> get props => [lat, lng, pincode, isDelivery];
}

class GoBackStore extends OndcEvent {
  List<ShopModel> existingModels = [];
  GoBackStore({
    required this.existingModels,
  });
  @override
  List<Object> get props => [existingModels];
}

class SearchOndcItemInLocalShop extends OndcEvent {
  final String storeId;
  final String productName;

  const SearchOndcItemInLocalShop({
    required this.storeId,
    required this.productName,
  });
  @override
  List<Object> get props => [storeId, productName];
}

class ClearSearchEventOndc extends OndcEvent {
  List<ProductOndcModel> productModels;
  ClearSearchEventOndc({
    required this.productModels,
  });
  @override
  List<Object> get props => [productModels];
}

class ClearSearchEventShops extends OndcEvent {
  List<ShopModel> shopModels;
  ClearSearchEventShops({
    required this.shopModels,
  });
  @override
  List<Object> get props => [shopModels];
}

class SearchOndcItemGlobal extends OndcEvent {
  final String transactionId;
  final String productName;
  const SearchOndcItemGlobal({
    required this.transactionId,
    required this.productName,
  });
  @override
  List<Object> get props => [transactionId, productName];
}

class FetchShopModelsGet extends OndcEvent {}

class FetchProductsOfShops extends OndcEvent {
  final String shopId;
  const FetchProductsOfShops({
    required this.shopId,
  });
  @override
  List<Object?> get props => [shopId];
}

class FetchListOfShopWithSearchedProducts extends OndcEvent {
  final String productName;
  const FetchListOfShopWithSearchedProducts({
    required this.productName,
  });
  @override
  List<Object> get props => [productName];
}



//