import 'package:flutter/material.dart';
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
          List<UserListModel> sentList = _allListController.sentList;
          sentList.sort((a, b) => a.updateListTime.compareTo(b.updateListTime));
          sentList = sentList.reversed.toList();
          if(sentList.isEmpty) return _emptyList(context);

          if(_allListController.isLoading) return const Center(child: CircularProgressIndicator(),);

          return RefreshIndicator(
            onRefresh: () async => await _allListController.getAllList(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 3.0),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: sentList.length,
              itemBuilder: (context, index) {
                return OfferCard(userList: sentList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _emptyList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await _allListController.getAllList(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 23.h),
          Image.asset(
            'assets/sent_tab_image.png',
            height: 45.vh,
          ),
          SizedBox(
            height: 20.sp,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                'All your shopping lists that you have sent to Shops in last 72 hours will appear here. Go to',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                  height: 2.sp,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' New ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 16.sp,
                      height: 2.sp,
                    ),
                  ),
                  TextSpan(
                    text: 'tab to create and send your shopping lists.',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 16.sp, height: 2.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

