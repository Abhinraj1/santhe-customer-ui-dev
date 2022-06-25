import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santhe/controllers/chat_controller.dart';

import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_theme.dart';
import 'package:santhe/widgets/sent_tab_widgets/merchant_offer_card.dart';

import '../../controllers/api_service_controller.dart';
import '../../models/answer_list_model.dart';
import '../../models/item_model.dart';
import '../../models/offer/customer_offer_response.dart';
import '../../models/santhe_list_item_model.dart';
import '../../models/santhe_user_list_model.dart';

class OffersListPage extends StatefulWidget {
  final UserList userList;
  final bool showOffers;
  final String merchTitle;

  const OffersListPage(
      {required this.userList, Key? key, required this.showOffers, required this.merchTitle})
      : super(key: key);

  @override
  State<OffersListPage> createState() => _OffersListPageState();
}

class _OffersListPageState extends State<OffersListPage> with AutomaticKeepAliveClientMixin{
  late Future<List<CustomerOfferResponse>> listOffersData;
  final apiController = Get.find<APIs>();

  @override
  void initState() {
    listOffersData = apiController.getAllMerchOfferByListId(widget.userList.listId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return widget.showOffers
        ? FutureBuilder<List<CustomerOfferResponse>>(
            future: listOffersData,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isEmpty ||
                  snapshot.hasError) {
                return _waitingImage();
              } else if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      //future builder will take care of future value so no need to mark this function async
                      listOffersData = apiController.getAllMerchOfferByListId(widget.userList!.listId);
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
                              maxHeight: MediaQuery.of(context).size.height),
                          designSize: const Size(390, 844),
                          context: context,
                          minTextAdapt: true,
                          orientation: Orientation.portrait);
                      if (index == 0) {
                        return Column(
                          children: [
                            if (widget.userList.processStatus == 'maxoffer' &&
                                widget.userList.custListSentTime
                                    .toLocal()
                                    .isBefore(DateTime.now()))
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
                                      style: TextStyle(
                                          color: const Color(0xffBBBBBB),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13.sp),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: Container(),
                                    ),
                                  ),
                                ]),
                              ),
                            MerchantOfferCard(
                              currentMerchantOffer: snapshot.data![index],
                              userList: widget.userList,
                            ),
                          ],
                        );
                      } else {
                        return MerchantOfferCard(
                          currentMerchantOffer: snapshot.data![index],
                          userList: widget.userList,
                        );
                      }
                    },
                  ),
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
            },
          )
        : _waitingImage();
  }

  Widget _waitingImage() => Column(
        children: [
          Image.asset('assets/sent_tab/waiting_for_offer.png'),
          SizedBox(
            height: 27.h,
          ),
          Text(
            'Waiting for Offers',
            style: AppTheme().bold700(24, color: AppColors().grey100),
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
              width: 314.w,
              child: Text(
                'The Merchants are working on your Shopping List. We will let you know as soon as there are offers',
                textAlign: TextAlign.center,
                style: AppTheme()
                    .normal400(16, color: AppColors().grey100, height: 2.h),
              ))
        ],
      );

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
