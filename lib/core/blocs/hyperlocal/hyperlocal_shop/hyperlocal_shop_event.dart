// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hyperlocal_shop_bloc.dart';

abstract class HyperlocalShopEvent extends Equatable {
  const HyperlocalShopEvent();

  @override
  List<Object> get props => [];
}

class HyperLocalGetShopEvent extends HyperlocalShopEvent {
  final String lat;
  final String lng;
  const HyperLocalGetShopEvent({
    required this.lat,
    required this.lng,
  });
  @override
  List<Object> get props => [lat, lng];
}

class HyperLocalClearSearchEventShops extends HyperlocalShopEvent {
  final List<HyperLocalShopModel> previousModels;
  final String lat;
  final String lng;
  HyperLocalClearSearchEventShops({
    required this.previousModels,
    required this.lat,
    required this.lng,
  });
  @override
  List<Object> get props => [previousModels, lat, lng];
}

class HyperLocalGetShopSearchEvent extends HyperlocalShopEvent {
  final String lat;
  final String lng;
  final String itemName;
  const HyperLocalGetShopSearchEvent({
    required this.lat,
    required this.lng,
    required this.itemName,
  });
  @override
  List<Object> get props => [lat, lng, itemName];
}

class HyperLocalGetProductOfShopEvent extends HyperlocalShopEvent {
  final String shopId;
  final String lat;
  final String lng;
  const HyperLocalGetProductOfShopEvent({
    required this.shopId,
    required this.lat,
    required this.lng,
  });
  @override
  List<Object> get props => [lat, lng, shopId];
}

class HyperLocalGetSearchProductsOfShopEvent extends HyperlocalShopEvent {
  final String shopId;
  final String productName;
  final String lat;
  final String lng;
  const HyperLocalGetSearchProductsOfShopEvent({
    required this.shopId,
    required this.productName,
    required this.lat,
    required this.lng,
  });
  @override
  List<Object> get props => [shopId, productName, lat, lng];
}

class HyperLocalGetSearchProductsClearEvent extends HyperlocalShopEvent {
  final String shopId;
  final String lat;
  final String lng;
  const HyperLocalGetSearchProductsClearEvent({
    required this.shopId,
    required this.lat,
    required this.lng,
  });
  @override
  List<Object> get props => [shopId, lat, lng];
}

class HyperLocalGetResetEvent extends HyperlocalShopEvent {}
