import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../models/ondc/past_cart_items_model.dart';
import '../../../loggers.dart';
import '../../../repositories/ondc_repository.dart';
part 'ondc_past_order_details_event.dart';
part 'ondc_past_order_details_state.dart';

class PastOrderDetailsBloc
    extends Bloc<PastOrdersDetailsEvent, PastOrdersDetailsState> with LogMixin {
  final OndcRepository ondcRepository;

  PastOrderDetailsBloc({
    required this.ondcRepository,
  }) : super(LoadingState()) {
    List<PastOrderRow> orderDetails = [];

    warningLog("Current State is $state");
    on<PastOrdersDetailsEvent>((event, emit) {});

    on<LoadDataEvent>((event, emit) async {
      warningLog("LOAD DATA STATE LOADED.............#################3");

      emit(LoadingState());

      try {
        orderDetails =
            await ondcRepository.getSingleOrder(OrderId: event.orderId);

        emit(DataLoadedState(orderDetails: orderDetails));
      } catch (e) {}
    });
  }
}
