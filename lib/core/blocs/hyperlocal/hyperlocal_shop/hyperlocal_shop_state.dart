// // ignore_for_file: public_member_api_docs, sort_constructors_first
// part of 'hyperlocal_shop_bloc.dart';
//
// abstract class HyperlocalShopBlocState extends Equatable {
//   const HyperlocalShopBlocState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class HyperlocalShopInitial extends HyperlocalShopBlocState {}
//
// class HyperLocalGetShopsState extends HyperlocalShopBlocState {
//   final List<HyperLocalShopModel> hyperLocalShopModels;
//   final bool hasLoadedData;
//   const HyperLocalGetShopsState({
//     required this.hyperLocalShopModels,
//     required this.hasLoadedData
//   });
//   // @override
//   // List<Object> get props => [hyperLocalShopModels];
// }
//
// class HyperLocalGetLoadingState extends HyperlocalShopBlocState {}
//
// class HyperLocalGetShopErrorState extends HyperlocalShopBlocState {
//   final String message;
//   const HyperLocalGetShopErrorState({
//     required this.message,
//   });
//   @override
//   List<Object> get props => [message];
// }
//
// class HyperLocalSearchItemLoadedState extends HyperlocalShopBlocState {}
//
// class HyperLocalGetShopSearchState extends HyperlocalShopBlocState {
//   final List<HyperLocalShopWidget> searchModels;
//   const HyperLocalGetShopSearchState({
//     required this.searchModels,
//   });
//   @override
//   List<Object> get props => [searchModels];
// }
//
// class HyperLocalGetShopSearchClearLoadingState extends HyperlocalShopBlocState {}
//
// class HyperLocalGetShopSearchClearErrorState extends HyperlocalShopBlocState {
//   final String message;
//   const HyperLocalGetShopSearchClearErrorState({
//     required this.message,
//   });
//   @override
//   List<Object> get props => [message];
// }
//
// class HyperLocalGetResetState extends HyperlocalShopBlocState {}
//
// class HyperLocalGetShopSearchClearState extends HyperlocalShopBlocState {
//   final List<HyperLocalShopModel> previousModels;
//   const HyperLocalGetShopSearchClearState({
//     required this.previousModels,
//   });
//   @override
//   List<Object> get props => [previousModels];
// }
//
// class HyperLocalGetShopSearchLoadingState extends HyperlocalShopBlocState {}
//
// class HyperLocalGetShopSearchErrorState extends HyperlocalShopBlocState {
//   final String message;
//   const HyperLocalGetShopSearchErrorState({
//     required this.message,
//   });
//   @override
//   List<Object> get props => [message];
// }
//
// class HyperLocalGetProductsOfShopState extends HyperlocalShopBlocState {
//   final List<HyperLocalProductModel> hyperLocalProductModels;
//   const HyperLocalGetProductsOfShopState({
//     required this.hyperLocalProductModels,
//   });
//   @override
//   List<Object> get props => [hyperLocalProductModels];
// }
//
// class HyperLocalGetProductsOfShopLoadingState extends HyperlocalShopBlocState {}
//
// class HyperLocalGetProductsOfShopErrorState extends HyperlocalShopBlocState {
//   final String message;
//   const HyperLocalGetProductsOfShopErrorState({
//     required this.message,
//   });
//   @override
//   List<Object> get props => [message];
// }
//
// class HyperLocalGetSearchProductsOfShopState extends HyperlocalShopBlocState {
//   final List<HyperLocalProductModel> hyperLocalProductModels;
//   const HyperLocalGetSearchProductsOfShopState({
//     required this.hyperLocalProductModels,
//   });
//   @override
//   List<Object> get props => [hyperLocalProductModels];
// }
//
// class HyperLocalGetSearchProductsOfShopLoadingState
//     extends HyperlocalShopBlocState {}
//
// class HyperLocalGetSearchProductsOfShopErrorState extends HyperlocalShopBlocState {
//   final String message;
//   const HyperLocalGetSearchProductsOfShopErrorState({
//     required this.message,
//   });
//   @override
//   List<Object> get props => [message];
// }
//
// class HyperLocalClearShopSearchLoadingState extends HyperlocalShopBlocState {}
//
// class HyperLocalClearShopSearchProductState extends HyperlocalShopBlocState {
//   final List<HyperLocalProductModel> hyperLocalProductModels;
//   const HyperLocalClearShopSearchProductState({
//     required this.hyperLocalProductModels,
//   });
//   @override
//   List<Object> get props => [hyperLocalProductModels];
// }
