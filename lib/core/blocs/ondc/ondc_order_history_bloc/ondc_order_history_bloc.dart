import 'package:dartz/dartz_unsafe.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../models/ondc/single_order_model.dart';
import '../../../loggers.dart';
import '../../../repositories/ondc_repository.dart';
part 'ondc_order_history_event.dart';
part 'ondc_order_history_state.dart';



var myOrdersLoading = false.obs;
var sevenDaysFilter = true.obs;
var thirtyDaysFilter = false.obs;
var customDaysFilter = false.obs;
var ONDCMyOrdersOffset = 0.obs;
List<DateTime?> customDates = [];

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState>
    with LogMixin {
  final OndcRepository ondcRepository;

  OrderHistoryBloc({
    required this.ondcRepository,
  }) : super(LoadDataState()) {


    List<SingleOrderModel> orderDetails = [];

    on<OrderHistoryEvent>((event, emit) {});

    if (state is LoadDataState) {
      emit(PastOrderDataLoadedState(orderDetails: orderDetails));
    }

    // on<LoadPastOrderDataEvent>((event, emit) async {
    //   //orderDetails = event.alreadyFetchedList;
    //
    //   event.offset == "0" ? emit(LoadingState()) : null;
    //
    //   try {
    //     List<SingleOrderModel> fetchedList =
    //         await ondcRepository.getPastOrder(offset: event.offset);
    //
    //     if (fetchedList.isNotEmpty) {
    //       fetchedList.forEach((e) {
    //        event.alreadyFetchedList.add(e);
    //       });
    //     }
    //     orderDetails.clear();
    //     orderDetails.addAll(event.alreadyFetchedList);
    //
    //     emit(PastOrderDataLoadedState(orderDetails: event.alreadyFetchedList));
    //   } catch (e) {
    //     emit(SingleOrderErrorState(message: e.toString()));
    //   }
    // });

    on<SevenDaysFilterEvent>((event, emit) async{
      DateTime today = DateTime.now();
      DateTime startingDate = today.subtract(const Duration(days: 7));

      List<SingleOrderModel> filteredOrders = [];
      filteredOrders.addAll(event.alreadyFetchedList);

      try {
            List<SingleOrderModel> fetchedList =
                await ondcRepository.getPastOrder(offset: event.offset,
                startDate:startingDate ,endDate:today);
            filteredOrders.addAll(fetchedList);

            emit(SevenDaysFilterState(orderDetails:filteredOrders));

          } catch (e) {
            emit(SingleOrderErrorState(message: e.toString()));
          }

    });

    on<ThirtyDaysFilterEvent>((event, emit) async{

      DateTime today = DateTime.now();
      DateTime startingDate = today.subtract(const Duration(days: 30));

      List<SingleOrderModel> filteredOrders = [];
      filteredOrders.addAll(event.alreadyFetchedList);

      try {
        List<SingleOrderModel> fetchedList =
            await ondcRepository.getPastOrder(offset: event.offset,
            startDate:startingDate ,endDate:today);

        filteredOrders.addAll(fetchedList);

        emit(ThirtyDaysFilterState(orderDetails:filteredOrders));

      } catch (e) {
        emit(SingleOrderErrorState(message: e.toString()));
      }

    });

    on<CustomDaysFilterEvent>((event, emit) async{

     if(event.offset == "0"){
       customDates.addAll(event.selectedDates);
     }

      List<SingleOrderModel> filteredOrders = [];
      filteredOrders.addAll(event.alreadyFetchedList);

     try {
       List<SingleOrderModel> fetchedList =
           await ondcRepository.getPastOrder(offset: event.offset,
           startDate:event.selectedDates[0] ,endDate:event.selectedDates[1]);

       filteredOrders.addAll(fetchedList);

       emit(CustomDaysFilterState(orderDetails:filteredOrders));

     } catch (e) {
       emit(SingleOrderErrorState(message: e.toString()));
     }


      //  print("################################################ CustomDaysFilterEvent ${filteredOrders.length} ");
    });
  }
}
