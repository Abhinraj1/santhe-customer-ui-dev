
part of "ondc_past_order_details_bloc.dart";



abstract class PastOrdersDetailsState extends Equatable {
  const PastOrdersDetailsState();

  @override
  List<Object?> get props => [];
}




class LoadDataState extends PastOrdersDetailsState{}

class LoadingState extends PastOrdersDetailsState{}

class DataLoadedState extends PastOrdersDetailsState{

 final List<PastOrderRow> orderDetails;

  const DataLoadedState({required this.orderDetails});

  @override
  List<Object?> get props => [orderDetails];

}

class ErrorState extends PastOrdersDetailsState{

  final String message;

  const ErrorState({required this.message});
}