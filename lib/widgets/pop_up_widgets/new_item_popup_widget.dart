import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

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
  bool edit;

  NewItemPopUpWidget(
      {Key? key,
      required this.item,
      required this.currentUserListDBKey,
      this.edit = false})
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
  late final GroupButtonController _unitsController;
  late final TextEditingController _qtyController;
  final apiController = Get.find<APIs>();
  int custPhone =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  @override
  void initState() {
    // print(
    //     '${widget.item.unit.indexWhere((element) => element == widget.item.dUnit)}');
    _unitsController = GroupButtonController(
        selectedIndex: widget.item.unit.indexWhere((element) =>
            element.toLowerCase() == widget.item.dUnit.toLowerCase()));
    // print('dUnit:${widget.item.dUnit}');
    // print('Units:${widget.item.unit}');
    _qtyController = TextEditingController(text: '${widget.item.dQuantity}');
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    return Dialog(
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
                      item.itemName,
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
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  textAlignVertical: TextAlignVertical.center,
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
                                            .instance?.focusManager.primaryFocus
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
                                            .instance?.focusManager.primaryFocus
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
                            padding: EdgeInsets.only(
                                top: 8.sp, left: 8.sp, right: 8.sp),
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
                                    print(
                                        '${imageController.editItemCustomImageItemId.value} : Item->${item.itemId}');
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
                          Positioned(
                            top: 0.0,
                            right: 6.0,
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
                                              Text(
                                                'Add Custom Image',
                                                style: GoogleFonts.mulish(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 24,
                                                ),
                                              ),
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
                                                        Text(
                                                          'Camera',
                                                          style: GoogleFonts
                                                              .mulish(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                          ),
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
                                                        Text(
                                                          'Gallery',
                                                          style: GoogleFonts
                                                              .mulish(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                    GroupButton(
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
                      maxLength: 45,
                      // maxLines: 2,
                      textAlignVertical: TextAlignVertical.center,
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
                      maxLength: 90,
                      textAlignVertical: TextAlignVertical.center,
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
                        width: screenWidth * 45,
                        height: 50,
                        child: isProcessing
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              )
                            : MaterialButton(
                                elevation: 0.0,
                                highlightElevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                color: Colors.orange,
                                onPressed: () async {
                                  setState(() {
                                    isProcessing = true;
                                  });

                                  final itemUnit =
                                      selectedUnit; //todo firebase and add custom image item
                                  print('${_qtyController.text} $itemUnit');

                                  if (_formKey.currentState!.validate()) {
                                    //--------------------------Creating List Item from Item and new data gathered from user------------------------
                                    //TODO add parameter validation
                                    if (imageController
                                        .editItemCustomImageUrl.value.isEmpty) {
                                      print(
                                          "Item added=== > DB KEY: ${currentUserList.key}");
                                      final listItem = ListItem(
                                        brandType: _brandController.text,
                                        itemId: '${item.itemId}',
                                        itemImageId: item.itemImageId,
                                        itemName: item.itemName,
                                        quantity:
                                        double.parse(_qtyController.text),
                                        notes: _notesController.text,
                                        unit: itemUnit,
                                        possibleUnits: item.unit,
                                        catName: Boxes.getCategoriesDB()
                                            .get(int.parse(item.catId
                                            .replaceAll(
                                            'projects/santhe-425a8/databases/(default)/documents/category/',
                                            '')))
                                            ?.catName ??
                                            'Error',
                                        catId: int.parse(
                                          item.catId.replaceAll(
                                              'projects/santhe-425a8/databases/(default)/documents/category/',
                                              ''),
                                        ),
                                      );
                                      if(widget.edit){
                                        currentUserList.items.removeWhere((element) => element.itemId==listItem.itemId);

                                      }
                                      currentUserList.items.add(listItem);
                                      //make changes persistent
                                      currentUserList.save();
                                      Navigator.pop(context);
                                    } else {
                                      int itemCount =
                                          await apiController.getItemsCount();

                                      print(
                                          '>>>>>>>>>>>>ITEM COUNT: $itemCount');
                                      print(
                                          '>>>>>>>>>>>>OFFLINE COUNT: ${apiController.itemsDB.length}');
                                      //--------------------------Creating List Item from Item and new data gathered from user------------------------
                                      //TODO add parameter validation

                                      print(
                                          '---------------${_qtyController.text} $itemUnit---------------');

                                      if (itemCount != 0) {
                                        //todo add custom item to firebase
                                        Item newCustomItem = Item(
                                            dBrandType: _brandController.text,
                                            dItemNotes: _notesController.text,
                                            itemImageTn: imageController
                                                .editItemCustomImageUrl.value,
                                            catId: '4000',
                                            createUser: custPhone,
                                            dQuantity: 1,
                                            dUnit: selectedUnit,
                                            itemAlias: item.itemName,
                                            itemId: itemCount,
                                            itemImageId: imageController
                                                .editItemCustomImageUrl.value,
                                            itemName: item.itemName,
                                            status: 'inactive',
                                            unit: [selectedUnit],
                                            updateUser: custPhone);

                                        int response = await apiController
                                            .addItem(newCustomItem);

                                        if (response == 1) {

                                          final listItem = ListItem(
                                            brandType: _brandController.text,
                                            //item ref
                                            itemId:
                                            'projects/santhe-425a8/databases/(default)/documents/item/${itemCount}',
                                            itemImageId: imageController
                                                .editItemCustomImageUrl.value,
                                            //todo make it work
                                            itemName: item.itemName,
                                            quantity: double.parse(
                                                _qtyController.text),
                                            notes: _notesController.text,
                                            unit: itemUnit,
                                            possibleUnits: item.unit,
                                            catName: Boxes.getCategoriesDB()
                                                .get(int.parse(item.catId
                                                .replaceAll(
                                                'projects/santhe-425a8/databases/(default)/documents/category/',
                                                '')))
                                                ?.catName ??
                                                'Error',
                                            catId: 4000,
                                          );

                                          if(widget.edit){
                                            currentUserList.items.removeWhere((element) => element.itemId==listItem.itemId);
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
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text('Enter Quantity'),
                                          ),
                                          messageText: const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
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
                                },
                                child: AutoSizeText(
                                  'Add',
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
    );
  }
}
