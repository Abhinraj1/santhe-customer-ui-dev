import 'package:get/get.dart';

class RegistrationController extends GetxController {
  RxString address = "".obs;
  RxString pinCode = "".obs;
  RxDouble lng = 0.0.obs;
  RxDouble lat = 0.0.obs;
  RxBool isMapSelected = false.obs;
  RxBool homeDelivery = false.obs;
  RxString howToReach = "".obs;
}
