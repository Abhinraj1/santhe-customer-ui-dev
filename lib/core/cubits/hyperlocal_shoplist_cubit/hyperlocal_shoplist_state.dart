part of 'hyperlocal_shoplist_cubit.dart';

@immutable
abstract class HyperlocalShopState {}

class HyperlocalShopInitialState extends HyperlocalShopState {}

class HyperlocalShopNothingFound extends HyperlocalShopState {}

class HyperlocalShopLoaded extends
HyperlocalShopState {
  final bool loaded;
  final List<HyperLocalShopModel> shopList;
  HyperlocalShopLoaded({required this.shopList,required this.loaded});
}

class HyperlocalSearchShopLoaded extends
HyperlocalShopState {
  final bool loaded;
  final String? searchedItem;
  final List<HyperLocalShopModel> shopList;
  HyperlocalSearchShopLoaded({required this.shopList,
    required this.loaded,this.searchedItem});
}



class HyperlocalShopLoadingState extends HyperlocalShopState {

}

class HyperlocalShopErrorState extends HyperlocalShopState {

}