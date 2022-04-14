import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/controllers/custom_image_controller.dart';
import 'package:santhe/models/santhe_item_model.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';

import '../../../controllers/api_service_controller.dart';
import '../../../controllers/boxes_controller.dart';
import '../../../firebase/firebase_helper.dart';
import '../../../models/santhe_list_item_model.dart';

class AddCustomItemCard extends StatefulWidget {
  final int currentUserListDBKey;
  final String searchQuery;
  final VoidCallback clearSearchQuery;
  const AddCustomItemCard(
      {required this.currentUserListDBKey,
      required this.searchQuery,
      required this.clearSearchQuery,
      Key? key})
      : super(key: key);

  @override
  State<AddCustomItemCard> createState() => _AddCustomItemCardState();
}

class _AddCustomItemCardState extends State<AddCustomItemCard> {
  //for quantity field validation
  final GlobalKey<FormState> _formKey = GlobalKey();

  // final TextEditingController _customerCategoryNameController =
  //     TextEditingController();
  final TextEditingController _customQtyController =
      TextEditingController(text: '1');
  final TextEditingController _customBrandController = TextEditingController();
  final TextEditingController _customNotesController = TextEditingController();
  final _unitsController = GroupButtonController(selectedIndex: 0);
  List<String> availableUnits = ['Kg', 'gms', 'L', 'ml', 'pack/s', 'Piece/s'];
  int buttonTapCount = 0;

  int customItemId = 4000;

  final TextStyle kLabelTextStyle = GoogleFonts.mulish(
      color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 15);

  //todo add login check
  int custPhone =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;
  bool isProcessing = false;
  final imageController = Get.find<CustomImageController>()
      .addItemCustomImageUrl
      .value = 'https://i.imgur.com/XcM6VIv.png';

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    final int currentUserListDBKey = widget.currentUserListDBKey;
    final String searchQuery = widget.searchQuery;

    final imageController = Get.find<CustomImageController>();
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    final apiController = Get.find<APIs>();
    final TextEditingController _customItemNameController =
        TextEditingController(text: searchQuery);
    String selectedUnit = availableUnits[0];

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth * 15,
                height: screenWidth * 15,
                child: const Icon(
                  CupertinoIcons.news,
                  color: Colors.orange,
                  size: 40.0,
                ),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(searchQuery,
                      style: GoogleFonts.mulish(
                          color: const Color(0xff8B8B8B),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0)),
                  Text(
                    'Add a custom item',
                    style: GoogleFonts.mulish(
                        color: Colors.orange,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                //todo implement add to user list on firebase

                showDialog(
                    context: context,
                    barrierColor: const Color.fromARGB(165, 241, 241, 241),
                    builder: (context) {
                      return Dialog(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          // padding: const EdgeInsets.all(1.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //title: item name
                                Stack(children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: AutoSizeText(
                                        'Custom Item',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.mulish(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w700,
                                            fontSize: screenWidth * 6),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Color(0xffD1D1D1),
                                      ),
                                      splashRadius: 0.1,
                                      splashColor: Colors.transparent,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ]),
                                // const SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //name text field
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 7.sp,
                                          // top: 21.sp,
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                              text: 'Name',
                                              style: kLabelTextStyle,
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: ' *',
                                                    style: GoogleFonts.mulish(
                                                        color: Colors.orange,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 13.sp))
                                              ]),
                                        ),
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: _customItemNameController,
                                        maxLength: 30,
                                        // maxLines: 2,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: GoogleFonts.mulish(
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                        ),
                                        onSaved: (value) {
                                          _customItemNameController.text =
                                              value!;
                                        },
                                        decoration: InputDecoration(
                                          counterStyle:
                                              TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                kTextFieldCircularBorderRadius),
                                            borderSide: const BorderSide(
                                                width: 1.0,
                                                color: kTextFieldGrey),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                kTextFieldCircularBorderRadius),
                                            borderSide: const BorderSide(
                                                width: 1.0,
                                                color: kTextFieldGrey),
                                          ),
                                          hintText:
                                              'Enter product name here...',
                                          hintStyle: GoogleFonts.mulish(
                                              fontWeight: FontWeight.w300,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 15.sp,
                                              color: Colors.grey.shade500),
                                        ),
                                      ),

                                      //Category text field
                                      // Padding(
                                      //   padding: EdgeInsets.only(
                                      //     bottom: 7.sp,
                                      //     top: 21.sp,
                                      //   ),
                                      //   child: RichText(
                                      //     text: TextSpan(
                                      //         text: 'Category *',
                                      //         style: kLabelTextStyle,
                                      //         children: <TextSpan>[
                                      //           TextSpan(
                                      //               text: '',
                                      //               style: GoogleFonts.mulish(
                                      //                   color: const Color(
                                      //                       0xffFFBE74),
                                      //                   fontWeight:
                                      //                       FontWeight.w300,
                                      //                   fontSize: 13.sp))
                                      //         ]),
                                      //   ),
                                      // ),
                                      // TextFormField(
                                      //   keyboardType: TextInputType.text,
                                      //   controller:
                                      //       _customerCategoryNameController,
                                      //   textAlignVertical:
                                      //       TextAlignVertical.center,
                                      //   style: GoogleFonts.mulish(
                                      //       color: Colors.grey.shade500,
                                      //       fontWeight: FontWeight.w400,
                                      //       fontSize: 16.0),
                                      //   onSaved: (value) {
                                      //     _customerCategoryNameController.text =
                                      //         value!;
                                      //   },
                                      //   decoration: InputDecoration(
                                      //     border: OutlineInputBorder(
                                      //                                                           borderRadius:
                                      //                                                               BorderRadius
                                      //                                                                   .circular(
                                      //                                                                       16.0),
                                      //                                                           borderSide: BorderSide(
                                      //                                                               color: Colors.grey
                                      //                                                                   .shade200)),
                                      //                                                       enabledBorder:
                                      //                                                           OutlineInputBorder(
                                      //                                                               borderRadius:
                                      //                                                                   BorderRadius
                                      //                                                                       .circular(
                                      //                                                                           16.0),
                                      //                                                               borderSide: BorderSide(
                                      //                                                                   width: 2.0,
                                      //                                                                   color: Colors
                                      //                                                                       .grey
                                      //                                                                       .shade200)),
                                      //     hintText:
                                      //         'Enter category name here...',
                                      //     hintStyle: GoogleFonts.mulish(
                                      //         fontWeight: FontWeight.w300,
                                      //         fontStyle: FontStyle.italic,
                                      //         color: Colors.grey.shade500),
                                      //   ),
                                      // ),

                                      //Quantity Row
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //Quantity text field
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 7.sp,
                                                ),
                                                child: Text(
                                                  'Quantity',
                                                  style: kLabelTextStyle,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 128.sp,
                                                height: 60.sp,
                                                //Quantity
                                                child: Stack(children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                16.0),
                                                        bottomLeft: const Radius
                                                            .circular(16.0),
                                                      ),
                                                      child: Container(
                                                        height: double.infinity,
                                                        width: 36.sp,
                                                        color: Colors
                                                            .grey.shade200,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(
                                                                16.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                16.0),
                                                      ),
                                                      child: Container(
                                                        height: double.infinity,
                                                        width: 36.sp,
                                                        color: Colors
                                                            .grey.shade200,
                                                      ),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter quantity';
                                                      } else if (double.parse(
                                                                  value) ==
                                                              0 ||
                                                          double.parse(value)
                                                              .isNegative ||
                                                          double.parse(value)
                                                              .isInfinite) {
                                                        return 'Enter a valid quantity';
                                                      }
                                                      return null;
                                                    },
                                                    controller:
                                                        _customQtyController,
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 6,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    style: GoogleFonts.mulish(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15.sp,
                                                    ),
                                                    onSaved: (value) {
                                                      _customQtyController
                                                          .text = value!;
                                                    },
                                                    decoration: InputDecoration(
                                                      counterText: '',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                kTextFieldCircularBorderRadius),
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 1.0,
                                                                color:
                                                                    kTextFieldGrey),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                kTextFieldCircularBorderRadius),
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 1.0,
                                                                color:
                                                                    kTextFieldGrey),
                                                      ),
                                                      prefix: GestureDetector(
                                                        onTap: () {
                                                          WidgetsBinding
                                                              .instance
                                                              ?.focusManager
                                                              .primaryFocus
                                                              ?.unfocus();
                                                          if (_customQtyController
                                                              .text.isEmpty) {
                                                            _customQtyController
                                                                    .text =
                                                                0.toString();
                                                          }
                                                          double i = double.parse(
                                                              _customQtyController
                                                                  .text);
                                                          if (i > 0) {
                                                            i--;
                                                            _customQtyController
                                                                    .text =
                                                                removeDecimalZeroFormat(
                                                                    i);
                                                          }
                                                        },
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 5.0),
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .minus,
                                                            color: Color(
                                                                0xff8B8B8B),
                                                            size: 15.0,
                                                          ),
                                                        ),
                                                      ),
                                                      suffix: GestureDetector(
                                                        onTap: () {
                                                          WidgetsBinding
                                                              .instance
                                                              ?.focusManager
                                                              .primaryFocus
                                                              ?.unfocus();
                                                          if (_customQtyController
                                                              .text.isEmpty) {
                                                            _customQtyController
                                                                    .text =
                                                                0.toString();
                                                          }

                                                          double i = double.parse(
                                                              _customQtyController
                                                                  .text);

                                                          i++;
                                                          _customQtyController
                                                                  .text =
                                                              removeDecimalZeroFormat(
                                                                  i);
                                                        },
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0),
                                                          child: Icon(
                                                            CupertinoIcons.add,
                                                            color: Color(
                                                                0xff8B8B8B),
                                                            size: 15.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ],
                                          ),
                                          Stack(children: [
                                            Container(
                                              color: Colors.transparent,
                                              height: screenWidth * 30,
                                              width: screenWidth * 30,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8.sp,
                                                  left: 8.sp,
                                                  right: 8.sp),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Obx(
                                                  () => CachedNetworkImage(
                                                    imageUrl: imageController
                                                            .addItemCustomImageUrl
                                                            .isEmpty
                                                        ? 'https://i.imgur.com/XcM6VIv.png'
                                                        : imageController
                                                            .addItemCustomImageUrl
                                                            .value,
                                                    width: screenWidth * 25,
                                                    height: screenWidth * 25,
                                                    useOldImageOnUrlChange:
                                                        true,
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, url, error) {
                                                      print(error);
                                                      return Container(
                                                        color: Colors.red,
                                                        width: screenWidth * 25,
                                                        height:
                                                            screenWidth * 25,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              //EDIT ICON IMAGE ADD NEW IMAGE
                                              top: 0.0,
                                              right: 10.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  print(
                                                      'upload custom image CTA triggered');
                                                  showModalBottomSheet<void>(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      context: context,
                                                      barrierColor:
                                                          const Color.fromARGB(
                                                              165,
                                                              241,
                                                              241,
                                                              241),
                                                      isScrollControlled: true,
                                                      builder: (context) {
                                                        return Container(
                                                          height:
                                                              screenHeight * 24,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      28.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      28.0),
                                                            ),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                blurRadius:
                                                                    14.0,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Add Custom Image',
                                                                  style:
                                                                      GoogleFonts
                                                                          .mulish(
                                                                    color: Colors
                                                                        .orange,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        24,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          12.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              await FirebaseHelper().addCustomItemImage(DateTime.now().toUtc().toString().replaceAll(' ', 'T'), true, true, false).toString();
                                                                            },
                                                                            child:
                                                                                const CircleAvatar(
                                                                              radius: 45,
                                                                              backgroundColor: Colors.grey,
                                                                              child: CircleAvatar(
                                                                                radius: 43,
                                                                                backgroundColor: Colors.white,
                                                                                child: Icon(
                                                                                  CupertinoIcons.camera_fill,
                                                                                  color: Colors.orange,
                                                                                  size: 45,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Camera',
                                                                            style:
                                                                                GoogleFonts.mulish(
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              //todo same as above
                                                                              Navigator.pop(context);
                                                                              await FirebaseHelper().addCustomItemImage('${DateTime.now().toUtc().toString().replaceAll(' ', 'T')}', false, true, false).toString();
                                                                            },
                                                                            child:
                                                                                const CircleAvatar(
                                                                              radius: 45,
                                                                              backgroundColor: Colors.grey,
                                                                              child: CircleAvatar(
                                                                                radius: 43,
                                                                                backgroundColor: Colors.white,
                                                                                child: Icon(
                                                                                  CupertinoIcons.photo_fill_on_rectangle_fill,
                                                                                  color: Colors.orange,
                                                                                  size: 45,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Gallery',
                                                                            style:
                                                                                GoogleFonts.mulish(
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: const Icon(
                                                  CupertinoIcons
                                                      .pencil_circle_fill,
                                                  color: Colors.orange,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),

                                      //unit text field
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 7.sp,
                                        ),
                                        child: Text('Unit',
                                            style: kLabelTextStyle),
                                      ),

                                      //UNIT SELECTOR
                                      SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: GroupButton(
                                            options: GroupButtonOptions(
                                              //design
                                              unselectedBorderColor:
                                                  Colors.grey.shade300,
                                              selectedBorderColor:
                                                  Colors.orange,

                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              selectedColor: Colors.orange,
                                              unselectedTextStyle:
                                                  GoogleFonts.mulish(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.sp,
                                                      color: const Color(
                                                          0xff8B8B8B)),
                                              buttonWidth: 69.sp,
                                              buttonHeight: 50.sp,
                                              selectedShadow: [
                                                const BoxShadow()
                                              ],
                                              unselectedShadow: [
                                                const BoxShadow()
                                              ],
                                              selectedTextStyle:
                                                  GoogleFonts.mulish(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.sp,
                                                      color: Colors.white),
                                            ),

                                            //function logic
                                            controller: _unitsController,
                                            buttons: availableUnits,
                                            onSelected: (index, isSelected) {
                                              selectedUnit =
                                                  availableUnits[index];
                                            }),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 7.sp,
                                          top: 21.sp,
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                              text: 'Brand/Type/Size',
                                              style: kLabelTextStyle,
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: ' (optional)',
                                                    style: GoogleFonts.mulish(
                                                        color: const Color(
                                                            0xffFFBE74),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 13.sp))
                                              ]),
                                        ),
                                      ),
                                      //add widget

                                      //Brand/Type
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: _customBrandController,
                                        maxLength: 45,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: GoogleFonts.mulish(
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                        ),
                                        onSaved: (value) {
                                          _customBrandController.text = value!;
                                        },
                                        decoration: InputDecoration(
                                          counterStyle:
                                              TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                kTextFieldCircularBorderRadius),
                                            borderSide: const BorderSide(
                                                width: 1.0,
                                                color: kTextFieldGrey),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                kTextFieldCircularBorderRadius),
                                            borderSide: const BorderSide(
                                                width: 1.0,
                                                color: kTextFieldGrey),
                                          ),
                                          hintText:
                                              'You can mention brand, type or size of the item here',
                                          hintStyle: GoogleFonts.mulish(
                                              fontWeight: FontWeight.w300,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14.sp,
                                              color: Colors.grey.shade500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 7.sp,
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                              text: 'Note',
                                              style: kLabelTextStyle,
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: ' (optional)',
                                                    style: GoogleFonts.mulish(
                                                        color: const Color(
                                                            0xffFFBE74),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 13.sp))
                                              ]),
                                        ),
                                      ),

                                      //Notes
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: _customNotesController,
                                        maxLength: 90,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        maxLines: 3,
                                        style: GoogleFonts.mulish(
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                        ),
                                        onSaved: (value) {
                                          _customNotesController.text = value!;
                                        },
                                        decoration: InputDecoration(
                                          counterStyle:
                                              TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                kTextFieldCircularBorderRadius),
                                            borderSide: const BorderSide(
                                                width: 1.0,
                                                color: kTextFieldGrey),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                kTextFieldCircularBorderRadius),
                                            borderSide: const BorderSide(
                                                width: 1.0,
                                                color: kTextFieldGrey),
                                          ),
                                          hintText:
                                              'Any additional information like the number of items in a pack, type of package, ingredient choice etc goes here ',
                                          hintStyle: GoogleFonts.mulish(
                                              fontWeight: FontWeight.w300,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14.sp,
                                              color: Colors.grey.shade500),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      //-----------------ADD BUTTON---------------
                                      Center(
                                        child: SizedBox(
                                          width: screenWidth * 45,
                                          height: 50,
                                          child: isProcessing
                                              ? const CircularProgressIndicator()
                                              : MaterialButton(
                                                  elevation: 0.0,
                                                  highlightElevation: 0.0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0)),
                                                  color: Colors.orange,
                                                  onPressed: () async {
                                                    //todo add list item to user list on firebase
                                                    final itemUnit =
                                                        selectedUnit;

                                                    setState(() {
                                                      isProcessing = true;
                                                    });

                                                    if (_formKey.currentState!
                                                            .validate() &&
                                                        itemUnit.isNotEmpty &&
                                                        _customItemNameController
                                                            .text.isNotEmpty) {
                                                      int itemCount =
                                                          await apiController
                                                              .getItemsCount();

                                                      print(
                                                          '>>>>>>>>>>>>ITEM COUNT: $itemCount');
                                                      print(
                                                          '>>>>>>>>>>>>OFFLINE COUNT: ${apiController.itemsDB.length}');
                                                      //--------------------------Creating List Item from Item and new data gathered from user------------------------
                                                      //TODO add parameter validation

                                                      print(
                                                          '---------------${_customQtyController.text} $itemUnit---------------');

                                                      if (buttonTapCount == 0) {
                                                        if (itemCount != 0) {
                                                          //todo add custom item to firebase
                                                          Item newCustomItem = Item(
                                                              dBrandType:
                                                                  _customBrandController
                                                                      .text,
                                                              dItemNotes:
                                                                  _customNotesController
                                                                      .text,
                                                              itemImageTn: imageController
                                                                  .addItemCustomImageUrl
                                                                  .value,
                                                              catId: '4000',
                                                              createUser:
                                                                  custPhone,
                                                              dQuantity: 1,
                                                              dUnit:
                                                                  selectedUnit,
                                                              itemAlias:
                                                                  _customItemNameController
                                                                      .text,
                                                              itemId: itemCount,
                                                              itemImageId:
                                                                  imageController
                                                                      .addItemCustomImageUrl
                                                                      .value,
                                                              itemName:
                                                                  _customItemNameController
                                                                      .text,
                                                              status:
                                                                  'inactive',
                                                              unit: [
                                                                selectedUnit
                                                              ],
                                                              updateUser:
                                                                  custPhone);

                                                          int response =
                                                              await apiController
                                                                  .addItem(
                                                                      newCustomItem);

                                                          if (response == 1) {
                                                            final box = Boxes
                                                                .getUserListDB();
                                                            //adding item to user list
                                                            box
                                                                .get(
                                                                    currentUserListDBKey)
                                                                ?.items
                                                                .add(ListItem(
                                                                  brandType:
                                                                      _customBrandController
                                                                          .text,
                                                                  //item ref
                                                                  itemId:
                                                                      '$itemCount',
                                                                  itemImageId:
                                                                      imageController
                                                                          .addItemCustomImageUrl
                                                                          .value,
                                                                  status:
                                                                      'inactive',
                                                                  //todo make it work
                                                                  itemName:
                                                                      _customItemNameController
                                                                          .text,
                                                                  quantity: double.parse(
                                                                      _customQtyController
                                                                          .text),
                                                                  notes:
                                                                      _customNotesController
                                                                          .text,
                                                                  unit:
                                                                      itemUnit,
                                                                  possibleUnits:
                                                                      availableUnits,
                                                                  catName:
                                                                      'Others',
                                                                  catId: 4000,
                                                                ));

                                                            //make changes persistent
                                                            box
                                                                .get(
                                                                    currentUserListDBKey)
                                                                ?.save();
                                                            print(
                                                                'URL: ${imageController.addItemCustomImageUrl.value}');
                                                            buttonTapCount++;
                                                            //clear search field

                                                            if (mounted) {
                                                              widget
                                                                  .clearSearchQuery();
                                                            }

                                                            Navigator.pop(
                                                                context);
                                                          } else {
                                                            print(
                                                                'Error, action not completed!');
                                                          }
                                                        } else {
                                                          errorMsg(
                                                              'Please fill all required values',
                                                              'Please enter all the values for required');
                                                        }
                                                      }
                                                    }

                                                    setState(() {
                                                      isProcessing = false;
                                                    });
                                                  },
                                                  child: AutoSizeText(
                                                    'Add',
                                                    style: GoogleFonts.mulish(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: screenWidth * 5,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.add,
                color: Colors.orange,
              )),
        ],
      ),
    );
  }
}
