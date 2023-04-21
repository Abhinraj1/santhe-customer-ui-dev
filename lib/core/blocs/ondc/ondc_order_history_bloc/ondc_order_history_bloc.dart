
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../models/ondc/single_order_model.dart';
import '../../../loggers.dart';
import '../../../repositories/ondc_repository.dart';
part 'ondc_order_history_event.dart';
part 'ondc_order_history_state.dart';



class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState>
    with LogMixin {
  final OndcRepository ondcRepository;

  OrderHistoryBloc({
    required this.ondcRepository,

  }) : super(LoadDataState()) {

    List<SingleOrderModel> orderDetails = [];

    on<OrderHistoryEvent> ((event, emit) {});

    if(state is LoadDataState) {
      emit(
        PastOrderDataLoadedState(orderDetails: orderDetails));
    }

    on<LoadPastOrderDataEvent>((event, emit) async {


      emit(LoadingState());

      try{
        orderDetails = await ondcRepository.getPastOrder();

        emit(PastOrderDataLoadedState(
            orderDetails: orderDetails
        ));

      }catch(e){

        emit(SingleOrderErrorState(message: e.toString()));

      }

    });

    on<SevenDaysFilterEvent>((event, emit) {

      DateTime today = DateTime.now();
      DateTime startingDate = today.subtract(const Duration(days: 8));

      List<SingleOrderModel> filteredOrders = [];

       for(var i in orderDetails){
        i.quotes?.forEach((element) {
          if(DateTime.parse(element.createdAt.toString()).isAfter(startingDate)){
            filteredOrders.add(i);
        } });
       }

      emit(SevenDaysFilterState(orderDetails: filteredOrders));
    });

    on<ThirtyDaysFilterEvent>((event, emit) {

      DateTime today = DateTime.now();
      DateTime startingDate = today.subtract(const Duration(days: 31));

      List<SingleOrderModel> filteredOrders = [];

      for(var i in orderDetails){
        i.quotes?.forEach((element) {
          if(DateTime.parse(element.createdAt.toString()).isAfter(startingDate)){
            filteredOrders.add(i);
          } });
      }
      emit(ThirtyDaysFilterState(orderDetails: filteredOrders));
    });



    on<CustomDaysFilterEvent>((event, emit) {
      List<SingleOrderModel> filteredOrders = [];

      for(var i in orderDetails){
        i.quotes?.forEach((element) {

          if(
          DateTime.parse(element.createdAt.toString()).
          isAfter(
              (event.selectedDates.first)!.subtract(const Duration(days: 1))) &&

              DateTime.parse(element.createdAt.toString())
                  .isBefore((
                  event.selectedDates.last)!.add(const Duration(days: 1)) )
          ){
            filteredOrders.add(i);
          }
        });
      }
    //  print("################################################ CustomDaysFilterEvent ${filteredOrders.length} ");
      emit(SevenDaysFilterState(orderDetails: filteredOrders));
    });

  }
}