// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:santhe/core/app_colors.dart';
// import 'package:santhe/core/app_url.dart';
// import 'package:santhe/models/new_list/list_item_model.dart';
// import 'package:santhe/widgets/protectedCachedNetworkImage.dart';
// import 'package:resize/resize.dart';
//
// class SentListItemCard extends StatelessWidget {
//   final ListItemModel listItem;
//
//   const SentListItemCard({required this.listItem, Key? key}) : super(key: key);
//
//   final String placeHolderIdentifier = 'H+MbQeThWmYq3t6w';
//
//   String checkPlaceHolder(String data) {
//     if (data.contains(placeHolderIdentifier)) {
//       return '';
//     }
//     return data;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: ProtectedCachedNetworkImage(
//                     imageUrl: 'https://firebasestorage.googleapis.com/v0/b/${AppUrl.envType}.appspot.com/o/${listItem.itemImageId.replaceAll(
//                       'https://firebasestorage.googleapis.com/v0/b/${AppUrl.envType}.appspot.com/o/',
//                       '',
//                     )}',
//                     width: 50.h,
//                     height: 50.h,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10.w,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(listItem.itemName, style: TextStyle(
//                         color: AppColors().grey100,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                       ),),
//                       checkPlaceHolder(listItem.brandType).isEmpty
//                           ? AutoSizeText(
//                               checkPlaceHolder(listItem.notes).isEmpty
//                                   ? '${listItem.quantity} ${listItem.unit}'
//                                   : '${listItem.quantity} ${listItem.unit}, ${checkPlaceHolder(listItem.notes)}',
//                               softWrap: false,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Colors.orange,
//                                 fontSize: 13.sp
//                               ),
//                             )
//                           : AutoSizeText(
//                               '${listItem.quantity} ${listItem.unit}, ${checkPlaceHolder(listItem.notes).isEmpty ? checkPlaceHolder(listItem.brandType) : '${checkPlaceHolder(listItem.brandType)}, ${checkPlaceHolder(listItem.notes)}'}',
//                               softWrap: false,
//                               maxLines: 2,
//                               minFontSize: 10,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Colors.orange,
//                                 fontSize: 13.sp,
//                               ),
//                             ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
