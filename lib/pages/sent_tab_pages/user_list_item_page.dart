import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:santhe/constants.dart';

import '../../models/santhe_list_item_model.dart';
import '../../models/santhe_user_list_model.dart';
import '../../widgets/sent_tab_widgets/sent_list_item_card.dart';

class UserListItemDetailsPage extends StatelessWidget {
  final UserList userList;
  const UserListItemDetailsPage({required this.userList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              '${userList.items.length} ${userList.items.length < 2 ? 'Item' : 'Items'}',
              style: GoogleFonts.mulish(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54),
            ),
          ),
          Expanded(
            child: GroupedListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 23.sp,
                right: 23.sp,
                bottom: 10,
              ),
              elements: userList.items,
              groupBy: (ListItem element) => element.catName,
              indexedItemBuilder:
                  (BuildContext context, dynamic element, int index) {
                return SentListItemCard(
                  listItem: element,
                );
              },
              groupSeparatorBuilder: (String value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.mulish(
                          color: kTextGrey, fontWeight: FontWeight.w700),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
