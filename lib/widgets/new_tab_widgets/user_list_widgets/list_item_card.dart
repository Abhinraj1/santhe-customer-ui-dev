import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:santhe/models/santhe_item_model.dart';
import '../../../controllers/api_service_controller.dart';
import 'package:santhe/models/santhe_list_item_model.dart';
import '../../../controllers/boxes_controller.dart';
import '../../../controllers/custom_image_controller.dart';
import '../../../controllers/error_user_fallback.dart';
import '../../../firebase/firebase_helper.dart';
import '../../../models/santhe_user_list_model.dart';
import '../../../pages/new_tab_pages/image_page.dart';
import 'package:santhe/constants.dart';

class ListItemCard extends StatelessWidget {
  final ListItem listItem;
  final int currentUserListDBKey;
  const ListItemCard(
      {required this.listItem, required this.currentUserListDBKey, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var apiController = Get.find<APIs>();
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    //for quantity field validation
    final GlobalKey<FormState> _formKey = GlobalKey();
    final imageController = Get.find<CustomImageController>();
    String removeDecimalZeroFormat(double n) {
      return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    }

    final TextEditingController _qtyController = TextEditingController(
        text: removeDecimalZeroFormat(listItem.quantity));
    final TextEditingController _brandController =
        TextEditingController(text: listItem.brandType);
    final TextEditingController _notesController =
        TextEditingController(text: listItem.notes);

    final int unitIndex = listItem.possibleUnits
        .indexWhere((element) => element == listItem.unit);
    final _unitsController = GroupButtonController(selectedIndex: unitIndex);


    String selectedUnit = listItem.unit;

    UserList currentUserList = Boxes.getUserListDB().get(currentUserListDBKey) ?? fallBack_error_userList;

    const TextStyle kLabelTextStyle = TextStyle(color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 15);

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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: int.parse(listItem.itemId.replaceAll('projects/santhe-425a8/databases/(default)/documents/item/', '')) < 4000
                          ? 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${listItem.itemImageId}'
                          : listItem.itemImageId,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        print(error);
                        return Container(
                          color: Colors.orange,
                          width: screenWidth * 50,
                          height: screenWidth * 50,
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
                      children: [
                        Text(listItem.itemName),
                        listItem.brandType.isEmpty
                            ? Text(
                                listItem.notes.isEmpty
                                    ? '${removeDecimalZeroFormat(listItem.quantity)} ${listItem.unit}'
                                    : '${removeDecimalZeroFormat(listItem.quantity)} ${listItem.unit},\n${listItem.notes}',
                                // softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16.sp,
                                ),
                              )
                            : Text(
                                '''${removeDecimalZeroFormat(listItem.quantity)} ${listItem.unit}, ${listItem.notes.isEmpty ? '${listItem.brandType}' : '${listItem.brandType},\n${listItem.notes}'}''',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 14.sp,
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierColor:
                              const Color.fromARGB(165, 241, 241, 241),
                          builder: (context) {
                            ScreenUtil.init(
                                BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width,
                                    maxHeight:
                                        MediaQuery.of(context).size.height),
                                designSize: const Size(390, 844),
                                context: context,
                                minTextAdapt: true,
                                orientation: Orientation.portrait);
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
                                              listItem.itemName,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
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
                                                      child: const Text(
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
                                                                  color: Colors
                                                                      .orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      16.0),
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
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                              () => ImageViewerPage(
                                                                  itemImageUrl: listItem
                                                                      .itemImageId
                                                                      .replaceFirst(
                                                                          'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/',
                                                                          ''),
                                                                  showCustomImage:
                                                                      false),
                                                              transition:
                                                                  Transition
                                                                      .fadeIn,
                                                              opaque: false);
                                                          // showOverlay(context);
                                                        },
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: int.parse(listItem
                                                                      .itemId
                                                                      .replaceAll(
                                                                          'projects/santhe-425a8/databases/(default)/documents/item/',
                                                                          '')) <
                                                                  4000
                                                              ? 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${listItem.itemImageId}'
                                                              : listItem
                                                                  .itemImageId,
                                                          width:
                                                              screenWidth * 25,
                                                          height:
                                                              screenWidth * 25,
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context,
                                                              url, error) {
                                                            print(error);
                                                            return Container(
                                                              color:
                                                                  Colors.orange,
                                                              width:
                                                                  screenWidth *
                                                                      25,
                                                              height:
                                                                  screenWidth *
                                                                      25,
                                                            );
                                                          },
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
                                                                                    Navigator.pop(context);
                                                                                    await FirebaseHelper().addCustomItemImage('${DateTime.now().toUtc().toString().replaceAll(' ', 'T')}-${listItem.itemId}', true, false);
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
                                                                                const Text(
                                                                                  'Camera',
                                                                                  style: TextStyle(
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
                                                                                    Navigator.pop(context);
                                                                                    await FirebaseHelper().addCustomItemImage('${DateTime.now().toUtc().toString().replaceAll(' ', 'T')}-${listItem.itemId}', false, false);
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
                                                                                const Text(
                                                                                  'Gallery',
                                                                                  style: TextStyle(
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
                                                      //todo fix image edit
                                                      child: const Visibility(
                                                        visible: false,
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .pencil_circle_fill,
                                                          color: Colors.orange,
                                                          size: 24.0,
                                                        ),
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
                                              child: const Text(
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
                                                    BorderRadius.circular(10.0),
                                                selectedColor: Colors.orange,
                                                unselectedTextStyle:
                                                    TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16.sp,
                                                        color: const Color(
                                                            0xff8B8B8B)),
                                                buttonWidth: 69.sp,
                                                buttonHeight: 50.sp,
                                                selectedTextStyle:
                                                    TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16.sp,
                                                        color: Colors.white),
                                              ),

                                              //function logic
                                              controller: _unitsController,
                                              buttons: listItem.possibleUnits,
                                              onSelected: (index, isSelected) {
                                                selectedUnit = listItem
                                                    .possibleUnits[index];
                                                print(
                                                    'Unit Selected: $selectedUnit');
                                              },
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
                                                          style: TextStyle(
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
                                              style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0),
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
                                                hintText:
                                                    'Your product type, brand or size goes here',
                                                hintStyle: TextStyle(
                                                    fontWeight: FontWeight.w300,
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
                                                          style: TextStyle(
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
                                              style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0),
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
                                                hintText:
                                                    'Mention type of package, number of packs, number of items in a pack etc here',
                                                hintStyle: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.italic,
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

                                                    if (_formKey.currentState!.validate()) {
                                                      //--------------------------Creating List Item from Item and new data gathered from user------------------------
                                                      //TODO add parameter validation

                                                      //making a copy of current list item
                                                      ListItem currentListItem = listItem;

                                                      //delete item
                                                      currentUserList.items.remove(listItem);

                                                      //add new updated item
                                                      currentUserList.items.add(ListItem(
                                                        brandType:
                                                            _brandController
                                                                .text,
                                                        catName:
                                                            listItem.catName,
                                                        itemId:
                                                            '${listItem.itemId}',
                                                        itemImageId:
                                                            currentListItem
                                                                .itemImageId,
                                                        itemName:
                                                            currentListItem
                                                                .itemName,
                                                        quantity: double.parse(
                                                            _qtyController
                                                                .text),
                                                        notes: _notesController
                                                            .text,
                                                        unit: selectedUnit,
                                                        catId: listItem.catId,
                                                        possibleUnits: listItem
                                                            .possibleUnits,
                                                      ));

                                                      //make changes persistent
                                                      Boxes.getUserListDB().put(currentUserListDBKey, currentUserList);

                                                      Get.back();
                                                    } else {
                                                      Get.snackbar(
                                                        'Enter Quantity',
                                                        'Please enter some quantity before adding to list...',
                                                        snackPosition:
                                                            SnackPosition.TOP,
                                                        backgroundColor:
                                                            Colors.white,
                                                        colorText: Colors.grey,
                                                      );
                                                    }
                                                  },
                                                  child: AutoSizeText(
                                                    'dfacn,',
                                                    style: TextStyle(
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
                    splashRadius: 0.1,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    )),
                IconButton(
                    onPressed: () {
                      //TODO implement delete feature

                      //deleting item
                      currentUserList.items.remove(listItem);

                      //make changes persistent
                      currentUserList.save();
                    },
                    icon: const Icon(Icons.delete_forever_outlined,
                        color: Colors.orange)),
              ],
            ),
          ],
        ));
  }
}
