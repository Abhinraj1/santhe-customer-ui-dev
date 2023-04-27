import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:santhe/core/repositories/hyperlocal_repository.dart';

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
        await hyperLocalRepository.getHyperLocalShops(
            lat: event.lat, lng: event.lng);
        emit(HyperLocalGetShopsState());
      } on HyperLocalGetShopErrorState catch (e) {
        emit(
          HyperLocalGetShopErrorState(message: e.message),
        );
      }
    });
  }
}
