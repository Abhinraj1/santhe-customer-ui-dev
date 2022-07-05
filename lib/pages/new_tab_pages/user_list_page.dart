// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:easy_debounce/easy_debounce.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:resize/resize.dart';
// import 'package:flutter_svg/svg.dart';
//
// import 'package:get/get.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:santhe/constants.dart';
// import 'package:santhe/controllers/getx/all_list_controller.dart';
// import 'package:santhe/core/app_colors.dart';
// import 'package:santhe/models/new_list/list_item_model.dart';
// import 'package:santhe/pages/new_tab_pages/categories_page.dart';
// import '../../controllers/api_service_controller.dart';
// import '../../controllers/boxes_controller.dart';
// import '../../models/new_list/user_list_model.dart';
// import '../../models/santhe_item_model.dart';
// import '../../widgets/new_tab_widgets/user_list_widgets/list_item_card.dart';
//
// class UserListPage extends StatefulWidget {
//   final String listId;
//
//   const UserListPage({required this.listId, Key? key})
//       : super(key: key);
//
//   @override
//   _UserListPageState createState() => _UserListPageState();
// }
//
// class _UserListPageState extends State<UserListPage>
//     with WidgetsBindingObserver {
//   bool safeGuard = false;
//   bool listNameEditFlag = false;
//
//   String newListName = '';
//   String searchQuery = '';
//
//   final searchQueryController = TextEditingController();
//   late Future<List<Item>> searchedItemsResult;
//
//   void clearSearchQuery() {
//     searchQueryController.clear();
//     searchQuery = '';
//     setState(() {});
//   }
//
//   void _latestSearchQuery() {
//     setState(() {
//       searchQuery = searchQueryController.text;
//     });
//   }
//
//   final AllListController _allListController = Get.find();
//
//   final apiController = Get.find<APIs>();
//
//   late UserListModel currentList = _allListController.allListMap[widget.listId]!;
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
// /*if (state == AppLifecycleState.paused) {
//       int custId = Boxes.getUserCredentialsDB()
//           .get('currentUserCredentials')!
//           .phoneNumber;
//       apiController.updateUserList(custId, box.get(widget.userKey)!,
//           status: 'new');
//     }*/
//
//   }
//
//   @override
//   void initState() {
//     searchQueryController.addListener(_latestSearchQuery);
//     searchedItemsResult = Future.value([]);
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
// searchQueryController.dispose();
//     int custId = Boxes.getUserCredentialsDB().get('currentUserCredentials')!.phoneNumber;
//    // apiController.updateUserList(custId, box.get(widget.userKey)!, status: 'new');
//
//     super.dispose();
//   }
//
//   final TextStyle popupTextStyle = TextStyle(
//     fontWeight: FontWeight.w400,
//     fontSize: 13.sp,
//     color: const Color(0xffB0B0B0),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final buildContext = context;
//
//     double screenWidth = MediaQuery.of(context).size.width / 100;
//     double screenHeight = MediaQuery.of(context).size.height / 100;
//     final TextStyle popupTextStyle = TextStyle(
//       fontWeight: FontWeight.w400,
//       fontSize: screenWidth * 3.5,
//       color: const Color(0xffB0B0B0),
//     );
//
//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           elevation: 0.0,
//           toolbarHeight: screenHeight * 5.5,
//           leading: IconButton(
//             splashRadius: 0.1,
//             icon: Icon(
//               Icons.arrow_back_ios_rounded,
//               size: 13.sp,
//             ),
//             onPressed: () async {
//               Navigator.pop(context);
//             },
//           ),
//           title: listNameEditFlag
//               ? Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 30),
//                   child: SizedBox(
//                     height: screenHeight * 4.5,
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16.0)),
//                       child: Stack(children: [
//                         TextFormField(
//                           autofocus: true,
//                           initialValue: currentList.listName,
//                           // enableInteractiveSelection: false,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontSize: 14.0,
//                           ),
//                           cursorHeight: 18.sp,
//                           maxLength: 30,
//                           decoration: InputDecoration(
//                             isDense: true,
//                             contentPadding: const EdgeInsets.only(
//                                 top: 10.0,
//                                 bottom: 10.0,
//                                 right: 30.0,
//                                 left: 30.0),
//                             counterText: '',
//
//                             // hintText: userList.listName,
//                             hintStyle: const TextStyle(
//                               fontWeight: FontWeight.w300,
//                               color: Colors.grey,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(21),
//                               borderSide: const BorderSide(
//                                   width: 0.0, color: Colors.transparent),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(21),
//                               borderSide: const BorderSide(
//                                   width: 0.0, color: Colors.transparent),
//                             ),
//                           ),
//
//                           onChanged: (String value) {
//                             newListName = value;
//                           },
//                           onEditingComplete: () {
//                             if (newListName.isNotEmpty) {
//                               _allListController.allListMap[currentList.listId]?.listName = newListName;
//                               currentList.listName = newListName;
//                               setState(() {
//                                 listNameEditFlag = false;
//                               });
//                             }
//                           },
//                         ),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 listNameEditFlag = false;
//                               });
//                               if (newListName.isNotEmpty) {
//                                 _allListController.allListMap[currentList.listId]?.listName = newListName;
//                                 currentList.listName = newListName;
//                                 setState(() {
//                                   listNameEditFlag = false;
//                                 });
//                               }
//                             },
//                             child: const Padding(
//                               padding: EdgeInsets.only(right: 3.0),
//                               child: Icon(
//                                 CupertinoIcons.check_mark_circled_solid,
//                                 color: Colors.orange,
//                                 size: 26,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ]),
//                     ),
//                   ),
//                 )
//               : Text(
//                   currentList.listName,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 18.sp),
//                 ),
//           actions: [
//             Visibility(
//               visible: !listNameEditFlag,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 8, bottom: 0),
//                 child: IconButton(
//                   splashRadius: 0.1,
//                   icon: const Icon(
//                     CupertinoIcons.pencil_circle_fill,
//                     size: 24,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       listNameEditFlag = true;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             Visibility(
//               visible: listNameEditFlag,
//               child: IconButton(
//                 splashRadius: 0.1,
//                 icon: Icon(
//                   CupertinoIcons.pencil_circle_fill,
//                   size: 24.sp,
//                   color: Colors.transparent,
//                 ),
//                 onPressed: () {},
//               ),
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               //search text field
//               TextFormField(
//                 controller: searchQueryController,
//                 textAlignVertical: TextAlignVertical.center,
//                 textAlign: TextAlign.left,
//                 textInputAction: TextInputAction.done,
//                 onChanged: (value) {
//                   if (value.length > 2) {
//                     EasyDebounce.debounce(
//                         'searchItem', const Duration(milliseconds: 500), () {
//                       setState(() {
//                         searchedItemsResult =
//                             apiController.searchedItemResult(value);
//                       });
//                     });
//                   }
//                 },
//                 style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xff8B8B8B),
//                     fontSize: 16.sp),
//                 decoration: InputDecoration(
//                     suffixIcon: Visibility(
//                       visible: searchQueryController.text.isNotEmpty,
//                       child: IconButton(
//                         icon: const Icon(
//                           CupertinoIcons.xmark,
//                           color: Color(0xffE0E0E0),
//                           size: 21,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             searchQueryController.clear();
//                           });
//                         },
//                       ),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(vertical: 9.0),
//                     prefixIcon: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 9.0),
//                       child: Icon(
//                         CupertinoIcons.search_circle_fill,
//                         size: 32,
//                         color: Colors.orange,
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.only(
//                         topLeft: const Radius.circular(16),
//                         topRight: const Radius.circular(16),
//                         bottomRight: searchQuery.length < 3
//                             ? const Radius.circular(16)
//                             : const Radius.circular(0),
//                         bottomLeft: searchQuery.length < 3
//                             ? const Radius.circular(16)
//                             : const Radius.circular(0),
//                       ),
//                       borderSide:
//                           BorderSide(width: 1.0, color: Colors.grey.shade400),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.only(
//                         topLeft: const Radius.circular(16),
//                         topRight: const Radius.circular(16),
//                         bottomRight: searchQuery.length < 3
//                             ? const Radius.circular(16)
//                             : const Radius.circular(0),
//                         bottomLeft: searchQuery.length < 3
//                             ? const Radius.circular(16)
//                             : const Radius.circular(0),
//                       ),
//                       borderSide: BorderSide(
//                           width: searchQuery.length < 3 ? 1.0 : 2.0,
//                           color: Colors.grey.shade400),
//                     ),
//                     hintStyle: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         color: Colors.grey.shade500,
//                         fontStyle: FontStyle.italic,
//                         fontSize: 18.sp),
//                     hintText: 'Search and add products...'),
//               ),
//               //top item counter widget
//               Expanded(
//                 child: Stack(
//                   children: [
//                     Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(top: 15.sp, bottom: 0.0),
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 8.0),
//                             child: Text(
//                               '${currentList.items.length} ${currentList.items.length < 2 ? 'Item' : 'Items'}',
//                               style: TextStyle(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.black54),
//                             ),
//                           ),
//                         ),
//                         //main component---------------------------------------
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 8.0, right: 8.0, bottom: 8.0),
//                             child: currentList.items.isNotEmpty
//                                 ? GroupedListView(
//                                     physics: const BouncingScrollPhysics(),
//                                     elements: currentList.items,
//                                     groupBy: (ListItemModel element) => element.catName,
//                                     indexedItemBuilder: (BuildContext context, dynamic element, int index) => ListItemCard(
//                                       listItem: currentList.items[index], listId: '',
//                                     ),
//                                     groupSeparatorBuilder: (String value) {
//                                       return Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(value),
//                                           const Divider(
//                                             color: Colors.grey,
//                                             thickness: 1,
//                                           )
//                                         ],
//                                       );
//                                     },
//                                   )
//                                 : SizedBox(
//                               height: double.infinity,
//                               width: double.infinity,
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.center,
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                             left: screenWidth * 20),
//                                         child: SizedBox(
//                                           height: screenHeight * 24,
//                                           child: SvgPicture.asset(
//                                             'assets/search_items_pointer_arrow.svg',
//                                             width: screenWidth * 50,
//                                             color: Colors.orange,
//                                           ),
//                                         ),
//                                       ),
//                                       const Text(
//                                         'Add your item by searching',
//                                         style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     children: [
//                                       const Text(
//                                         'Add your item from catalog',
//                                         style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: screenHeight * 20,
//                                         child: SvgPicture.asset(
//                                           'assets/item_catalog_arrow.svg',
//                                           width: screenWidth * 70,
//                                           color: Colors.orange,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         //BUTTONS
//                         currentList.items.length >= 2
//                             ? Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceEvenly,
//                           children: [
//                             SizedBox(
//                               height: 55,
//                               width: screenWidth * 65,
//                               child: MaterialButton(
//                                 elevation: 0.0,
//                                 highlightElevation: 0.0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(16.0)),
//                                 color:
//                                 currentList.items.length < 2
//                                     ? AppColors().grey40
//                                     : Colors.orange,
//                                 onPressed: () {
//                                   // SnackBar snackBar = const SnackBar(
//                                   //     content: Text('Sending to Shops...'));
//                                   // ScaffoldMessenger.of(context)
//                                   //     .showSnackBar(snackBar);
//
//                                   //SEND TO SHOP BOTTOM SHEET
//                                   showModalBottomSheet<void>(
//                                       backgroundColor:
//                                       Colors.transparent,
//                                       context: context,
//                                       barrierColor:
//                                       const Color.fromARGB(
//                                           165, 241, 241, 241),
//                                       isScrollControlled: true,
//                                       builder: (ctx) {
//                                         return Padding(
//                                           padding: EdgeInsets.only(
//                                               bottom:
//                                               MediaQuery.of(ctx)
//                                                   .viewInsets
//                                                   .bottom),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                               BorderRadius.only(
//                                                 topRight:
//                                                 Radius.circular(
//                                                     30.r),
//                                                 topLeft:
//                                                 Radius.circular(
//                                                     30.r),
//                                               ),
//                                               color: Colors.white,
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors
//                                                       .grey.shade300,
//                                                   blurRadius: 16.0,
//                                                 ),
//                                               ],
//                                             ),
//                                             //giving a new context so that modal sheet can also set state
//                                             child:
//                                             SingleChildScrollView(
//                                               physics:
//                                               const BouncingScrollPhysics(),
//                                               child: Padding(
//                                                 padding:
//                                                 EdgeInsets.all(
//                                                     23.sp),
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .center,
//                                                   mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceEvenly,
//                                                   children: <Widget>[
//                                                     Row(
//                                                       children: [
//                                                         Column(
//                                                           children: const [
//                                                             Icon(
//                                                                 Icons
//                                                                     .close,
//                                                                 color:
//                                                                 Colors.transparent),
//                                                             SizedBox(
//                                                               height:
//                                                               30.0,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Expanded(
//                                                           child: Text(
//                                                             'Send list to shops\nnear you',
//                                                             textAlign:
//                                                             TextAlign
//                                                                 .center,
//                                                             style:
//                                                             TextStyle(
//                                                               color: Colors
//                                                                   .orange,
//                                                               fontWeight:
//                                                               FontWeight.w700,
//                                                               fontSize:
//                                                               24.sp,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Column(
//                                                           children: [
//                                                             GestureDetector(
//                                                               onTap:
//                                                                   () {
//                                                                 Navigator.pop(
//                                                                     ctx);
//                                                               },
//                                                               child: const Icon(
//                                                                   Icons
//                                                                       .close,
//                                                                   color:
//                                                                   kTextFieldGrey),
//                                                             ),
//                                                             const SizedBox(
//                                                               height:
//                                                               30.0,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Image.asset(
//                                                       'assets/send_to_shops.gif',
//                                                       height: 235.sp,
//                                                       width: 344.sp,
//                                                     ),
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .start,
//                                                       children: [
//                                                         Row(
//                                                           textBaseline:
//                                                           TextBaseline
//                                                               .ideographic,
//                                                           crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .baseline,
//                                                           children: [
//                                                             Text(
//                                                               '1.',
//                                                               style:
//                                                               popupTextStyle,
//                                                             ),
//                                                             SizedBox(
//                                                                 width:
//                                                                 12.36.sp),
//                                                             Expanded(
//                                                                 child:
//                                                                 RichText(
//                                                                   text:
//                                                                   TextSpan(
//                                                                     text:
//                                                                     'Your list will be sent to all the registered shops with in',
//                                                                     style:
//                                                                     popupTextStyle,
//                                                                     children: <
//                                                                         TextSpan>[
//                                                                       TextSpan(
//                                                                           text: ' 3 Km ',
//                                                                           style: popupTextStyle.copyWith(fontWeight: FontWeight.w700)),
//                                                                       TextSpan(
//                                                                         text: 'from your home address.',
//                                                                         style: popupTextStyle,
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 )),
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                             height: 13
//                                                                 .sp),
//                                                         Row(
//                                                           textBaseline:
//                                                           TextBaseline
//                                                               .ideographic,
//                                                           crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .baseline,
//                                                           children: [
//                                                             Text(
//                                                               '2.',
//                                                               style:
//                                                               popupTextStyle,
//                                                             ),
//                                                             SizedBox(
//                                                                 width:
//                                                                 12.36.sp),
//                                                             Expanded(
//                                                               child:
//                                                               Text(
//                                                                 'It will take anywhere between 3 to 12 hours before you get offers from shops.',
//                                                                 style:
//                                                                 popupTextStyle,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                             height: 13
//                                                                 .sp),
//                                                         Row(
//                                                           textBaseline:
//                                                           TextBaseline
//                                                               .ideographic,
//                                                           crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .baseline,
//                                                           children: [
//                                                             Text(
//                                                               '3.',
//                                                               style:
//                                                               popupTextStyle,
//                                                             ),
//                                                             SizedBox(
//                                                                 width:
//                                                                 12.36.sp),
//                                                             Expanded(
//                                                               child:
//                                                               Text(
//                                                                 'Once sent, you cannot modify this list.',
//                                                                 style:
//                                                                 popupTextStyle,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         if (currentList
//                                                             .items
//                                                             .length <=
//                                                             3)
//                                                           SizedBox(
//                                                               height:
//                                                               13.sp),
//                                                         if (currentList
//                                                             .items
//                                                             .length <=
//                                                             3)
//                                                           Row(
//                                                             textBaseline:
//                                                             TextBaseline
//                                                                 .ideographic,
//                                                             crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .baseline,
//                                                             children: [
//                                                               Text(
//                                                                 '4.',
//                                                                 style:
//                                                                 popupTextStyle,
//                                                               ),
//                                                               SizedBox(
//                                                                   width:
//                                                                   12.36.sp),
//                                                               Expanded(
//                                                                 child:
//                                                                 Text(
//                                                                   'Sending a list with few items may not get enough offers from shops.',
//                                                                   style:
//                                                                   TextStyle(
//                                                                     fontWeight: FontWeight.w800,
//                                                                     fontSize: screenWidth * 3.5,
//                                                                     color: const Color(0xffB0B0B0),
//                                                                   ),
//                                                                   softWrap:
//                                                                   true,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(
//                                                         height:
//                                                         30.sp),
//                                                     //send to shops button material
//                                                     SizedBox(
//                                                       height: 50,
//                                                       width: 234.sp,
//                                                       child:
//                                                       MaterialButton(
//                                                         elevation:
//                                                         0.0,
//                                                         highlightElevation:
//                                                         0.0,
//                                                         color: Colors
//                                                             .orange,
//                                                         shape: RoundedRectangleBorder(
//                                                             side: const BorderSide(
//                                                                 color: Colors
//                                                                     .orange,
//                                                                 width:
//                                                                 2.0),
//                                                             borderRadius:
//                                                             BorderRadius.circular(
//                                                                 16.0)),
//                                                         onPressed:
//                                                             () {
//                                                           sendList();
//                                                         },
//                                                         child: Text(
//                                                           'Send to Shops',
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                               FontWeight
//                                                                   .w700,
//                                                               color: Colors
//                                                                   .white,
//                                                               fontSize:
//                                                               18.sp),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       });
//                                 },
//                                 child: const Text(
//                                   'Send to Shops',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 53,
//                               width: 77.sp,
//                               child: MaterialButton(
//                                 elevation: 0.0,
//                                 highlightElevation: 0.0,
//                                 splashColor: Colors.transparent,
//                                 shape: RoundedRectangleBorder(
//                                     side: const BorderSide(
//                                         color: Colors.orange,
//                                         width: 2.0),
//                                     borderRadius:
//                                     BorderRadius.circular(16.0)),
//                                 color: Colors.white,
//                                 onPressed: () {
//                                   //todo implement category / catalog page opening
//                                   Get.to(() => CategoriesPage(listId: currentList.listId));
//                                 },
//                                 child: const Icon(
//                                   CupertinoIcons.square_grid_2x2,
//                                   color: Colors.orange,
//                                   size: 35,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                             : SizedBox(
//                           height: 50,
//                           width: 325.sp,
//                           child: MaterialButton(
//                             elevation: 0.0,
//                             highlightElevation: 0.0,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(16.0)),
//                             color: Colors.orange,
//                             onPressed: () {
//                               Get.to(() => CategoriesPage(listId: currentList.listId));
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: screenWidth * 4.5),
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.center,
//                                 children: const [
//                                   Icon(
//                                     CupertinoIcons.square_grid_2x2,
//                                     color: Colors.white,
//                                     size: 28,
//                                   ),
//                                   Expanded(
//                                     child: Center(
//                                       child: AutoSizeText(
//                                         'Item Catalog',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Icon(
//                                     CupertinoIcons.square_grid_2x2,
//                                     color: Colors.transparent,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     //SEARCH COMPONENT-------------------------------
//                     Visibility(
//                       visible: searchQuery.length > 2,
//                       child: ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(16),
//                           bottomRight: Radius.circular(16),
//                         ),
//                         child: Container(
//                           width: double.infinity,
//                           constraints: BoxConstraints(
//                             maxHeight:
//                                 MediaQuery.of(context).viewInsets.bottom != 0
//                                     ? (screenHeight * 100) / 3
//                                     : (screenHeight * 100) / 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.97),
//                             borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(16),
//                               bottomRight: Radius.circular(16),
//                             ),
//                             border: Border.all(
//                                 color: Colors.grey.shade300, width: 2),
//                           ),
//                           child: searchQuery.length > 2
//                               ? FutureBuilder(
//                                   future: searchedItemsResult,
//                                   builder: (BuildContext context,
//                                       AsyncSnapshot<dynamic> snapshot) {
//                                     if (snapshot.hasError) {
//                                       //todo show proper error screen
//                                       return Text('${snapshot.error}');
//                                     } else if (snapshot.connectionState ==
//                                             ConnectionState.done &&
//                                         snapshot.hasData &&
//                                         snapshot.data.length < 1) {
//                                       return Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: SizedBox(
//                                           height: screenHeight * 12 < 120
//                                               ? 120
//                                               : screenHeight * 12,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               /*InkWell(
//                                                 onTap: () {
//                                                   FocusManager
//                                                       .instance.primaryFocus
//                                                       ?.unfocus();
//                                                   showDialog(
//                                                       context: context,
//                                                       barrierColor:
//                                                           const Color.fromARGB(
//                                                               165,
//                                                               241,
//                                                               241,
//                                                               241),
//                                                       builder: (context) {
//                                                         return CustomItemPopUpWidget(
//                                                             currentUserListDBKey:
//                                                                 widget.userKey,
//                                                             searchQuery:
//                                                                 searchQuery);
//                                                       }).then((value) {
//                                                     searchQueryController
//                                                         .clear();
//                                                     searchQuery = '';
//                                                     setState(() {});
//                                                   });
//                                                 },
//                                                 child: AddCustomItemCard(
//                                                   currentUserListDBKey:
//                                                       widget.userKey,
//                                                   searchQuery: searchQuery,
//                                                 ),
//                                               ),*/
//                                               const Padding(
//                                                 padding:
//                                                     EdgeInsets.only(left: 20.0),
//                                                 child: Text(
//                                                   'No Search Results Found...',
//                                                   style: TextStyle(
//                                                       fontStyle:
//                                                           FontStyle.italic),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     } else if (snapshot.hasData &&
//                                         snapshot.connectionState ==
//                                             ConnectionState.done) {
//                                       return ListView.builder(
//                                         shrinkWrap: true,
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 8.0, horizontal: 8.0),
//                                         itemCount: snapshot.data?.length,
//                                         keyboardDismissBehavior:
//                                             ScrollViewKeyboardDismissBehavior
//                                                 .onDrag,
//                                         itemBuilder: (context, index) {
//                                           if (index ==
//                                               snapshot.data?.length - 1) {
//                                             return Column(
//                                               children: [
//                                                 /*InkWell(
//                                                   onTap: () {
//                                                     FocusManager
//                                                         .instance.primaryFocus
//                                                         ?.unfocus();
//                                                     showDialog(
//                                                         context: buildContext,
//                                                         barrierColor:
//                                                             const Color
//                                                                     .fromARGB(
//                                                                 165,
//                                                                 241,
//                                                                 241,
//                                                                 241),
//                                                         builder: (context) {
//                                                           return NewItemPopUpWidget(
//                                                               item: snapshot
//                                                                   .data![index],
//                                                               fromSearch: true,
//                                                               currentUserListDBKey:
//                                                                   widget
//                                                                       .userKey);
//                                                         }).then((value) {
//                                                       searchQueryController
//                                                           .clear();
//                                                       searchQuery = '';
//                                                       setState(() {});
//                                                     });
//                                                   },
//                                                   child: SearchedItemCard(
//                                                     key: ValueKey(
//                                                         (snapshot.data![index]
//                                                                 as Item)
//                                                             .itemId),
//                                                     searchQuery: searchQuery,
//                                                     currentUserListDBKey:
//                                                         widget.userKey,
//                                                     item: snapshot.data![index],
//                                                     clearSearchQuery:
//                                                         clearSearchQuery,
//                                                   ),
//                                                 ),
//                                                 InkWell(
//                                                     onTap: () {
//                                                       FocusManager
//                                                           .instance.primaryFocus
//                                                           ?.unfocus();
//                                                       showDialog(
//                                                           context: buildContext,
//                                                           barrierColor:
//                                                               const Color
//                                                                       .fromARGB(
//                                                                   165,
//                                                                   241,
//                                                                   241,
//                                                                   241),
//                                                           builder: (context) {
//                                                             return CustomItemPopUpWidget(
//                                                                 currentUserListDBKey:
//                                                                     widget
//                                                                         .userKey,
//                                                                 searchQuery:
//                                                                     searchQuery);
//                                                           }).then((value) {
//                                                         searchQueryController
//                                                             .clear();
//                                                         searchQuery = '';
//                                                         setState(() {});
//                                                       });
//                                                     },
//                                                     child: AddCustomItemCard(
//                                                         currentUserListDBKey:
//                                                             widget.userKey,
//                                                         searchQuery:
//                                                             searchQuery)),*/
//                                               ],
//                                             );
//                                           } else {
//                                             return SizedBox();
//                                             /*return InkWell(
//                                               onTap: () {
//                                                 FocusManager
//                                                     .instance.primaryFocus
//                                                     ?.unfocus();
//                                                 showDialog(
//                                                     context: buildContext,
//                                                     barrierColor:
//                                                         const Color.fromARGB(
//                                                             165, 241, 241, 241),
//                                                     builder: (context) {
//                                                       return NewItemPopUpWidget(
//                                                           item: snapshot
//                                                               .data![index],
//                                                           fromSearch: true,
//                                                           currentUserListDBKey:
//                                                               widget.userKey);
//                                                     }).then((value) {
//                                                   searchQueryController.clear();
//                                                   searchQuery = '';
//                                                   setState(() {});
//                                                 });
//                                               },
//                                               child: SearchedItemCard(
//                                                 key: ValueKey((snapshot
//                                                         .data![index] as Item)
//                                                     .itemId),
//                                                 searchQuery: searchQuery,
//                                                 currentUserListDBKey:
//                                                     widget.userKey,
//                                                 item: snapshot.data![index],
//                                                 clearSearchQuery:
//                                                     clearSearchQuery,
//                                               ),
//                                             );*/
//                                           }
//                                         },
//                                       );
//                                     } else {
//                                       return Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: screenWidth * 41.2,
//                                             vertical: screenHeight * 15),
//                                         child:
//                                             const CircularProgressIndicator(),
//                                       );
//                                     }
//                                   },
//                                 )
//                               : null,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void sendList() async {
//     /*UserListModel currentUserList = UserListModel(
//         listOfferCounter: '0',
//         custId: currentList.custId,
//         custListSentTime: DateTime.now(),
//         custListStatus: 'sent',
//         items: currentList.items,
//         listId: currentList.listId,
//         listName: currentList.listName,
//         createListTime: currentList.createListTime,
//         processStatus: 'draft',
//         custOfferWaitTime: currentList.custOfferWaitTime,
//         updateListTime: DateTime.now(),
//     );
//
//     //todo send list to firebase (currentUserList)
//     int custId = Boxes.getUserCredentialsDB()
//             .get('currentUserCredentials')
//             ?.phoneNumber ??
//         404;
//     if (custId == 404) {
//       Get.off(() => const LoginScreen());
//     }
//     int response = await apiController.updateUserList(custId, currentUserList);
//
//     if (response == 1) {
//       //dismiss page
//       successMsg('List Sent', 'List has been successfully sent to merchants.');
//       Get.off(
//           () => const HomePage(
//                 pageIndex: 1,
//               ),
//           transition: Transition.leftToRight);
//
//       Future.delayed(const Duration(seconds: 2), () {
//         box.values
//             .singleWhere((element) => element.listId == userList.listId)
//             .delete();
//       });
//     } else {
//       errorMsg('Connectivity Error',
//           'Some connectivity error has occurred, please try again later!');
//     }*/
//   }
// }
