import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/controllers/getx/new_list_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/models/santhe_user_list_model.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:santhe/pages/login_pages/phone_number_login_page.dart';
import 'package:santhe/pages/new_tab_pages/user_list_page.dart';
import 'package:santhe/widgets/new_tab_widgets/user_list_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import '../../core/app_colors.dart';
import '../../models/new_list/user_list_model.dart';

class NewTabPage extends StatefulWidget {
  const NewTabPage({Key? key, this.limit = 3}) : super(key: key);

  final int limit;

  @override
  _NewTabPageState createState() => _NewTabPageState();
}

enum NewListType { startFromNew, importFromOld }

class _NewTabPageState extends State<NewTabPage> with WidgetsBindingObserver {

  NewListType? _type = NewListType.startFromNew;

  final apiController = Get.find<APIs>();

  final NewListController _newListController = Get.find();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {

    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState(){
    super.initState();
    _newListController.getAllList();
  }

  String? selectedValue;

  final _formKey = GlobalKey<FormState>();

  String listName = '';
  int custId = int.parse(AppHelpers().getPhoneNumberWithoutCountryCode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: GetBuilder(
        init: _newListController,
        id: 'fab',
        builder: (ctr) => _newListController.newList.length >= widget.limit || _newListController.isLoading ?
          const SizedBox() :
          FloatingActionButton(
          elevation: 0.0,
          onPressed: () => showModalBottomSheet<void>(
              backgroundColor: Colors.transparent,
              context: context,
              barrierColor:
              const Color.fromARGB(165, 241, 241, 241),
              isScrollControlled: true,
              builder: (ctx) => _bottomSheet(ctx)),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
            semanticLabel: 'Click here to create a new order!',
          ),
        ),
      ),
      body: SizedBox(
        height: 100.vh,
        width: 100.vw,
        child: GetBuilder(
          init: _newListController,
          id: 'list',
          builder: (ctr) => RefreshIndicator(
              child: _newListController.isLoading ?
              Center(child: CircularProgressIndicator(color: AppColors().brandDark),) :
              _newListController.newList.isEmpty
                  ? _emptyList()
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 3.0),
                    itemCount: _newListController.newList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) => UserListCard(userList: _newListController.newList.values.elementAt(index)),
              ),
              onRefresh: () async {
                await _newListController.getAllList();
              }),
        ),
      ),
    );
  }

  Widget _emptyList() => RefreshIndicator(child: Column(
    children: [
      SizedBox(height: 23.h),
      SvgPicture.asset(
        'assets/new_tab_image.svg',
        height: 45.vh,
      ),
      Expanded(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Get started by easily creating your\nshopping list',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    height: 2.sp,
                    color: kTextGrey),
              ),
            ),
            Align(
              alignment: const Alignment(-0.2, 0.5),
              child: SizedBox(
                width: 50.vw,
                child: SvgPicture.asset(
                  'assets/new_tab_arrow.svg',
                  color: Colors.orange,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ), onRefresh: () async => await _newListController.getAllList());
  
  Widget _bottomSheet(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: Icon(
                              Icons.close,
                              color:
                              Colors.transparent,
                              // color: Color(0xffe8e8e8),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Add New List',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight:
                                FontWeight.w700,
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
                                color:
                                Color(0xffe8e8e8),
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
                        value:
                        NewListType.startFromNew,
                        groupValue: _type,
                        onChanged:
                            (NewListType? value) {
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
                                fontWeight:
                                FontWeight.w400,
                                fontStyle:
                                FontStyle.italic,
                                color: Colors.grey),
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
                              BorderRadius.circular(kTextFieldCircularBorderRadius),
                              borderSide:
                              const BorderSide(
                                  width: 1.0,
                                  color:
                                  kTextFieldGrey),
                            ),
                            focusedBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  kTextFieldCircularBorderRadius),
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: AppColors()
                                      .brandDark),
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
                      visible: _newListController.getLatestList(5).isNotEmpty
                          ? true
                          : false,
                      child: Column(
                        children: [
                          ListTile(
                            minVerticalPadding: 0.0,
                            contentPadding:
                            const EdgeInsets.all(
                                0.0),
                            title: Text(
                              'Start from an old list',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.w500,
                                color: Colors
                                    .grey.shade600,
                              ),
                            ),
                            horizontalTitleGap: 0,
                            leading:
                            Radio<NewListType>(
                              value: NewListType
                                  .importFromOld,
                              groupValue: _type,
                              onChanged: (NewListType?
                              value) {
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
                                    alignment: Alignment
                                        .topCenter,
                                    child: SizedBox(
                                      width: 314.w,
                                      height: 65.h,
                                      child:
                                      DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            isExpanded: true,
                                            hint: Text(
                                              'Select',
                                              style: TextStyle(
                                                  fontSize:
                                                  16.sp,
                                                  fontWeight:
                                                  FontWeight
                                                      .w400,
                                                  fontStyle:
                                                  FontStyle
                                                      .italic,
                                                  color: Colors
                                                      .grey),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            items: _addDividersAfterItems(),
                                            customItemsHeight: 4,
                                            value: selectedValue,
                                            onChanged: (value) {
                                              changeState(() {
                                                selectedValue = value as String;
                                              });
                                            },
                                            icon: const Icon(Icons.keyboard_arrow_up,),
                                            iconSize: 14,
                                            iconEnabledColor:
                                            Colors.grey,
                                            iconDisabledColor:
                                            Colors.grey.shade100,
                                            buttonHeight: 50,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                14.sp,
                                                fontWeight:
                                                FontWeight
                                                    .w400),
                                            buttonWidth: 160,
                                            buttonPadding: const EdgeInsets.only(
                                                left:
                                                14,
                                                right:
                                                14),
                                            buttonDecoration:
                                            BoxDecoration(
                                              borderRadius: BorderRadius.circular(kTextFieldCircularBorderRadius),
                                              border: Border.all(color: kTextFieldGrey,),
                                              color: Colors.white,
                                            ),
                                            buttonElevation: 0,
                                            itemHeight: 40,
                                            itemPadding:
                                            const EdgeInsets.only(left: 14, right: 14),
                                            dropdownMaxHeight: 200,
                                            dropdownWidth: 314.sp,
                                            dropdownPadding: null,
                                            dropdownDecoration:
                                            BoxDecoration(
                                              borderRadius: BorderRadius.circular(kTextFieldCircularBorderRadius),
                                              color: Colors.grey.shade100,
                                            ),
                                            dropdownElevation: 0,
                                            scrollbarRadius: const Radius.circular(40),
                                            scrollbarThickness: 6,
                                            scrollbarAlwaysShow: true,
                                            offset: const Offset(0, 0),
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
                    SizedBox(height: 30.sp),
                    SizedBox(
                      width: 221.sp,
                      height: 50.sp,
                      child: Obx(() =>
                      _newListController.isProcessing.value ?
                      Center(child: CircularProgressIndicator(color: AppColors().brandDark,),) : MaterialButton(
                        elevation: 0.0,
                        highlightElevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                16)),
                        color: Colors.orange,
                        onPressed: () async {
                          if (listName.isNotEmpty && _type == NewListType.startFromNew) {
                            if (_formKey.currentState!.validate()) {
                              if(_newListController.isListAlreadyExist(listName)){
                                Get.snackbar('', '',
                                  titleText: const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('List name already exists'),
                                  ),
                                  messageText: const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('Please enter a new name'),
                                  ),
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(8.0),
                                  backgroundColor: Colors.white,
                                  shouldIconPulse: true,
                                  icon: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(CupertinoIcons.exclamationmark_triangle_fill,
                                      color:
                                      Colors.orange,
                                      size: 45,
                                    ),
                                  ),
                                );
                              }else{
                                _newListController.addNewListToDB(listName);
                              }
                            }
                          }
                          else if (listName.isEmpty && _type == NewListType.startFromNew) {
                            Get.snackbar('', '',
                              titleText: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text('Enter a List Name'),
                              ),
                              messageText: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text('Please enter a new list name before continuing...'),
                              ),
                              margin: const EdgeInsets.all(10.0),
                              padding: const EdgeInsets.all(8.0),
                              backgroundColor: Colors.white,
                              shouldIconPulse: true,
                              icon: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  CupertinoIcons.exclamationmark_triangle_fill,
                                  color: Colors.orange,
                                  size: 45,
                                ),
                              ),
                            );
                          }
                          else if (_type == NewListType.importFromOld) {
                            if (selectedValue != null) {
                              _newListController.addCopyListToDB(selectedValue!);
                            }
                            else {
                              Get.snackbar('', '',
                                titleText: const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text('Please select a list'),
                                ),
                                messageText: const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text('Else create a new list'),
                                ),
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(8.0),
                                backgroundColor: Colors.white,
                                shouldIconPulse: true,
                                icon: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(CupertinoIcons.exclamationmark_triangle_fill,
                                    color:
                                    Colors.orange,
                                    size: 45,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Text('Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                            FontWeight.w700,
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

  List<DropdownMenuItem<String>> _addDividersAfterItems() {
    int _maxLength = 5;
    List<DropdownMenuItem<String>> _menuItems = [];
    List<UserListModel> _list = _newListController.getLatestList(_maxLength);
    for (var element in _list) {
      _menuItems.addAll(
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
          if(element != _list[_maxLength - 1])
          const DropdownMenuItem<String>(
            enabled: false,
            child: Divider(),
          )
        ],
      );
    }
    return _menuItems;
  }
}
