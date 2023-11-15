import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../../constants.dart';
import '../../../models/hyperlocal_models/hyperlocal_shopmodel.dart';
import '../../../widgets/hyperlocal_widgets/hyperlocal_shopwidget.dart';
import '../../blocs/hyperlocal/hyperlocal_shop/hyperlocal_shop_bloc.dart';
import '../../repositories/hyperlocal_repository.dart';

part 'hyperlocal_shoplist_state.dart';



var fetchingShops = false.obs;
var loadingNewShops = false.obs;
var shopListOffset = 0.obs;
var searchShopListOffset = 0.obs;
List<HyperLocalShopModel> shopListWidgets = [];
List<HyperLocalShopModel> searchedShopListWidgets = [];

class HyperlocalShopsCubit extends Cubit<HyperlocalShopState> {
  final HyperLocalRepository repo;
  HyperlocalShopsCubit({required this.repo}) :
        super(HyperlocalShopInitialState());

  String searchedItem = "";

  onScroll({required List<HyperLocalShopModel> shopsList,
    required int searchOffset, required int offset,
    required bool load,
    required List<HyperLocalShopModel> searchedShopList,
    required String lat, required String lng}){


    if(state is HyperlocalShopLoaded){

      shopListOffset.value = shopListOffset.value + 5;

      getShops(
        load: load,
        offset: shopListOffset.value,
        shopsList: shopListWidgets,
        lng: lng,
        lat: lat
      );
    }
    if(state is HyperlocalSearchShopLoaded){

      searchShopListOffset.value = searchShopListOffset.value +5;

    searchShops(
        itemName: searchedItem,
        searchedShopList: searchedShopList,
        offset: searchShopListOffset.value,
        load: load,
      lat: lat,
      lng: lng
    );
    }
  }


  getShops({required List<HyperLocalShopModel> shopsList,
     required int offset, required bool load,
    required String lat, required String lng }) async{

    searchedItem= "";


    if(offset == 0){
      shopListWidgets = [];
      shopsList = [];
      emit(HyperlocalShopLoadingState());
    }
    try {
      List<HyperLocalShopModel> shops = [];
      if(load){
        shops = await repo
            .getHyperLocalShops(lat: lat, lng: lng,
            offset: offset.toString());

        if(shops.isNotEmpty){
          fetchingShops.value = false;
          shopsList.addAll(shops);
        }
      }
      emit(HyperlocalShopLoaded(shopList: shopsList,loaded: load));
    }catch(e){
      throw HyperlocalShopErrorState();
    }
  }

  searchShops({required String itemName,
    required List<HyperLocalShopModel> searchedShopList, required int offset,
  required bool load, required String lat, required String lng }) async{

    searchedItem = itemName;

   offset == 0 ? emit(HyperlocalShopLoadingState()) : null;

    List<HyperLocalShopModel> searchedShops = [];

    try {
      if(load) {
        searchedShops =
        await repo.getHyperLocalSearchShop(
            nameOfProduct: itemName, lat: lat, lng: lng,offset: offset.toString());

        if(searchedShops.isNotEmpty){
          fetchingShops.value = false;

            searchedShopList.addAll(searchedShops);

        }

        emit(HyperlocalSearchShopLoaded(
          searchedItem: searchedItem,
            shopList: searchedShopList, loaded: load));
      }

    } catch (e) {
      emit(HyperlocalShopErrorState());
    }
  }

}
