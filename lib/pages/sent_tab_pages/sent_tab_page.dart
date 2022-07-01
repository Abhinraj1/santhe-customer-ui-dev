import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../controllers/getx/all_list_controller.dart';
import '../../models/new_list/user_list_model.dart';
import '../../widgets/sent_tab_widgets/offer_card_widget.dart';

class OfferTabPage extends StatelessWidget {
  OfferTabPage({Key? key}) : super(key: key);

  final AllListController _allListController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: _allListController,
        id: 'sentList',
        builder: (builder) {
          List<UserListModel> _sentList = _allListController.sentList;
          if(_sentList.isEmpty) return _emptyList();
          return RefreshIndicator(
            onRefresh: () async {

            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 3.0),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: _sentList.length,
              itemBuilder: (context, index) {
                return OfferCard(userList: _sentList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _emptyList() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 100.vw,
        width: 100.vw,
        child: SvgPicture.asset(
          'assets/onboarding_sentPage_arrow.svg',
          color: Colors.orange,
          fit: BoxFit.fill,
        ),
      ),
      SizedBox(height: 20.sp,),
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'All your shopping lists that you have sent to merchants in last 72 hours will appear here. Go to New tab to create your shopping lists',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.sp,
                height: 2.sp,
                color: Colors.grey),
          ),
        ),
      ),
    ],
  );
}

