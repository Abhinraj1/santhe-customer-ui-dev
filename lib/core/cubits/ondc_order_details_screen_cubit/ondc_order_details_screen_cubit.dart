import 'package:bloc/bloc.dart';
import 'package:santhe/core/cubits/ondc_order_details_screen_cubit/ondc_order_details_screen_state.dart';



class OrderDetailsCubit extends Cubit<OrderDetailsState>{
  OrderDetailsCubit() :
        super(ShowCancelButton());


  hideCancelButton(){
    emit(HideCancelButton());
  }

  showCancelButton(){
    emit(ShowCancelButton());
  }

}