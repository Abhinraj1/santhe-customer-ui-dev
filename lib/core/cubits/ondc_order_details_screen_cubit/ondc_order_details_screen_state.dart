

import '../../../models/ondc/single_order_model.dart';

abstract class OrderDetailsButtonState {}

class ShowCancelButton extends OrderDetailsButtonState{}

class HideCancelButton extends OrderDetailsButtonState{}



abstract class OrderDetailsScreenState{}

class OrderDetailsDataLoadedState extends OrderDetailsScreenState{
  final List<SingleOrderModel> orderDetails;

  OrderDetailsDataLoadedState({required this.orderDetails});

}

class OrderDetailsDataLoadingState extends OrderDetailsScreenState{}

class OrderDetailsErrorState extends OrderDetailsScreenState{
  final String message;
  OrderDetailsErrorState({required this.message});
}