import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/models/offer/santhe_offer_item_model.dart';
import 'package:santhe/pages/chat/chat_screen.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:santhe/widgets/confirmation_widgets/success_snackbar_widget.dart';

import '../../controllers/api_service_controller.dart';
import '../../core/app_theme.dart';
import '../../models/merchant_details_response.dart';
import '../../models/offer/customer_offer_response.dart';
import '../../models/offer/merchant_offer_response.dart';
import '../../models/santhe_user_list_model.dart';
import '../../widgets/sent_tab_widgets/merchant_item_card.dart';

class MerchantItemsListPage extends StatelessWidget {
  CustomerOfferResponse? currentMerchantOffer;
  final UserList userList;
  MerchantDetailsResponse? merchantResponse;
  bool archived;

  MerchantItemsListPage(
      {this.currentMerchantOffer,
      Key? key,
      required this.userList,
      this.merchantResponse,
      this.archived = false})
      : super(key: key);

  Future<MerchantOfferResponse> getDetails() async {
    final apiController = Get.find<APIs>();
    if (archived) {
      final data =
          await apiController.getAllMerchOfferByListId(userList.listId);
      currentMerchantOffer = data.firstWhere(
          (element) => element.custOfferResponse.custOfferStatus == 'accepted');
      merchantResponse = await apiController
          .getMerchantDetails(currentMerchantOffer!.merchId.path.segments.last);
    }

    return await apiController
        .getMerchantResponse(currentMerchantOffer!.listEventId);
  }

  @override
  Widget build(BuildContext context) {
    final apiController = Get.find<APIs>();
    final screenSize = MediaQuery.of(context).size;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    String removeDecimalZeroFormat(double n) {
      return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    }

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return FutureBuilder<MerchantOfferResponse>(
      future: getDetails(),
      builder: (context, snapShot) {
        if (snapShot.data != null &&
            snapShot.connectionState == ConnectionState.done) {
          List<OfferItem> _items = [];
          for (var element in snapShot.data!.fields.items.arrayValue.values) {
            _items.add(OfferItem(
                brandType: element.mapValue.fields.brandType.stringValue,
                catName: element.mapValue.fields.catName.stringValue,
                itemId: element.mapValue.fields.itemId.referenceValue,
                itemImageId: element.mapValue.fields.itemImageId.stringValue,
                itemName: element.mapValue.fields.itemName.stringValue,
                itemNotes: element.mapValue.fields.itemNotes.stringValue,
                itemSeqNum:
                    int.parse(element.mapValue.fields.itemSeqNum.integerValue),
                merchAvailability:
                    element.mapValue.fields.merchAvailability.booleanValue,
                merchNotes: element.mapValue.fields.merchNotes.stringValue,
                merchPrice: double.parse(
                    element.mapValue.fields.merchPrice.stringValue),
                quantity:
                    double.parse(element.mapValue.fields.quantity.stringValue),
                unit: element.mapValue.fields.unit.stringValue));
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: screenHeight * 5.5,
              leading: IconButton(
                splashRadius: 0.1,
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 13.sp,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Offer Rs. ${currentMerchantOffer!.merchResponse.merchTotalPrice}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: 60.sp,
                  child: Center(
                    child: Text(
                      isDone() ? 'Offer Accepted' : 'Items and Price',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color:
                              isDone() ? AppColors().green100 : Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp),
                    ),
                  ),
                ),
                if (isDone())
                  SizedBox(
                    width: screenSize.width,
                    height: screenSize.height / 3 + 10,
                    child: Stack(
                      children: [
                        isDone()
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                color: AppColors().white100,
                                width: screenSize.width,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    Image.asset(
                                      'assets/offers/store_icon.png',
                                      height: 75.h,
                                    ),
                                    SizedBox(
                                      width: 19.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10.sp,
                                          ),
                                          Text(
                                            merchantResponse!
                                                .fields.merchName.stringValue,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 29.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.sp,
                                          ),
                                          SizedBox(
                                            width: 240.w,
                                            child: Text(
                                              merchantResponse!
                                                  .fields
                                                  .contact
                                                  .mapValue
                                                  .fields
                                                  .address
                                                  .stringValue,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18.sp,
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
                                                radius: 18.sp,
                                                backgroundColor:
                                                    AppColors().brandDark,
                                                child: Icon(
                                                  Icons.phone,
                                                  color: AppColors().white100,
                                                  size: 15.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.sp,
                                              ),
                                              //phone number
                                              Text(
                                                '+91-' +
                                                    merchantResponse!
                                                        .fields
                                                        .contact
                                                        .mapValue
                                                        .fields
                                                        .phoneNumber
                                                        .integerValue,
                                                style: AppTheme().bold700(16,
                                                    color:
                                                        AppColors().brandDark),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              log(merchantResponse!.fields
                                                  .merchId.integerValue +
                                                  userList.listId.toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                        chatId: userList.listId
                                                            .toString(),
                                                        title:
                                                        currentMerchantOffer!
                                                            .merchResponse
                                                            .merchTotalPrice,
                                                        fromNotification: false,
                                                        listEventId:
                                                        merchantResponse!
                                                            .fields
                                                            .merchId
                                                            .integerValue +
                                                            userList.listId
                                                                .toString(),
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 23.sp,
                                                  vertical: 8.sp),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.sp)),
                                                  color: AppColors().brandDark),
                                              child: Text(
                                                "Chat",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.sp),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        archived
                            ? Center(
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 20, sigmaY: 20),
                                    child: SizedBox(
                                      height: screenSize.height / 3 + 10,
                                      width: screenSize.width,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        archived
                            ? Center(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  alignment: Alignment.center,
                                  height: screenSize.height / 3 + 10,
                                  width: screenSize.width,
                                  child: Text(
                                    'Merchant information will be available only upto 72 hours since the list was sent to shops.',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppColors().grey100,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                Container(
                  height: 50.sp,
                  width: screenSize.width,
                  color: AppColors().white100,
                  alignment: Alignment.center,
                  child: Text(
                    '${_items.length} Items',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                      bottom: 10.sp,
                    ),
                    child: GroupedListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        left: 15.0,
                        right: 15.0,
                      ),
                      elements: _items,
                      groupBy: (OfferItem offerItem) => offerItem.catName,
                      groupSeparatorBuilder: (String value) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.sp,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    value,
                                    style: TextStyle(
                                      color: const Color(0xff8B8B8B),
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                      color: AppColors().brandDark,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.sp,
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ],
                        );
                      },
                      indexedItemBuilder:
                          (BuildContext context, dynamic element, int index) {
                        return MerchantItemCard(
                          merchantItem: _items[index],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                isDone()
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: screenSize.width,
                          color: AppColors().white100,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 40.0),
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
                                '₹ ${removeDecimalZeroFormat(double.parse(currentMerchantOffer!.merchResponse.merchTotalPrice))}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.sp,
                                    color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                if (!isDone())
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 1.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 40.0),
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
                                'Rs. ${removeDecimalZeroFormat(double.parse(currentMerchantOffer!.merchResponse.merchTotalPrice))}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.sp,
                                    color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
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
                                  barrierColor:
                                      const Color.fromARGB(165, 241, 241, 241),
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    ScreenUtil.init(
                                        BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            maxHeight: MediaQuery.of(context)
                                                .size
                                                .height),
                                        designSize: const Size(390, 844),
                                        context: context,
                                        minTextAdapt: true,
                                        orientation: Orientation.portrait);
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: Container(
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
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
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
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 24.sp,
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Color(
                                                                0xffeaeaea),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 18.sp,
                                                    left: 45.sp,
                                                    right: 45.sp,
                                                  ),
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                        text: 'You can accept',
                                                        style: TextStyle(
                                                            fontSize: 18.sp,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                ' can accept ',
                                                            style: TextStyle(
                                                                fontSize: 18.sp,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                'offer. If you accept this offer, all other offers will disappear',
                                                            style: TextStyle(
                                                                fontSize: 18.sp,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 25.sp),
                                                  child: SizedBox(
                                                    height: 50.sp,
                                                    width: 234.sp,
                                                    child: MaterialButton(
                                                      onPressed: () async {
                                                        //todo push acceptance changes to db
                                                        int response =
                                                            await apiController
                                                                .acceptOffer(
                                                                    currentMerchantOffer!
                                                                        .listEventId);

                                                        int response2 = await apiController
                                                            .processedStatusChange(
                                                                int.parse(
                                                                    currentMerchantOffer!
                                                                        .listId
                                                                        .path
                                                                        .segments
                                                                        .last));
                                                        // int response = 1;
                                                        if (response == 1 &&
                                                            response2 == 1) {
                                                          //todo refresh and send to sent page
                                                          successMsg(
                                                              'Yay! Offer Accepted!',
                                                              'Hope you had a pleasant time using the app.');
                                                          Get.close(3);
                                                        } else {
                                                          errorMsg(
                                                              'Connectivity Error',
                                                              'Some connectivity error has occurred, please try again later!');
                                                        }
                                                      },
                                                      child: Text(
                                                        'Accept',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 18.sp),
                                                      ),
                                                      color: Colors.orange,
                                                      elevation: 0.0,
                                                      highlightElevation: 0.0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
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
            ),
          );
        }

        if (snapShot.hasError) {
          log(snapShot.toString());
          log(snapShot.error.toString());
          return const Center(
            child: Text('Error fetching merchant response'),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }

  bool isDone() {
    return userList.processStatus == 'accepted' ||
            userList.processStatus == 'processed'
        ? true
        : false;
  }
}
