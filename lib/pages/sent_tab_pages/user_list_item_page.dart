import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:santhe/models/new_list/list_item_model.dart';
import 'package:santhe/models/new_list/user_list_model.dart';

import '../../widgets/sent_tab_widgets/sent_list_item_card.dart';

class UserListItemDetailsPage extends StatelessWidget {
  final UserListModel userList;
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
        groupBy: (ListItemModel element) => element.catName,
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
