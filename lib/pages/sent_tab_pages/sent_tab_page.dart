import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:santhe/constants.dart';
import '../../controllers/api_service_controller.dart';
import '../../controllers/boxes_controller.dart';
import '../../models/santhe_user_list_model.dart';
import '../../widgets/sent_tab_widgets/offer_card_widget.dart';

class OfferTabPage extends StatefulWidget {
  const OfferTabPage({Key? key}) : super(key: key);

  @override
  State<OfferTabPage> createState() => _OfferTabPageState();
}

class _OfferTabPageState extends State<OfferTabPage> {
  int custPhone = Boxes.getUser().get('currentUserDetails')?.phoneNumber ?? 404;
  final apiController = Get.find<APIs>();
  late Future<List<UserList>> userSentListsData;

  @override
  void initState() {
    userSentListsData = apiController.getCustListByStatus(custPhone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserList>>(
        future: userSentListsData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 89.62.h,
                    ),
                    SizedBox(
                      height: 372.02.h,
                      width: 312.65.w,
                      child: SvgPicture.asset(
                        'assets/sent_tab_image.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              'All your shopping lists that you have sent to Shops in last 72 hours will appear here. Go to',
                          style: TextStyle(
                            color: kTextGrey,
                            fontSize: 24.sp,
                            height: 2.sp,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' New ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextGrey,
                                fontSize: 24.sp,
                                height: 2.sp,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'tab to create and send your shopping lists.',
                              style: TextStyle(
                                  color: kTextGrey,
                                  fontSize: 24.sp,
                                  height: 2.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data?.length == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 89.62.h,
                ),
                SizedBox(
                  height: 372.02.h,
                  width: 312.65.w,
                  child: SvgPicture.asset(
                    'assets/onboarding_sentPage_arrow.svg',
                    color: Colors.orange,
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'All your shopping lists that you have sent to merchants in last 72 hours will appear here. Go to New tab to create your shopping lists',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24.sp,
                          height: 2.sp,
                          color: Colors.grey),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  //future builder will take care of future value so no need to mark this function async
                  userSentListsData =
                      apiController.getCustListByStatus(custPhone);
                });
                return;
              },
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 3.0),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return OfferCard(userList: snapshot.data![index]);
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
