
part of "ondc_single_order_details_bloc.dart";



abstract class SingleOrdersDetailsState extends Equatable {
  const SingleOrdersDetailsState();

  @override
  List<Object?> get props => [];
}




class LoadDataState extends SingleOrdersDetailsState{}

class LoadingState extends SingleOrdersDetailsState{}

class DataLoadedState extends SingleOrdersDetailsState{

 final List<SingleOrderModel> orderDetails;

  const DataLoadedState({required this.orderDetails});

  @override
  List<Object?> get props => [orderDetails];

}

class SingleOrderErrorState extends SingleOrdersDetailsState{

  final String message;

  const SingleOrderErrorState({required this.message});
}