import 'dart:async';
import 'dart:math';
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
import '../../widgets/registration_widgets/textFieldRegistration.dart';

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
  final _formKey = GlobalKey<FormState>();

  late SharedPreferences pref;
  PlaceApiProvider placeApiProvider = PlaceApiProvider();
  var textController = TextEditingController();
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

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: MapPicker(
                      iconWidget: Column(
                        children: [
                          Material(
                              elevation: 5,
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.white,
                                  child: Text(textController.value.text))),
                          const Image(
                            image: AssetImage("assets/location_icon.png"),
                            height: 50,
                            width: 30,
                          ),
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
                          //get address name from camera position
                          // List<Suggestion> placemarks = await placemarkFromCoordinates(
                          //   cameraPosition.target.latitude,
                          //   cameraPosition.target.longitude,
                          // );
                          print("jjr");
                          var a = await placeApiProvider.getAddressFromLatLong(
                              cameraPosition.target.latitude.toString(),
                              cameraPosition.target.longitude.toString());
                          setState(() {
                            textController.text =
                                a; //'${cameraPosition.target.longitude},${cameraPosition.target.latitude}';
                            registrationController.address = a.obs;
                            addressTextController.text = a;

                            registrationController.lat.value =
                                cameraPosition.target.latitude;
                            registrationController.lng.value =
                                cameraPosition.target.longitude;
                            registrationController.address.value =
                                textController.value.text;

                            pref.setDouble(
                                'lat', cameraPosition.target.latitude);
                            pref.setDouble(
                                'lng', cameraPosition.target.longitude);
                          });

                          // update the ui with the address
                          print('------------' +
                              textController.value.text +
                              '-----------');
                          //'${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                        },
                      ),
                      // GoogleMap(
                      //   myLocationEnabled: true,
                      //   zoomControlsEnabled: false,
                      //   // hide location button
                      //   myLocationButtonEnabled: false,
                      //   mapType: MapType.normal,
                      //   //  camera position
                      //   initialCameraPosition: cameraPosition,
                      //   onMapCreated: (GoogleMapController controller) {
                      //     _controller.complete(controller);
                      //     print("heje");
                      //   },
                      //   onCameraMoveStarted: () {
                      //     // notify map is moving
                      //     mapPickerController.mapMoving!();
                      //   },
                      //   onCameraMove: (cameraPosition) {
                      //     this.cameraPosition = cameraPosition;
                      //   },
                      //   onCameraIdle: () async {
                      //     // notify map stopped moving
                      //     mapPickerController.mapFinishedMoving!();
                      //     //get address name from camera position
                      //     // List<Placemark> placemarks = await placemarkFromCoordinates(
                      //     //   cameraPosition.target.latitude,
                      //     //   cameraPosition.target.longitude,
                      //     // );
                      //   },
                      // ),
                    ),
                  ),
                  isVisible
                      ? Expanded(
                          flex: 14,
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Address *",
                                            style: Constant.mediumOrangeText16,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return "Please Filled Required Fields.";
                                          }
                                          var containPincode =
                                              RegExp(r'^.*\d{6}.*$')
                                                  .hasMatch(value.toString());
                                          if (!containPincode) {
                                            return 'Address Should Contain Pincode';
                                          }
                                          return null;
                                        },
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
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  RegisterationTextFeild(
                                    labelText: "How to reach (Optional)",
                                    hintText: "eg. Near Xyz hospital",
                                    icon: Icons.directions,
                                    controller: optionalAddController,
                                    readOnly: false,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextButton(
                                      child: const Text(
                                        "Submit",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 19,
                                          // height: 19/19,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          // var containPincode =
                                          //     RegExp(r'^.*\d{6}.*$').hasMatch(
                                          //         addressTextController
                                          //             .value.text);
                                          setState(() {});
                                          if (addressTextController
                                              .value.text.isNotEmpty) {
                                            setState(() {
                                              List<String> ls =
                                                  addressTextController
                                                      .value.text
                                                      .split(' ');
                                              var pin;
                                              for (var i in ls) {
                                                var a = RegExp(r'^.*\d{6}.*$')
                                                    .hasMatch(i);
                                                if (a) {
                                                  pin = i;
                                                }
                                              }
                                              locationController.mapSelected =
                                                  true.obs;
                                              registrationController
                                                  .isMapSelected = true.obs;
                                              registrationController.pinCode
                                                  .value = pin.split(',')[0];
                                              registrationController.address =
                                                  addressTextController
                                                      .value.text.obs;
                                              registrationController
                                                      .howToReach.value =
                                                  optionalAddController.text;
                                              print(registrationController
                                                  .address);

                                              //go back to registration screen
                                              Get.close(2);
                                            });
                                          } else {
                                            print("Outside if");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Please Filled Required Fields."),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                        // } else {
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(
                                        //     const SnackBar(
                                        //       content: Text(
                                        //           "Address Should Contain Pincode"),
                                        //       backgroundColor: Colors.red,
                                        //     ),
                                        //   );
                                        // }

                                        //
                                        // Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Constant.bgColor),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          !isVisible
              ? Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: Color(0xFFFFFFFF),
                          fontSize: 19,
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
