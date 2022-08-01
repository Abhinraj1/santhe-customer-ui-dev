import 'package:santhe/models/new_list/list_item_model.dart';

class UserListModel{

  UserListModel({
    required this.createListTime,
    required this.custId,
    required this.items,
    required this.listId,
    required this.listName,
    required this.custListSentTime,
    required this.custListStatus,
    required this.listOfferCounter,
    required this.processStatus,
    required this.custOfferWaitTime,
    required this.listUpdateTime
  });

  DateTime createListTime;
  String custId;
  DateTime custListSentTime;
  String custListStatus;
  List<ListItemModel> items;
  String listId;
  String listName;
  String listOfferCounter;
  String processStatus;
  DateTime custOfferWaitTime;
  DateTime listUpdateTime;
}