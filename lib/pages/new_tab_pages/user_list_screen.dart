import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:resize/resize.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/network_call/network_call.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:santhe/widgets/pop_up_widgets/custom_item_popup_widget.dart';
import 'package:santhe/widgets/protectedCachedNetworkImage.dart';

import '../../constants.dart';
import '../../controllers/boxes_controller.dart';
import '../../controllers/home_controller.dart';
import '../../core/app_colors.dart';
import '../../models/new_list/list_item_model.dart';
import '../../models/new_list/user_list_model.dart';
import '../../models/santhe_category_model.dart';
import '../../models/santhe_item_model.dart';
import '../../widgets/new_tab_widgets/user_list_widgets/list_item_card.dart';
import '../../widgets/pop_up_widgets/new_item_popup_widget.dart';
import 'categories_page.dart';

class UserListScreen extends StatefulWidget {
  final String listId;

  const UserListScreen({Key? key, required this.listId}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final AllListController _allListController = Get.find();

  late UserListModel _userList = _allListController.allListMap[widget.listId]!;

  late String _title = _userList.listName, searchQuery = '';

  late Future<List<Item>> searchedItemsResult;

  final searchQueryController = TextEditingController();

  final List<Category> _categoryList = Boxes.getCategoriesDB().values.toList();

  final HomeController _homeController = Get.find();
  final ProfileController _profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 0.1,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 16.sp,
          ),
          onPressed: () async {
            saveList();
            _homeController.homeTabController.animateTo(0);
            Get.back();
          },
        ),
        title: Obx(() => _allListController.isTitleEditable.value
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10.vw),
                child: Container(
                  // height: 35.sp,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Stack(
                    children: [
                      TextFormField(
                        autofocus: true,
                        initialValue: _userList.listName,
                        // enableInteractiveSelection: false,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        cursorHeight: 18.sp,
                        maxLength: 30,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, right: 30.0, left: 30.0),
                          counterText: '',

                          // hintText: userList.listName,
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                width: 0.0, color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                width: 0.0, color: Colors.transparent),
                          ),
                        ),
                        onChanged: (val) => _title = val,
                        onFieldSubmitted: (val) => changeListName(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => changeListName(),
                          child: const Padding(
                            padding: EdgeInsets.only(right: 3.0, top: 6.0),
                            child: Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: Colors.orange,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Text(
                _userList.listName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp),
              )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 0),
            child: Obx(() => _allListController.isTitleEditable.value
                ? const SizedBox()
                : IconButton(
                    splashRadius: 0.1,
                    icon: const Icon(
                      CupertinoIcons.pencil_circle_fill,
                      size: 24,
                    ),
                    onPressed: () {
                      _allListController.isTitleEditable.value =
                          !_allListController.isTitleEditable.value;
                    },
                  )),
          ),
        ],
      ),
      body: WillPopScope(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //search text field
              GetBuilder(
                  init: _allListController,
                  id: 'searchField',
                  builder: (builder) => TextFormField(
                        controller: searchQueryController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          searchQuery = value;
                          if (value.length > 2) {
                            EasyDebounce.debounce(
                                'searchItem', const Duration(milliseconds: 500),
                                () {
                              searchedItemsResult =
                                  APIs().searchedItemResult(value);
                              _allListController
                                  .update(['searchResults', 'searchField']);
                            });
                          }
                        },
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff8B8B8B),
                            fontSize: 16.sp),
                        decoration: InputDecoration(
                            suffixIcon: Visibility(
                              visible: searchQuery.isNotEmpty,
                              child: IconButton(
                                icon: const Icon(
                                  CupertinoIcons.xmark,
                                  color: Color(0xffE0E0E0),
                                  size: 21,
                                ),
                                onPressed: () {
                                  searchQueryController.clear();
                                  searchQuery = '';
                                  FocusScope.of(context).unfocus();
                                  _allListController
                                      .update(['searchResults', 'searchField']);
                                },
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 9.0),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 9.0),
                              child: Icon(
                                CupertinoIcons.search_circle_fill,
                                size: 32,
                                color: Colors.orange,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomRight: searchQuery.length < 3
                                    ? const Radius.circular(16)
                                    : const Radius.circular(0),
                                bottomLeft: searchQuery.length < 3
                                    ? const Radius.circular(16)
                                    : const Radius.circular(0),
                              ),
                              borderSide: BorderSide(
                                  width: 1.0, color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomRight: searchQuery.length < 3
                                    ? const Radius.circular(16)
                                    : const Radius.circular(0),
                                bottomLeft: searchQuery.length < 3
                                    ? const Radius.circular(16)
                                    : const Radius.circular(0),
                              ),
                              borderSide: BorderSide(
                                  width: searchQuery.length < 3 ? 1.0 : 2.0,
                                  color: Colors.grey.shade400),
                            ),
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic,
                                fontSize: 18.sp),
                            hintText: 'Search and add products...'),
                      )),
              //top item counter widget
              Expanded(
                child: Stack(
                  children: [
                    GetBuilder(
                      init: _allListController,
                      id: 'addedItems',
                      builder: (builder) => Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15.sp, bottom: 0.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _profileController.isOperational.value
                                  ? Text(
                                      '${_userList.items.length} ${_userList.items.length < 2 ? 'Item' : 'Items'}',
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black54),
                                    )
                                  : null,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: _userList.items.isNotEmpty
                                  ? _groupedItemListView()
                                  : _emptyList(),
                            ),
                          ),
                          //buttons
                          _userList.items.length >= 2
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //send to shops
                                    if (_profileController.isOperational.value)
                                      _sendToShopsButton(),
                                    //categories page
                                    _profileController.isOperational.value
                                        ? _iconCategoryButton()
                                        : _fullCategoryButton(),
                                  ],
                                )
                              : _fullCategoryButton(),
                        ],
                      ),
                    ),
                    //search results
                    GetBuilder(
                        init: _allListController,
                        id: 'searchResults',
                        builder: (builder) => searchQuery.length > 2
                            ? ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.97),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 2),
                                    ),
                                    child: _loadSearchResult()),
                              )
                            : const SizedBox())
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          saveList();
          _allListController.update(['newList', 'fab']);
          _homeController.homeTabController.animateTo(0);
          Get.back();
          return true;
        },
      ),
    );
  }

  void changeListName() {
    if (_title == _allListController.allListMap[widget.listId]!.listName) {
      _allListController.isTitleEditable.value =
          !_allListController.isTitleEditable.value;
    } else if (_allListController.isListAlreadyExist(_title)) {
      errorMsg('List name cannot be duplicated', 'Enter unique name');
    } else if (_title.trim().isNotEmpty) {
      _allListController.allListMap[widget.listId]!.listName = _title;
      _userList = _allListController.allListMap[widget.listId]!;
      _allListController.isTitleEditable.value =
          !_allListController.isTitleEditable.value;
      _allListController.update(['newList', 'fab']);
      _title = _allListController.allListMap[widget.listId]!.listName;
    } else {
      _allListController.isTitleEditable.value =
          !_allListController.isTitleEditable.value;
    }
  }

  Widget _itemName(bool isCustom, {Item? item}) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: isCustom
                      ? Icon(
                          CupertinoIcons.news,
                          color: Colors.orange,
                          size: 40.0.sp,
                        )
                      : ProtectedCachedNetworkImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${item!.itemImageId.replaceAll('https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/', '')}',
                          width: 40.w,
                          height: 40.w,
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
                        isCustom ? searchQuery : item!.itemName,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700),
                      ),
                      Text(
                        isCustom
                            ? 'Add a custom item'
                            : (item!.catId == '4000'
                                ? 'Custom Category'
                                : getCategoryName(item)),
                        style: const TextStyle(
                          color: Colors.orange,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Icon(
            Icons.add,
            color: Colors.orange,
          ),
        ],
      ));

  String getCategoryName(Item item) {
    List<Category> temp = _categoryList
        .where((element) =>
            element.catId ==
            int.parse(item.catId.replaceAll(
                'projects/santhe-425a8/databases/(default)/documents/category/',
                '')))
        .toList();
    if (temp.isEmpty) {
      return 'Custom Category';
    } else {
      return temp.first.catName;
    }
  }

  Widget _loadSearchResult() => FutureBuilder<List<Item>>(
        future: searchedItemsResult,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 10.vh,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        showDialog(
                            context: context,
                            barrierColor:
                                const Color.fromARGB(165, 241, 241, 241),
                            builder: (context) {
                              return CustomItemPopUpWidget(
                                listId: widget.listId,
                                searchQuery: searchQuery,
                              );
                            }).then((value) {
                          searchQueryController.clear();
                          searchQuery = '';
                          setState(() {});
                        });
                      },
                      child: _itemName(true),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'No Search Results Found...',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              shrinkWrap: true,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              itemCount: snapshot.data!.length + 1,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemBuilder: (context, index) {
                late Item item;
                if (index < snapshot.data!.length) {
                  item = snapshot.data![index];
                }
                return index == snapshot.data!.length
                    ? InkWell(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          showDialog(
                              context: context,
                              barrierColor:
                                  const Color.fromARGB(165, 241, 241, 241),
                              builder: (context) {
                                return CustomItemPopUpWidget(
                                  listId: widget.listId,
                                  searchQuery: searchQuery,
                                );
                              }).then((value) {
                            searchQueryController.clear();
                            searchQuery = '';
                            setState(() {});
                          });
                        },
                        child: _itemName(true))
                    : InkWell(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          showDialog(
                              context: context,
                              barrierColor:
                                  const Color.fromARGB(165, 241, 241, 241),
                              builder: (context) {
                                return NewItemPopUpWidget(
                                  item: snapshot.data![index],
                                  fromSearch: true,
                                  listId: widget.listId,
                                );
                              }).then((value) {
                            searchQueryController.clear();
                            searchQuery = '';
                            setState(() {});
                          });
                        },
                        child: _itemName(false, item: item),
                      );
              },
            );
          } else {
            return SizedBox(
              height: 50.h,
              width: 100.vh,
              child: Center(
                child: SizedBox(
                  height: 10.h,
                  width: 10.h,
                  child: const CircularProgressIndicator(),
                ),
              ),
            );
          }
        },
      );

  Widget _emptyList() => Obx(
        () => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.vw),
                    child: SizedBox(
                      height: _profileController.isOperational.value
                          ? 24.vh
                          : 18.vh,
                      child: SvgPicture.asset(
                        'assets/search_items_pointer_arrow.svg',
                        width: 50.vw,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  const Text(
                    'Add your item by searching',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              if (!_profileController.isOperational.value)
                Text(
                  'We don\'t serve in your location yet. As soon as we have active merchants in your locality, you will be able to send your lists to shops. For now, you can create and manage your shopping lists on Santhe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      height: 2.sp,
                      color: kTextGrey),
                ),
              Column(
                children: [
                  const Text(
                    'Add your item from catalog',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height:
                        _profileController.isOperational.value ? 20.vh : 12.vh,
                    child: SvgPicture.asset(
                      'assets/item_catalog_arrow.svg',
                      width: 70.vw,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _fullCategoryButton() => SizedBox(
        height: 50,
        width: 325.sp,
        child: MaterialButton(
          elevation: 0.0,
          highlightElevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          color: Colors.orange,
          onPressed: () {
            Get.to(() => CategoriesPage(listId: widget.listId));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.5.vw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  CupertinoIcons.square_grid_2x2,
                  color: Colors.white,
                  size: 28,
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      'Item Catalog',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.square_grid_2x2,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _iconCategoryButton() => SizedBox(
        height: 53,
        width: 77.sp,
        child: MaterialButton(
          elevation: 0.0,
          highlightElevation: 0.0,
          splashColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.orange, width: 2.0),
              borderRadius: BorderRadius.circular(16.0)),
          color: Colors.white,
          onPressed: () {
            Get.to(() => CategoriesPage(listId: widget.listId));
          },
          child: const Icon(
            CupertinoIcons.square_grid_2x2,
            color: Colors.orange,
            size: 35,
          ),
        ),
      );

  Widget _sendToShopsButton() => SizedBox(
        height: 55,
        width: 65.vw,
        child: MaterialButton(
          elevation: 0.0,
          highlightElevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          color:
              _userList.items.length < 2 ? AppColors().grey40 : Colors.orange,
          onPressed: () {
            //SEND TO SHOP BOTTOM SHEET
            showModalBottomSheet<void>(
                backgroundColor: Colors.transparent,
                context: context,
                barrierColor: const Color.fromARGB(165, 241, 241, 241),
                isScrollControlled: true,
                builder: (ctx) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom),
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
                      //giving a new context so that modal sheet can also set state
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(23.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: [
                                  Column(
                                    children: const [
                                      Icon(Icons.close,
                                          color: Colors.transparent),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Send list to shops\nnear you',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(ctx);
                                        },
                                        child: Icon(Icons.close,
                                            color: AppColors().grey60),
                                      ),
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Image.asset(
                                'assets/send_to_shops.gif',
                                height: 235.sp,
                                width: 344.sp,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    textBaseline: TextBaseline.ideographic,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    children: [
                                      Text(
                                        '1.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                          color: const Color(0xffB0B0B0),
                                        ),
                                      ),
                                      SizedBox(width: 12.36.sp),
                                      Expanded(
                                          child: RichText(
                                        text: TextSpan(
                                          text:
                                              'Your list will be sent to all the registered shops with in',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp,
                                            color: const Color(0xffB0B0B0),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: ' 3 Km ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15.sp,
                                                  color:
                                                      const Color(0xffB0B0B0),
                                                ).copyWith(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            TextSpan(
                                              text: 'from your home address.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15.sp,
                                                color: const Color(0xffB0B0B0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                  SizedBox(height: 13.sp),
                                  Row(
                                    textBaseline: TextBaseline.ideographic,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    children: [
                                      Text(
                                        '2.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                          color: const Color(0xffB0B0B0),
                                        ),
                                      ),
                                      SizedBox(width: 12.36.sp),
                                      Expanded(
                                        child: Text(
                                          'It will take anywhere between 3 to 12 hours before you get offers from shops.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp,
                                            color: const Color(0xffB0B0B0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 13.sp),
                                  Row(
                                    textBaseline: TextBaseline.ideographic,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    children: [
                                      Text(
                                        '3.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                          color: const Color(0xffB0B0B0),
                                        ),
                                      ),
                                      SizedBox(width: 12.36.sp),
                                      Expanded(
                                        child: Text(
                                          'Once sent, you cannot modify this list.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp,
                                            color: const Color(0xffB0B0B0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_userList.items.length <= 3)
                                    SizedBox(height: 13.sp),
                                  if (_userList.items.length <= 3)
                                    Row(
                                      textBaseline: TextBaseline.ideographic,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      children: [
                                        Text(
                                          '4.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp,
                                            color: const Color(0xffB0B0B0),
                                          ),
                                        ),
                                        SizedBox(width: 12.36.sp),
                                        Expanded(
                                          child: Text(
                                            'Sending a list with few items may not get enough offers from shops.',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15.sp,
                                              color: const Color(0xffB0B0B0),
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              SizedBox(height: 30.sp),
                              //send to shops button material
                              SizedBox(
                                height: 50,
                                width: 234.sp,
                                child: MaterialButton(
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                  color: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.orange, width: 2.0),
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  onPressed: () {
                                    sendList();
                                  },
                                  child: Text(
                                    'Send to Shops',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 18.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
          child: const Text(
            'Send to Shops',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      );

  Widget _groupedItemListView() => GetBuilder(
        init: _allListController,
        id: 'newList',
        builder: (ctr) => GroupedListView(
          physics: const BouncingScrollPhysics(),
          elements: _userList.items,
          groupBy: (ListItemModel element) => element.catName,
          indexedItemBuilder:
              (BuildContext context, dynamic element, int index) =>
                  ListItemCard(
            listItem: _userList.items[index],
            listId: widget.listId,
          ),
          groupSeparatorBuilder: (String value) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: AppColors().grey100,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                thickness: 1.sp,
              )
            ],
          ),
        ),
      );

  void saveList() {
    NetworkCall()
        .updateUserList(_userList, processStatus: 'draft', status: 'new');
    _allListController.update(['newList', 'fab']);
  }

  void sendList() {
    NetworkCall().updateUserList(_userList, success: true);
    _allListController.allListMap[widget.listId] = _userList
      ..custListStatus = 'sent';
    _allListController.update(['newList', 'sentList']);
    _homeController.homeTabController.animateTo(1);
    Get.back();
    Get.back();
  }

  @override
  void dispose() {
    _allListController.isTitleEditable.value = false;
    super.dispose();
  }
}
