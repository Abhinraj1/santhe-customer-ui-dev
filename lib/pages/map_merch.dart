// ignore_for_file: prefer_collection_literals

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as sv;
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_picker/map_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/location_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/pages/youtubevideo.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../controllers/getx/profile_controller.dart';

class MapMerchant extends StatefulWidget {
  const MapMerchant({
    Key? key,
  }) : super(key: key);

  @override
  State<MapMerchant> createState() => _MapMerchantState();
}

class _MapMerchantState extends State<MapMerchant> with LogMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Completer<GoogleMapController> _controller = Completer();
  late Position position;
  // List<MapMarker> mapMarkers = [];
  Set<Marker> customMarkers = Set();
  Set<Polyline> customerPolygon = Set();
  bool _hasData = false;
  LocationData? currentLocation;
  MapPickerController mapPickerController = MapPickerController();
  Location? location;
  Set<Marker> customerMarkerIncluded = Set();

  @override
  void initState() {
    super.initState();
    // getLocation();
    // setInitialLocation();
    getListOfShopsAroundRadius();
    mapPickerController.mapFinishedMoving;
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await sv.rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getListOfShopsAroundRadius() async {
    position = (await LocationController.getGeoLocationPosition())!;
    warningLog('$position');
    setState(() {
      _hasData = true;
    });
    final tokenHandler = Get.find<ProfileController>();
    await tokenHandler.generateUrlToken();
    final token = tokenHandler.urlToken;
    final header = {"authorization": 'Bearer $token'};
    log(header.toString());
    final url = Uri.parse(
        'https://us-central1-santhe-425a8.cloudfunctions.net/apis/santhe/v1/app/customer/nearby/merchants?lat=${position.latitude}&lng=${position.longitude}');
    try {
      final response = await http.get(url, headers: header);
      final Uint8List polygonIcon =
          await getBytesFromAssets('assets/customerPin.png', 180);

      warningLog('$response');
      final responseBody = json.decode(response.body)['data'] as List<dynamic>;
      Set<Marker> ccustomMarkers = Set();
      for (var element in responseBody) {
        final Uint8List markerIcon =
            await getBytesFromAssets('assets/shopPin.png', 180);
        ccustomMarkers.add(
          Marker(
            infoWindow: InfoWindow(title: element['contact']['address']),
            markerId: MarkerId(
              element['gstinNumber'],
            ),
            position: LatLng(
              element['contact']['location']['lat'],
              element['contact']['location']['lng'],
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
      }
      // List<Marker> markers = [];
      warningLog('$ccustomMarkers');
      final Uint8List customerIcon =
          await getBytesFromAssets('assets/customerPin.png', 180);
      ccustomMarkers.add(
        Marker(
            markerId: MarkerId(
              position.latitude.toString(),
            ),
            position: LatLng(
              position.latitude,
              position.longitude,
            ),
            icon: BitmapDescriptor.fromBytes(customerIcon)),
      );
      infoLog('$ccustomMarkers');
      setState(() {
        customMarkers = ccustomMarkers;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            //APIs().updateDeviceToken(AppHelpers().getPhoneNumberWithoutCountryCode);
            /*log(await AppHelpers().getToken);
            sendNotification('tesst');*/
            _key.currentState!.openDrawer();
            /*FirebaseAnalytics.instance.logEvent(
              name: "select_content",
              parameters: {
                "content_type": "image",
                "item_id": 'itemId',
              },
            ).then((value) => print('success')).catchError((e) => print(e.toString()));*/
          },
          splashRadius: 25.0,
          icon: SvgPicture.asset(
            'assets/drawer_icon.svg',
            color: Colors.white,
          ),
        ),
        shadowColor: Colors.orange.withOpacity(0.5),
        elevation: 10.0,
        title: GestureDetector(
          onTap: getListOfShopsAroundRadius,
          child: const AutoSizeText(
            kAppName,
            style: TextStyle(
                fontWeight: FontWeight.w800, color: Colors.white, fontSize: 24),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  child: YoutubeVideoGuide(),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            child: Image.asset('assets/questioncircle.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.5),
            child: IconButton(
              onPressed: () {
                if (Platform.isIOS) {
                  Share.share(
                    AppHelpers().appStoreLink,
                  );
                } else {
                  Share.share(
                    AppHelpers().playStoreLink,
                  );
                }
              },
              splashRadius: 25.0,
              icon: const Icon(
                Icons.share,
                color: Colors.white,
                size: 27.0,
              ),
            ),
          )
        ],
      ),
      body: _hasData
          ? MapPicker(
              mapPickerController: mapPickerController,
              iconWidget: Column(
                children: const [
                  // Image(
                  //   image: AssetImage("assets/customerPin.png"),
                  //   height: 50,
                  //   width: 30,
                  // ),
                ],
              ),
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: customMarkers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  warningLog('${mapPickerController.mapFinishedMoving}');
                  mapPickerController.mapFinishedMoving;
                },
              ),
            )
          : const Center(
              child: Text(
                'Getting your Location..please wait',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
    );
  }
}
