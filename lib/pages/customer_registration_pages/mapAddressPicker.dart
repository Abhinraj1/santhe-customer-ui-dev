import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:flutter/material.dart';
import 'package:santhe/API/addressSearchAPI.dart';
import 'package:santhe/controllers/error_user_fallback.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/controllers/registrationController.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import '../../constants.dart';
import '../../controllers/location_controller.dart';
import '../../core/app_colors.dart';
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
  late CameraPosition initialCameraPosition;
  var addressTextController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController optionalAddController = TextEditingController();
  bool isVisible = false;
  bool denied = false;
  final _formKey = GlobalKey<FormState>();
  final profileController = Get.find<ProfileController>();
  CustomerModel? currentUser;
  PlaceApiProvider placeApiProvider = PlaceApiProvider();
  var textController = TextEditingController();
  GoogleMapController? _googleMapController;

  @override
  void initState() {
    lat = widget.lat;
    lng = widget.lng;
    initialCameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 18,
    );
    currentUser = profileController.customerDetails ?? fallback_error_customer;
    /*if (widget.lat != null && widget.lng != null) {
      lat = widget.lat!;
      lng = widget.lng!;
      initialCameraPosition = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 18,
      );
      currentUser = profileController.customerDetails ?? fallback_error_customer;
    } else {
      initialCameraPosition = CameraPosition(target: LatLng(double.parse(currentUser?.lat ?? '12.980143644412847'), double.parse(currentUser?.lng ?? '77.56857242435218')), zoom: 18);
      LocationController.getGeoLocationPosition().then((value) async {
        if (value != null) {
          lat = value.latitude;
          lng = value.longitude;
          await initAdd(lat, lng);
          if (_googleMapController != null) {
            _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 18)));
          }
        }
      });
    }*/

    // TODO: implement initState
    super.initState();
  }

  initAdd(lat, lng) async {
    var res = await placeApiProvider.getAddressFromLatLong(
        lat.toString(), lng.toString());
    setState(() {
      textController.text = res;
      addressTextController.text = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.find();
    final RegistrationController registrationController = Get.find();
    Size size = MediaQuery.of(context).size;

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
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        initialCameraPosition: initialCameraPosition,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          _googleMapController = controller;
                        },
                        onCameraMoveStarted: () {
                          mapPickerController.mapMoving!();
                          textController.text = "checking ...";
                        },
                        onCameraMove: (initialCameraPosition) {
                          this.initialCameraPosition = initialCameraPosition;
                        },
                        onCameraIdle: () async {
                          mapPickerController.mapFinishedMoving!();
                          var a = await placeApiProvider.getAddressFromLatLong(
                              initialCameraPosition.target.latitude.toString(),
                              initialCameraPosition.target.longitude
                                  .toString());
                          setState(() {
                            textController.text = a;
                            registrationController.address = a.obs;
                            addressTextController.text = a;
                            lat = initialCameraPosition.target.latitude;
                            lng = initialCameraPosition.target.longitude;
                            registrationController.lat.value =
                                initialCameraPosition.target.latitude;
                            registrationController.lng.value =
                                initialCameraPosition.target.longitude;
                            registrationController.address.value =
                                textController.value.text;
                          });
                        },
                      ),
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                        textInputAction: TextInputAction.done,
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
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                kTextFieldCircularBorderRadius),
                                            borderSide: BorderSide(
                                                width: 1.0,
                                                color: AppColors().brandDark),
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
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {});
                                          if (addressTextController
                                              .value.text.isNotEmpty) {
                                            setState(() {
                                              List<String> ls =
                                                  addressTextController
                                                      .value.text
                                                      .split(' ');
                                              String pin = '';
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
                                              registrationController
                                                      .pinCode.value =
                                                  pin.replaceAll(',', '');
                                              registrationController.address =
                                                  addressTextController
                                                      .value.text.obs;
                                              registrationController
                                                      .howToReach.value =
                                                  optionalAddController.text;
                                              registrationController.lat.value =
                                                  lat;
                                              registrationController.lng.value =
                                                  lng;

                                              registrationController
                                                  .update(['fieldValue']);
                                              //go back to registration screen
                                              Get.close(2);
                                            });
                                          } else {
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
          !isVisible && textController.text.isNotEmpty
              ? Positioned(
                  bottom: 24,
                  child: SizedBox(
                    height: 50,
                    width: size.width * 0.4,
                    child: TextButton(
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
                    ),
                  ),
                )
              : Container(),
          if (textController.text.isEmpty)
            Container(
              height: size.height,
              width: size.width,
              color: Colors.black12,
              child: const Center(child: CircularProgressIndicator.adaptive()),
            )
        ],
      ),
    );
  }
}
