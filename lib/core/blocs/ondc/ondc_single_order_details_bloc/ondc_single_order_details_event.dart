


part of 'ondc_single_order_details_bloc.dart';


abstract class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object?> get props => [];
}



class LoadPastOrderDataEvent extends OrderHistoryEvent{
  const LoadPastOrderDataEvent();
}


class DataLoadedEvent extends OrderHistoryEvent{

}

class SevenDaysFilterEvent extends OrderHistoryEvent{

}
class ThirtyDaysFilterEvent extends OrderHistoryEvent{

}
class CustomDaysFilterEvent extends OrderHistoryEvent{

  final List<DateTime?> selectedDates;

  const CustomDaysFilterEvent({required this.selectedDates});

}