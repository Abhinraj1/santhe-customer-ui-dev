import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resize/resize.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:santhe/constants.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/pages/new_tab_pages/user_list_screen.dart';
import '../../core/app_colors.dart';
import '../../models/new_list/user_list_model.dart';

class NewTabPage extends StatefulWidget {
  const NewTabPage({Key? key}) : super(key: key);

  @override
  _NewTabPageState createState() => _NewTabPageState();
}

enum NewListType { startFromNew, importFromOld }

class _NewTabPageState extends State<NewTabPage> with AutomaticKeepAliveClientMixin {

  NewListType? _type = NewListType.startFromNew;

  final AllListController _allListController = Get.find();

  String? selectedValue;

  final _formKey = GlobalKey<FormState>();

  String listName = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: GetBuilder(
        init: _allListController,
        id: 'fab',
        builder: (ctr) => _allListController.newList.length >= _allListController.lengthLimit || _allListController.isLoading ?
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
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 22.5.sp,
            semanticLabel: 'Click here to create a new order!',
          ),
        ),
      ),
      body: SizedBox(
        height: 100.vh,
        width: 100.vw,
        child: GetBuilder(
          init: _allListController,
          id: 'newList',
          builder: (ctr){
            List<UserListModel> _userList = _allListController.newList;
            if(_allListController.isLoading){
              return Center(child: CircularProgressIndicator(color: AppColors().brandDark),);
            }
            if(_allListController.newList.isEmpty) {
              return _emptyList();
            }
            return RefreshIndicator(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 3.0),
                  itemCount: _userList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) => _userListCard(_userList[index]),
                ),
                onRefresh: () async {
                  await _allListController.getAllList();
                });
          },
        ),
      ),
    );
  }

  Widget _emptyList() => RefreshIndicator(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: 23.h),
      Image.asset(
        'assets/new_tab_image.png',
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
  ), onRefresh: () async => await _allListController.getAllList());
  
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
                      visible: _allListController.getLatestList(5).isNotEmpty
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
                      _allListController.isProcessing.value ?
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
                              if(_allListController.isListAlreadyExist(listName)){
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
                                _allListController.addNewListToDB(listName);
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
                              _allListController.addCopyListToDB(selectedValue!);
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
    List<UserListModel> _list = _allListController.getLatestList(_maxLength);
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

  Widget _userListCard(UserListModel userList){
    String imagePath = 'assets/basket0.png';

    //image logic
    if (userList.items.isEmpty) {
      imagePath = 'assets/basket0.png';
    } else if (userList.items.length <= 10) {
      imagePath = 'assets/basket1.png';
    } else if (userList.items.length <= 20) {
      imagePath = 'assets/basket2.png';
    } else {
      imagePath = 'assets/basket3.png';
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () async => Get.to(() => UserListScreen(listId: userList.listId)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.21),
                blurRadius: 15.0, // soften the shadow
                spreadRadius: 3.6, //extend the shadow
                offset: const Offset(
                  0.0,
                  0.0,
                ),
              )
            ],
          ),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                //copy from old list
                Visibility(
                  visible: _allListController.newList.length < _allListController.lengthLimit,
                  child: SlidableAction(
                    onPressed: (context) async {
                      _allListController.addCopyListToDB(userList.listId);
                    },
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.orange,
                    autoClose: true,
                    icon: Icons.copy_rounded,
                    label: 'Copy',
                  ),
                ),
                //delete list
                SlidableAction(
                  onPressed: (context) => _allListController.deleteListFromDB(userList.listId, 'new'),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.orange,
                  icon: CupertinoIcons.delete_solid,
                  label: 'Delete',
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 10.0, left: 15.0, right: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              userList.listName,
                              maxLines: 2,
                              style: TextStyle(
                                  letterSpacing: 0.2,
                                  fontSize: 20.sp,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w400),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.sp),
                              child: AutoSizeText(
                                '${userList.items.length} ${userList.items.length > 1 ? 'Items' : 'Item'}',
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(top: 1.sp, bottom: 8.32.sp),
                              child: AutoSizeText(
                                'Added on ${userList.createListTime.day}/${userList.createListTime.month}/${userList.createListTime.year}',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.transparent,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        imagePath,
                        height: 129.sp,
                        width: 129.sp,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Added on ${userList.createListTime.day}/${userList.createListTime.month}/${userList.createListTime.year}',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xffBBBBBB),
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}