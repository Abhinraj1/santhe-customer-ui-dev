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

class HyperLocalGetShopSearchEvent extends HyperlocalShopEvent {}

class HyperLocalGetProductOfShopEvent extends HyperlocalShopEvent {}
