import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:santhe/pages/error_pages/no_internet_page.dart';

class ConnectivityController extends GetxController{
  bool hasInternet = true;

  bool inInternetErrorScreen = false;

  ConnectivityResult connectivityResult = ConnectivityResult.none;

  void listenConnectivity(ConnectivityResult result){
    connectivityResult = result;

    if(result == ConnectivityResult.none){
      hasInternet = false;
      Get.to(() => const NoInternetPage(), transition: Transition.fade);
    }

    if((result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) && !hasInternet){
      Get.back();
      hasInternet = true;
    }
  }

  void checkConnectivity(){
    if(!hasInternet){
      Connectivity().checkConnectivity().then((result){
        if((result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) && !hasInternet){
          Get.back();
          hasInternet = true;
        }
      });
    }
  }
}