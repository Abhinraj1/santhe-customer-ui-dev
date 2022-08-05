import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:santhe/controllers/getx/all_list_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/models/offer/santhe_offer_item_model.dart';
import 'package:santhe/pages/chat/chat_screen.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:santhe/widgets/confirmation_widgets/success_snackbar_widget.dart';

import '../../controllers/api_service_controller.dart';
import '../../models/merchant_details_response.dart';
import '../../models/new_list/user_list_model.dart';
import '../../models/offer/customer_offer_response.dart';
import '../../models/offer/merchant_offer_response.dart';
import '../../widgets/sent_tab_widgets/merchant_item_card.dart';

class MerchantItemsListPage extends StatefulWidget {
  CustomerOfferResponse? currentMerchantOffer;
  final UserListModel userList;
  MerchantDetailsResponse? merchantResponse;
  bool archived;
  bool overrideData;

  MerchantItemsListPage(
      {this.currentMerchantOffer,
      Key? key,
      required this.userList,
      this.merchantResponse,
      this.archived = false,
      this.overrideData = false})
      : super(key: key);

  @override
  State<MerchantItemsListPage> createState() => _MerchantItemsListPageState();
}

class _MerchantItemsListPageState extends State<MerchantItemsListPage> with AutomaticKeepAliveClientMixin{

  MerchantOfferResponse? merchantOfferResponse;
  List<CustomerOfferResponse>? customerOfferResponse;

  Future<void> getDetails() async {
    final apiController = Get.find<APIs>();
    if (widget.archived) {
      customerOfferResponse ??= await apiController.getAllMerchOfferByListId(
          widget.userList.listId,
          widget.userList.items.length,
        );
      widget.currentMerchantOffer = customerOfferResponse!.firstWhere((element) => element.custOfferResponse.custOfferStatus == 'accepted');
      widget.merchantResponse ??= await apiController.getMerchantDetails(widget.currentMerchantOffer!.merchId.path.segments.last);
    }

    merchantOfferResponse ??= await apiController.getMerchantResponse(widget.currentMerchantOffer!.listEventId);
  }


  String removeDecimalZeroFormat(double n) {
    final itr = n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    return itr.replaceAll('.0', '');
  }


  final apiController = Get.find<APIs>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(widget.overrideData);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            leading: IconButton(
              splashRadius: 0.1,
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 20.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop(widget.overrideData);
              },
            ),
            title: Text(
              widget.archived
                  ? widget.userList.listName
                  : 'Offer Rs. ${widget.currentMerchantOffer!.merchResponse.merchTotalPrice}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp)
            ),
          ),
          body: FutureBuilder(
            future: getDetails(),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.done) {
                List<OfferItem> items = [];
                for (var element in merchantOfferResponse!.items) {
                  items.add(OfferItem(
                      brandType: element.brandType,
                      catName: element.catName,
                      itemId: '1',
                      itemImageId: element.itemImageId,
                      itemName: element.itemName,
                      itemNotes: element.itemNotes,
                      itemSeqNum: element.itemSeqNum,
                      merchAvailability: element.merchAvailability,
                      merchNotes: element.merchNotes,
                      merchPrice: double.parse(element.merchPrice),
                      quantity: double.parse(element.quantity),
                      unit: element.unit));
                }

                final sortItems = items;
                sortItems.sort((a, b) => a.catName.compareTo(b.catName));
                final firstCat = sortItems.first.catName;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: 60.h,
                      child: Center(
                        child: Text(
                          isDone() ? 'Offer Accepted' : 'Items and Price',
                          style: TextStyle(
                              color: isDone()
                                  ? AppColors().green100
                                  : AppColors().brandDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        ),
                      ),
                    ),
                    if (isDone())
                      SizedBox(
                        width: screenSize.width,
                        child: Stack(
                          children: [
                            if(isDone() && !widget.archived)
                              Container(
                                padding: const EdgeInsets.all(10),
                                color: AppColors().white100,
                                width: screenSize.width,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Image.asset(
                                      'assets/offers/store_icon.png',
                                      height: 60.h,
                                      width: 60.w,
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          if (widget.archived)
                                            SizedBox(
                                              height: 15.sp,
                                            ),
                                          Text(
                                            widget.merchantResponse!.fields
                                                .merchName.stringValue,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              widget.archived ? 20.sp : 24.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.sp,
                                          ),
                                          SizedBox(
                                            width: 240.w,
                                            child: Text(
                                              widget
                                                  .merchantResponse!
                                                  .fields
                                                  .contact
                                                  .mapValue
                                                  .fields
                                                  .address
                                                  .stringValue,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.sp,
                                          ),
                                          //contact number
                                          Row(
                                            children: [
                                              //phone icon
                                              CircleAvatar(
                                                radius: 15.sp,
                                                backgroundColor:
                                                AppColors().brandDark,
                                                child: Icon(
                                                  Icons.phone,
                                                  color: AppColors().white100,
                                                  size: 16.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.sp,
                                              ),
                                              //phone number
                                              Text(
                                                '+91-${widget.merchantResponse!.fields.contact.mapValue.fields.phoneNumber.integerValue}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors().brandDark,
                                                    fontSize: 16.sp),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              log(widget.merchantResponse!.fields
                                                  .merchId.integerValue +
                                                  widget.userList.listId
                                                      .toString());
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                    child: ChatScreen(
                                                      chatId: widget
                                                          .userList.listId
                                                          .toString(),
                                                      customerTitle: widget
                                                          .currentMerchantOffer!
                                                          .merchResponse
                                                          .merchTotalPrice,
                                                      listEventId: widget
                                                          .merchantResponse!
                                                          .fields
                                                          .merchId
                                                          .integerValue +
                                                          widget.userList.listId
                                                              .toString(),
                                                      merchantTitle:
                                                      // 'Request ${widget.currentMerchantOffer!.requestForDay} of ${DateFormat('yyyy-MM-dd').format(widget.currentMerchantOffer!.merchReqDate)}',
                                                      'Request ${widget.currentMerchantOffer!.requestForDay} of ${DateFormat('yyyy-MM-dd').format(widget.currentMerchantOffer!.merchReqDate)}',
                                                    ),
                                                    type: PageTransitionType
                                                        .rightToLeft),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 23.sp,
                                                  vertical: 5.sp),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10.sp)),
                                                  color: AppColors().brandDark),
                                              child: Text(
                                                "Chat",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if(isDone() && widget.archived)
                              Container(
                                padding: const EdgeInsets.all(10),
                                color: AppColors().white100,
                                width: screenSize.width,
                                height: screenSize.width/3 - 40.sp,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Image.asset(
                                      'assets/offers/store_icon.png',
                                      height: 60.h,
                                      width: 60.w,
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          if (widget.archived)
                                            SizedBox(
                                              height: 15.sp,
                                            ),
                                          Text(
                                            'Some Random Store',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              widget.archived ? 20.sp : 24.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.sp,
                                          ),
                                          SizedBox(
                                            width: 240.w,
                                            child: Text(
                                              'Addres: value lorem Ipsum, casa blanka lorett caster monte lorgeti 000000',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.sp,
                                          ),
                                          //contact number
                                          Row(
                                            children: [
                                              //phone icon
                                              CircleAvatar(
                                                radius: 15.sp,
                                                backgroundColor:
                                                AppColors().brandDark,
                                                child: Icon(
                                                  Icons.phone,
                                                  color: AppColors().white100,
                                                  size: 16.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.sp,
                                              ),
                                              //phone number
                                              Text(
                                                '+91-9999999999',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors().brandDark,
                                                    fontSize: 16.sp),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 23.sp,
                                                vertical: 5.sp),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.sp)),
                                                color: AppColors().brandDark),
                                            child: Text(
                                              "Chat",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (widget.archived)
                              Center(
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter:
                                    ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: SizedBox(
                                      height: screenSize.height / 3 - 40.sp,
                                      width: screenSize.width,
                                    ),
                                  ),
                                ),
                              ),
                            if (widget.archived)
                              SizedBox(
                                height: screenSize.height / 3 - 40.sp,
                                width: screenSize.width,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 10.h),
                                    color: AppColors().white100,
                                    alignment: Alignment.center,
                                    height: 65.h,
                                    width: screenSize.width,
                                    child: Text(
                                      'Merchant information will be available only upto 72 hours since the list was sent to shops.',
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          height: 1.5,
                                          fontSize: 15.sp,
                                          color: AppColors().grey80),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    if (widget.archived)
                      Container(
                        width: screenSize.width,
                        color: AppColors().white100,
                        child: Divider(
                          thickness: 1.sp,
                        ),
                      ),
                    Container(
                      width: screenSize.width,
                      color: AppColors().white100,
                      alignment: Alignment.center,
                      child: Text(
                        '${items.length} Items',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: GroupedListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          elements: items,
                          groupBy: (OfferItem offerItem) => offerItem.catName,
                          groupSeparatorBuilder: (String value) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 8.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.sp,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        value,
                                        style: TextStyle(
                                          color: AppColors().grey100,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (firstCat == value)
                                        Text(
                                          'Price',
                                          style: TextStyle(
                                            color: AppColors().brandDark,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.sp,
                                ),
                                Divider(
                                  thickness: 1.sp,
                                ),
                              ],
                            );
                          },
                          indexedItemBuilder:
                              (BuildContext context, dynamic element, int index) {
                            return MerchantItemCard(
                              merchantItem: items[index],
                              archived: widget.archived,
                            );
                          },
                        ),
                      ),
                    ),
                    isDone()
                        ? Container(
                      width: screenSize.width,
                      color: AppColors().white100,
                      padding: EdgeInsets.symmetric(vertical: 5.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Divider(
                            thickness: 1.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.w, right: 20.w, bottom: Platform.isIOS ? 20.h : 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24.sp,
                                      color: const Color(0xff8B8B8B)),
                                ),
                                Text(
                                  '₹ ${removeDecimalZeroFormat(double.parse(widget.currentMerchantOffer!.merchResponse.merchTotalPrice))}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17.sp,
                                      color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                        : const SizedBox.shrink(),
                    if (!isDone())
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                                color: AppColors().grey40,
                                style: BorderStyle.solid,
                                width: 1.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 25.0, right: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 24.sp,
                                        color: const Color(0xff8B8B8B)),
                                  ),
                                  Text(
                                    'Rs. ${removeDecimalZeroFormat(double.parse(widget.currentMerchantOffer!.merchResponse.merchTotalPrice))}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17.sp,
                                        color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 15.0,
                                  left: 15.0,
                                  bottom: Platform.isIOS ? 20.h : 10.h,
                                  top: 8.0),
                              child: SizedBox(
                                width: 234.sp,
                                height: 50.sp,
                                child: MaterialButton(
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                  onPressed: () {
                                    //CONFIRMATION BOTTOM SHEET
                                    showModalBottomSheet<void>(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      barrierColor: const Color.fromARGB(
                                          165, 241, 241, 241),
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        bool accepting = false;
                                        return StatefulBuilder(
                                          builder: (ctx, ss) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  const BorderRadius.only(
                                                    topRight:
                                                    Radius.circular(28.0),
                                                    topLeft:
                                                    Radius.circular(28.0),
                                                  ),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.shade400,
                                                      blurRadius: 14.0,
                                                    ),
                                                  ],
                                                ),
                                                child: SingleChildScrollView(
                                                  physics:
                                                  const BouncingScrollPhysics(),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        Stack(
                                                          children: <Widget>[
                                                            Center(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                                child: Text(
                                                                  'Are you sure?',
                                                                  style:
                                                                  TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                    fontSize:
                                                                    24.sp,
                                                                    color: Colors
                                                                        .orange,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .topRight,
                                                              child:
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Icon(
                                                                  Icons.close,
                                                                  color: Color(
                                                                      0xffeaeaea),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                            top: 18.sp,
                                                            left: 45.sp,
                                                            right: 45.sp,
                                                          ),
                                                          child: RichText(
                                                            textAlign:
                                                            TextAlign.center,
                                                            text: TextSpan(
                                                              text:
                                                              'You can accept',
                                                              style: TextStyle(
                                                                  fontSize: 18.sp,
                                                                  color:
                                                                  Colors.grey,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                  ' only ONE ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      18.sp,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                  'offer. If you accept this offer, all other offers will disappear',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      18.sp,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              top: 25.sp, bottom: Platform.isIOS ? 20.h : 10.h),
                                                          child: SizedBox(
                                                            height: accepting
                                                                ? 30.sp
                                                                : 50.sp,
                                                            width: accepting
                                                                ? 30.sp
                                                                : 234.sp,
                                                            child: accepting
                                                                ? const CircularProgressIndicator()
                                                                : MaterialButton(
                                                              onPressed:
                                                                  () async {
                                                                ss(() {
                                                                  accepting =
                                                                  true;
                                                                });
                                                                final CustomerOfferResponse?
                                                                response =
                                                                await apiController
                                                                    .acceptOffer(
                                                                  widget
                                                                      .userList
                                                                      .listId,
                                                                  widget
                                                                      .currentMerchantOffer!
                                                                      .listEventId,
                                                                );

                                                                // int response = 1;
                                                                // int response2 = 1;
                                                                if (response!=null) {
                                                                  widget.currentMerchantOffer = response;
                                                                  widget.merchantResponse = await apiController.getMerchantDetails(widget
                                                                      .currentMerchantOffer!
                                                                      .merchId
                                                                      .path
                                                                      .segments
                                                                      .last);
                                                                  successMsg(
                                                                      'Yay! Offer Accepted!',
                                                                      'Hope you had a pleasant time using the app.');
                                                                  final allListController =
                                                                  Get.find<
                                                                      AllListController>();
                                                                  allListController
                                                                      .allListMap[
                                                                  widget
                                                                      .userList
                                                                      .listId] = widget
                                                                      .userList
                                                                    ..processStatus =
                                                                        "accepted"
                                                                    ..listUpdateTime =
                                                                    DateTime.now();
                                                                  allListController
                                                                      .update([
                                                                    'sentList'
                                                                  ]);
                                                                  Get.back();
                                                                  setState(
                                                                          () {
                                                                        widget.overrideData =
                                                                        true;
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                } else {
                                                                  errorMsg(
                                                                      'Connectivity Error',
                                                                      'Some connectivity error has occurred, please try again later!');
                                                                }
                                                              },
                                                              color: Colors
                                                                  .orange,
                                                              elevation:
                                                              0.0,
                                                              highlightElevation:
                                                              0.0,
                                                              shape:
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    16.0),
                                                              ),
                                                              child: Text(
                                                                'Accept',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                    fontSize:
                                                                    18.sp),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  color: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Text(
                                    'Accept Offer',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                );
              }

              if (snapShot.hasError) {
                log(snapShot.toString());
                log(snapShot.error.toString());
                Get.back();
                return const Center(
                  child: Text('Error fetching merchant response'),
                );
              }

              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
          ),
    )
    );
  }

  bool isDone() {
    return widget.overrideData
        ? true
        : widget.userList.processStatus == 'accepted' ||
                widget.userList.processStatus == 'processed'
            ? true
            : false;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
