import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/offer/customer_offer_response.dart';
import '../../models/offer/offer_model.dart';
import '../../models/santhe_user_list_model.dart';
import '../../pages/sent_tab_pages/merchant_items_list_page.dart';

class MerchantOfferCard extends StatelessWidget {
  final UserList userList;
  final CustomerOfferResponse currentMerchantOffer;
  const MerchantOfferCard(
      {required this.currentMerchantOffer, required this.userList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/sent_tab/0star.png';
    if (currentMerchantOffer.custOfferResponse.custDeal == 'best1') {
      imagePath = 'assets/sent_tab/3star.png';
    } else if (currentMerchantOffer.custOfferResponse.custDeal == 'best2') {
      imagePath = 'assets/sent_tab/2star.png';
    } else if (currentMerchantOffer.custOfferResponse.custDeal == 'best3') {
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Get.to(() => MerchantItemsListPage(
                currentMerchantOffer: currentMerchantOffer,
            userList: userList,
              ));
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
            child: Row(
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
                                    'Rs ${currentMerchantOffer.merchResponse.merchTotalPrice}',
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
                          '${currentMerchantOffer.merchResponse.merchOfferQuantity} of ${userList.items.length} items\navailable',
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
                                  'Merchant is ${currentMerchantOffer.custDistance} ${currentMerchantOffer.custDistance > 1 ? 'Kms' : 'Km'} away,\n',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xffBBBBBB),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      currentMerchantOffer.merchResponse.merchDelivery ? 'Does home delivery' : 'No home delivery',
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
                Stack(children: [
                  Positioned(
                    left: 6,
                    top: 5,
                    child: Container(
                      width: 142.w,
                      height: 142.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(imagePath), fit: BoxFit.contain),
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
                          '${currentMerchantOffer.merchResponse.merchOfferQuantity / userList.items.length}',
                        ),
                        strokeWidth: 9.0,
                      ),
                    ),
                  )
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
