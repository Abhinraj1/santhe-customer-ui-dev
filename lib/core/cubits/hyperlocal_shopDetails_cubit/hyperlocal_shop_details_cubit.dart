import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import '../../../models/hyperlocal_models/hyperlocal_productmodel.dart';
import '../../repositories/hyperlocal_repository.dart';
part 'hyperlocal_shop_details_state.dart';



var fetchingProducts = false.obs;
var loadingNewProducts = false.obs;
var shopListOffset = 0.obs;
var searchShopListOffset = 0.obs;
var loadingItemCount = true.obs;
List<HyperLocalProductModel> shopProducts = [];
List<HyperLocalProductModel> searchedShopProducts = [];


class HyperlocalShopDetailsCubit extends Cubit<HyperlocalShopDetailsState> {
  final HyperLocalRepository repo;
  HyperlocalShopDetailsCubit({required this.repo}) :
        super(HyperlocalShopDetailsInitial());

  String searchedProduct = "";


  onScroll({ required String storeId,
    required int offset,
    required int searchOffset,
    required String lat,
    required String lng,
    required bool load,
    required List<HyperLocalProductModel> productList,
    required List<HyperLocalProductModel> searchedProductList,
    String? itemName
  }){

    if(state is HyperlocalShopDetailsProductsLoaded){

      shopListOffset.value = shopListOffset.value + 5;

      getProducts(
          lng: lng,
          lat: lat,
          offset: shopListOffset.value,
          load: load,
          productList: productList,
      storeId: storeId);

    }
    if(state is HyperlocalShopDetailsSearchedProductsLoaded){
      searchShopListOffset.value = searchShopListOffset.value+5;
      searchProducts(
        storeId: storeId,
        load: load,
        lat: lat,
        lng: lng,
        itemName: itemName ?? searchedProduct,
        searchedProductList: searchedProductList,
        searchOffset: searchShopListOffset.value
      );
    }
  }



  getProducts({
    required String storeId,
    required int offset,
    required String lat,
    required String lng,
    required bool load,
    required List<HyperLocalProductModel> productList
  }) async{

    searchedProduct = "";
    loadingItemCount.value = true;
    if(offset == 0){
      shopProducts = [];
      searchedShopProducts = [];
      emit(HyperlocalShopDetailsLoading());
    }

    try {
      List<HyperLocalProductModel> fetchedProducts = [];
      getCartCount(shopId: storeId);
     if(load){
       fetchedProducts =  await repo.getProductsOfShop(
           storeId: storeId, lat: lat, lng: lng, offset: offset.toString());

       if(fetchedProducts.isNotEmpty){
         fetchingProducts.value = false;
           productList.addAll(fetchedProducts);

       }
     }

     emit(HyperlocalShopDetailsProductsLoaded(
         shopProducts: productList
     ));

    } catch (e) {
      throw HyperlocalShopDetailsErrorState();
    }finally{
      loadingItemCount.value = false;
      print("FINALLYYYY===================================="
          "loadingNewProducts.value == $loadingItemCount }");

    }
  }


  searchProducts({
    required String storeId,
    required int searchOffset,
    required String lat,
    required String lng,
    required bool load,
    required String itemName,
    required List<HyperLocalProductModel> searchedProductList
  }) async{

    searchedProduct = itemName;
    loadingItemCount.value = true;

    if(searchOffset ==0){
      shopProducts = [];
      searchedShopProducts = [];
      emit(HyperlocalShopDetailsLoading());
    }

    try {
      List<HyperLocalProductModel> fetchedProducts = [];

      if(load){
        fetchedProducts =  await repo.getSearchProductsOfShop(
          itemName: itemName,
            storeId: storeId, lat: lat, lng: lng,
            offset: searchOffset.toString());

        if(fetchedProducts.isNotEmpty){
          fetchingProducts.value = false;

            searchedProductList.addAll(fetchedProducts);

        }
      }

      emit(HyperlocalShopDetailsSearchedProductsLoaded(
          searchedShopProducts: searchedProductList
      ));

    } catch (e) {
      throw HyperlocalShopDetailsErrorState();
    }finally{
      loadingItemCount.value = false;
    }
  }

  getCartCount({required String shopId}) async{
    dynamic cartCount = await repo.getCartCount(
        storeDescriptionId: shopId);
  }
}
