// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/models/ondc/shop_model.dart';
part 'ondc_event.dart';
part 'ondc_state.dart';

class OndcBloc extends Bloc<OndcEvent, OndcState> with LogMixin {
  final OndcRepository ondcRepository;

  OndcBloc({
    required this.ondcRepository,
  }) : super(OndcInitial()) {
    List<ShopModel> revertshopModel = [];

    on<OndcEvent>((event, emit) {});

    on<ResetOndcEvent>((event, emit) async {
      int shopCartCount = await ondcRepository.getCartCountMethod(
          storeLocation_id: event.shopId);
      warningLog('called $shopCartCount');
      emit(
        ResetOndcState(cartCount: shopCartCount),
      );
    });

    on<FetchNearByShops>((event, emit) async {
      emit(OndcLoadingState());

      try {
        final String? transactionId =
            await ondcRepository.getNearByOndcShopsTransactionId(
                lat: event.lat,
                lng: event.lng,
                pincode: event.pincode,
                isDelivery: event.isDelivery);

        warningLog('transaction $transactionId');
        // await ondcRepository.getNearByShopsModel(
        //     transactionIdl: transactionId!);

        emit(
          OndcLoadingForShopsModelState(
            transactionId: transactionId,
          ),
        );
        // emit(OndcShopModelsLoaded(shopModels: shopModels));
      } catch (e) {
        emit(
          ErrorFetchingShops(
            message: e.toString(),
          ),
        );
      }
    });

    on<FetchProductsOfShops>((event, emit) async {
      emit(OndcFetchProductLoading());
      try {
        int shopCartCount = await ondcRepository.getCartCountMethod(
            storeLocation_id: event.shopId);
        warningLog('Getting cartCount $shopCartCount');
        List<ProductOndcModel> productModels =
            await ondcRepository.getProductsOfShop(
                shopId: event.shopId, transactionIdLoc: event.transactionId
                // event.transactionId,
                );
        emit(OndcProductsOfShopsLoaded(productModels: productModels));
      } catch (e) {
        emit(
          ErrorFetchingProductsOfShops(
            message: e.toString(),
          ),
        );
      }
    });

    on<GoBackStore>((event, emit) {
      emit(
        OndcShopModelsLoaded(shopModels: event.existingModels),
      );
    });

    on<SearchOndcItemInLocalShop>((event, emit) async {

      emit(OndcFetchProductLoading());

      try {
        List<ProductOndcModel>? productModels =
            await ondcRepository.getProductsOnSearchinLocalShop(
                shopId: event.storeId,
                transactionIdLoc: event.transactionId,
                productName: event.productName,);

        if(productModels != null){

          emit(FetchedItemsInLocalShop(productModels: productModels));

        }else if(productModels == null){

          emit(NoItemsFoundState());

        }

      } catch (e) {
        emit(
          ErrorFetchingProductsOfShops(
            message: e.toString(),
          ),
        );
      }
    });



    on<ClearSearchEventShops>((event, emit) async {
      emit(ClearStateLoading());
      try {
        List<ShopModel> shopModel = await ondcRepository.getNearByShopsModel(
            transactionIdl: ondcRepository.transactionId
            //  event.transactionId!,
            );
        // revertshopModel = shopModel;
        // warningLog('$revertshopModel');
        emit(ClearSearchState(ondcShopModels: shopModel));
      } catch (e) {
        emit(
          ClearStateErrorState(
            message: e.toString(),
          ),
        );
      }
    });


    on<SearchOndcItemGlobal>((event, emit) async {
      emit(OndcFetchProductsGlobalLoading());
      try {
        List<ProductOndcModel> productModels =
            await ondcRepository.searchProductsOnGlobal(
                transactionIdLocal: event.transactionId,
                //  event.transactionId,
                productName: event.productName);
        emit(
          FetchedItemsInGlobal(productModels: productModels),
        );
      } catch (e) {
        emit(
          ErrorFetchingGlobalProducts(
            message: e.toString(),
          ),
        );
      }
    });

    // on<ClearSearchEventOndc>((event, emit) {
    //   emit(
    //     OndcProductsOfShopsLoaded(productModels: event.productModels),
    //   );
    // });

    on<FetchShopModelsGet>(
      (event, emit) async {
        emit(OndcFetchShopLoading());
        try {
          List<ShopModel> shopModel = await ondcRepository.getNearByShopsModel(
              transactionIdl: event.transactionId!
              //  event.transactionId!,
              );
          revertshopModel = shopModel;
          warningLog('$revertshopModel');
          emit(
            OndcShopModelsLoaded(shopModels: shopModel),
          );
        } catch (e) {
          emit(
            ErrorFetchingShops(
              message: e.toString(),
            ),
          );
        }
      },
    );

    on<FetchListOfShopWithSearchedProducts>((event, emit) async {
      emit(OndcFetchShopLoading());
      try {
        List<ShopModel> shopsList =
            await ondcRepository.getListOfShopsForSearchedProduct(
                productName: event.productName,
                transactionIdLocal: event.transactionId);
        warningLog("${shopsList}");
        emit(SearchItemLoaded(shopsList: shopsList));
      } catch (e) {
        emit(
          ErrorFetchingProductsOfShops(
            message: e.toString(),
          ),
        );
      }
    });
  }
}
