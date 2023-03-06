
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../models/ondc/single_order_model.dart';
import '../../../loggers.dart';
import '../../../repositories/ondc_repository.dart';
part 'ondc_single_order_details_event.dart';
part 'ondc_single_order_details_state.dart';



class SingleOrderDetailsBloc extends Bloc<SingleOrdersDetailsEvent, SingleOrdersDetailsState>
    with LogMixin {
  final OndcRepository ondcRepository;

  SingleOrderDetailsBloc({
    required this.ondcRepository,

  }) : super(LoadingState()) {

    List<SingleOrderModel> orderDetails = [];


    on<SingleOrdersDetailsEvent> ((event, emit) {});

    on<LoadDataEvent>((event, emit) async {


      emit(LoadingState());

      try{
        orderDetails = await ondcRepository.getSingleOrder(OrderId: event.orderId);

        emit(DataLoadedState(
          orderDetails: orderDetails
        ));

      }catch(e){

      }

    });
  }

}