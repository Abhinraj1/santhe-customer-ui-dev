// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'ondc_bloc.dart';

abstract class OndcEvent extends Equatable {
  const OndcEvent();

  @override
  List<Object?> get props => [];
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

class SearchOndcItemInLocalShop extends OndcEvent {
  final String transactionId;
  final String storeId;
  final String productName;
  const SearchOndcItemInLocalShop({
    required this.transactionId,
    required this.storeId,
    required this.productName,
  });
  @override
  List<Object> get props => [transactionId, storeId, productName];
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

class FetchShopModelsGet extends OndcEvent {
  final String? transactionId;
  const FetchShopModelsGet({
    required this.transactionId,
  });
  @override
  List<Object?> get props => [transactionId];
}

class FetchProductsOfShops extends OndcEvent {
  final String shopId;
  final String transactionId;
  const FetchProductsOfShops({
    required this.shopId,
    required this.transactionId,
  });
  @override
  List<Object?> get props => [transactionId, shopId];
}
