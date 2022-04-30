import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/boxes_controller.dart';
import 'package:santhe/models/santhe_user_list_model.dart';
import 'package:santhe/widgets/archived_tab_widgets/archived_list_card.dart';
import '../../constants.dart';

class ArchiveTabPage extends StatefulWidget {
  const ArchiveTabPage({Key? key}) : super(key: key);

  @override
  State<ArchiveTabPage> createState() => _ArchiveTabPageState();
}

class _ArchiveTabPageState extends State<ArchiveTabPage> {
  int custId =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;
  final apiController = Get.find<APIs>();
  late Future<List<UserList>> userArchivedListsData;

  @override
  void initState() {
    userArchivedListsData = apiController.getArchivedCust(custId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;
    // var box = Boxes.getUserListDB();
    // box.clear();
    // box = Boxes.getUserListDB();
    // print(box.values.where((element) => element.custListStatus == 'archived'));
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
        future: userArchivedListsData,
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
                        'assets/archive_tab_image.svg',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 28.sp, left: 23.sp, right: 23.sp),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  'All your shopping lists that you have sent to Shops in more than 72 hours will appear here. Go to',
                              style: GoogleFonts.mulish(
                                  color: kTextGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\nNew ',
                                  style: GoogleFonts.mulish(
                                      color: kTextGrey,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.sp),
                                ),
                                TextSpan(
                                  text:
                                      'tab to create and send your shopping lists',
                                  style: GoogleFonts.mulish(
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
                        'assets/archive_tab_image.svg',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 28.sp, left: 23.sp, right: 23.sp),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  'All your shopping lists that you have sent to Shops in more than 72 hours will appear here. Go to',
                              style: GoogleFonts.mulish(
                                  color: kTextGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\nNew ',
                                  style: GoogleFonts.mulish(
                                      color: kTextGrey,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.sp),
                                ),
                                TextSpan(
                                  text:
                                      'tab to create and send your shopping lists',
                                  style: GoogleFonts.mulish(
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
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  //future builder will take care of future value so no need to mark this function async
                  userArchivedListsData = apiController.getArchivedCust(custId);
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
                  return ArchivedUserListCard(
                    userList: snapshot.data![index],
                  );
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
