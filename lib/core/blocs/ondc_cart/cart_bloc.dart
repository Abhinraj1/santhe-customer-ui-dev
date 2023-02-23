// ignore_for_file: public_member_api_docs, sort_constructors_first, body_might_complete_normally_nullable
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:santhe/core/loggers.dart';

import 'package:santhe/core/repositories/ondc_cart_repository.dart';
import 'package:santhe/core/sharedpref.dart';
import 'package:santhe/models/ondc/cart_item_model.dart';
import 'package:santhe/models/ondc/product_ondc.dart';
import 'package:santhe/models/ondc/shop_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> with LogMixin {
  final OndcCartRepository ondcCartRepository;
  List<CartitemModel> productModelBloc = [];
  List<ProductOndcModel> productModelBlocLocal = [];
  SharedPref sharedPref = SharedPref();
  Map<dynamic, dynamic> data = {};
  CartBloc({
    required this.ondcCartRepository,
  }) : super(const CartState()) {
    on<CartEvent>((event, emit) {});

    on<AddToCartEvent>((event, emit) async {
      try {
        bool canAdd = event.productOndcModel.addToCart();

        // ondcCartRepository.addToCart(productOndcModel: event.productOndcModel);
        canAdd
            ? await ondcCartRepository.addToCart(
                productOndcModel: event.productOndcModel)
            : null;
        warningLog('${productModelBloc.length}');
        emit(
          AddedToCartList(productOndcModels: productModelBlocLocal),
        );
      } on ErrorAddingItemToCartState catch (e) {
        emit(
          ErrorAddingItemToCartState(message: e.message),
        );
      }
    });

    on<UpdateCartEvent>((event, emit) async {
      // sharedPref.save('MyCart', event.productOndcModels);
      // productModelBloc = await loadSharedPrefs();
      productModelBloc = event.productOndcModels;
      // ondcCartRepository.productModels = productModelBloc;
      emit(
        UpdatedCartItemState(productOndcModel: event.productOndcModels),
      );
    });

    on<DeleteCartItemEvent>((event, emit) async {
      emit(DeleteCartLoading());
      try {
        // event.productOndcModel.removeFromCart();
        await ondcCartRepository.deleteCartItem(
            productOndcModelLocal: event.productOndcModel);
        productModelBloc.removeWhere(
          (element) => element.id == event.productOndcModel.id,
        );
        emit(
          DeleteCartItemState(
            productOndcModel: event.productOndcModel,
          ),
        );
      } on ErrorDeletingItemState catch (e) {
        emit(ErrorDeletingItemState(message: e.message));
      }
    });

    on<UpdateQuantityEvent>((event, emit) async {
      try {
        await ondcCartRepository.updateQuantityOfItems(
            productOndcModel: event.cartModel);
        warningLog('Cartmodels ${event.cartModel.quantity}');
        emit(UpdatedQuantityState(productOndcModel: event.cartModel));
      } catch (e) {
        rethrow;
      }
    });

    on<OnAppRefreshEvent>((event, emit) async {
      // await clear();
      try {
        // List<ProductOndcModel> products = await ondcCartRepository.getCart();
        List<CartitemModel> productModels1 = await ondcCartRepository.getCart(
            storeLocationId: event.storeLocationId);
        warningLog('local cart $productModels1');
        emit(
          GetCartItemsOfShopState(products: productModels1),
        );
      } on ErrorGettingCartListState catch (e) {
        emit(
          ErrorGettingCartListState(message: e.message),
        );
      }
    });
  }

  // @override
  // CartState? fromJson(Map<String, dynamic> json) {
  //   // log('checking for hyrdated statefromjson${json['productOndcModel']}',
  //   //     name: "CartState fromJson()");
  //   return UpdatedCartItemState.fromMap(json);
  // }

  // @override
  // Map<String, dynamic>? toJson(CartState state) {
  //   if (state is UpdatedCartItemState) {
  //     // debugLog('checking for hydrated state$state');
  //     return state.toMap();
  //   }
  // }
}
