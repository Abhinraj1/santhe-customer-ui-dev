import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/widgets/sent_tab_widgets/merchant_offer_card.dart';

import '../../constants.dart';
import '../../controllers/api_service_controller.dart';
import '../../models/offer/offer_model.dart';
import '../../models/santhe_user_list_model.dart';
import '../../widgets/sent_tab_widgets/offer_card_widget.dart';

class OffersListPage extends StatefulWidget {
  final UserList userList;
  const OffersListPage({required this.userList, Key? key}) : super(key: key);

  @override
  State<OffersListPage> createState() => _OffersListPageState();
}

class _OffersListPageState extends State<OffersListPage> {
  late Future<List<Offer>> listOffersData;
  final apiController = Get.find<APIs>();

  @override
  void initState() {
    listOffersData =
        apiController.getAllMerchOfferByListId(widget.userList.listId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    final UserList userList = widget.userList;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return userList.processStatus == 'processed'
        ? SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [],
              ),
            ),
          )
        : FutureBuilder<List<Offer>>(
            future: listOffersData,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                ScreenUtil.init(
                    BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        maxHeight: MediaQuery.of(context).size.height),
                    designSize: const Size(390, 844),
                    context: context,
                    minTextAdapt: true,
                    orientation: Orientation.portrait);
                // return Center(child: Text('${snapshot.error}'));
                return SizedBox(
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
                            'assets/sent_tab/waiting_for_offer.svg',
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Waiting for Offers',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    color: kTextGrey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.sp),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 38.sp, right: 38.sp, top: 10.sp),
                                child: Text(
                                  'The Merchants are working on your Shopping List. We will let you know as soon as there are offers',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.mulish(
                                      color: kTextGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data?.length == 0) {
                ScreenUtil.init(
                    BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        maxHeight: MediaQuery.of(context).size.height),
                    designSize: const Size(390, 844),
                    context: context,
                    minTextAdapt: true,
                    orientation: Orientation.portrait);
                return SizedBox(
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
                            'assets/sent_tab/waiting_for_offer.svg',
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Waiting for Offers',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                    color: kTextGrey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.sp),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 38.sp, right: 38.sp, top: 10.sp),
                                child: Text(
                                  'The Merchants are working on your Shopping List. We will let you know as soon as there are offers',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.mulish(
                                      color: kTextGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                ScreenUtil.init(
                    BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        maxHeight: MediaQuery.of(context).size.height),
                    designSize: const Size(390, 844),
                    context: context,
                    minTextAdapt: true,
                    orientation: Orientation.portrait);
                return userList.custOfferWaitTime.isBefore(DateTime.now())
                    ? RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            //future builder will take care of future value so no need to mark this function async
                            listOffersData =
                                apiController.getAllMerchOfferByListId(
                                    widget.userList.listId);
                          });
                          return;
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 3.0),
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            ScreenUtil.init(
                                BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width,
                                    maxHeight:
                                        MediaQuery.of(context).size.height),
                                designSize: const Size(390, 844),
                                context: context,
                                minTextAdapt: true,
                                orientation: Orientation.portrait);
                            if (index == 0 &&
                                userList.custOfferWaitTime
                                    .isBefore(DateTime.now())) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 15.0, // soften the shadow
                                          spreadRadius: 3.6, //extend the shadow
                                          offset: const Offset(
                                            0.0,
                                            0.0,
                                          ),
                                        )
                                      ],
                                    ),
                                    child: Stack(children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'More offers awaited in next hours',
                                          style: GoogleFonts.mulish(
                                              color: const Color(0xffBBBBBB),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13.sp),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: Container(),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  MerchantOfferCard(
                                      currentMerchantOffer:
                                          snapshot.data![index],
                                      userList: userList),
                                ],
                              );
                            } else {
                              return MerchantOfferCard(
                                  currentMerchantOffer: snapshot.data![index],
                                  userList: userList);
                            }
                          },
                        ),
                      )
                    : SizedBox(
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
                                  'assets/sent_tab/waiting_for_offer.svg',
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Waiting for Offers',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.mulish(
                                          color: kTextGrey,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24.sp),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 38.sp,
                                          right: 38.sp,
                                          top: 10.sp),
                                      child: Text(
                                        'The Merchants are working on your Shopping List. We will let you know as soon as there are offers',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.mulish(
                                            color: kTextGrey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              } else {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
            },
          );
  }
}
