


part of 'ondc_single_order_details_bloc.dart';


abstract class SingleOrdersDetailsEvent extends Equatable {
  const SingleOrdersDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDataEvent extends SingleOrdersDetailsEvent{
  final String orderId;

  const LoadDataEvent({required this.orderId});

}


class DataLoadedEvent extends SingleOrdersDetailsEvent{

}