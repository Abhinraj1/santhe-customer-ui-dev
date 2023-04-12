import 'package:bloc/bloc.dart';
import 'package:santhe/core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_state.dart';

import '../../../models/ondc/single_order_model.dart';
import '../../../models/user_profile/customer_model.dart';
import '../../repositories/ondc_repository.dart';



class OrderDetailsButtonCubit extends Cubit<OrderDetailsButtonState>{
  OrderDetailsButtonCubit() :
        super(HideCancelButton());


  hideCancelButton(){
    emit(HideCancelButton());
  }

  showCancelButton(){
    emit(ShowCancelButton());
  }

}


class OrderDetailsScreenCubit extends Cubit<OrderDetailsScreenState>{
  final OndcRepository ondcRepository;

  OrderDetailsScreenCubit({required this.ondcRepository}) :
        super(OrderDetailsDataLoadingState());


 late Data orderDetails ;





///RepositoryProvider.of<OndcCheckoutRepository>(context).orderId
  loadOrderDetails({required String orderId}) async{

    emit(OrderDetailsDataLoadingState());

    try{

      orderDetails = await ondcRepository.getSingleOrder(OrderId: orderId);

      emit(OrderDetailsDataLoadedState(
          orderDetails: orderDetails
      ));

    }catch(e){

      emit(OrderDetailsErrorState(message: e.toString()));
    }
  }

  sellerNotResponded({required String message}){
    emit(OrderDetailsSellerNotRespondedErrorState(
        message: message, orderDetails: orderDetails));
  }
}