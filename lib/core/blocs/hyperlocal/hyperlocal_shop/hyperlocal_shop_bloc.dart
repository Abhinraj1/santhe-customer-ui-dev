// import 'dart:developer';
//
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:get/get.dart';
// import 'package:santhe/core/repositories/hyperlocal_repository.dart';
// import 'package:santhe/models/hyperlocal_models/hyperlocal_productmodel.dart';
// import 'package:santhe/models/hyperlocal_models/hyperlocal_shopmodel.dart';
//
// import '../../../../constants.dart';
// import '../../../../widgets/hyperlocal_widgets/hyperlocal_shopwidget.dart';
//
// // part 'hyperlocal_shop_event.dart';
// part 'hyperlocal_shop_state.dart';
//
//
//
//
//
//
// class HyperlocalShopCubit
//     extends Cubit< HyperlocalShopBlocState> {
//   final HyperLocalRepository hyperLocalRepository;
//   HyperlocalShopCubit({required this.hyperLocalRepository})
//       : super(HyperlocalShopInitial());
//
//
//
//     // getShops({required List<HyperLocalShopModel> shopsList,
//     //   required int offset, required bool load }) async{
//     //   final String lat = customerModel.lat;
//     //   final String lng = customerModel.lng;
//     //
//     //  offset ==0 ? emit(HyperLocalGetLoadingState()) : null;
//     //
//     //  // List<HyperLocalShopModel> shopsList = shopWidgetList;
//     //  // shops.addAll(event.shopWidgetList);
//     //
//     //   try {
//     //     List<HyperLocalShopModel> shops = [];
//     //     if(load){
//     //
//     //       shops = await hyperLocalRepository
//     //           .getHyperLocalShops(lat: lat, lng: lng,
//     //           offset: offset.toString());
//     //
//     //       if(shops.isNotEmpty){
//     //         shops.forEach((element) {
//     //           shopsList.add(element);
//     //         });
//     //       }
//     //
//     //
//     //       print("LENGHT OF ++++++++++++++++ ==shopListWidgets addAll==${shops.length}");
//     //
//     //       emit(HyperLocalGetShopsState(hyperLocalShopModels: shopsList,hasLoadedData: true));
//     //       // for (var element in shopModels) {
//     //       //  // shops.add(HyperLocalShopWidget(hyperLocalShopModel: element));
//     //       //   shops.add(element);
//     //       // }
//     //
//     //
//     //     }
//     //   }catch(E){
//     //
//     //   }
//     //
//     //   // try {
//     //   //   List<HyperLocalShopModel> shops = [];
//     //   //   if(load){
//     //   //
//     //   //     shops = await hyperLocalRepository
//     //   //         .getHyperLocalShops(lat: lat, lng: lng,
//     //   //         offset: offset.toString());
//     //   //
//     //   //     if(shops.isNotEmpty){
//     //   //       shops.forEach((element) {
//     //   //         shopsList.add(element);
//     //   //       });
//     //   //     }
//     //   //
//     //   //
//     //   //     print("LENGHT OF ++++++++++++++++ ==shopListWidgets addAll==${shops.length}");
//     //   //
//     //   //     // for (var element in shopModels) {
//     //   //     //  // shops.add(HyperLocalShopWidget(hyperLocalShopModel: element));
//     //   //     //   shops.add(element);
//     //   //     // }
//     //   //
//     //   //     print("LENGHT OF ++++++++++++++++ ==IFFFFF add==${shopsList.length}");
//     //   //     emit(HyperLocalGetShopsState(hyperLocalShopModels: shopsList,
//     //   //         hasLoadedData: load));
//     //   //   }else {
//     //   //     print(
//     //   //         "LENGHT OF ++++++++++++++++ ==ELSE add==${shopsList.length}");
//     //   //     emit(HyperLocalGetShopsState(hyperLocalShopModels: shopsList,
//     //   //         hasLoadedData: load));
//     //   //   }
//     //   // } on HyperLocalGetShopErrorState catch (e) {
//     //   //   emit(
//     //   //     HyperLocalGetShopErrorState(message: e.message),
//     //   //   );
//     //   // }finally{
//     //   //   fetchingShops = false;
//     //   //
//     //   // }
//     // }
//
//     //on<HyperLocalGetShopSearchEvent>((event, emit) async {
//       searchShops({required String itemName,
//         required List<HyperLocalShopModel> searchedShopList}) async{
//
//
//
//       emit(HyperLocalGetShopSearchLoadingState());
//
//       List<HyperLocalShopWidget> searchedShops = [];
//       // try {
//       //   // List<HyperLocalShopModel> searchModels =
//       //   //     await hyperLocalRepository.getHyperLocalSearchShop(
//       //   //         nameOfProduct: itemName, lat: lat, lng: lng,offset: offset);
//       //
//       //   //searchedShops.addAll(searchedShopList);
//       //
//       //   for (var element in searchModels) {
//       //     searchedShops.add(HyperLocalShopWidget(hyperLocalShopModel: element));
//       //   }
//       //   emit(HyperLocalGetShopSearchState(searchModels: searchedShops));
//       //
//       // } on HyperLocalGetShopSearchErrorState catch (e) {
//       //   emit(HyperLocalGetShopSearchErrorState(message: e.message));
//       // }
//     }
//
//
//     // on<HyperLocalClearSearchEventShops>((event, emit) async {
//     //   emit(HyperLocalGetShopSearchClearLoadingState());
//     //   try {
//     //     List<HyperLocalShopModel> shops = await hyperLocalRepository
//     //         .getHyperLocalShops(lat: event.lat, lng: event.lng);
//     //     emit(HyperLocalGetShopSearchClearState(previousModels: shops));
//     //   } catch (e) {
//     //     emit(HyperLocalGetShopSearchClearErrorState(message: e.toString()));
//     //   }
//     // });
//
//     // on<HyperLocalGetProductOfShopEvent>((event, emit) async {
//     //   emit(HyperLocalGetProductsOfShopLoadingState());
//     //   try {
//     //     List<HyperLocalProductModel> hyperLocalProductModels =
//     //         await hyperLocalRepository.getProductsOfShop(
//     //             storeId: event.shopId, lat: event.lat, lng: event.lng);
//     //
//     //     dynamic cartCount = await hyperLocalRepository.getCartCount(
//     //         storeDescriptionId: event.shopId);
//     //
//     //     log('get products of shop bloc $cartCount',
//     //         name: 'Hyperlocal_shop_bloc.dart');
//     //
//     //     emit(HyperLocalGetProductsOfShopState(
//     //         hyperLocalProductModels: hyperLocalProductModels));
//     //   } on HyperLocalGetProductsOfShopErrorState catch (e) {
//     //     emit(HyperLocalGetProductsOfShopErrorState(message: e.toString()));
//     //   }
//     // });
//
//     // on<HyperLocalGetSearchProductsOfShopEvent>((event, emit) async {
//     //   emit(HyperLocalGetSearchProductsOfShopLoadingState());
//     //   try {
//     //     final List<HyperLocalProductModel> products =
//     //         await hyperLocalRepository.getSearchProductsOfShop(
//     //             storeId: event.shopId,
//     //             itemName: event.productName,
//     //             lat: event.lat,
//     //             lng: event.lng);
//     //     emit(HyperLocalGetSearchProductsOfShopState(
//     //         hyperLocalProductModels: products));
//     //   } on HyperLocalGetSearchProductsOfShopErrorState catch (e) {
//     //     emit(
//     //       HyperLocalGetSearchProductsOfShopErrorState(message: e.message),
//     //     );
//     //   }
//     // });
//
//     // on<HyperLocalGetSearchProductsClearEvent>((event, emit) async {
//     //
//     //   emit(HyperLocalClearShopSearchLoadingState());
//     //   try {
//     //     final List<HyperLocalProductModel> products =
//     //         await hyperLocalRepository.getProductsOfShop(
//     //             storeId: event.shopId, lat: event.lat, lng: event.lng);
//     //     log('products on clear ${products}',
//     //         name: 'HyperLocalGetSearchProductsClearEvent');
//     //     emit(HyperLocalClearShopSearchProductState(
//     //         hyperLocalProductModels: products));
//     //   } on HyperLocalGetProductsOfShopErrorState catch (e) {
//     //     emit(HyperLocalGetProductsOfShopErrorState(message: e.message));
//     //   }
//     // });
//    // on<HyperLocalGetResetEvent>(
//
//     reset(){
//     emit(
//     HyperLocalGetResetState(),
//     );
//     }
//   }
//
