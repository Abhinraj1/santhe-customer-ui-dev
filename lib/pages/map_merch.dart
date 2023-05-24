// ignore_for_file: prefer_collection_literals

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as sv;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_picker/map_picker.dart';
import 'package:resize/resize.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/controllers/home_controller.dart';
import 'package:santhe/controllers/location_controller.dart';
import 'package:santhe/controllers/notification_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/app_url.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/new_list/user_list_model.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/network_call/network_call.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:santhe/pages/new_tab_pages/new_tab_page.dart';
import 'package:santhe/pages/ondc/ondc_intro/ondc_intro_view.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../controllers/api_service_controller.dart';
import '../controllers/getx/profile_controller.dart';
import '../widgets/navigation_drawer_widget.dart';

class MapMerchant extends StatefulWidget {
  const MapMerchant({
    Key? key,
  }) : super(key: key);

  @override
  State<MapMerchant> createState() => _MapMerchantState();
}

class _MapMerchantState extends State<MapMerchant>
    with
        LogMixin,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Completer<GoogleMapController> _controller = Completer();
  late Position position;
  // List<MapMarker> mapMarkers = [];
  Set<Marker> customMarkers = Set();
  Set<Marker> ccustomMarkers = Set();
  Set<Polyline> customerPolygon = Set();
  bool _hasData = false;
  LocationData? currentLocation;
  final profileController = Get.find<ProfileController>();
  MapPickerController mapPickerController = MapPickerController();
  Location? location;
  Set<Marker> customerMarkerIncluded = Set();
  Set<Marker> customerMarkerExcluded = Set();
  final apiController = Get.find<APIs>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final NotificationController _notificationController = Get.find();
  final AllListController _allListController = Get.find();
  final ProfileController _profileController = Get.find();
  NewListType? _type = NewListType.startFromNew;

  NetworkCall networkcall = NetworkCall();
  String mapShops =
      'Unfortunately no Shops near you on Santhe,\n But you can create and manage list.';
  String? selectedValue;
  bool _noShops = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  String listName = '';

  bool disable = false;
  CustomerModel? customerModel;
  double? customerLat;
  double? customerLong;
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
    // getLocation();
    // setInitialLocation();
    _allListController.isLoading = true;
    _init();
    getListOfShopsAroundRadius();
  }

  Future<void> _init() async {
    _homeController.homeTabController =
        TabController(length: 3, vsync: this, initialIndex: 0);
    sv.SystemChrome.setSystemUIOverlayStyle(const sv.SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    await _profileController.initialise();
    await _profileController.getOperationalStatus();
    _allListController.getAllList();
    _allListController.checkSubPlan();
    /*Connectivity().onConnectivityChanged.listen((ConnectivityResult result) =>
        _connectivityController.listenConnectivity(result));*/
    APIs().updateDeviceToken(
      AppHelpers()
          .getPhoneNumberWithoutFoundedCountryCode(AppHelpers().getPhoneNumber),
    );
    apiController.searchedItemResult('potato');
    _notificationController.fromNotification = false;
  }

  getListOfShopsAroundRadius() async {
    final locationController = Get.find<LocationController>();
    final permission = await locationController.checkPermission();
    if (permission) {
      customerModel = await networkcall.getCustomerDetails();
      warningLog('$customerModel');
      setState(() {
        customerLat = double.tryParse(customerModel!.lat);
        customerLong = double.tryParse(customerModel!.lng);
        _isLoading = true;
      });
      warningLog(
          'latitude ${customerModel!.lat} longitude ${customerModel!.lng}');
      final tokenHandler = Get.find<ProfileController>();
      await tokenHandler.generateUrlToken();
      final token = tokenHandler.urlToken;
      final header = {"authorization": 'Bearer $token'};
      log(header.toString());
      errorLog('User details $customerLat and $customerLong');
      final url = Uri.parse(
        AppUrl.GET_MERCHANTS(customerModel!.lat, customerModel!.lng),
      );
      errorLog('url being hit $url');
      try {
        final response = await http.get(url, headers: header);
        warningLog('${response.statusCode} and ${response.body}');
        final responseBody =
            json.decode(response.body)['data'] as List<dynamic>;
        warningLog('$responseBody');
        for (var element in responseBody) {
          warningLog(
              '${element['contact']['location']['lat']} ${element['contact']['location']['lng']}');
          final Uint8List markerIcon =
              await getBytesFromAssets('assets/shopPin.png', 150);
          double? latitude =
              double.tryParse(element['contact']['location']['lat'].toString());
          double? longitude =
              double.tryParse(element['contact']['location']['lng'].toString());
          ccustomMarkers.add(
            Marker(
              infoWindow: InfoWindow(title: element['merchName']),
              markerId: MarkerId(
                element['gstinNumber'],
              ),
              position: LatLng(
                latitude!,
                longitude!,
              ),
              icon: BitmapDescriptor.fromBytes(markerIcon),
            ),
          );
          customerMarkerExcluded.add(
            Marker(
              infoWindow: InfoWindow(title: element['merchName']),
              markerId: MarkerId(
                element['gstinNumber'],
              ),
              position: LatLng(
                latitude,
                longitude,
              ),
              icon: BitmapDescriptor.fromBytes(markerIcon),
            ),
          );
        }
        // List<Marker> markers = [];
        warningLog('$ccustomMarkers');
        final Uint8List customerIcon =
            await getBytesFromAssets('assets/customerPin.png', 150);
        errorLog(
            'is Empty function ? ${customerMarkerExcluded.isEmpty} is Blank function ${customerMarkerExcluded.isBlank} length ${customerMarkerExcluded.length}');
        ccustomMarkers.add(
          Marker(
            infoWindow: const InfoWindow(title: 'Your Location'),
            markerId: MarkerId(
              customerModel!.customerId,
            ),
            position: LatLng(
              customerLat!,
              customerLong!,
            ),
            icon: BitmapDescriptor.fromBytes(customerIcon),
          ),
        );
        debugLog('$ccustomMarkers');
        setState(
          () {
            customMarkers = ccustomMarkers;
            _hasData = true;
            _isLoading = false;
          },
        );
        warningLog('checking for String change$mapShops');
      } catch (e) {
        setState(() {
          _hasData = true;
        });
        rethrow;
      }
    }
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

  _launchUrl() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=BkvCsbmzkU8');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    errorLog(
        'buildcontext${customerMarkerExcluded.isEmpty} checking for condition${_allListController.newList.length} for isloading ${_allListController.isLoading}');
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _key,
      drawer: const CustomNavigationDrawer(),
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
            onTap: _launchUrl,
            // () {
            //   Navigator.pushReplacement(
            //     context,
            //     PageTransition(
            //       child: const YoutubeVideoGuide(),
            //       type: PageTransitionType.rightToLeft,
            //     ),
            //   );
            // },
            child: Image.asset(
              'assets/questioncircle.png',
              height: 18,
              width: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 1.0),
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
          ),
          Padding(
            padding: const EdgeInsets.only(right: 1.5),
            child: IconButton(
              onPressed: () {
                // if (Platform.isIOS) {
                //   Share.share(
                //     AppHelpers().appStoreLink,
                //   );
                // } else {
                //   Share.share(
                //     AppHelpers().playStoreLink,
                //   );
                // }
                Get.off(() => const OndcIntroView());
              },
              splashRadius: 25.0,
              icon: const Icon(
                Icons.home,
                color: Colors.white,
                size: 27.0,
              ),
            ),
          ),
        ],
      ),
      body: _hasData
          ? RefreshIndicator(
              onRefresh: () => _allListController.getAllList(),
              child: Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    compassEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    markers: customMarkers,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(customerLat!, customerLong!),
                      zoom: 13.5,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      warningLog('${mapPickerController.mapFinishedMoving}');
                      mapPickerController.mapFinishedMoving;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: GestureDetector(
                        onTap: () {
                          log('Tapped on floating action button');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                showMap: false,
                                pageIndex: 0,
                                cameFromHomeScreen: true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Constant.bgColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Center(
                            child: Text(
                              'My Lists',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 190, 116, 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Center(
                            child: customerMarkerExcluded.isEmpty
                                ? const Text(
                                    'Unfortunately no Shops near you on Santhe,\n But you can create and manage list.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                :
                                // child:
                                const Text(
                                    'Grocery stores near you are on santhe \n Create list >> Send to shops >> Get great deal',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          // : RefreshIndicator(
          //     onRefresh: () => _allListController.getAllList(),
          //     child: Stack(
          //       children: [
          //         GoogleMap(
          //           myLocationEnabled: false,
          //           myLocationButtonEnabled: false,
          //           zoomControlsEnabled: false,
          //           zoomGesturesEnabled: false,
          //           tiltGesturesEnabled: false,
          //           compassEnabled: false,
          //           scrollGesturesEnabled: false,
          //           rotateGesturesEnabled: false,
          //           // markers: customMarkers,
          //           initialCameraPosition: CameraPosition(
          //             target: LatLng(customerLat!, customerLong!),
          //             zoom: 13.5,
          //           ),
          //           onMapCreated: (GoogleMapController controller) {
          //             _controller.complete(controller);
          //             warningLog('${mapPickerController.mapFinishedMoving}');
          //             mapPickerController.mapFinishedMoving;
          //           },
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(15.0),
          //           child: Align(
          //             alignment: Alignment.bottomLeft,
          //             child: GestureDetector(
          //               onTap: () {
          //                 log('Tapped on floating action button');
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) => HomePage(
          //                       showMap: false,
          //                       pageIndex: 0,
          //                       cameFromHomeScreen: true,
          //                     ),
          //                   ),
          //                 );
          //               },
          //               child: Container(
          //                 height: 40,
          //                 width: 100,
          //                 decoration: BoxDecoration(
          //                   color: Constant.bgColor,
          //                   borderRadius: BorderRadius.circular(10.0),
          //                 ),
          //                 child: const Center(
          //                   child: Text(
          //                     'My Lists',
          //                     style: TextStyle(
          //                         color: Colors.white,
          //                         fontWeight: FontWeight.bold),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(15.0),
          //           child: Align(
          //             alignment: Alignment.topCenter,
          //             child: Container(
          //               height: 100,
          //               width: MediaQuery.of(context).size.width,
          //               decoration: BoxDecoration(
          //                 color: const Color.fromRGBO(255, 190, 116, 1),
          //                 borderRadius: BorderRadius.circular(10.0),
          //               ),
          //               child: const Padding(
          //                 padding: EdgeInsets.all(3.0),
          //                 child: Center(
          //                     child: Text(
          //                   'Unfortunately no Shops near you on Santhe,\n But you can create and manage list.',
          //                   style: TextStyle(
          //                     color: Colors.black,
          //                     fontSize: 14,
          //                   ),
          //                   textAlign: TextAlign.center,
          //                 )),
          //               ),
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: GetBuilder(
        init: _allListController,
        id: 'fab1',
        builder: (ctr) =>
            _allListController.newList.length >= _allListController.lengthLimit
                //     ||
                // _allListController.isLoading
                ? const SizedBox()
                : FloatingActionButton(
                    heroTag: "btn10",
                    elevation: 0.0,
                    onPressed: () => showModalBottomSheet<void>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        barrierColor: const Color.fromARGB(165, 241, 241, 241),
                        isScrollControlled: true,
                        builder: (ctx) => _bottomSheet(ctx)),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 22.5.sp,
                      semanticLabel: 'Click here to create a new order!',
                    ),
                  ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _addDividersAfterItems() {
    int maxLength = 5;
    List<DropdownMenuItem<String>> menuItems = [];
    List<UserListModel> list = _allListController.getLatestList(maxLength);
    for (var element in list) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: element.listId,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                element.listName,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          //If it's last item, remove divider.
          if (element != list.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            )
        ],
      );
    }
    return menuItems;
  }

  Widget _bottomSheet(BuildContext context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.r),
              topLeft: Radius.circular(30.r),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 16.0,
              ),
            ],
          ),
          child: StatefulBuilder(
            builder: (c, changeState) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.transparent,
                                  // color: Color(0xffe8e8e8),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Add New List',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.sp,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(c);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(bottom: 12.0),
                                  child: Icon(
                                    Icons.close,
                                    color: Color(0xffe8e8e8),
                                  ),
                                ),
                              ),
                            ]),
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0.0),
                          title: Text(
                            'Create a new list',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          horizontalTitleGap: 0,
                          leading: Radio<NewListType>(
                            value: NewListType.startFromNew,
                            groupValue: _type,
                            onChanged: (NewListType? value) {
                              changeState(() {
                                _type = value;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: _type == NewListType.startFromNew,
                          child: SizedBox(
                            width: 314.w,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a list name';
                                }
                                return null;
                              },
                              enabled: _type == NewListType.startFromNew,
                              autofocus: true,
                              maxLength: 30,
                              onChanged: (value) {
                                listName = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter list Name',
                                hintStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      kTextFieldCircularBorderRadius),
                                  borderSide: const BorderSide(
                                      width: 1.0, color: kTextFieldGrey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      kTextFieldCircularBorderRadius),
                                  borderSide: const BorderSide(
                                      width: 1.0, color: kTextFieldGrey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      kTextFieldCircularBorderRadius),
                                  borderSide: BorderSide(
                                      width: 1.0, color: AppColors().brandDark),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        // start from an old list
                        Visibility(
                          visible:
                              _allListController.getLatestList(5).isNotEmpty
                                  ? true
                                  : false,
                          child: Column(
                            children: [
                              ListTile(
                                minVerticalPadding: 0.0,
                                contentPadding: const EdgeInsets.all(0.0),
                                title: Text(
                                  'Start from an old list',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                horizontalTitleGap: 0,
                                leading: Radio<NewListType>(
                                  value: NewListType.importFromOld,
                                  groupValue: _type,
                                  onChanged: (NewListType? value) {
                                    changeState(() {
                                      _type = value;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: _type == NewListType.importFromOld,
                                child: SizedBox(
                                  width: 314.w,
                                  height: 65.h,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: SizedBox(
                                          width: 314.w,
                                          height: 65.h,
                                          child: DropdownButtonHideUnderline(
                                              child: DropdownButton2(
                                            isExpanded: true,
                                            hint: Text(
                                              'Select',
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            items: _addDividersAfterItems(),

                                            ///
                                            value: selectedValue,
                                            onChanged: (value) {
                                              changeState(() {
                                                selectedValue = value as String;
                                              });
                                            },
                                            // icon: const Icon(
                                            //   Icons.keyboard_arrow_up,
                                            // ),
                                            // iconSize: 14,
                                            // iconEnabledColor: Colors.grey,
                                            // iconDisabledColor:
                                            //     Colors.grey.shade100,
                                            // buttonHeight: 50,
                                            // style: TextStyle(
                                            //     color: Colors.grey,
                                            //     fontSize: 14.sp,
                                            //     fontWeight: FontWeight.w400),
                                            // buttonWidth: 160,
                                            // buttonPadding:
                                            //     const EdgeInsets.only(
                                            //         left: 14, right: 14),
                                            // buttonDecoration: BoxDecoration(
                                            //   borderRadius: BorderRadius.circular(
                                            //       kTextFieldCircularBorderRadius),
                                            //   border: Border.all(
                                            //     color: kTextFieldGrey,
                                            //   ),
                                            //   color: Colors.white,
                                            // ),
                                            // buttonElevation: 0,
                                            // itemHeight: 40,
                                            // itemPadding: const EdgeInsets.only(
                                            //     left: 14, right: 14),
                                            // dropdownMaxHeight: 200,
                                            // dropdownWidth: 314.sp,
                                            // dropdownPadding: null,
                                            // dropdownDecoration: BoxDecoration(
                                            //   borderRadius: BorderRadius.circular(
                                            //       kTextFieldCircularBorderRadius),
                                            //   color: Colors.grey.shade100,
                                            // ),
                                            // dropdownElevation: 0,
                                            // scrollbarRadius:
                                            //     const Radius.circular(40),
                                            // scrollbarThickness: 6,
                                            // scrollbarAlwaysShow: true,
                                            // offset: const Offset(0, 0),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: _type == NewListType.importFromOld
                                ? 90.sp
                                : 30.sp),
                        SizedBox(
                          width: 221.sp,
                          height: 50.sp,
                          child: Obx(() => _allListController.isProcessing.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors().brandDark,
                                  ),
                                )
                              : MaterialButton(
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  color: Colors.orange,
                                  disabledColor: AppColors().grey80,
                                  onPressed: () async {
                                    _allListController.isProcessing.value =
                                        true;
                                    if (listName.isNotEmpty &&
                                        _type == NewListType.startFromNew) {
                                      if (_formKey.currentState!.validate()) {
                                        if (await _allListController
                                            .isListAlreadyExist(
                                                listName.trim())) {
                                          errorMsg('List name is already taken',
                                              'Enter unique name');
                                          _allListController
                                              .isProcessing.value = false;
                                        } else {
                                          _allListController
                                              .addNewListToDB(listName);
                                        }
                                      }
                                    } else if (listName.isEmpty &&
                                        _type == NewListType.startFromNew) {
                                      Get.snackbar(
                                        '',
                                        '',
                                        titleText: const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text('Enter a List Name'),
                                        ),
                                        messageText: const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              'Please enter a new list name before continuing...'),
                                        ),
                                        margin: const EdgeInsets.all(10.0),
                                        padding: const EdgeInsets.all(8.0),
                                        backgroundColor: Colors.white,
                                        shouldIconPulse: true,
                                        icon: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            CupertinoIcons
                                                .exclamationmark_triangle_fill,
                                            color: Colors.orange,
                                            size: 45,
                                          ),
                                        ),
                                      );
                                      _allListController.isProcessing.value =
                                          false;
                                    } else if (_type ==
                                        NewListType.importFromOld) {
                                      if (selectedValue != null) {
                                        _allListController
                                            .addCopyListToDB(selectedValue!);
                                      } else {
                                        Get.snackbar(
                                          '',
                                          '',
                                          titleText: const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text('Please select a list'),
                                          ),
                                          messageText: const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child:
                                                Text('Else create a new list'),
                                          ),
                                          margin: const EdgeInsets.all(10.0),
                                          padding: const EdgeInsets.all(8.0),
                                          backgroundColor: Colors.white,
                                          shouldIconPulse: true,
                                          icon: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              CupertinoIcons
                                                  .exclamationmark_triangle_fill,
                                              color: Colors.orange,
                                              size: 45,
                                            ),
                                          ),
                                        );
                                        _allListController.isProcessing.value =
                                            false;
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 21.sp,
                                    ),
                                  ),
                                )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  _showDialog(String errorMessage) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: const Center(
              child: Text(
                'Authentication Message',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            contentPadding: const EdgeInsets.only(top: 20),
            content: SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Expanded(
                        child: Text(errorMessage),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomePage(pageIndex: 0, showMap: false),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                        child: const Text(
                          "Exit",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
