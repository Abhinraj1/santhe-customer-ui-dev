import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:flutter/material.dart';
import 'package:santhe/API/addressSearchAPI.dart';
import 'package:santhe/controllers/registrationController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../controllers/boxes_controller.dart';
import '../../controllers/location_controller.dart';
import '../../widgets/confirmation_widgets/error_snackbar_widget.dart';
import '../../widgets/registration_widgets/textFieldRegistration.dart';
import 'mapSearchScreen.dart';

class MapAddressPicker extends StatefulWidget {
  final double lat, lng;
  const MapAddressPicker({Key? key, required this.lat, required this.lng})
      : super(key: key);

  @override
  _MapAddressPickerState createState() => _MapAddressPickerState();
}

class _MapAddressPickerState extends State<MapAddressPicker> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  late double lat, lng;
  late CameraPosition cameraPosition;
  var addressTextController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController optionalAddController = TextEditingController();
  bool isVisible = false;
  late SharedPreferences pref;
  PlaceApiProvider placeApiProvider = PlaceApiProvider();
  var textController = TextEditingController();
  bool _mapLoading = true;
  @override
  void initState() {
    print("Hello");
    lat = widget.lat;
    lng = widget.lng;
    initAdd(lat, lng);
    cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 18,
    );
    // TODO: implement initState
    super.initState();
  }

  initAdd(lat, lng) async {
    var res = await placeApiProvider.getAddressFromLatLong(
        lat.toString(), lng.toString());
    pref = await SharedPreferences.getInstance();
    setState(() {
      textController.text = res;
      addressTextController.text = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Get.put(LocationController());
    final registrationController = Get.put(RegistrationController());
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height - kToolbarHeight),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: SizedBox(
        height: 844.h,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                    child: AnimatedOpacity(
                      curve: Curves.fastOutSlowIn,
                      opacity: !_mapLoading ? 1.0 : 0,
                      duration: Duration(milliseconds: 1200),
                      child: MapPicker(
                        iconWidget: Column(
                          children: [
                            Material(
                              elevation: 5,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              child: Container(
                                width: 300.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  textController.value.text,
                                  style: TextStyle(
                                      color: Color(0xff8B8B8B),
                                      fontSize: 14.sp,
                                      height: 1.5.sp),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Icon(
                              CupertinoIcons.placemark_fill,
                              color: Constant.bgColor,
                              size: 40.sp,
                            )
                          ],
                        ),
                        // pass icon widget
                        //add map picker controller
                        mapPickerController: mapPickerController,
                        child: GoogleMap(
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                          // hide location button
                          myLocationButtonEnabled: false,
                          mapType: MapType.normal,
                          //  camera position
                          initialCameraPosition: cameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                            setState(() {
                              _mapLoading = false;
                            });
                          },
                          onCameraMoveStarted: () {
                            // notify map is moving
                            mapPickerController.mapMoving!();
                            textController.text = "checking ...";
                          },
                          onCameraMove: (cameraPosition) {
                            this.cameraPosition = cameraPosition;
                          },

                          onCameraIdle: () async {
                            // notify map stopped moving
                            mapPickerController.mapFinishedMoving!();

                            var a =
                                await placeApiProvider.getAddressFromLatLong(
                                    cameraPosition.target.latitude.toString(),
                                    cameraPosition.target.longitude.toString());
                            setState(() {
                              textController.text =
                                  a; //'${cameraPosition.target.longitude},${cameraPosition.target.latitude}';
                              registrationController.address = a.obs;

                              addressTextController.text = a;
                              userInfoController.lat.value =
                                  cameraPosition.target.latitude;
                              userInfoController.lng.value =
                                  cameraPosition.target.longitude;
                              locationController.lat.value =
                                  cameraPosition.target.latitude;
                              locationController.lng.value =
                                  cameraPosition.target.longitude;
                              pref.setDouble(
                                  'lat', cameraPosition.target.latitude);
                              pref.setDouble(
                                  'lng', cameraPosition.target.longitude);
                            });

                            // update the ui with the address
                            print(textController.value.text);
                            //'${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                          },
                        ),
                      ),
                    ),
                  ),
                  (_mapLoading)
                      ? Container(
                          height: 390.w,
                          width: 844.h,
                          color: Colors.grey[100],
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Visibility(
              child: Positioned(
                bottom: 0,
                child: Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  height: 376.h,
                  width: 390.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Address*",
                            style: Constant.mediumOrangeText16,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          //initialValue: textController.value.text.isEmpty?" ":registrationController.address.value,
                          controller: addressTextController,
                          minLines: 2,
                          maxLines: 5,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 6),
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: Constant.bgColor,
                                child: Icon(
                                  Icons.home,
                                  color: Constant.white,
                                  size: 25,
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Landmark (Optional)",
                              style: Constant.mediumOrangeText16,
                            ),
                          ),
                          TextField(
                            controller: optionalAddController,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 6),
                                child: CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Constant.bgColor,
                                  child: Icon(
                                    CupertinoIcons.placemark_fill,
                                    color: Colors.white,
                                  ), //SvgPicture.asset('assets/images/Icons/landmark.svg',height: 15,width: 15,color: Colors.red,)
                                ),
                              ),
                              hintText: "eg. Near Xyz hospital",
                              hintStyle: TextStyle(
                                  color: Color(0xffD1D1D1),
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // RegisterationTextFeild(
                      //   labelText: "Landmark (Optional)",
                      //   hintText: "eg. Near Xyz hospital",
                      //   icon: Icons.directions,
                      //   controller: optionalAddController,
                      //   readOnly: false,
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        width: 244.w,
                        child: TextButton(
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color: Color(0xFFFFFFFF),
                              fontSize: 19,
                              // height: 19/19,
                            ),
                          ),
                          onPressed: () {
                            var containPincode = RegExp(r'^.*\d{6}.*$')
                                .hasMatch(addressTextController.value.text);

                            if (containPincode) {
                              if (addressTextController.value.text.isNotEmpty) {
                                List<String> ls =
                                    addressTextController.value.text.split(' ');
                                var pin;
                                for (var i in ls) {
                                  var a = RegExp(r'^.*\d{6}.*$').hasMatch(i);
                                  if (a) {
                                    pin = i;
                                  }
                                }
                                locationController.mapSelected = true.obs;
                                registrationController.isMapSelected = true.obs;
                                registrationController.pinCode.value =
                                    pin.split(',')[0];

                                userInfoController.pinCode.value =
                                    pin.split(',')[0];
                                userInfoController.howToReach =
                                    optionalAddController.value.text.obs;
                                userInfoController.address =
                                    addressTextController.value.text.obs;
                                registrationController.howToReach =
                                    optionalAddController.value.text.obs;
                                registrationController.address =
                                    addressTextController.value.text.obs;
                                Navigator.pop(context);
                                Navigator.pop(context, 1);
                              } else {
                                errorMsg(
                                    "Error", "Please Filled Required Fields.");
                              }
                            } else {
                              errorMsg(
                                  "Error", "Address Should Contain Pincode");
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Constant.bgColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              visible: isVisible,
            ),
            Visibility(
              child: Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Container(
                  height: 50.h,
                  margin: EdgeInsets.symmetric(horizontal: 73.w),
                  child: TextButton(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: Color(0xFFFFFFFF),
                        fontSize: 18.sp,
                        // height: 19/19,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isVisible = true;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Constant.bgColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              visible: !isVisible,
            ),
          ],
        ),
      ),
    );
  }
}
