


part of 'ondc_past_order_details_bloc.dart';


abstract class PastOrdersDetailsEvent extends Equatable {
  const PastOrdersDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDataEvent extends PastOrdersDetailsEvent{

}


class DataLoadedEvent extends PastOrdersDetailsEvent{

}