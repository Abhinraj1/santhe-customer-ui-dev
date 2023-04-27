// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hyperlocal_shop_bloc.dart';

abstract class HyperlocalShopState extends Equatable {
  const HyperlocalShopState();

  @override
  List<Object> get props => [];
}

class HyperlocalShopInitial extends HyperlocalShopState {}

class HyperLocalGetShopsState extends HyperlocalShopState {}

class HyperLocalGetLoadingState extends HyperlocalShopState {}

class HyperLocalGetShopErrorState extends HyperLocalGetShopsState {
  final String message;
  HyperLocalGetShopErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class HyperLocalGetShopSearchState extends HyperlocalShopState {}

class HyperLocalGetShopSearchLoadingState extends HyperlocalShopState {}

class HyperLocalGetShopSearchErrorState extends HyperlocalShopState {}

class HyperLocalGetProductsOfShopState extends HyperlocalShopState {}

class HyperLocalGetProductsOfShopLoadingState extends HyperlocalShopState {}

class HyperLocalGetProductsOfShopErrorState extends HyperlocalShopState {}
