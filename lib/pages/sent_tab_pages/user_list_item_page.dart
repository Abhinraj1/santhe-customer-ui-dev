import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../models/santhe_list_item_model.dart';
import '../../models/santhe_user_list_model.dart';
import '../../widgets/sent_tab_widgets/sent_list_item_card.dart';

class UserListItemDetailsPage extends StatelessWidget {
  final UserList userList;
  const UserListItemDetailsPage({required this.userList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: GroupedListView(
        physics: const BouncingScrollPhysics(),
        padding:
            const EdgeInsets.only(left: 18, right: 18, bottom: 10, top: 20),
        elements: userList.items,
        groupBy: (ListItem element) => element.catName,
        indexedItemBuilder: (BuildContext context, dynamic element, int index) {
          return SentListItemCard(
            listItem: element,
          );
        },
        groupSeparatorBuilder: (String value) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              )
            ],
          );
        },
      ),
    );
  }
}
