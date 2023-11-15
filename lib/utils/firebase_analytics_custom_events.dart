

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:santhe/constants.dart';

class AnalyticsCustomEvents{

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);



  userSignUpEvent({required String number,required String name}) async{
    print("===================================================================="
        "====================================================================userSignUpEvent");
    await analytics.logSignUp(signUpMethod: number);

    await analytics.logEvent(
      name: "user_signUp",
      parameters: {
        "user_number":number,
        "user_name":name,
      }
    );
  }

  userLoginEvent() async{
    print("===================================================================="
        "====================================================================userLoginEvent");
    await analytics.logLogin(loginMethod: customerModel.phoneNumber);

    await analytics.logEvent(
        name: "user_login",
        parameters: {
          "user_number":customerModel.phoneNumber,
          "user_name":customerModel.customerName,
        }
    );
  }

  userEditProfileEvent() async{
    print("===================================================================="
        "====================================================================userEditProfileEvent");

    await analytics.logEvent(
        name: "user_edited_profile",
        parameters: {
          "user_number":customerModel.phoneNumber,
          "user_name":customerModel.customerName,
        }
    );
  }

  userEditDeliveryAddressEvent() async{
    print("===================================================================="
        "====================================================================userEditDeliveryAddressEvent");

    await analytics.logEvent(
        name: "user_edited_delivery_address",
        parameters: {
          "user_number":customerModel.phoneNumber,
          "user_name":customerModel.customerName,
        }
    );
  }

  userViewedScreen({required String screen}) async{

    await analytics.logEvent(
        name: "user_viewed_screen",
        parameters: {
          "viewed_screen":screen,
        }
    );
  }

  userViewedShopDetailsScreen({required String shopName}) async{
    print("===================================================================="
        "====================================================================userViewedShopDetailsScreen");

    await analytics.logEvent(
        name: "user_viewed_screen",
        parameters: {
          "viewed_screen":"Shop_Details_Screen",
          "store_name": shopName
        }
    );
  }

  userSearchShopDetailsScreen({required String searchedProduct,required String shopName}) async{
    print("===================================================================="
        "====================================================================userSearchShopDetailsScreen");
    await analytics.logEvent(
        name: "user_search_shop_details_Screen",
        parameters: {
          "searched_product": searchedProduct,
          "shop_name":shopName
        }
    );
  }

  userSearchShopListScreen({required String searchedProduct}) async{

    await analytics.logEvent(
        name: "user_search_shop_list_Screen",
        parameters: {
          "searched_product": searchedProduct
        }
    );
  }

  userViewedProduct({required String product,
    //required String shopName
  }) async{

    await analytics.logEvent(
        name: "user_viewed_product",
        parameters: {
          "product_name": product,
          //"shop_name":shopName
        }
    );
  }

  userCart({required String product,required String quantity}) async{

    await analytics.logAddToCart(items:[AnalyticsEventItem(
        itemName: product,
        quantity: int.parse(quantity))],
    );

    // await analytics.logEvent(
    //     name: "user_added_product_to_cart",
    //     parameters: {
    //       "product_name": product,
    //       "quantity": quantity
    //     }
    // );
  }

  userCheckOutEvent({required String storeDescriptionId}) async{

    await analytics.logEvent(
        name: "user_checkout",
        parameters: {
          "storeDescriptionId": storeDescriptionId,
          "user_number":customerModel.phoneNumber,
        }
    );
  }

  userOrderSuccessEvent({required String orderId,
    //required String shopName
  }) async{

    await analytics.logEvent(
        name: "user_order_placed_successfully",
        parameters: {
          "orderId": orderId,
          "user_number":customerModel.phoneNumber,
         // "shop_name":shopName
        }
    );
  }

  userOrderCancelEvent({required String orderId,required String reason}) async{

    await analytics.logEvent(
        name: "user_order_cancelled_order",
        parameters: {
          "orderId": orderId,
          "user_number":customerModel.phoneNumber,
          "reason":reason
        }
    );
  }

  //AnalyticsCustomEvents().userEditProfileEvent();


}