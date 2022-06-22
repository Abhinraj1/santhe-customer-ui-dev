import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/archived_controller.dart';
import 'package:santhe/controllers/boxes_controller.dart';
import 'package:santhe/models/santhe_user_list_model.dart';
import 'package:santhe/widgets/archived_tab_widgets/archived_list_card.dart';
import '../../constants.dart';

class ArchiveTabPage extends StatefulWidget {
  const ArchiveTabPage({Key? key}) : super(key: key);

  @override
  State<ArchiveTabPage> createState() => _ArchiveTabPageState();
}

class _ArchiveTabPageState extends State<ArchiveTabPage>
    with AutomaticKeepAliveClientMixin {
  int custId =
      Boxes.getUserCredentialsDB().get('currentUserCredentials')?.phoneNumber ??
          404;
  final apiController = Get.find<APIs>();
  late Future<List<UserList>> userArchivedListsData;
  final ArchivedController _archivedController = Get.find();

  @override
  void initState() {
    _archivedController.isDataLoading = true;
    _archivedController.update();
    apiController.getArchivedCust(custId).then((value) {
      _archivedController.archivedList = value;
      _archivedController.isDataLoading = false;
      _archivedController.update();
    }).catchError((e) {
      _archivedController.isDataLoading = false;
      _archivedController.update();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GetBuilder<ArchivedController>(
        builder: (controller) {
          if (controller.isDataLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (controller.archivedList.isEmpty) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 268.h,
                      width: 368.w,
                      child: SvgPicture.asset(
                        'assets/archive_tab_image.svg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              'All your shopping lists that you have sent to Shops in more than 72 hours will appear here. Go to',
                          style: TextStyle(
                            color: kTextGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 24.sp,
                            height: 2.sp,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' New ',
                              style: TextStyle(
                                color: kTextGrey,
                                fontWeight: FontWeight.w900,
                                fontSize: 24.sp,
                                height: 2.sp,
                              ),
                            ),
                            TextSpan(
                              text: 'tab to create and send your shopping lists',
                              style: TextStyle(
                                color: kTextGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 24.sp,
                                height: 2.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                //future builder will take care of future value so no need to mark this function async
                userArchivedListsData = apiController.getArchivedCust(custId);
                apiController.getArchivedCust(custId).then((value) {
                  _archivedController.archivedList = value;
                  _archivedController.isDataLoading = false;
                  _archivedController.update();
                }).catchError((e) {
                  _archivedController.isDataLoading = false;
                  _archivedController.update();
                });
              });
            },
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 3.0),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: controller.archivedList.length,
              itemBuilder: (context, index) {
                return ArchivedUserListCard(
                    userList: controller.archivedList[index], index: index);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
