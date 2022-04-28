import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/pages/sent_tab_pages/offers_list_page.dart';

import 'package:get/get.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';

import '../../models/santhe_user_list_model.dart';
import '../../pages/sent_tab_pages/sent_list_detail_page.dart';

class OfferCard extends StatelessWidget {
  final UserList userList;
  const OfferCard({required this.userList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    double screenWidth = MediaQuery.of(context).size.width / 100;
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
          Get.to(() => SentUserListDetailsPage(
            userList: userList,
            showOffers: _showOffer(),
          ));
        },
        child: Container(
          // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
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
                top: 5.0, bottom: 10.0, left: 15.0, right: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            userList.listName,
                            maxLines: 2,
                            style: GoogleFonts.mulish(
                                letterSpacing: 0.2,
                                fontSize: 21.sp,
                                color: Colors.orange,
                                fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.77.sp),
                            child: AutoSizeText(
                              '${userList.items.length} ${userList.items.length > 1 ? 'Items' : 'Item'}',
                              style: GoogleFonts.mulish(
                                  fontSize: 36.sp,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 1.sp, bottom: 8.32.sp),
                            child: AutoSizeText(
                              'Added on ${userList.createListTime.day}/${userList.createListTime.month}/${userList.createListTime.year}',
                              style: GoogleFonts.mulish(
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
                      height: 139.2.sp,
                      width: 139.2.sp,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      'Added on ${userList.createListTime.day}/${userList.createListTime.month}/${userList.createListTime.year}',
                      style: GoogleFonts.mulish(
                          fontSize: 14.sp,
                          color: const Color(0xffBBBBBB),
                          fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      //todo fix this
                      padding: const EdgeInsets.only(right: 0),
                      child: Row(
                        children: [
                          //nooofer
                          userList.processStatus == 'nooffer' ||
                                  userList.processStatus == 'noMerchants'
                              ? AutoSizeText(
                                  'No Offers',
                                  style: GoogleFonts.mulish(
                                      fontSize: 14.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400),
                                )
                              : const Visibility(
                                  visible: false,
                                  child: SizedBox(),
                                ),
                          //processed
                          userList.processStatus == 'processed'
                              ? AutoSizeText(
                                  'Accepted',
                                  style: GoogleFonts.mulish(
                                      fontSize: 14.sp,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w400),
                                )
                              : const Visibility(
                                  visible: false,
                                  child: SizedBox(),
                                ),
                          //minoffer
                          _showOffer() ? AutoSizeText(
                                  'Waiting for offers',
                                  style: GoogleFonts.mulish(
                                      fontSize: 14.sp,
                                      color: const Color(0xffFFC300),
                                      fontWeight: FontWeight.w400),
                                )
                              : userList.processStatus != 'processed' ? AutoSizeText(
                            '${userList.listOfferCounter} ${userList.listOfferCounter < 2 ? 'Offer Available' : 'Offers Available'} ',
                            style: GoogleFonts.mulish(
                                fontSize: 14.sp,
                                color: Colors.green,
                                fontWeight: FontWeight.w400),
                          ) : SizedBox(),
                          //minoffer
                          userList.processStatus == 'maxoffer'
                              ? AutoSizeText(
                                  '${userList.listOfferCounter} Offers Available',
                                  style: GoogleFonts.mulish(
                                      fontSize: 14.sp,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w400),
                                )
                              : const Visibility(
                                  visible: false,
                                  child: SizedBox(),
                                ),
                          //expired
                          userList.processStatus == 'expired'
                              ? AutoSizeText(
                                  'Offers Missed',
                                  style: GoogleFonts.mulish(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400),
                                )
                              : const Visibility(
                                  visible: false,
                                  child: SizedBox(),
                                ),
                          const SizedBox(width: 3),
                          //ICON ICON ICON
                          //draft
                          //noofffer & nomerchants
                          userList.processStatus == 'nooffer' ||
                                  userList.processStatus == 'noMerchants'
                              ? Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  color: Colors.red,
                                  size: 18.sp,
                                )
                              : const Visibility(
                                  visible: false,
                                  child: SizedBox(),
                                ),
                          //processed
                          userList.processStatus == 'processed'
                              ? Icon(
                                  CupertinoIcons.checkmark_alt_circle_fill,
                                  color: Colors.green,
                                  size: 18.sp,
                                )
                              : const Visibility(
                                  visible: false,
                                  child: SizedBox(),
                                ),
                          //minoffer
                          _showOffer()
                              ? Icon(
                                  CupertinoIcons.time_solid,
                                  color: Colors.orangeAccent,
                                  size: 18.sp,
                                )
                              : userList.processStatus != 'processed' ? Icon(
                              CupertinoIcons.hand_thumbsup,
                              color: Colors.orangeAccent,
                              size: 18.sp,
                          ) : const SizedBox(),
                          //max offer
                          if(userList.processStatus == 'maxoffer') Icon(
                                  CupertinoIcons.hand_thumbsup_fill,
                                  color: Colors.deepPurple,
                                  size: 18.sp,
                                ),
                          //expired
                          if(userList.processStatus == 'expired') Icon(
                                  CupertinoIcons.exclamationmark_circle_fill,
                                  color: Colors.grey,
                                  size: 18.sp,
                                )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _showOffer(){
    return (userList.processStatus == 'minoffer' && userList.custListSentTime.toLocal().isBefore(DateTime.now())) || userList.processStatus == 'draft' || userList.processStatus == 'processing' || userList.processStatus == 'waiting' ? true : false;
  }
}
