import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/models/merchant_details_response.dart';
import 'package:santhe/pages/chat/chat_screen.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';

import '../../core/app_theme.dart';
import '../../models/offer/customer_offer_response.dart';
import '../../models/santhe_user_list_model.dart';
import '../../pages/sent_tab_pages/merchant_items_list_page.dart';

class MerchantOfferCard extends StatefulWidget {
  final UserList userList;
  final CustomerOfferResponse currentMerchantOffer;

  const MerchantOfferCard(
      {required this.currentMerchantOffer, required this.userList, Key? key})
      : super(key: key);

  @override
  State<MerchantOfferCard> createState() => _MerchantOfferCardState();
}

class _MerchantOfferCardState extends State<MerchantOfferCard> {
  bool overrideData = false;
  late UserList userList;

  @override
  void initState() {
    userList = widget.userList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/sent_tab/0star.png';
    if (widget.currentMerchantOffer.custOfferResponse.custDeal == 'best1') {
      imagePath = 'assets/sent_tab/3star.png';
    } else if (widget.currentMerchantOffer.custOfferResponse.custDeal ==
        'best2') {
      imagePath = 'assets/sent_tab/2star.png';
    } else if (widget.currentMerchantOffer.custOfferResponse.custDeal ==
        'best3') {
      imagePath = 'assets/sent_tab/1star.png';
    } else {
      imagePath = 'assets/sent_tab/0star.png';
    }

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    MerchantDetailsResponse? merchantResponse;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          if (merchantResponse != null || !isDone()) {
            Get.to(() => MerchantItemsListPage(
                  currentMerchantOffer: widget.currentMerchantOffer,
                  userList: userList,
                  merchantResponse: merchantResponse,
                  archived: false,
                ))?.then((value) {
              if (value != null) {
                setState(() {
                  if(value==true){
                    overrideData = value;
                  }
                });
              }
            });
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
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 20.0, left: 20.0, right: 20.0),
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
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.orange,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        'Rs ${widget.currentMerchantOffer.merchResponse.merchTotalPrice}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              '${widget.currentMerchantOffer.merchResponse.merchOfferQuantity} of ${userList.items.length} items\navailable',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w900,
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
                                    fontSize: 13.sp,
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
                                        fontSize: 13.sp,
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
                                    image: AssetImage(imagePath),
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
                                  '${widget.currentMerchantOffer.merchResponse.merchOfferQuantity / userList.items.length}',
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
                            child: FutureBuilder<MerchantDetailsResponse>(
                              future: APIs().getMerchantDetails(widget
                                  .currentMerchantOffer
                                  .merchId
                                  .path
                                  .segments
                                  .last),
                              builder: (builder, snapShot) {
                                if (snapShot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                }

                                if (snapShot.hasError) {
                                  return const Center(
                                    child: Text(
                                        'Something went wrong please try again'),
                                  );
                                }

                                merchantResponse = snapShot.data;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapShot
                                          .data!.fields.merchName.stringValue,
                                      style: AppTheme().bold700(24,
                                          color: AppColors().grey100),
                                    ),
                                    SizedBox(
                                      height: 9.h,
                                    ),
                                    Text(
                                      snapShot.data!.fields.contact.mapValue
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
                                        Container(
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
                                        SizedBox(
                                          width: 9.w,
                                        ),
                                        //phone number
                                        Text(
                                          '+91-' +
                                              snapShot
                                                  .data!
                                                  .fields
                                                  .contact
                                                  .mapValue
                                                  .fields
                                                  .phoneNumber
                                                  .integerValue,
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
                                              // print(merchantResponse!.fields
                                              //         .merchId.integerValue +
                                              //     userList.listId.toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                    chatId: widget
                                                        .userList.listId
                                                        .toString(),
                                                    title: widget
                                                        .currentMerchantOffer
                                                        .merchResponse
                                                        .merchTotalPrice,
                                                    fromNotification: false,
                                                    listEventId:
                                                        merchantResponse!
                                                                .fields
                                                                .merchId
                                                                .integerValue +
                                                            widget
                                                                .userList.listId
                                                                .toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Chat',
                                              style: AppTheme().bold700(16,
                                                  color: AppColors().white100),
                                            )))
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

  bool isDone() {
    return overrideData
        ? true
        : userList.processStatus == 'accepted' ||
                userList.processStatus == 'processed'
            ? true
            : false;
  }
}
