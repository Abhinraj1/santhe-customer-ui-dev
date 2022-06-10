import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/core/app_theme.dart';

import '../../models/santhe_list_item_model.dart';
import '../../models/santhe_user_list_model.dart';
import '../../widgets/new_tab_widgets/user_list_widgets/list_item_card.dart';

class ArchiveDetailedPage extends StatelessWidget {
  final UserList userList;
  const ArchiveDetailedPage({Key? key, required this.userList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List for ${getAppHeader()}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(offerStatus() != 'processed') Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: Container(
                height: 70.h,
                width: 390.w,
                color: AppColors().white100,
                child: Row(
                  children: [
                    SizedBox(
                      width: 19.w,
                    ),
                    Image.asset('assets/sad_emoji.png', height: 47.h,),
                    SizedBox(
                      width: 19.w,
                    ),
                    if(offerStatus() == 'no_offers')Expanded(
                        child: Text('Unfortunately, there were no offers for this list', style: AppTheme().bold700(16, color: AppColors().grey100),)),
                    if(offerStatus() == 'missed')Expanded(
                        child: Text('Merchant offers were available, but none were accepted by you', style: AppTheme().bold700(16, color: AppColors().grey100),)),
                    SizedBox(
                      width: 19.w,
                    ),
                  ],
                ),
              ),
            ),
            if(offerStatus() == 'no_offers') Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Container(
                width: 390.w,
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.h),
                color: AppColors().white100,
                child: Column(
                  children: [
                    Text('Would you like to edit your list and try again?', style: AppTheme().bold700(16, color: AppColors().grey100),),
                    SizedBox(height: 30.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width:157.w,
                            height: 50.h,
                            child: ElevatedButton(onPressed: (){}, child: const Text('Yes'))),
                        SizedBox(width: 10.w,),
                        SizedBox(
                            width:157.w,
                            height: 50.h,
                            child: ElevatedButton(onPressed: (){}, child: const Text('No'),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) => AppColors().grey40,),
                                textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                                        (Set<MaterialState> states) => AppTheme().bold700(18, color: AppColors().grey100))
                              ),)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: AppColors().white100,
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: Column(
                children: [
                  if(offerStatus() == 'processed')SizedBox(height: 21.h,),
                  if(offerStatus() == 'processed')SizedBox(
                    height: 164.h, width: 315.w,
                    child: Stack(
                        children: [
                          Image.asset('assets/archived_accepted.png', height: 164.h, width: 315.w,),
                          Align(
                            alignment: const Alignment(0, 0.5),
                            child: Text('Merchant information will be available only upto 72 hours since the list was sent to shops', textAlign: TextAlign.center, style: AppTheme().bold600(16, color: AppColors().grey100),),
                          )
                        ],),
                  ),
                  SizedBox(height: 19.h,),
                  Text(userList.items.length == 1 ? '${userList.items.length.toString()} Item' : '${userList.items.length.toString()} Items', style: AppTheme().bold700(24, color: AppColors().grey100),),
                  SizedBox(height: 8.h,),
                  GroupedListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    elements: userList.items,
                    groupBy: (ListItem element) =>
                    element.catName,
                    indexedItemBuilder: (BuildContext context,
                        ListItem element, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: int.parse(element.itemId.replaceAll('projects/santhe-425a8/databases/(default)/documents/item/', '')) < 4000
                                    ? 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/${element.itemImageId}'
                                    : element.itemImageId,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return Container(
                                    color: Colors.orange,
                                    width: 50.vw,
                                    height: 50.vw,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(element.itemName),
                                  element.brandType.isEmpty
                                      ? Text(
                                    element.notes.isEmpty
                                        ? '${element.quantity} ${element.unit}'
                                        : '${element.quantity} ${element.unit},\n${element.notes}',
                                    // softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 16.sp,
                                    ),
                                  )
                                      : Text(
                                    '''${element.quantity} ${element.unit}, ${element.notes.isEmpty ? element.brandType : '${element.brandType},\n${element.notes}'}''',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    groupSeparatorBuilder: (String value) {
                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(value, style: AppTheme().bold700(16, color: AppColors().grey100),),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5.sp,
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getAppHeader() {
    return DateFormat('MMM yyyy').format(userList.custListSentTime);
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  String offerStatus(){
    if(userList.processStatus == 'expired' || userList.processStatus == 'missed') return 'missed';
    if(userList.processStatus == 'processed') return 'processed';
    return 'no_offers';
  }
}
