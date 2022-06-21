import 'package:santhe/models/santhe_list_item_model.dart';
import 'package:hive/hive.dart';

part 'santhe_user_list_model.g.dart';

@HiveType(typeId: 1)
class UserList extends HiveObject {
  @HiveField(0)
  final DateTime createListTime;

  @HiveField(1)
  final int custId;

  @HiveField(2)
  final DateTime custListSentTime;

  @HiveField(3)
  final String custListStatus;

  @HiveField(4)
  final List<ListItem> items;

  @HiveField(5)
  final int listId;

  @HiveField(6)
  String listName;

  @HiveField(7)
  final int listOfferCounter;

  @HiveField(8)
  String processStatus;

  @HiveField(9)
  final DateTime custOfferWaitTime;

  @HiveField(10)
  final DateTime updateListTime;
  
  UserList({
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
    DateTime? updateListTime,
  }): updateListTime = updateListTime??DateTime.now();

  factory UserList.fromJson(data) {
    List<ListItem> listItems = [];
    if (data['items']['arrayValue']['values'] != null) {
      for (var map in data['items']['arrayValue']['values']) {
        listItems.add(ListItem.fromJson(map['mapValue']['fields']));
      }
    }

    try {
      return UserList(
        createListTime:
            DateTime.parse(data['createListTime']['timestampValue']),
        custId: int.parse(data['custId']['referenceValue']
            .toString()
            .replaceAll(
                'projects/santhe-425a8/databases/(default)/documents/customer/',
                '')),
        items: listItems,
        listId: int.parse(data['listId']['integerValue']),
        listName: data['listName']['stringValue'],
        custListSentTime:
            DateTime.parse(data['custListSentTime']['timestampValue']),
        custListStatus: data['custListStatus']['stringValue'],
        listOfferCounter: int.parse(data['listOfferCounter']['integerValue']),
        processStatus: data['processStatus']['stringValue'],
        custOfferWaitTime:
            DateTime.parse(data['custOfferWaitTime']['timestampValue']),
        updateListTime:
            DateTime.parse(data['updateListTime']['timestampValue']),
      );
    } catch (e) {
      return UserList(
        createListTime:
            DateTime.parse(data['createListTime']['timestampValue']),
        custId: int.parse(data['custId']['referenceValue']
            .toString()
            .replaceAll(
                'projects/santhe-425a8/databases/(default)/documents/customer/',
                '')),
        items: listItems,
        listId: int.parse(data['listId']['integerValue']),
        listName: data['listName']['stringValue'],
        custListSentTime:
            DateTime.parse(data['custListSentTime']['timestampValue']),
        custListStatus: data['custListStatus']['stringValue'],
        listOfferCounter: int.parse(data['listOfferCounter']['integerValue']),
        processStatus: data['processStatus']['stringValue'],
        custOfferWaitTime:
            DateTime.parse(data['custOfferWaitTime']['timestampValue']),
        updateListTime: DateTime.parse(data['custListSentTime']['timestampValue']),
      );
    }
  }

// factory UserList.fromFirestore(data) {
//   List<ListItem> listItems = [];
//   for (ListItem item in data['items']) {
//     listItems.add(ListItem.fromFirebase(item));
//   }
//
//   return UserList(
//       createListTime: data['createListTime'],
//       custId: data['custId'],
//       items: listItems,
//       listId: int.parse(data['listId']),
//       listName: data['listName'],
//       custListSentTime: DateTime.parse(data['custListSentTime']),
//       custListStatus: data['custListStatus'],
//       listOfferCounter: int.parse(data['listOfferCounter']),
//       processStatus: data['processStatus']);
// }
//
// Map<String, dynamic> toJson() => {
//       'createListTime': createListTime,
//       'custId': custId,
//       'items': items,
//       'listId': listId,
//       'listName': listName,
//       'custListSentTime': custListSentTime,
//       'custListStatus': custListStatus,
//       'listOfferCounter': listOfferCounter,
//       'processStatus': processStatus,
//     };
}
