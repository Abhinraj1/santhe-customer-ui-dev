// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hyperlocal_shop_bloc.dart';

abstract class HyperlocalShopState extends Equatable {
  const HyperlocalShopState();

  @override
  List<Object> get props => [];
}

class HyperlocalShopInitial extends HyperlocalShopState {}

class HyperLocalGetShopsState extends HyperlocalShopState {
  final List<HyperLocalShopModel> hyperLocalShopModels;
  const HyperLocalGetShopsState({
    required this.hyperLocalShopModels,
  });
  @override
  List<Object> get props => [hyperLocalShopModels];
}

class HyperLocalGetLoadingState extends HyperlocalShopState {}

class HyperLocalGetShopErrorState extends HyperlocalShopState {
  final String message;
  const HyperLocalGetShopErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class HyperLocalSearchItemLoadedState extends HyperlocalShopState {}

class HyperLocalGetShopSearchState extends HyperlocalShopState {
  final List<HyperLocalShopModel> searchModels;
  const HyperLocalGetShopSearchState({
    required this.searchModels,
  });
  @override
  List<Object> get props => [searchModels];
}

class HyperLocalGetShopSearchClearLoadingState extends HyperlocalShopState {}

class HyperLocalGetShopSearchClearErrorState extends HyperlocalShopState {
  final String message;
  const HyperLocalGetShopSearchClearErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class HyperLocalGetResetState extends HyperlocalShopState {}

class HyperLocalGetShopSearchClearState extends HyperlocalShopState {
  final List<HyperLocalShopModel> previousModels;
  const HyperLocalGetShopSearchClearState({
    required this.previousModels,
  });
  @override
  List<Object> get props => [previousModels];
}

class HyperLocalGetShopSearchLoadingState extends HyperlocalShopState {}

class HyperLocalGetShopSearchErrorState extends HyperlocalShopState {
  final String message;
  const HyperLocalGetShopSearchErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class HyperLocalGetProductsOfShopState extends HyperlocalShopState {
  final List<HyperLocalProductModel> hyperLocalProductModels;
  const HyperLocalGetProductsOfShopState({
    required this.hyperLocalProductModels,
  });
  @override
  List<Object> get props => [hyperLocalProductModels];
}

class HyperLocalGetProductsOfShopLoadingState extends HyperlocalShopState {}

class HyperLocalGetProductsOfShopErrorState extends HyperlocalShopState {
  final String message;
  const HyperLocalGetProductsOfShopErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class HyperLocalGetSearchProductsOfShopState extends HyperlocalShopState {
  final List<HyperLocalProductModel> hyperLocalProductModels;
  const HyperLocalGetSearchProductsOfShopState({
    required this.hyperLocalProductModels,
  });
  @override
  List<Object> get props => [hyperLocalProductModels];
}

class HyperLocalGetSearchProductsOfShopLoadingState
    extends HyperlocalShopState {}

class HyperLocalGetSearchProductsOfShopErrorState extends HyperlocalShopState {
  final String message;
  const HyperLocalGetSearchProductsOfShopErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class HyperLocalClearShopSearchLoadingState extends HyperlocalShopState {}

class HyperLocalClearShopSearchProductState extends HyperlocalShopState {
  final List<HyperLocalProductModel> hyperLocalProductModels;
  const HyperLocalClearShopSearchProductState({
    required this.hyperLocalProductModels,
  });
  @override
  List<Object> get props => [hyperLocalProductModels];
}
