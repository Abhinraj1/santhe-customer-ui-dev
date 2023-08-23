


part of 'ondc_order_history_bloc.dart';


abstract class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object?> get props => [];
}



class LoadPastOrderDataEvent extends OrderHistoryEvent{
//   final String offset;
//   List<SingleOrderModel> alreadyFetchedList = [];
//    LoadPastOrderDataEvent({
//      required this.offset,
//      required this.alreadyFetchedList});
 }


class DataLoadedEvent extends OrderHistoryEvent{

}

class SevenDaysFilterEvent extends OrderHistoryEvent{
  final String offset;
  final List<SingleOrderModel> alreadyFetchedList;
  const SevenDaysFilterEvent({required this.offset,
    required this.alreadyFetchedList});
}
class ThirtyDaysFilterEvent extends OrderHistoryEvent{
  final String offset;
 final List<SingleOrderModel> alreadyFetchedList;
  const ThirtyDaysFilterEvent({required this.offset,
    required this.alreadyFetchedList});
}
class CustomDaysFilterEvent extends OrderHistoryEvent{
  final String offset;
  final List<SingleOrderModel> alreadyFetchedList;
  final List<DateTime?> selectedDates;

  const CustomDaysFilterEvent({required this.selectedDates,
    required this.offset,
    required this.alreadyFetchedList});

}