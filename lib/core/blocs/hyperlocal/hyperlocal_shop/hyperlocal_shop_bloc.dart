import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:santhe/core/repositories/hyperlocal_repository.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_productmodel.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';

part 'hyperlocal_shop_event.dart';
part 'hyperlocal_shop_state.dart';

class HyperlocalShopBloc
    extends Bloc<HyperlocalShopEvent, HyperlocalShopState> {
  final HyperLocalRepository hyperLocalRepository;
  HyperlocalShopBloc({required this.hyperLocalRepository})
      : super(HyperlocalShopInitial()) {
    on<HyperlocalShopEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<HyperLocalGetShopEvent>((event, emit) async {
      emit(HyperLocalGetLoadingState());
      try {
        List<HyperLocalShopModel> shopModels = await hyperLocalRepository
            .getHyperLocalShops(lat: event.lat, lng: event.lng);
        emit(HyperLocalGetShopsState(hyperLocalShopModels: shopModels));
      } on HyperLocalGetShopErrorState catch (e) {
        emit(
          HyperLocalGetShopErrorState(message: e.message),
        );
      }
    });
    on<HyperLocalGetShopSearchEvent>((event, emit) async {
      emit(HyperLocalGetShopSearchLoadingState());
      try {
        List<HyperLocalShopModel> searchModels =
            await hyperLocalRepository.getHyperLocalSearchShop(
                nameOfProduct: event.itemName, lat: event.lat, lng: event.lng);
        emit(HyperLocalGetShopSearchState(searchModels: searchModels));
      } on HyperLocalGetShopSearchErrorState catch (e) {
        emit(HyperLocalGetShopSearchErrorState(message: e.message));
      }
    });
    on<HyperLocalClearSearchEventShops>((event, emit) async {
      emit(HyperLocalGetShopSearchClearLoadingState());
      try {
        List<HyperLocalShopModel> shops = await hyperLocalRepository
            .getHyperLocalShops(lat: event.lat, lng: event.lng);
        emit(HyperLocalGetShopSearchClearState(previousModels: shops));
      } catch (e) {
        emit(HyperLocalGetShopSearchClearErrorState(message: e.toString()));
      }
    });
    on<HyperLocalGetProductOfShopEvent>((event, emit) async {
      emit(HyperLocalGetProductsOfShopLoadingState());
      try {
        List<HyperLocalProductModel> hyperLocalProductModels =
            await hyperLocalRepository.getProductsOfShop(
                storeId: event.shopId, lat: event.lat, lng: event.lng);
        dynamic cartCount = await hyperLocalRepository.getCartCount(
            storeDescriptionId: event.shopId);
        log('get products of shop bloc $cartCount',
            name: 'Hyperlocal_shop_bloc.dart');
        emit(HyperLocalGetProductsOfShopState(
            hyperLocalProductModels: hyperLocalProductModels));
      } on HyperLocalGetProductsOfShopErrorState catch (e) {
        emit(HyperLocalGetProductsOfShopErrorState(message: e.toString()));
      }
    });

    on<HyperLocalGetSearchProductsOfShopEvent>((event, emit) async {
      emit(HyperLocalGetSearchProductsOfShopLoadingState());
      try {
        final List<HyperLocalProductModel> products =
            await hyperLocalRepository.getSearchProductsOfShop(
                storeId: event.shopId,
                itemName: event.productName,
                lat: event.lat,
                lng: event.lng);
        emit(HyperLocalGetSearchProductsOfShopState(
            hyperLocalProductModels: products));
      } on HyperLocalGetSearchProductsOfShopErrorState catch (e) {
        emit(
          HyperLocalGetSearchProductsOfShopErrorState(message: e.message),
        );
      }
    });

    on<HyperLocalGetSearchProductsClearEvent>((event, emit) async {
      emit(HyperLocalClearShopSearchLoadingState());
      try {
        final List<HyperLocalProductModel> products =
            await hyperLocalRepository.getProductsOfShop(
                storeId: event.shopId, lat: event.lat, lng: event.lng);
        log('products on clear ${products}',
            name: 'HyperLocalGetSearchProductsClearEvent');
        emit(HyperLocalClearShopSearchProductState(
            hyperLocalProductModels: products));
      } on HyperLocalGetProductsOfShopErrorState catch (e) {
        emit(HyperLocalGetProductsOfShopErrorState(message: e.message));
      }
    });
    on<HyperLocalGetResetEvent>(
      (event, emit) => emit(
        HyperLocalGetResetState(),
      ),
    );
  }
}
