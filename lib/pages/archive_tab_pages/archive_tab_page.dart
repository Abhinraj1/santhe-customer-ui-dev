// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:resize/resize.dart';
// import 'package:santhe/core/app_colors.dart';
// import 'package:santhe/widgets/archived_tab_widgets/archived_list_card.dart';
//
// import '../../controllers/getx/all_list_controller.dart';
// import '../../models/new_list/user_list_model.dart';
//
// class ArchivedTabScreen extends StatelessWidget {
//   ArchivedTabScreen({Key? key}) : super(key: key);
//
//  // final AllListController _allListController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetBuilder(
//         init: _allListController,
//         id: 'archivedList',
//         builder: (builder){
//           List<UserListModel> archivedList = _allListController.archivedList;
//           archivedList.sort((a, b) => b.listUpdateTime.compareTo(a.listUpdateTime));
//           if(_allListController.isLoading) return Center(child: CircularProgressIndicator(color: AppColors().brandDark),);
//
//           if(_allListController.archivedList.isEmpty) return _emptyList(context);
//
//           return RefreshIndicator(
//             onRefresh: () async => await _allListController.getAllList(),
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 3.0),
//               physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//               itemCount: archivedList.length,
//               itemBuilder: (context, index) {
//                 return ArchivedUserListCard(userList: archivedList[index]);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _emptyList(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async => await _allListController.getAllList(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(height: 23.h),
//           SvgPicture.asset(
//             'assets/archive_tab_image.svg',
//             height: 45.vh,
//           ),
//           SizedBox(
//             height: 20.sp,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30),
//             child: RichText(
//               textAlign: TextAlign.center,
//               text: TextSpan(
//                 text:
//                 'All your shopping lists that you have sent to Shops in last 72 hours will appear here. Go to',
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 16.sp,
//                   height: 2.sp,
//                 ),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: ' New ',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey,
//                       fontSize: 16.sp,
//                       height: 2.sp,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'tab to create and send your shopping lists.',
//                     style: TextStyle(
//                         color: Colors.grey, fontSize: 16.sp, height: 2.sp),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
