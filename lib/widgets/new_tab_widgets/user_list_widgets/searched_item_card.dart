import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:santhe/controllers/error_user_fallback.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import '../../../controllers/api_service_controller.dart';
import '../../../controllers/boxes_controller.dart';
import '../../../controllers/custom_image_controller.dart';
import '../../../firebase/firebase_helper.dart';
import '../../../models/santhe_item_model.dart';
import '../../../models/santhe_list_item_model.dart';
import '../../../models/santhe_user_list_model.dart';
import '../../../pages/new_tab_pages/image_page.dart';
import '../../../pages/new_tab_pages/user_list_page.dart';
import 'package:santhe/constants.dart';

class SearchedItemCard extends StatelessWidget {
  final String searchQuery;
  final Item item;
  final int currentUserListDBKey;
  final VoidCallback clearSearchQuery;
  const SearchedItemCard(
      {required this.searchQuery,
      required this.item,
      required this.currentUserListDBKey,
      required this.clearSearchQuery,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;

    //for quantity field validation
    final GlobalKey<FormState> _formKey = GlobalKey();

    final TextEditingController _qtyController =
        TextEditingController(text: '${item.dQuantity}');
    final TextEditingController _brandController = TextEditingController();
    final TextEditingController _notesController = TextEditingController();
    final _unitsController = GroupButtonController(
        selectedIndex: item.unit.indexWhere(
            (element) => element.toLowerCase() == item.dUnit.toLowerCase()));
    String selectedUnit = item.unit[item.unit.indexWhere(
        (element) => element.toLowerCase() == item.dUnit.toLowerCase())];

    print(item.dUnit);
    print(item.unit);

    final apiController = Get.find<APIs>();
    final imageController2 =
        Get.find<CustomImageController>().editItemCustomImageUrl.value = '';

    final TextStyle kLabelTextStyle = GoogleFonts.mulish(
        color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 15);

    final imageController = Get.find<CustomImageController>();

    String removeDecimalZeroFormat(double n) {
      return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    }

    UserList currentUserList =
        Boxes.getUserListDB().get(currentUserListDBKey) ??
            fallBack_error_userList;
    int custPhone = Boxes.getUserCredentialsDB()
            .get('currentUserCredentials')
            ?.phoneNumber ??
        404;

    final queryText = item.itemName.substring(0, searchQuery.length);
    final remainingText = item.itemName.substring(searchQuery.length);
    int buttonTapCount = 0;
    bool goAhead = true;

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
        child: GestureDetector(
          onTap: () {
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
                                    item.itemName,
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
                            const SizedBox(height: 10.0),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.ideographic,
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
                                                alignment: Alignment.centerLeft,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16.0),
                                                    bottomLeft:
                                                        const Radius.circular(
                                                            16.0),
                                                  ),
                                                  child: Container(
                                                    height: double.infinity,
                                                    width: 36.sp,
                                                    color: Colors.grey.shade200,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(16.0),
                                                    bottomRight:
                                                        Radius.circular(16.0),
                                                  ),
                                                  child: Container(
                                                    height: double.infinity,
                                                    width: 36.sp,
                                                    color: Colors.grey.shade200,
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
                                                controller: _qtyController,
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 6,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: GoogleFonts.mulish(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15.sp,
                                                ),
                                                onSaved: (value) {
                                                  _qtyController.text = value!;
                                                },
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  border: OutlineInputBorder(
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
                                                      if (_qtyController
                                                          .text.isEmpty) {
                                                        _qtyController.text =
                                                            0.toString();
                                                      }
                                                      double i = double.parse(
                                                          _qtyController.text);
                                                      if (i > 0) {
                                                        i--;
                                                        _qtyController.text =
                                                            removeDecimalZeroFormat(
                                                                i);
                                                      }
                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 5.0),
                                                      child: Icon(
                                                        CupertinoIcons.minus,
                                                        color:
                                                            Color(0xff8B8B8B),
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
                                                      if (_qtyController
                                                          .text.isEmpty) {
                                                        _qtyController.text =
                                                            0.toString();
                                                      }

                                                      double i = double.parse(
                                                          _qtyController.text);

                                                      i++;
                                                      _qtyController.text =
                                                          removeDecimalZeroFormat(
                                                              i);
                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0),
                                                      child: Icon(
                                                        CupertinoIcons.add,
                                                        color:
                                                            Color(0xff8B8B8B),
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
                                          child: GestureDetector(
                                            onTap: () {
                                              if (imageController
                                                      .editItemCustomImageUrl
                                                      .value
                                                      .isNotEmpty &&
                                                  imageController
                                                          .editItemCustomImageItemId
                                                          .value ==
                                                      item.itemId.toString()) {
                                                Get.to(
                                                    () => ImageViewerPage(
                                                          itemImageUrl:
                                                              imageController
                                                                  .editItemCustomImageUrl
                                                                  .value,
                                                          showCustomImage: true,
                                                        ),
                                                    transition:
                                                        Transition.fadeIn,
                                                    opaque: false);
                                              } else {
                                                print(
                                                    '${imageController.editItemCustomImageItemId.value} : Item->${item.itemId}');
                                                Get.to(
                                                    () => ImageViewerPage(
                                                        itemImageUrl:
                                                            item.itemImageId,
                                                        showCustomImage: false),
                                                    transition:
                                                        Transition.fadeIn,
                                                    opaque: false);
                                              }
                                            },
                                            child: Obx(
                                              () => Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: CachedNetworkImage(
                                                      imageUrl: imageController
                                                          .editItemCustomImageUrl
                                                          .value,
                                                      width: screenWidth * 25,
                                                      height: screenWidth * 25,
                                                      useOldImageOnUrlChange:
                                                          true,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                          url, error) {
                                                        print(error);
                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          child:
                                                              CachedNetworkImage(
                                                            width: screenWidth *
                                                                25,
                                                            height:
                                                                screenWidth *
                                                                    25,
                                                            useOldImageOnUrlChange:
                                                                true,
                                                            fit: BoxFit.cover,
                                                            imageUrl:
                                                                'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${item.itemImageId}',
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10,
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: imageController
                                                              .imageUploadProgress
                                                              .value
                                                              .isNotEmpty
                                                          ? double.parse(
                                                              imageController
                                                                  .imageUploadProgress
                                                                  .value)
                                                          : 0.0,
                                                      strokeWidth: 5.0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0.0,
                                          right: 6.0,
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
                                                          165, 241, 241, 241),
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return Container(
                                                      height: screenHeight * 24,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  28.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  28.0),
                                                        ),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade400,
                                                            blurRadius: 14.0,
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
                                                              style: GoogleFonts
                                                                  .mulish(
                                                                color: Colors
                                                                    .orange,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 24,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
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
                                                                          goAhead =
                                                                              false;
                                                                          Navigator.pop(
                                                                              context);
                                                                          String url = await FirebaseHelper().addCustomItemImage(
                                                                              '${DateTime.now().toUtc().toString().replaceAll(' ', 'T')}-${item.itemId}',
                                                                              true,
                                                                              false,
                                                                              false);
                                                                          url.isNotEmpty
                                                                              ? imageController.editItemCustomImageItemId.value = item.itemId.toString()
                                                                              : null;
                                                                          goAhead =
                                                                              true;
                                                                        },
                                                                        child:
                                                                            const CircleAvatar(
                                                                          radius:
                                                                              45,
                                                                          backgroundColor:
                                                                              Colors.grey,
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                43,
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            child:
                                                                                Icon(
                                                                              CupertinoIcons.camera_fill,
                                                                              color: Colors.orange,
                                                                              size: 45,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'Camera',
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          color:
                                                                              Colors.grey,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          goAhead =
                                                                              false;
                                                                          Navigator.pop(
                                                                              context);
                                                                          String url = await FirebaseHelper().addCustomItemImage(
                                                                              '${DateTime.now().toUtc().toString().replaceAll(' ', 'T')}-${item.itemId}',
                                                                              false,
                                                                              false,
                                                                              false);
                                                                          url.isNotEmpty
                                                                              ? imageController.editItemCustomImageItemId.value = item.itemId.toString()
                                                                              : null;
                                                                          goAhead =
                                                                              true;
                                                                        },
                                                                        child:
                                                                            const CircleAvatar(
                                                                          radius:
                                                                              45,
                                                                          backgroundColor:
                                                                              Colors.grey,
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                43,
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            child:
                                                                                Icon(
                                                                              CupertinoIcons.photo_fill_on_rectangle_fill,
                                                                              color: Colors.orange,
                                                                              size: 45,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'Gallery',
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          color:
                                                                              Colors.grey,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              16,
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
                                              CupertinoIcons.pencil_circle_fill,
                                              color: Colors.orange,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 7.sp,
                                    ),
                                    child: Text(
                                      'Unit',
                                      style: kLabelTextStyle,
                                    ),
                                  ),
                                  //UNIT SELECTOR
                                  GroupButton(
                                      options: GroupButtonOptions(
                                        //design
                                        unselectedBorderColor:
                                            Colors.grey.shade300,
                                        selectedBorderColor: Colors.orange,
                                        selectedShadow: [const BoxShadow()],
                                        unselectedShadow: [const BoxShadow()],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        selectedColor: Colors.orange,
                                        unselectedTextStyle: GoogleFonts.mulish(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp,
                                            color: const Color(0xff8B8B8B)),
                                        buttonWidth: 69.sp,
                                        buttonHeight: 50.sp,
                                        selectedTextStyle: GoogleFonts.mulish(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp,
                                            color: Colors.white),
                                      ),

                                      //function logic
                                      controller: _unitsController,
                                      buttons: item.unit,
                                      onSelected: (index, isSelected) {
                                        selectedUnit = item.unit[index];
                                      }),

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
                                                    color:
                                                        const Color(0xffFFBE74),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 13.sp))
                                          ]),
                                    ),
                                  ),
                                  //add widget

                                  //Brand/Type
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _brandController,
                                    maxLength: 45,
                                    // maxLines: 2,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: GoogleFonts.mulish(
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.sp,
                                    ),
                                    onSaved: (value) {
                                      _brandController.text = value!;
                                    },
                                    decoration: InputDecoration(
                                      counterStyle:
                                          TextStyle(color: Colors.grey),
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
                                      hintText: item.dBrandType,
                                      hintStyle: GoogleFonts.mulish(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15.sp,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey.shade500),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 21.sp,
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
                                                    color:
                                                        const Color(0xffFFBE74),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 13.sp))
                                          ]),
                                    ),
                                  ),

                                  //Notes
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _notesController,
                                    textAlignVertical: TextAlignVertical.center,
                                    maxLines: 3,
                                    maxLength: 90,
                                    style: GoogleFonts.mulish(
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.sp,
                                    ),
                                    onSaved: (value) {
                                      _notesController.text = value!;
                                    },
                                    decoration: InputDecoration(
                                      counterStyle:
                                          TextStyle(color: Colors.grey),
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
                                      hintText: item.dItemNotes,
                                      hintStyle: GoogleFonts.mulish(
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15.sp,
                                          color: Colors.grey.shade500),
                                    ),
                                  ),
                                  SizedBox(height: 30.sp),
                                  //-----------------ADD BUTTON---------------
                                  Center(
                                    child: SizedBox(
                                      width: screenWidth * 45,
                                      height: 50,
                                      child: MaterialButton(
                                        elevation: 0.0,
                                        highlightElevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        color: Colors.orange,
                                        onPressed: () async {
                                          final itemUnit =
                                              selectedUnit; //todo firebase and add custom image item
                                          print(
                                              '${_qtyController.text} $itemUnit');

                                          if (_formKey.currentState!
                                                  .validate() &&
                                              goAhead) {
                                            //--------------------------Creating List Item from Item and new data gathered from user------------------------
                                            //TODO add parameter validation
                                            if (imageController
                                                .editItemCustomImageUrl
                                                .value
                                                .isEmpty) {
                                              currentUserList.items
                                                  .add(ListItem(
                                                brandType:
                                                    _brandController.text,
                                                itemId: '${item.itemId}',
                                                itemImageId: item.itemImageId,
                                                status: item.status,
                                                itemName: item.itemName,
                                                quantity: double.parse(
                                                    _qtyController.text),
                                                notes: _notesController.text,
                                                unit: itemUnit,
                                                possibleUnits: item.unit,
                                                catName: Boxes.getCategoriesDB()
                                                        .get(int.parse(item
                                                            .catId
                                                            .replaceAll(
                                                                'projects/santhe-425a8/databases/(default)/documents/category/',
                                                                '')))
                                                        ?.catName ??
                                                    'Error',
                                                catId: int.parse(item.catId
                                                    .replaceAll(
                                                        'projects/santhe-425a8/databases/(default)/documents/category/',
                                                        '')),
                                              ));

                                              //make changes persistent
                                              currentUserList.save();
                                              print(
                                                  '#################################3');
                                              clearSearchQuery();
                                              Navigator.pop(context);
                                            } else {
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
                                                  '---------------${_qtyController.text} $itemUnit---------------');

                                              if (buttonTapCount == 0) {
                                                if (itemCount != 0) {
                                                  //todo add custom item to firebase
                                                  Item newCustomItem = Item(
                                                      dBrandType:
                                                          _brandController.text,
                                                      dItemNotes:
                                                          _notesController.text,
                                                      itemImageTn: imageController
                                                          .editItemCustomImageUrl
                                                          .value,
                                                      catId: '4000',
                                                      createUser: custPhone,
                                                      dQuantity: 1,
                                                      dUnit: selectedUnit,
                                                      itemAlias: item.itemName,
                                                      itemId: itemCount,
                                                      itemImageId: imageController
                                                          .editItemCustomImageUrl
                                                          .value,
                                                      itemName: item.itemName,
                                                      status: 'inactive',
                                                      unit: [selectedUnit],
                                                      updateUser: custPhone);

                                                  int response =
                                                      await apiController
                                                          .addItem(
                                                              newCustomItem);

                                                  if (response == 1) {
                                                    currentUserList.items
                                                        .add(ListItem(
                                                      brandType:
                                                          _brandController.text,
                                                      //item ref
                                                      itemId:
                                                          'projects/santhe-425a8/databases/(default)/documents/item/${itemCount}',
                                                      itemImageId: imageController
                                                          .editItemCustomImageUrl
                                                          .value,
                                                      status: 'inactive',
                                                      itemName: item.itemName,
                                                      quantity: double.parse(
                                                          _qtyController.text),
                                                      notes:
                                                          _notesController.text,
                                                      unit: itemUnit,
                                                      possibleUnits: item.unit,
                                                      catName: Boxes
                                                                  .getCategoriesDB()
                                                              .get(int.parse(item
                                                                  .catId
                                                                  .replaceAll(
                                                                      'projects/santhe-425a8/databases/(default)/documents/category/',
                                                                      '')))
                                                              ?.catName ??
                                                          'Error',
                                                      catId: 4000,
                                                    ));

                                                    //make changes persistent
                                                    if (buttonTapCount == 0) {
                                                      currentUserList.save();
                                                      clearSearchQuery();
                                                      Navigator.pop(context);
                                                      buttonTapCount++;
                                                    }

                                                    print(
                                                        'URL: ${imageController.addItemCustomImageUrl.value}');
                                                  } else {
                                                    // Get.snackbar(
                                                    //     'Network Error',
                                                    //     'Error Adding item to the list!',
                                                    //     backgroundColor:
                                                    //         Colors.white,
                                                    //     colorText: Colors.grey);
                                                  }
                                                } else {
                                                  //todo put internet error

                                                }
                                              }
                                            }
                                            // Navigator.pop(context);
                                          }
                                        },
                                        child: AutoSizeText(
                                          'Add',
                                          style: GoogleFonts.mulish(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
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
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${item.itemImageId}',
                          width: screenWidth * 15,
                          height: screenWidth * 15,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            print(error);
                            return Container(
                              color: Colors.orange,
                              width: screenWidth * 25,
                              height: screenWidth * 25,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              item.itemName,
                              style: GoogleFonts.mulish(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700),
                            ),
                            // RichText(
                            //   text: TextSpan(
                            //       text: queryText,
                            //       style: GoogleFonts.mulish(
                            //           fontSize: 14.0,
                            //           fontWeight: FontWeight.w700,
                            //           color: Colors.grey.shade700),
                            //       children: [
                            //         TextSpan(
                            //           text: remainingText,
                            //           style: GoogleFonts.mulish(
                            //               fontSize: 14.0,
                            //               color: Colors.grey.shade500),
                            //         )
                            //       ]),
                            // ),
                            Text(
                              Boxes.getCategoriesDB()
                                  .values
                                  .firstWhere((element) =>
                                      element.catId ==
                                      int.parse(item.catId.replaceAll(
                                          'projects/santhe-425a8/databases/(default)/documents/category/',
                                          '')))
                                  .catName,
                              style: GoogleFonts.mulish(
                                color: Colors.orange,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierColor:
                              const Color.fromARGB(165, 241, 241, 241),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //title: item name
                                      Stack(children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: AutoSizeText(
                                              item.itemName,
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
                                      const SizedBox(height: 10.0),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.ideographic,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      16.0),
                                                              bottomLeft:
                                                                  const Radius
                                                                          .circular(
                                                                      16.0),
                                                            ),
                                                            child: Container(
                                                              height: double
                                                                  .infinity,
                                                              width: 36.sp,
                                                              color: Colors.grey
                                                                  .shade200,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      16.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          16.0),
                                                            ),
                                                            child: Container(
                                                              height: double
                                                                  .infinity,
                                                              width: 36.sp,
                                                              color: Colors.grey
                                                                  .shade200,
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
                                                                double.parse(
                                                                        value)
                                                                    .isNegative ||
                                                                double.parse(
                                                                        value)
                                                                    .isInfinite) {
                                                              return 'Enter a valid quantity';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              _qtyController,
                                                          textAlign:
                                                              TextAlign.center,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          maxLength: 6,
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .center,
                                                          style: GoogleFonts
                                                              .mulish(
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 15.sp,
                                                          ),
                                                          onSaved: (value) {
                                                            _qtyController
                                                                .text = value!;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            counterText: '',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          kTextFieldCircularBorderRadius),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      width:
                                                                          1.0,
                                                                      color:
                                                                          kTextFieldGrey),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          kTextFieldCircularBorderRadius),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      width:
                                                                          1.0,
                                                                      color:
                                                                          kTextFieldGrey),
                                                            ),
                                                            prefix:
                                                                GestureDetector(
                                                              onTap: () {
                                                                WidgetsBinding
                                                                    .instance
                                                                    ?.focusManager
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                                if (_qtyController
                                                                    .text
                                                                    .isEmpty) {
                                                                  _qtyController
                                                                          .text =
                                                                      0.toString();
                                                                }
                                                                double i = double.parse(
                                                                    _qtyController
                                                                        .text);
                                                                if (i > 0) {
                                                                  i--;
                                                                  _qtyController
                                                                          .text =
                                                                      removeDecimalZeroFormat(
                                                                          i);
                                                                }
                                                              },
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            5.0),
                                                                child: Icon(
                                                                  CupertinoIcons
                                                                      .minus,
                                                                  color: Color(
                                                                      0xff8B8B8B),
                                                                  size: 15.0,
                                                                ),
                                                              ),
                                                            ),
                                                            suffix:
                                                                GestureDetector(
                                                              onTap: () {
                                                                WidgetsBinding
                                                                    .instance
                                                                    ?.focusManager
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                                if (_qtyController
                                                                    .text
                                                                    .isEmpty) {
                                                                  _qtyController
                                                                          .text =
                                                                      0.toString();
                                                                }

                                                                double i = double.parse(
                                                                    _qtyController
                                                                        .text);

                                                                i++;
                                                                _qtyController
                                                                        .text =
                                                                    removeDecimalZeroFormat(
                                                                        i);
                                                              },
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5.0),
                                                                child: Icon(
                                                                  CupertinoIcons
                                                                      .add,
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
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (imageController
                                                                .editItemCustomImageUrl
                                                                .value
                                                                .isNotEmpty &&
                                                            imageController
                                                                    .editItemCustomImageItemId
                                                                    .value ==
                                                                item.itemId
                                                                    .toString()) {
                                                          Get.to(
                                                              () =>
                                                                  ImageViewerPage(
                                                                    itemImageUrl:
                                                                        imageController
                                                                            .editItemCustomImageUrl
                                                                            .value,
                                                                    showCustomImage:
                                                                        true,
                                                                  ),
                                                              transition:
                                                                  Transition
                                                                      .fadeIn,
                                                              opaque: false);
                                                        } else {
                                                          print(
                                                              '${imageController.editItemCustomImageItemId.value} : Item->${item.itemId}');
                                                          Get.to(
                                                              () => ImageViewerPage(
                                                                  itemImageUrl: item
                                                                      .itemImageId,
                                                                  showCustomImage:
                                                                      false),
                                                              transition:
                                                                  Transition
                                                                      .fadeIn,
                                                              opaque: false);
                                                        }
                                                      },
                                                      child: Obx(
                                                        () => Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    imageController
                                                                        .editItemCustomImageUrl
                                                                        .value,
                                                                width:
                                                                    screenWidth *
                                                                        25,
                                                                height:
                                                                    screenWidth *
                                                                        25,
                                                                useOldImageOnUrlChange:
                                                                    true,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorWidget:
                                                                    (context,
                                                                        url,
                                                                        error) {
                                                                  print(error);
                                                                  return ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      width:
                                                                          screenWidth *
                                                                              25,
                                                                      height:
                                                                          screenWidth *
                                                                              25,
                                                                      useOldImageOnUrlChange:
                                                                          true,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      imageUrl:
                                                                          'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${item.itemImageId}',
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 10,
                                                              bottom: 10,
                                                              left: 10,
                                                              right: 10,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value: imageController
                                                                        .imageUploadProgress
                                                                        .value
                                                                        .isNotEmpty
                                                                    ? double.parse(
                                                                        imageController
                                                                            .imageUploadProgress
                                                                            .value)
                                                                    : 0.0,
                                                                strokeWidth:
                                                                    5.0,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0.0,
                                                    right: 6.0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            'upload custom image CTA triggered');
                                                        showModalBottomSheet<
                                                                void>(
                                                            backgroundColor: Colors
                                                                .transparent,
                                                            context: context,
                                                            barrierColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    165,
                                                                    241,
                                                                    241,
                                                                    241),
                                                            isScrollControlled:
                                                                true,
                                                            builder: (context) {
                                                              return Container(
                                                                height:
                                                                    screenHeight *
                                                                        24,
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
                                                                  color: Colors
                                                                      .white,
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
                                                                              .all(
                                                                          15.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'Add Custom Image',
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          color:
                                                                              Colors.orange,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          fontSize:
                                                                              24,
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 12.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    goAhead = false;
                                                                                    Navigator.pop(context);
                                                                                    String url = await FirebaseHelper().addCustomItemImage('${DateTime.now().toUtc().toString().replaceAll(' ', 'T')}-${item.itemId}', true, false, false);
                                                                                    url.isNotEmpty ? imageController.editItemCustomImageItemId.value = item.itemId.toString() : null;
                                                                                    goAhead = true;
                                                                                  },
                                                                                  child: const CircleAvatar(
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
                                                                                  style: GoogleFonts.mulish(
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
                                                                                  onTap: () async {
                                                                                    goAhead = false;
                                                                                    Navigator.pop(context);
                                                                                    String url = await FirebaseHelper().addCustomItemImage('${DateTime.now().toUtc().toString().replaceAll(' ', 'T')}-${item.itemId}', false, false, false);
                                                                                    url.isNotEmpty ? imageController.editItemCustomImageItemId.value = item.itemId.toString() : null;
                                                                                    goAhead = true;
                                                                                  },
                                                                                  child: const CircleAvatar(
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
                                                                                  style: GoogleFonts.mulish(
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
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 7.sp,
                                              ),
                                              child: Text(
                                                'Unit',
                                                style: kLabelTextStyle,
                                              ),
                                            ),
                                            //UNIT SELECTOR
                                            GroupButton(
                                                options: GroupButtonOptions(
                                                  //design
                                                  unselectedBorderColor:
                                                      Colors.grey.shade300,
                                                  selectedBorderColor:
                                                      Colors.orange,
                                                  selectedShadow: [
                                                    const BoxShadow()
                                                  ],
                                                  unselectedShadow: [
                                                    const BoxShadow()
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
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
                                                  selectedTextStyle:
                                                      GoogleFonts.mulish(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16.sp,
                                                          color: Colors.white),
                                                ),

                                                //function logic
                                                controller: _unitsController,
                                                buttons: item.unit,
                                                onSelected:
                                                    (index, isSelected) {
                                                  selectedUnit =
                                                      item.unit[index];
                                                }),

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
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 13.sp))
                                                    ]),
                                              ),
                                            ),
                                            //add widget

                                            //Brand/Type
                                            TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: _brandController,
                                              maxLength: 45,
                                              // maxLines: 2,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              style: GoogleFonts.mulish(
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15.sp,
                                              ),
                                              onSaved: (value) {
                                                _brandController.text = value!;
                                              },
                                              decoration: InputDecoration(
                                                counterStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          kTextFieldCircularBorderRadius),
                                                  borderSide: const BorderSide(
                                                      width: 1.0,
                                                      color: kTextFieldGrey),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          kTextFieldCircularBorderRadius),
                                                  borderSide: const BorderSide(
                                                      width: 1.0,
                                                      color: kTextFieldGrey),
                                                ),
                                                hintText: item.dBrandType,
                                                hintStyle: GoogleFonts.mulish(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 15.sp,
                                                    fontStyle: FontStyle.italic,
                                                    color:
                                                        Colors.grey.shade500),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 21.sp,
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
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 13.sp))
                                                    ]),
                                              ),
                                            ),

                                            //Notes
                                            TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: _notesController,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              maxLines: 3,
                                              maxLength: 90,
                                              style: GoogleFonts.mulish(
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15.sp,
                                              ),
                                              onSaved: (value) {
                                                _notesController.text = value!;
                                              },
                                              decoration: InputDecoration(
                                                counterStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          kTextFieldCircularBorderRadius),
                                                  borderSide: const BorderSide(
                                                      width: 1.0,
                                                      color: kTextFieldGrey),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          kTextFieldCircularBorderRadius),
                                                  borderSide: const BorderSide(
                                                      width: 1.0,
                                                      color: kTextFieldGrey),
                                                ),
                                                hintText: item.dItemNotes,
                                                hintStyle: GoogleFonts.mulish(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 15.sp,
                                                    color:
                                                        Colors.grey.shade500),
                                              ),
                                            ),
                                            SizedBox(height: 30.sp),
                                            //-----------------ADD BUTTON---------------
                                            Center(
                                              child: SizedBox(
                                                width: screenWidth * 45,
                                                height: 50,
                                                child: MaterialButton(
                                                  elevation: 0.0,
                                                  highlightElevation: 0.0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0)),
                                                  color: Colors.orange,
                                                  onPressed: () async {
                                                    final itemUnit =
                                                        selectedUnit; //todo firebase and add custom image item
                                                    print(
                                                        '${_qtyController.text} $itemUnit');

                                                    if (_formKey.currentState!
                                                            .validate() &&
                                                        goAhead) {
                                                      //--------------------------Creating List Item from Item and new data gathered from user------------------------
                                                      //TODO add parameter validation
                                                      if (imageController
                                                          .editItemCustomImageUrl
                                                          .value
                                                          .isEmpty) {
                                                        currentUserList.items
                                                            .add(ListItem(
                                                          status: item.status,
                                                          brandType:
                                                              _brandController
                                                                  .text,
                                                          itemId:
                                                              '${item.itemId}',
                                                          itemImageId:
                                                              item.itemImageId,
                                                          itemName:
                                                              item.itemName,
                                                          quantity:
                                                              double.parse(
                                                                  _qtyController
                                                                      .text),
                                                          notes:
                                                              _notesController
                                                                  .text,
                                                          unit: itemUnit,
                                                          possibleUnits:
                                                              item.unit,
                                                          catName: Boxes
                                                                      .getCategoriesDB()
                                                                  .get(int.parse(item
                                                                      .catId
                                                                      .replaceAll(
                                                                          'projects/santhe-425a8/databases/(default)/documents/category/',
                                                                          '')))
                                                                  ?.catName ??
                                                              'Error',
                                                          catId: int.parse(item
                                                              .catId
                                                              .replaceAll(
                                                                  'projects/santhe-425a8/databases/(default)/documents/category/',
                                                                  '')),
                                                        ));

                                                        //make changes persistent
                                                        currentUserList.save();
                                                        print(
                                                            '#################################3');
                                                        clearSearchQuery();
                                                        Navigator.pop(context);
                                                      } else {
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
                                                            '---------------${_qtyController.text} $itemUnit---------------');

                                                        if (buttonTapCount ==
                                                            0) {
                                                          if (itemCount != 0) {
                                                            //todo add custom item to firebase
                                                            Item newCustomItem = Item(
                                                                dBrandType:
                                                                    _brandController
                                                                        .text,
                                                                dItemNotes:
                                                                    _notesController
                                                                        .text,
                                                                itemImageTn:
                                                                    imageController
                                                                        .editItemCustomImageUrl
                                                                        .value,
                                                                catId: '4000',
                                                                createUser:
                                                                    custPhone,
                                                                dQuantity: 1,
                                                                dUnit:
                                                                    selectedUnit,
                                                                itemAlias: item
                                                                    .itemName,
                                                                itemId:
                                                                    itemCount,
                                                                itemImageId:
                                                                    imageController
                                                                        .editItemCustomImageUrl
                                                                        .value,
                                                                itemName: item
                                                                    .itemName,
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
                                                              currentUserList
                                                                  .items
                                                                  .add(ListItem(
                                                                brandType:
                                                                    _brandController
                                                                        .text,
                                                                //item ref
                                                                itemId:
                                                                    'projects/santhe-425a8/databases/(default)/documents/item/${itemCount}',
                                                                itemImageId:
                                                                    imageController
                                                                        .editItemCustomImageUrl
                                                                        .value,
                                                                status: 'inactive',
                                                                itemName: item
                                                                    .itemName,
                                                                quantity: double.parse(
                                                                    _qtyController
                                                                        .text),
                                                                notes:
                                                                    _notesController
                                                                        .text,
                                                                unit: itemUnit,
                                                                possibleUnits:
                                                                    item.unit,
                                                                catName: Boxes
                                                                            .getCategoriesDB()
                                                                        .get(int.parse(item.catId.replaceAll(
                                                                            'projects/santhe-425a8/databases/(default)/documents/category/',
                                                                            '')))
                                                                        ?.catName ??
                                                                    'Error',
                                                                catId: 4000,
                                                              ));

                                                              //make changes persistent
                                                              if (buttonTapCount ==
                                                                  0) {
                                                                currentUserList
                                                                    .save();
                                                                clearSearchQuery();
                                                                Navigator.pop(
                                                                    context);
                                                                buttonTapCount++;
                                                              }

                                                              print(
                                                                  'URL: ${imageController.addItemCustomImageUrl.value}');
                                                            } else {
                                                              // Get.snackbar(
                                                              //     'Network Error',
                                                              //     'Error Adding item to the list!',
                                                              //     backgroundColor:
                                                              //         Colors.white,
                                                              //     colorText: Colors.grey);
                                                            }
                                                          } else {
                                                            //todo put internet error

                                                          }
                                                        }
                                                      }
                                                      // Navigator.pop(context);
                                                    }
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
          ),
        ));
  }
}
