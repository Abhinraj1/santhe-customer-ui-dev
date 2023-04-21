import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../constants.dart';
import '../pages/ondc/ondc_customer_order_history_screen/ondc_order_history_view.dart';
import '../pages/ondc/ondc_shop_list/ondc_shop_list_view.dart';



orderDetailsScreenRoutingLogic(){
  if(isUserFromMyOrders ?? false){
    Get.to(const ONDCOrderHistoryView(),
        transition: Transition.leftToRight);
  }else{
    Get.to(OndcShopListView(customerModel: customerModel,),
        transition: Transition.leftToRight);

  }
}

isFromMyOrders({bool? value}){
  isUserFromMyOrders = value ?? true;
}