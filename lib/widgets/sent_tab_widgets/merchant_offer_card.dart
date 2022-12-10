import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:resize/resize.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/chat_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/models/merchant_details_response.dart';
import 'package:santhe/models/new_list/user_list_model.dart';
import 'package:santhe/pages/chat/chat_screen.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_theme.dart';
import '../../models/offer/customer_offer_response.dart';
import '../../pages/sent_tab_pages/merchant_items_list_page.dart';

class MerchantOfferCard extends StatefulWidget {
  final UserListModel userList;
  final CustomerOfferResponse currentMerchantOffer;
  final Function refresh;
  bool overrideData;

  MerchantOfferCard(
      {required this.currentMerchantOffer,
      required this.userList,
      required this.refresh,
      this.overrideData = false,
      Key? key})
      : super(key: key);

  @override
  State<MerchantOfferCard> createState() => _MerchantOfferCardState();
}

class _MerchantOfferCardState extends State<MerchantOfferCard>
    with AutomaticKeepAliveClientMixin {
  final ChatController _chatController = Get.find();
  MerchantDetailsResponse? merchantResponse;
  String imagePath = 'assets/sent_tab/0star.png';

  Future<void> getMerchantResponse() async {
    merchantResponse ??= await APIs().getMerchantDetails(
        widget.currentMerchantOffer.merchId.path.segments.last);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          if (merchantResponse != null || !isDone()) {
            Get.to(() => MerchantItemsListPage(
                  currentMerchantOffer: widget.currentMerchantOffer,
                  userList: widget.userList,
                  merchantResponse: merchantResponse,
                  archived: false,
                ))?.then(
              (value) {
                if (value != null) {
                  if (value == true) {
                    setState(() {
                      widget.overrideData = true;
                      widget.userList.processStatus = 'accepted';
                      widget.refresh(widget.overrideData);
                    });
                  }
                }
              },
            );
          } else {
            errorMsg('Please wait till loading', '');
          }
        },
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Offer Price: ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.orange,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        'Rs ${widget.currentMerchantOffer.merchResponse.merchTotalPrice}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                '${widget.currentMerchantOffer.merchResponse.merchOfferQuantity} of ${widget.userList.items.length} items available',
                                softWrap: true,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 21.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: RichText(
                              text: TextSpan(
                                  text:
                                      'Merchant is ${widget.currentMerchantOffer.custDistance} ${widget.currentMerchantOffer.custDistance > 1 ? 'Kms' : 'Km'} away,\n',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xffBBBBBB),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.currentMerchantOffer
                                              .merchResponse.merchDelivery
                                          ? 'Does home delivery'
                                          : 'No home delivery',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xffBBBBBB),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150.sp,
                      width: 150.sp,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 142.w,
                              height: 142.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(loadImage()),
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 150.sp,
                              height: 150.sp,
                              child: CircularProgressIndicator(
                                value: double.parse(
                                  '${widget.currentMerchantOffer.merchResponse.merchOfferQuantity / widget.userList.items.length}',
                                ),
                                strokeWidth: 9.0,
                                color: AppColors().brandDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isDone())
                  Column(
                    children: [
                      SizedBox(
                        height: 35.h,
                      ),
                      Center(
                        child: Text(
                          'Offer Accepted',
                          style: AppTheme()
                              .bold800(20, color: AppColors().green100),
                        ),
                      ),
                      SizedBox(
                        height: 36.h,
                      ),
                      //store details
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/offers/store_icon.png',
                            height: 75.h,
                          ),
                          SizedBox(
                            width: 19.w,
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: getMerchantResponse(),
                              builder: (builder, snapShot) {
                                if (snapShot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                }

                                if (snapShot.hasError) {
                                  return const Center(
                                    child: Text(
                                        'Something went wrong please try again'),
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      merchantResponse!
                                          .fields.merchName.stringValue,
                                      style: AppTheme().bold700(24,
                                          color: AppColors().grey100),
                                    ),
                                    SizedBox(
                                      height: 9.h,
                                    ),
                                    Text(
                                      merchantResponse!.fields.contact.mapValue
                                          .fields.address.stringValue,
                                      style: AppTheme().normal400(13,
                                          color: AppColors().grey100),
                                    ),
                                    SizedBox(
                                      height: 9.h,
                                    ),
                                    //contact number
                                    Row(
                                      children: [
                                        //phone icon
                                        GestureDetector(
                                          onTap: () => launchUrl(Uri.parse(
                                              'tel:${merchantResponse!.fields.contact.mapValue.fields.phoneNumber.integerValue}')),
                                          child: Container(
                                            height: 24.h,
                                            width: 24.h,
                                            decoration: BoxDecoration(
                                                color: AppColors().brandDark,
                                                borderRadius:
                                                    BorderRadius.circular(60)),
                                            child: Center(
                                              child: Icon(
                                                Icons.phone,
                                                color: AppColors().white100,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 9.w,
                                        ),
                                        //phone number
                                        Text(
                                          '+${merchantResponse!.fields.contact.mapValue.fields.phoneNumber.integerValue}',
                                          style: AppTheme().bold700(16,
                                              color: AppColors().brandDark),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    //chat button
                                    SizedBox(
                                      height: 32.h,
                                      width: 92.w,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                                child: ChatScreen(
                                                  chatId: widget.userList.listId
                                                      .toString(),
                                                  customerTitle: widget
                                                      .currentMerchantOffer
                                                      .merchResponse
                                                      .merchTotalPrice,
                                                  merchantTitle:
                                                      // 'Request ${widget.currentMerchantOffer.requestForDay} of ${DateFormat('yyyy-MM-dd').format(widget.currentMerchantOffer.merchReqDate)}',
                                                      'Request ${widget.currentMerchantOffer.requestForDay} of ${DateFormat('yyyy-MM-dd').format(widget.currentMerchantOffer.merchReqDate)}',
                                                  listEventId: merchantResponse!
                                                          .fields
                                                          .merchId
                                                          .integerValue +
                                                      widget.userList.listId
                                                          .toString(),
                                                ),
                                                type: PageTransitionType
                                                    .rightToLeft),
                                          );
                                        },
                                        child: Text(
                                          'Chat',
                                          style: AppTheme().bold700(16,
                                              color: AppColors().white100),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String loadImage() {
    if (widget.currentMerchantOffer.custOfferResponse.custDeal == 'best1' ||
        widget.currentMerchantOffer.custOfferResponse.custDeal == 'best2') {
      return 'assets/sent_tab/3star.png';
    } else if (widget.currentMerchantOffer.custOfferResponse.custDeal ==
        'best3') {
      return 'assets/sent_tab/2star.png';
    } else if (widget.currentMerchantOffer.custOfferResponse.custDeal ==
        'best4') {
      return 'assets/sent_tab/1star.png';
    } else {
      return 'assets/sent_tab/0star.png';
    }
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
  void dispose() {
    _chatController.inOfferScreen = false;
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
