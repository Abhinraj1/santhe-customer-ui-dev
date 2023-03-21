
part of "ondc_order_history_bloc.dart";



abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object?> get props => [];
}




class LoadDataState extends OrderHistoryState{}

class LoadingState extends OrderHistoryState{}

class SevenDaysFilterState extends OrderHistoryState{

  final List<SingleOrderModel> orderDetails;

  const SevenDaysFilterState({required this.orderDetails});

  @override
  List<Object?> get props => [orderDetails];
}

class ThirtyDaysFilterState extends OrderHistoryState{
  final List<SingleOrderModel> orderDetails;

  const ThirtyDaysFilterState({required this.orderDetails});

  @override
  List<Object?> get props => [orderDetails];
}

class CustomDaysFilterState extends OrderHistoryState{
  final List<SingleOrderModel> orderDetails;

  const CustomDaysFilterState({required this.orderDetails});

  @override
  List<Object?> get props => [orderDetails];
}


class DataLoadedState extends OrderHistoryState{

 final List<SingleOrderModel> orderDetails;

  const DataLoadedState({required this.orderDetails});

  @override
  List<Object?> get props => [orderDetails];

}

class PastOrderDataLoadedState extends OrderHistoryState{

  final List<SingleOrderModel> orderDetails;

  const PastOrderDataLoadedState({required this.orderDetails});

  @override
  List<Object?> get props => [orderDetails];

}

class SingleOrderErrorState extends OrderHistoryState{

  final String message;

  const SingleOrderErrorState({required this.message});
}