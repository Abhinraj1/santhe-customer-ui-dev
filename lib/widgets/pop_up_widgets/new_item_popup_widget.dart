import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:resize/resize.dart';
import 'package:santhe/core/app_helpers.dart';

import '../../constants.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import '../../controllers/custom_image_controller.dart';
import '../../controllers/error_user_fallback.dart';
import '../../firebase/firebase_helper.dart';
import '../../models/santhe_item_model.dart';
import '../../models/santhe_list_item_model.dart';
import '../../models/santhe_user_list_model.dart';
import '../../pages/new_tab_pages/image_page.dart';

class NewItemPopUpWidget extends StatefulWidget {
  final Item item;
  final int currentUserListDBKey;
  final bool edit;
  final bool? fromSearch;

  const NewItemPopUpWidget(
      {Key? key,
      required this.item,
      required this.currentUserListDBKey,
      this.edit = false, this.fromSearch})
      : super(key: key);

  @override
  State<NewItemPopUpWidget> createState() => _NewItemPopUpWidgetState();
}

class _NewItemPopUpWidgetState extends State<NewItemPopUpWidget> {
  bool packQuantityVisible = false;
  bool removeOverlay = false;
  bool isProcessing = false;

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  late final TextEditingController _customItemNameController;
  late final GroupButtonController _unitsController;
  late final TextEditingController _qtyController;
  final placeHolderIdentifier = 'H+MbQeThWmYq3t6w';
  final apiController = Get.find<APIs>();
  int custPhone =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(2);
  }

  @override
  void initState() {
    // log(
    //     '${widget.item.unit.indexWhere((element) => element == widget.item.dUnit)}');
    _unitsController = GroupButtonController(
        selectedIndex: widget.item.unit.indexWhere((element) =>
            element.toLowerCase() == widget.item.dUnit.toLowerCase()));
    // log('dUnit:${widget.item.dUnit}');
    // log('Units:${widget.item.unit}');
    _qtyController = TextEditingController(text: '${widget.item.dQuantity}');
    _customItemNameController =
        TextEditingController(text: widget.item.itemName);
    if (widget.edit) {
      if (!widget.item.dBrandType.contains(placeHolderIdentifier)) {
        _brandController.text = widget.item.dBrandType;
      }
      if (!widget.item.dItemNotes.contains(placeHolderIdentifier)) {
        _notesController.text = widget.item.dItemNotes;
      }
    }
    imageController.editItemCustomImageUrl.value = '';
    imageController.editItemCustomImageItemId.value = '';
    imageController.addItemCustomImageUrl.value = '';
    super.initState();
  }

  bool customEdit(){
    if(widget.edit){
      if(item.catId=='4000'){
        return true;
      }
    }

    return false;
  }

  late final Item item = widget.item;
  late final int currentUserListDBKey = widget.currentUserListDBKey;

  late String selectedUnit = item.unit[item.unit.indexWhere(
      (element) => element.toLowerCase() == item.dUnit.toLowerCase())];

  //for quantity field validation
  final GlobalKey<FormState> _formKey = GlobalKey();

  late final imageController = Get.find<CustomImageController>();

  late UserList currentUserList =
      Boxes.getUserListDB().get(currentUserListDBKey) ??
          fallBack_error_userList;

  static const TextStyle kLabelTextStyle = TextStyle(
      color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 15);

  double top = 10.vh, right = 10.vw;
  double animatedHeight = 150.h, animatedWidth = 150.h;
  bool startAnimation = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Dialog(
            elevation: 8.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                            item.catId=='4000'?
                          'Custom Item'
                          : item.itemName,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(customEdit())
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
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.sp))
                                  ]),
                            ),
                          ),
                          if(customEdit())
                          TextFormField(
                            validator: (value) {
                              if(value!.isEmpty){
                                return 'Please enter item name.';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            controller: _customItemNameController,
                            textInputAction: TextInputAction.next,
                            maxLength: 30,
                            // maxLines: 2,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0),
                            onSaved: (value) {
                              _customItemNameController.text = value!;
                            },
                            decoration: InputDecoration(
                              counterStyle: const TextStyle(color: Colors.grey),
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
                              hintText: 'Enter product name here...',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade500),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        alignment: Alignment.centerLeft,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16.0),
                                            bottomLeft: Radius.circular(16.0),
                                          ),
                                          child: Container(
                                            height: double.infinity,
                                            width: 36.sp,
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(16.0),
                                            bottomRight: Radius.circular(16.0),
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
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter quantity';
                                          } else if (double.parse(value) == 0 ||
                                              double.parse(value).isNegative ||
                                              double.parse(value).isInfinite) {
                                            return 'Enter a valid quantity';
                                          }
                                          return null;
                                        },
                                        controller: _qtyController,
                                        textInputAction: TextInputAction.next,
                                        textAlign: TextAlign.center,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              maxLength: 5,
                                        textAlignVertical: TextAlignVertical.center,
                                        inputFormatters: [DecimalTextInputFormatter(decimalRange: 1)],
                                              style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.0),
                                              onSaved: (value) {
                                                _qtyController.text = value!;
                                              },
                                              decoration: InputDecoration(
                                                counterText: '',
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
                                                prefix: GestureDetector(
                                                  onTap: () {
                                                    WidgetsBinding
                                                        .instance.focusManager.primaryFocus
                                                        ?.unfocus();
                                                    if (_qtyController.text.isEmpty) {
                                                      _qtyController.text = 0.toString();
                                                    }
                                                    double i =
                                                    double.parse(_qtyController.text);
                                                    if (i > 0) {
                                                      i--;
                                                      _qtyController.text =
                                                          removeDecimalZeroFormat(i);
                                                    }
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(right: 5.0),
                                                    child: Icon(
                                                      CupertinoIcons.minus,
                                                      color: Color(0xff8B8B8B),
                                                      size: 15.0,
                                                    ),
                                                  ),
                                                ),
                                                suffix: GestureDetector(
                                                  onTap: () {
                                                    WidgetsBinding
                                                        .instance.focusManager.primaryFocus
                                                        ?.unfocus();
                                                    if (_qtyController.text.isEmpty) {
                                                      _qtyController.text = 0.toString();
                                                    }

                                                    double i =
                                                    double.parse(_qtyController.text);

                                                    i++;
                                                    _qtyController.text =
                                                        removeDecimalZeroFormat(i);
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(left: 5.0),
                                                    child: Icon(
                                                      CupertinoIcons.add,
                                                      color: Color(0xff8B8B8B),
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
                                        padding: EdgeInsets.all(10.sp),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (imageController.editItemCustomImageUrl
                                                  .value.isNotEmpty &&
                                                  imageController.editItemCustomImageItemId
                                                      .value ==
                                                      item.itemId.toString()) {
                                                Get.to(
                                                        () => ImageViewerPage(
                                                      itemImageUrl: imageController
                                                          .editItemCustomImageUrl.value,
                                                      showCustomImage: true,
                                                    ),
                                                    transition: Transition.fadeIn,
                                                    opaque: false);
                                              } else {
                                                Get.to(
                                              () => ImageViewerPage(
                                                  itemImageUrl: item.itemImageId,
                                                  showCustomImage: false),
                                              transition: Transition.fadeIn,
                                              opaque: false);
                                        }
                                        // showOverlay(context);
                                      },
                                      child: Obx(
                                          //todo fix error due to builder logic issue move logic elsewhere
                                          () {
                                        String img = item.itemImageId.replaceAll(
                                          'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/',
                                          '',
                                        );
                                        return Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: imageController
                                                        .editItemCustomImageUrl.isEmpty
                                                        ? 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/$img'
                                                  : imageController
                                                      .editItemCustomImageUrl.value,
                                                    width: screenWidth * 25,
                                                    height: screenWidth * 25,
                                                    useOldImageOnUrlChange: true,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url, error) {
                                                      return Container(
                                                        color: Colors.red,
                                                        width: screenWidth * 25,
                                                        height: screenWidth * 25,
                                                      );
                                                    },
                                                  ),
                                                  Positioned(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10,
                                                    child: CircularProgressIndicator(
                                                      value: imageController
                                                          .imageUploadProgress
                                                          .value
                                                          .isNotEmpty
                                                          ? double.parse(imageController
                                                          .imageUploadProgress.value)
                                                          : 0.0,
                                                      strokeWidth: 5.0,
                                                    ),
                                                  )
                                                ],
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -1.0,
                                        right: -1.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          barrierColor: const Color.fromARGB(
                                              165, 241, 241, 241),
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return Container(
                                              height: screenHeight * 30,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(28.0),
                                                  topLeft: Radius.circular(28.0),
                                                ),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 14.0,
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text('Add Custom Image',
                                                        style: TextStyle(
                                                            color: Colors.orange,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 24,
                                                            fontFamily: 'Mulish')),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 12.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  String url =
                                                                      await FirebaseHelper()
                                                                          .addCustomItemImage(
                                                                              '${DateTime.now().toUtc().toString().replaceAll(' ', 'T')}-${item.itemId}',
                                                                              true,
                                                                              false);
                                                                  url.isNotEmpty
                                                                      ? imageController
                                                                              .editItemCustomImageItemId
                                                                              .value =
                                                                          item.itemId
                                                                              .toString()
                                                                      : null;
                                                                  url.isNotEmpty
                                                                      ? imageController
                                                                          .editItemCustomImageUrl
                                                                          .value = url
                                                                      : null;
                                                                },
                                                                child:
                                                                    const CircleAvatar(
                                                                  radius: 45,
                                                                  backgroundColor:
                                                                      Colors.grey,
                                                                  child: CircleAvatar(
                                                                    radius: 43,
                                                                    backgroundColor:
                                                                        Colors.white,
                                                                    child: Icon(
                                                                      CupertinoIcons
                                                                          .camera_fill,
                                                                      color: Colors
                                                                          .orange,
                                                                      size: 45,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const Text(
                                                                'Camera',
                                                                style: TextStyle(
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize: 16,
                                                                    fontFamily:
                                                                        'Mulish'),
                                                              )
                                                            ],
                                                          ),
                                                                Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  String url =
                                                                      await FirebaseHelper()
                                                                          .addCustomItemImage(
                                                                              '${DateTime.now().toUtc().toString().replaceAll(' ', 'T')}-${item.itemId}',
                                                                              false,
                                                                              false);
                                                                  url.isNotEmpty
                                                                      ? imageController
                                                                              .editItemCustomImageItemId
                                                                              .value =
                                                                          item.itemId
                                                                              .toString()
                                                                      : null;
                                                                  url.isNotEmpty
                                                                      ? imageController
                                                                          .editItemCustomImageUrl
                                                                          .value = url
                                                                      : null;
                                                                },
                                                                child:
                                                                    const CircleAvatar(
                                                                  radius: 45,
                                                                  backgroundColor:
                                                                      Colors.grey,
                                                                  child: CircleAvatar(
                                                                    radius: 43,
                                                                    backgroundColor:
                                                                        Colors.white,
                                                                    child: Icon(
                                                                      CupertinoIcons
                                                                          .photo_fill_on_rectangle_fill,
                                                                      color: Colors
                                                                          .orange,
                                                                      size: 45,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const Text(
                                                                'Gallery',
                                                                style: TextStyle(
                                                                    color:
                                                                        Colors.grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize: 16,
                                                                    fontFamily:
                                                                        'Mulish'),
                                                              ),
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
                            child: const Text(
                              'Unit',
                              style: kLabelTextStyle,
                            ),
                          ),
                          //UNIT SELECTOR
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: GroupButton(
                                options: GroupButtonOptions(
                                  //design
                                  unselectedBorderColor: Colors.grey.shade300,
                                  selectedBorderColor: Colors.orange,
                                  borderRadius: BorderRadius.circular(10.0),
                                  selectedShadow: [const BoxShadow()],
                                  unselectedShadow: [const BoxShadow()],
                                  selectedColor: Colors.orange,
                                  unselectedTextStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      color: const Color(0xff8B8B8B)),
                                  buttonWidth: 69.sp,
                                  buttonHeight: 50.sp,
                                  selectedTextStyle: TextStyle(
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
                                            color: const Color(0xffFFBE74),
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
                            maxLength: 30,
                                  // maxLines: 2,
                                  textAlignVertical: TextAlignVertical.center,
                                  textInputAction: TextInputAction.next,
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0),
                            onSaved: (value) {
                              _brandController.text = value!;
                            },
                            decoration: InputDecoration(
                              counterStyle: const TextStyle(color: Colors.grey),
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
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
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
                                        style: TextStyle(
                                            color: const Color(0xffFFBE74),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13.sp))

                                        ]),
                                  ),
                                ),
                                //Notes
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _notesController,
                                  maxLength: 50,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.done,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0),
                                  onSaved: (value) {
                                    _notesController.text = value!;
                                  },
                                  decoration: InputDecoration(
                                    counterStyle: const TextStyle(color: Colors.grey),
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
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey.shade500),
                                  ),
                                ),
                                SizedBox(height: 30.sp),
                                //-----------------ADD BUTTON---------------
                                Center(
                                  child: SizedBox(
                                    width: isProcessing ? 30 : screenWidth * 45,
                                    height: isProcessing ? 30 : 50,
                                    child: isProcessing
                                        ? const CircularProgressIndicator()
                                        : MaterialButton(
                                      elevation: 0.0,
                                      highlightElevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0)),
                                      color: Colors.orange,
                                      onPressed: () async {
                                        if(!widget.edit && widget.fromSearch != true)animateAdd(MediaQuery.of(context).size.width / 100);
                                        Future.delayed(Duration(milliseconds: !widget.edit && widget.fromSearch != true ? 500 : 0), () async {
                                          setState(() {
                                            isProcessing = true;
                                          });

                                        final itemUnit = selectedUnit;

                                        if (_formKey.currentState!.validate()) {
                                          //--------------------------Creating List Item from Item and new data gathered from user------------------------
                                          if (imageController.editItemCustomImageUrl
                                              .value.isEmpty ||
                                              imageController.editItemCustomImageUrl
                                                  .value ==
                                                  '') {
                                            final listItem = ListItem(
                                              brandType:
                                              _brandController.text.isEmpty
                                                  ? item.dItemNotes +
                                                  placeHolderIdentifier
                                                  : _brandController.text,
                                                itemId: '${item.itemId}',
                                                itemImageId: item.itemImageId,
                                                itemName: _customItemNameController.text,
                                              quantity:
                                              double.parse(_qtyController.text),
                                              notes: _notesController.text.isEmpty
                                                  ? item.dItemNotes +
                                                  placeHolderIdentifier
                                                  : _notesController.text,
                                              unit: itemUnit,
                                              possibleUnits: item.unit,
                                              catName: Boxes.getCategoriesDB()
                                                  .get(int.parse(item.catId
                                                  .replaceAll(
                                                  'projects/santhe-425a8/databases/(default)/documents/category/',
                                                  '')))
                                                  ?.catName ??
                                                  'Others',
                                              catId: int.parse(
                                                item.catId.replaceAll(
                                                    'projects/santhe-425a8/databases/(default)/documents/category/',
                                                    ''),
                                              ),
                                            );
                                            if (widget.edit) {
                                              currentUserList.items.removeWhere(
                                                      (element) =>
                                                  element.itemId ==
                                                      listItem.itemId);
                                            }
                                            currentUserList.items.add(listItem);
                                            //make changes persistent
                                            currentUserList.save();
                                            Navigator.pop(context);
                                          } else {
                                            int itemCount =
                                            await apiController.getItemsCount();

                                              if (itemCount != 0) {
                                              Item newCustomItem = Item(
                                                  dBrandType:
                                                  _brandController.text.isEmpty
                                                      ? item.dItemNotes +
                                                      placeHolderIdentifier
                                                      : _brandController.text,
                                                  dItemNotes:
                                                  _notesController.text.isEmpty
                                                      ? item.dItemNotes +
                                                      placeHolderIdentifier
                                                      : _notesController.text,
                                                    itemImageTn: imageController
                                                        .editItemCustomImageUrl.value,
                                                    catId: item.catId,
                                                    createUser: custPhone,
                                                    dQuantity: 1,
                                                    dUnit: selectedUnit,
                                                    itemAlias: _customItemNameController.text,
                                                    itemId: itemCount,
                                                    itemImageId: imageController
                                                        .editItemCustomImageUrl.value,
                                                    itemName: _customItemNameController.text,
                                                    status: item.catId=='4000'?'inactive':'active',
                                                    unit: [selectedUnit],
                                                    updateUser: custPhone);

                                                int response = await apiController
                                                    .addItem(newCustomItem);

                                              if (response == 1) {
                                                final listItem = ListItem(
                                                  brandType:
                                                  _brandController.text.isEmpty
                                                      ? item.dItemNotes +
                                                      placeHolderIdentifier
                                                      : _brandController.text,
                                                  //item ref
                                                  itemId: '${item.itemId}',
                                                    itemImageId: imageController
                                                        .editItemCustomImageUrl.value,
                                                    itemName: _customItemNameController.text,
                                                  quantity: double.parse(
                                                      _qtyController.text),
                                                  notes:
                                                  _notesController.text.isEmpty
                                                      ? item.dItemNotes +
                                                      placeHolderIdentifier
                                                      : _notesController.text,
                                                  unit: itemUnit,
                                                  possibleUnits: item.unit,
                                                  catName: Boxes.getCategoriesDB()
                                                      .get(int.parse(item.catId
                                                      .replaceAll(
                                                      'projects/santhe-425a8/databases/(default)/documents/category/',
                                                      '')))
                                                      ?.catName ??
                                                      'Others',
                                                  catId: int.parse(
                                                    item.catId.replaceAll(
                                                        'projects/santhe-425a8/databases/(default)/documents/category/',
                                                        ''),
                                                  ),
                                                  );

                                                if (widget.edit) {
                                                  currentUserList.items.removeWhere(
                                                          (element) =>
                                                      element.itemId ==
                                                          '${item.itemId}');
                                                }
                                                currentUserList.items.add(listItem);
                                                //make changes persistent
                                                currentUserList.save();
                                              } else {
                                                Get.snackbar('Network Error',
                                                    'Error Adding item to the list!',
                                                    backgroundColor: Colors.white,
                                                    colorText: Colors.grey);
                                              }
                                              Navigator.pop(context);
                                            } else {
                                              Get.snackbar(
                                                '',
                                                '',
                                                titleText: const Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 8.0),
                                                  child: Text('Enter Quantity'),
                                                ),
                                                messageText: const Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                      'Please enter some quantity to add...'),
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
                                                    color: Colors.yellow,
                                                    size: 45,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        }

                                          setState(() {
                                            isProcessing = false;
                                          });
                                        });
                                      },
                                      child: AutoSizeText(
                                        widget.edit ? 'Update' : 'Add',
                                        style: TextStyle(
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
          ),
          //animation widget
          if(startAnimation)AnimatedPositioned(
            top: top,
            right: right,
            duration: const Duration(milliseconds: 400),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                height: animatedHeight,
                width: animatedWidth,
                duration: const Duration(milliseconds: 300),
                child: Obx(
                  //todo fix error due to builder logic issue move logic elsewhere
                      () => Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageController
                            .editItemCustomImageUrl
                            .value
                            .isNotEmpty &&
                            imageController
                                .editItemCustomImageItemId
                                .value ==
                                item.itemId.toString()
                            ? imageController
                            .editItemCustomImageUrl.value
                            : 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${item.itemImageId}',
                        width: screenWidth * 25,
                        height: screenWidth * 25,
                        useOldImageOnUrlChange: true,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          print(error);
                          return Container(
                            color: Colors.red,
                            width: screenWidth * 25,
                            height: screenWidth * 25,
                          );
                        },
                      ),
                      Positioned(
                        top: 10,
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: CircularProgressIndicator(
                          value: imageController
                              .imageUploadProgress
                              .value
                              .isNotEmpty
                              ? double.parse(imageController
                              .imageUploadProgress.value)
                              : 0.0,
                          strokeWidth: 5.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void animateAdd(double value){
    setState(() => startAnimation = true);
    Future.delayed(const Duration(milliseconds: 50), (){
      setState((){
        animatedWidth = 50.w;
        animatedHeight = 50.w;
        top = 81.vh;
        right = 10.vw;
      });
    });
    Future.delayed(const Duration(milliseconds: 500), () => setState(() => startAnimation = false));
    top = 20.vh; right = 20.vw;
  }
}
