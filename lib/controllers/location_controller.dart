import 'dart:developer';

import 'package:get/get.dart';

import 'package:geolocator/geolocator.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
class LocationController extends GetxController {
  RxDouble lat = 0.0.obs;
  RxDouble lng = 0.0.obs;
  RxBool mapSelected = false.obs;

  updateLatLng(lat, lng) {
    this.lng.value = lng;
    this.lat.value = lat;
    log(this.lat.toString());
    log(this.lng.toString());
    update();
  }

  static Future<Position?> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
    return null;
  }

  Future<bool> checkPermission() async{
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.deniedForever){
        errorMsg('Permission Denied Forever', 'Please enable location services from settings.');
      }else if(permission == LocationPermission.denied){
        errorMsg('Location Permission Denied', 'Please allow to use location permissions.');
      }
    }

    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      return true;
    }
    return false;
  }
}
