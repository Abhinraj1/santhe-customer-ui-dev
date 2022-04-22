import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:santhe/models/offer/santhe_offer_item_model.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:santhe/widgets/confirmation_widgets/success_snackbar_widget.dart';

import '../../controllers/api_service_controller.dart';
import '../../models/offer/offer_model.dart';
import '../../widgets/sent_tab_widgets/merchant_item_card.dart';

class MerchantItemsListPage extends StatelessWidget {
  final Offer currentMerchantOffer;
  const MerchantItemsListPage({required this.currentMerchantOffer, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiController = Get.find<APIs>();
    double screenWidth = MediaQuery.of(context).size.width / 100;
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
          'Offer Rs. ${currentMerchantOffer.merchTotalPrice}',
          style: GoogleFonts.mulish(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60.sp,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  'Items and Price',
                  style: GoogleFonts.mulish(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp),
                ),
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: Colors.white,
              child: GroupedListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 15.0,
                  right: 15.0,
                ),
                elements: currentMerchantOffer.offerItems,
                groupBy: (OfferItem offerItem) => offerItem.catName,
                groupSeparatorBuilder: (String value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      )
                    ],
                  );
                },
                indexedItemBuilder:
                    (BuildContext context, dynamic element, int index) {
                  return MerchantItemCard(
                    merchantItem: currentMerchantOffer.offerItems[index],
                  );
                },
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 1.0))),
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
                        style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w400,
                            fontSize: 24.sp,
                            color: const Color(0xff8B8B8B)),
                      ),
                      Text(
                        'Rs. ${removeDecimalZeroFormat(currentMerchantOffer.merchTotalPrice)}',
                        style: GoogleFonts.mulish(
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
                                      maxWidth:
                                      MediaQuery.of(context).size.width,
                                      maxHeight:
                                      MediaQuery.of(context).size.height),
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
                                    physics: const BouncingScrollPhysics(),
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
                                                  const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Are you sure?',
                                                    style: GoogleFonts.mulish(
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      fontSize: 24.sp,
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      color: const Color(
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
                                                  style: GoogleFonts.mulish(
                                                      fontSize: 18.sp,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                      FontWeight.w400),
                                                  children: [
                                                    TextSpan(
                                                      text: ' can accept ',
                                                      style: GoogleFonts.mulish(
                                                          fontSize: 18.sp,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                          FontWeight.w700),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                      'offer. If you accept this offer, all other offers will disappear',
                                                      style: GoogleFonts.mulish(
                                                          fontSize: 18.sp,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.only(top: 25.sp),
                                            child: SizedBox(
                                              height: 50.sp,
                                              width: 234.sp,
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  //todo push acceptance changes to db
                                                  int response =
                                                  await apiController
                                                      .acceptOffer(
                                                      currentMerchantOffer
                                                          .listEventId);

                                                  int response2 = await apiController
                                                      .processedStatusChange(int
                                                      .parse(currentMerchantOffer
                                                      .listId
                                                      .replaceAll(
                                                      'projects/santhe-425a8/databases/(default)/documents/customerList/',
                                                      '')));
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
                                                  style: GoogleFonts.mulish(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      fontSize: 18.sp),
                                                ),
                                                color: Colors.orange,
                                                elevation: 0.0,
                                                highlightElevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      child: Text(
                        'Accept Offer',
                        style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
