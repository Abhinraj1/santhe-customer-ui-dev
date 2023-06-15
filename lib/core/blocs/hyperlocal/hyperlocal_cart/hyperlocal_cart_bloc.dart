import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:santhe/core/repositories/hyperlocal_cartrepo.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_cartmodel.dart';
import 'package:santhe/models/hyperlocal_models/hyperlocal_productmodel.dart';

part 'hyperlocal_cart_event.dart';
part 'hyperlocal_cart_state.dart';

class HyperlocalCartBloc
    extends Bloc<HyperlocalCartEvent, HyperlocalCartState> {
  final HyperLocalCartRepository hyperLocalCartRepository;
  HyperlocalCartBloc({required this.hyperLocalCartRepository})
      : super(HyperlocalCartInitial()) {
    on<HyperlocalCartEvent>((event, emit) {});

    on<AddToCartHyperLocalEvent>((event, emit) async {
      emit(AddToCartHyperLocalLoadingState());
      try {
        bool canAdd = event.hyperLocalProductModel.addToCart();

        canAdd
            ? await hyperLocalCartRepository.addToCart(
                hyperLocalProductModel: event.hyperLocalProductModel)
            : null;
        emit(AddToCartHyperLocalState());
      } on AddToCartHyperLocalErrorState catch (e) {
        emit(
          AddToCartHyperLocalErrorState(message: e.message),
        );
      }
    });

    on<OnAppRefreshHyperLocalCartEvent>((event, emit) async {
      emit(GetHyperLocalCartStateLoadingState());
      try {
        List<HyperLocalCartModel> cartModels = await hyperLocalCartRepository
            .getCart(storeDescriptionId: event.storeDescriptionId);
        emit(
          GotHyperLocalCartState(cartModels: cartModels),
        );
      } on GetHyperLocalCartErrorState catch (e) {
        emit(GetHyperLocalCartErrorState(message: e.message));
      }
    });

    on<DeleteHyperCartItemEvent>((event, emit) async {
      emit(DeleteHyperLocalCartItemLoadingState());
      try {
        await hyperLocalCartRepository.deleteCartItem(
            hyperLocalCartModel: event.cartModel);
        emit(DeleteHyperLocalCartItemState(cartModel: event.cartModel));
      } on DeleteHyperLocalCartItemErrorState catch (e) {
        emit(
          DeleteHyperLocalCartItemErrorState(message: e.message),
        );
      }
    });

    on<UpdateCartItemQuantityEvent>((event, emit) async {
      emit(UpdateQuantityHyperLocalCartItemLoadingState());
      try {
        await hyperLocalCartRepository.updateCartItemQuantity(
            hyperLocalCartModel: event.cartModel);
        emit(UpdateQuantityHyperLocalCartItemState(cartModel: event.cartModel));
      } on UpdateQuantityHyperLocalCartItemErrorState catch (e) {
        emit(
          UpdateQuantityHyperLocalCartItemErrorState(message: e.message),
        );
      }
    });

    on<UpdateHyperLocalCartEvent>((event, emit) {
      emit(UpdatedHyperLocalCartState(cartModels: event.cartModels));
    });

    on<ResetHyperCartEvent>((event, emit) {
      emit(ResetHyperLocalCartState());
    });
  }
}
