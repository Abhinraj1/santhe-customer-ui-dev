import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:santhe/core/repositories/hyperlocal_repository.dart';
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
  }
}
