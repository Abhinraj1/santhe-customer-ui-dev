import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/REEEEEEEEEEE/api_test/test.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/models/santhe_user_list_model.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:santhe/pages/login_pages/phone_number_login_page.dart';
import 'package:santhe/widgets/new_tab_widgets/user_list_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import '../../core/app_colors.dart';

class NewTabPage extends StatefulWidget {
  const NewTabPage({Key? key}) : super(key: key);

  @override
  _NewTabPageState createState() => _NewTabPageState();
}

enum NewListType { startFromNew, importFromOld }

class _NewTabPageState extends State<NewTabPage> {
  NewListType? _type = NewListType.startFromNew;
  final apiController = Get.find<APIs>();

  String listName = '';
  int totalCustList = 0;
  int custId =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;
  String? selectedValue;
  // List<UserList> items = Boxes.getUserListDB().values.map((e) => e).toList();

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<UserList> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (UserList item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: '${item.listId}',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.listName,
                style: GoogleFonts.mulish(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          //If it's last item, remove divider.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;

    Box<UserList> box = Boxes.getUserListDB();

    print(box.values.map((e) => e.listId).toList());

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Boxes.getUserListDB().values.length < 3
          ? FloatingActionButton(
              elevation: 0.0,
              onPressed: () async {
                setState(() {});
                if (custId == 404) {
                  print('login to continue');
                  Get.snackbar('Login to Continue',
                      'Please log in to sync your data and progress further...',
                      backgroundColor: Colors.orange, colorText: Colors.white);
                  Get.offAll(() => LoginScreen());
                }

                //todo have the same api do all the heavy lifting

                List<UserList> top5UserList =
                    apiController.userListsDB.length > 5
                        ? apiController.userListsDB
                            .getRange(apiController.userListsDB.length - 6,
                                apiController.userListsDB.length - 1)
                            .toList()
                        : apiController.userListsDB;

                int userListCount =
                    await apiController.getAllCustomerLists(custId);

                showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    barrierColor: const Color.fromARGB(165, 241, 241, 241),
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      ScreenUtil.init(
                          BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                              maxHeight: MediaQuery.of(context).size.height),
                          designSize: const Size(390, 844),
                          context: context,
                          minTextAdapt: true,
                          orientation: Orientation.portrait);
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          height: userListCount < 1
                              ? screenHeight * 40
                              : screenHeight * 50,
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
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              ScreenUtil.init(
                                  BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width,
                                      maxHeight:
                                          MediaQuery.of(context).size.height),
                                  designSize: const Size(390, 844),
                                  context: context,
                                  minTextAdapt: true,
                                  orientation: Orientation.portrait);
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 12.0),
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
                                                  style: GoogleFonts.mulish(
                                                    color: Colors.orange,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 24.sp,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 12.0),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Color(0xffe8e8e8),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 0.0),
                                          title: Text(
                                            'Create a new list',
                                            style: GoogleFonts.mulish(
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
                                              setState(() {
                                                _type = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 314.sp,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter a list name';
                                              }
                                              return null;
                                            },
                                            enabled: _type ==
                                                NewListType.startFromNew,
                                            autofocus: true,
                                            maxLength: 30,
                                            onChanged: (value) {
                                              listName = value;
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Enter list Name',
                                              hintStyle: GoogleFonts.mulish(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey),
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
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                    kTextFieldCircularBorderRadius),
                                                borderSide: BorderSide(
                                                    width: 1.0,
                                                    color:
                                                        AppColors().brandDark),
                                              ),
                                            ),
                                            style: GoogleFonts.mulish(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2.0),
                                        // start from an old list
                                        Visibility(
                                          visible: top5UserList.isNotEmpty
                                              ? true
                                              : false,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                minVerticalPadding: 0.0,
                                                contentPadding:
                                                    const EdgeInsets.all(0.0),
                                                title: Text(
                                                  'Start from an old list',
                                                  style: GoogleFonts.mulish(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                horizontalTitleGap: 0,
                                                leading: Radio<NewListType>(
                                                  value:
                                                      NewListType.importFromOld,
                                                  groupValue: _type,
                                                  onChanged:
                                                      (NewListType? value) {
                                                    setState(() {
                                                      _type = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 90.sw,
                                                height: 65.h,
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: SizedBox(
                                                        width: 314.w,
                                                        height: 65.h,
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                                child:
                                                                    DropdownButton2(
                                                          isExpanded: true,
                                                          hint: Text(
                                                            'Select',
                                                            style: GoogleFonts.mulish(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: Colors
                                                                    .grey),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          items:
                                                              _addDividersAfterItems(
                                                                  top5UserList),
                                                          customItemsHeight: 4,
                                                          value: selectedValue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              selectedValue =
                                                                  value
                                                                      as String;
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .keyboard_arrow_up,
                                                          ),
                                                          iconSize: 14,
                                                          iconEnabledColor:
                                                              Colors.grey,
                                                          iconDisabledColor:
                                                              Colors.grey
                                                                  .shade100,
                                                          buttonHeight: 50,
                                                          style: GoogleFonts
                                                              .mulish(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                          buttonWidth: 160,
                                                          buttonPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 14,
                                                                  right: 14),
                                                          buttonDecoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        kTextFieldCircularBorderRadius),
                                                            border: Border.all(
                                                              color:
                                                                  kTextFieldGrey,
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          buttonElevation: 0,
                                                          itemHeight: 40,
                                                          itemPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 14,
                                                                  right: 14),
                                                          dropdownMaxHeight:
                                                              200,
                                                          dropdownWidth: 314.sp,
                                                          dropdownPadding: null,
                                                          dropdownDecoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        kTextFieldCircularBorderRadius),
                                                            color: Colors
                                                                .grey.shade100,
                                                          ),
                                                          dropdownElevation: 0,
                                                          scrollbarRadius:
                                                              const Radius
                                                                  .circular(40),
                                                          scrollbarThickness: 6,
                                                          scrollbarAlwaysShow:
                                                              true,
                                                          offset: const Offset(
                                                              0, 0),
                                                        )),
                                                      ),
                                                    ),
                                                    if (_type ==
                                                        NewListType
                                                            .startFromNew)
                                                      Container(
                                                        color:
                                                            Colors.transparent,
                                                        width: 100.sw,
                                                        height: 100.sh,
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30.sp),
                                        SizedBox(
                                          width: 221.sp,
                                          height: 50.sp,
                                          child: MaterialButton(
                                            elevation: 0.0,
                                            highlightElevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            color: Colors.orange,
                                            onPressed: () async {
                                              if (listName.isNotEmpty &&
                                                  _type ==
                                                      NewListType
                                                          .startFromNew) {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  //add to user list to hive db
                                                  final box =
                                                      Boxes.getUserListDB();

                                                  if (custId == 404) {
                                                    print('login to continue');
                                                    Get.snackbar(
                                                        'Login to Continue',
                                                        'Please log in to sync your data and process futher...',
                                                        backgroundColor:
                                                            Colors.orange,
                                                        colorText:
                                                            Colors.white);
                                                    Get.offAll(() =>
                                                        const LoginScreen());
                                                  }
                                                  print(
                                                      'TOTAL USER LIST NUMBER: $userListCount');
                                                  print(
                                                      'New List Id: ${userListCount + 1}');
                                                  UserList newUserList =
                                                      UserList(
                                                    createListTime:
                                                        DateTime.now(),
                                                    custId: custId,
                                                    items: [],
                                                    listId: int.parse(
                                                        '$custId${userListCount + 1}'),
                                                    listName: listName,
                                                    processStatus: 'draft',
                                                    custListSentTime:
                                                        DateTime.now(),
                                                    custListStatus: 'new',
                                                    listOfferCounter: 0,
                                                    custOfferWaitTime:
                                                        DateTime.now(),
                                                  );
                                                  //add to firebase
                                                  int response =
                                                      await apiController
                                                          .addCustomerList(
                                                              newUserList,
                                                              custId,
                                                              'new');

                                                  if (response == 1) {
                                                    box.add(newUserList);
                                                  } else {
                                                    Get.dialog(const Card(
                                                      child: Center(
                                                        child: Text('Error!'),
                                                      ),
                                                    ));
                                                  }

                                                  //Dismiss the pop up
                                                  if (box.values.length == 3) {
                                                    Get.offAll(
                                                        () => const HomePage(),
                                                        transition: Transition
                                                            .noTransition);
                                                  } else {
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              } else if (listName.isEmpty &&
                                                  _type ==
                                                      NewListType
                                                          .startFromNew) {
                                                Get.snackbar(
                                                  '',
                                                  '',
                                                  titleText: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Text(
                                                        'Enter a List Name'),
                                                  ),
                                                  messageText: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Text(
                                                        'Please enter a new list name before continuing...'),
                                                  ),
                                                  margin: const EdgeInsets.all(
                                                      10.0),
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  backgroundColor: Colors.white,
                                                  shouldIconPulse: true,
                                                  icon: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      CupertinoIcons
                                                          .exclamationmark_triangle_fill,
                                                      color: Colors.orange,
                                                      size: 45,
                                                    ),
                                                  ),
                                                );
                                              } else if (_type ==
                                                  NewListType.importFromOld) {
                                                if (selectedValue != null) {
                                                  UserList oldUserList =
                                                      apiController
                                                          .userListsDB
                                                          .firstWhere((element) =>
                                                              element.listId ==
                                                              int.parse(
                                                                  selectedValue!));

                                                  UserList newImportedList = UserList(
                                                      createListTime:
                                                          DateTime.now(),
                                                      custId:
                                                          oldUserList.custId,
                                                      items: oldUserList.items,
                                                      listId: int.parse(
                                                          '$custId${userListCount + 1}'),
                                                      listName:
                                                          '(COPY) ${oldUserList.listName}',
                                                      custListSentTime:
                                                          oldUserList
                                                              .custListSentTime,
                                                      custListStatus:
                                                          oldUserList
                                                              .custListStatus,
                                                      listOfferCounter:
                                                          oldUserList
                                                              .listOfferCounter,
                                                      processStatus: oldUserList
                                                          .processStatus,
                                                      custOfferWaitTime:
                                                          oldUserList
                                                              .custOfferWaitTime);
                                                  //add to firebase
                                                  int response =
                                                      await apiController
                                                          .addCustomerList(
                                                              newImportedList,
                                                              custId,
                                                              'new');

                                                  if (response == 1) {
                                                    box.add(newImportedList);
                                                  } else {
                                                    Get.dialog(const Card(
                                                      child: Center(
                                                        child: Text('Error!'),
                                                      ),
                                                    ));
                                                  }

                                                  //Dismiss the pop up
                                                  if (box.values.length == 3) {
                                                    Get.offAll(
                                                        () => const HomePage(),
                                                        transition: Transition
                                                            .noTransition);
                                                  } else {
                                                    Navigator.pop(context);
                                                  }
                                                } else {
                                                  Get.snackbar(
                                                    '',
                                                    '',
                                                    titleText: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                          'Please select a list'),
                                                    ),
                                                    messageText: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                          'Else create a new list'),
                                                    ),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    backgroundColor:
                                                        Colors.white,
                                                    shouldIconPulse: true,
                                                    icon: const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .exclamationmark_triangle_fill,
                                                        color: Colors.orange,
                                                        size: 45,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                print(
                                                    'implement import feature');
                                              }
                                              await apiController
                                                  .getAllCustomerLists(custId);
                                            },
                                            child: Text(
                                              'Next',
                                              style: GoogleFonts.mulish(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 21.sp,
                                              ),
                                            ),
                                          ),
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
                    });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: screenWidth * 9,
                semanticLabel: 'Click here to create a new order!',
              ),
            )
          : null,
      body: ValueListenableBuilder<Box<UserList>>(
        valueListenable: Boxes.getUserListDB().listenable(),
        builder: (context, box, widget) {
          var userLists = box.values.toList().cast<UserList>();
          ScreenUtil.init(
              BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height),
              designSize: const Size(390, 844),
              context: context,
              minTextAdapt: true,
              orientation: Orientation.portrait);
          userLists.forEach((element) {
            print(element.listId);
          });
          return userLists.isEmpty
              ? SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // SizedBox(height: screenHeight * 23),
                        SizedBox(
                          height: screenWidth * 100,
                          width: screenWidth * 100,
                          child: SvgPicture.asset(
                            'assets/new_tab_image.svg',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 80.sp),
                          child: Stack(
                            children: [
                              Text(
                                'Get started by easily creating your\nshopping list',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: kTextGrey),
                              ),
                              SizedBox(
                                height: screenWidth * 40,
                                width: screenWidth * 50,
                                child: SvgPicture.asset(
                                  'assets/new_tab_arrow.svg',
                                  color: Colors.orange,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 3.0),
                  itemCount: userLists.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    print("NEW TAB PAGE");
                    print(userLists[index].listId);
                    return UserListCard(
                      userList: userLists[index],
                    );
                  },
                );
        },
      ),
    );
  }
}
