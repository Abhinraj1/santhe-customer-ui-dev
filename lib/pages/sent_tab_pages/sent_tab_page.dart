import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/testing.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/firebase/firebase_helper.dart';
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
    // final offerResponse = 'my stream';
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    print('-->PHONE: $custPhone');
    // FirebaseHelper().offerStream();

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      body: FutureBuilder<List<UserList>>(
        future: userSentListsData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //todo show proper error screen
            // return Center(child: Text('${snapshot.error}'));
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
                        'assets/sent_tab_image.svg',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 42.sp, left: 23.sp, right: 23.sp),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  'All your shopping lists that you have sent to\nShops in last 72 hours will appear here. Go to',
                              style: TextStyle(
                                  color: kTextGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\nNew ',
                                  style: TextStyle(
                                      color: kTextGrey,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.sp),
                                ),
                                TextSpan(
                                  text:
                                      'tab to create and send your shopping lists',
                                  style: TextStyle(
                                      color: kTextGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp),
                                ),
                              ])),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data?.length == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  width: screenWidth * 60,
                  child: SvgPicture.asset(
                    'assets/onboarding_sentPage_arrow.svg',
                    color: Colors.orange,
                    height: screenHeight * 30,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0),
                    child: Text(
                      'All your shopping lists that you have sent to merchants in last 72 hours will appear here. Go to New tab to create your shopping lists',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
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
                  ScreenUtil.init(
                      BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                          maxHeight: MediaQuery.of(context).size.height),
                      designSize: const Size(390, 844),
                      context: context,
                      minTextAdapt: true,
                      orientation: Orientation.portrait);
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

//     body: Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   mainAxisAlignment: MainAxisAlignment.start,
//   children: [
//     const SizedBox(
//       height: 25.0,
//     ),
//     SizedBox(
//       width: screenWidth * 60,
//       child: SvgPicture.asset(
//         'assets/onboarding_sentPage_arrow.svg',
//         color: Colors.orange,
//         height: screenHeight * 30,
//       ),
//     ),
//     Center(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
//         child: Text(
//           'All your shopping lists that you have sent to merchants in last 72 hours will appear here. Go to New tab to create your shopping lists',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               fontWeight: FontWeight.w400,
//               fontSize: 16.sp,
//               color: Colors.grey),
//         ),
//       ),
//     ),
//   ],
// ),
