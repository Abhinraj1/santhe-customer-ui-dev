import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/location_controller.dart';
import 'package:santhe/pages/customer_registration_pages/mapAddressPicker.dart';

import '../../API/addressSearchAPI.dart';
import '../../constants.dart';
import '../../controllers/registrationController.dart';
import '../../core/app_colors.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({Key? key}) : super(key: key);

  @override
  _MapSearchScreenState createState() => _MapSearchScreenState();
}

final userInfoController = Get.put(RegistrationController());

class _MapSearchScreenState extends State<MapSearchScreen> {
  final _controller = TextEditingController();
  String query = "";
  PlaceApiProvider apiClient = PlaceApiProvider();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isFetchingLocation = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: screenHeight * 5.5,
        leading: IconButton(
          splashRadius: 0.1,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 13.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Your Address',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _controller,
                  textAlignVertical: TextAlignVertical.center,
                  // autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: const Color(0xff8B8B8B),
                  ),
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: Visibility(
                      visible: query.isNotEmpty,
                      child: GestureDetector(
                          onTap: () {
                            _controller.clear();
                            setState(() {
                              query = "";
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.grey.shade300,
                          )),
                    ),
                    prefixIcon: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 7),
                      child: Icon(
                        CupertinoIcons.search_circle_fill,
                        color: Colors.orange,
                        size: 30,
                      ),
                    ),
                    hintText: "Enter your address",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(16),
                      topLeft: const Radius.circular(16),
                      bottomLeft: query.isEmpty
                          ? const Radius.circular(16)
                          : const Radius.circular(2),
                      bottomRight: query.isEmpty
                          ? const Radius.circular(16)
                          : const Radius.circular(2),
                    )),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(kTextFieldCircularBorderRadius),
                      borderSide:
                          BorderSide(width: 1.0, color: AppColors().brandDark),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.sp),
                  ),
                ),
                Visibility(
                  visible: _controller.text.isEmpty ? false : true,
                  child: Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffE0E0E0).withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14))),
                      child: FutureBuilder(
                          future: query == ""
                              ? null
                              : apiClient.fetchSuggestions(query,
                                  Localizations.localeOf(context).languageCode),
                          builder: (context, AsyncSnapshot snapshot) => query ==
                                  ''
                              ? Container()
                              : snapshot.hasData
                                  ? snapshot.hasData
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) =>
                                              GestureDetector(
                                                  onTap: () async {
                                                    PlaceApiProvider
                                                        placeApiProvider =
                                                        PlaceApiProvider();
                                                    placeApiProvider
                                                        .getPlaceDetailFromId(
                                                            snapshot.data[index]
                                                                .placeId);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 20.h),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          size: 24.sp,
                                                          color:
                                                              Constant.bgColor,
                                                        ),
                                                        SizedBox(width: 13.w),
                                                        Column(
                                                          children: [
                                                            Wrap(children: [
                                                              SizedBox(
                                                                  width: 234.w,
                                                                  child: Text(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .description,
                                                                    style: Constant
                                                                        .regularGrayText16,
                                                                    maxLines: 5,
                                                                  ))
                                                            ]),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Constant.grey,
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                          itemCount: snapshot.data.length,
                                        )
                                      : const Text('Loading...')
                                  : Container()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Visibility(
                  visible: _controller.text.isEmpty ? true : false,
                  child: const SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        "OR",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      )),
                ),
                SizedBox(
                  height: 15.h,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isFetchingLocation = true;
                    });
                    Future.delayed(const Duration(seconds: 0), () async {
                      final locationController = Get.find<LocationController>();
                      final permission =
                          await locationController.checkPermission();
                      if (permission) {
                        LocationController.getGeoLocationPosition()
                            .then((value) {
                          Get.to(() => MapAddressPicker(
                                lat: value!.latitude,
                                lng: value.longitude,
                              ));
                          _isFetchingLocation = false;
                        });
                      }
                      setState(() {
                        _isFetchingLocation = false;
                      });
                    });
                  },
                  child: Center(
                    child: Container(
                      width: 70.vw,
                      decoration: BoxDecoration(
                          color: Constant.bgColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14))),
                      margin: EdgeInsets.symmetric(horizontal: 40.w),
                      padding: const EdgeInsets.all(10),
                      child: _isFetchingLocation
                          ? Center(
                              child: SizedBox(
                                  height: 30.h,
                                  width: 30.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  )),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.gps_fixed,
                                  color: Constant.white,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "Use current location",
                                  style: TextStyle(
                                      color: Constant.white,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Visibility(
                  visible: _controller.text.isEmpty ? true : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Visibility(
                            visible: userInfoController.address.isEmpty
                                ? false
                                : true,
                            child: const Text(
                              "Current Address",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            )),
                      ),
                      Obx(() => Text(
                          '${userInfoController.address.obs.string}\n${userInfoController.howToReach.value}'))
                    ],
                  ),
                ),
              ],
            ),
            /*Positioned(
              child: GestureDetector(
                onTap: () async {
                  Position position =
                      await LocationController.getGeoLocationPosition();
                  Get.to(() => MapAddressPicker(
                        lng: position.longitude,
                        lat: position.latitude,
                      ));
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Constant.bgColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14))),
                    margin: EdgeInsets.symmetric(horizontal: 65.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 13.h, horizontal: 30.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.gps_fixed,
                          color: Constant.white,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "Use current location",
                          style: TextStyle(
                              color: Constant.white,
                              fontWeight: FontWeight.w800),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              bottom: 50.h,
            )*/
          ],
        ),
      ),
    );
  }
}
