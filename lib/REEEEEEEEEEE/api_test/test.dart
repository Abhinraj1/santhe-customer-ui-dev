import 'dart:convert';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/models/santhe_user_list_model.dart';
import '../../controllers/boxes_controller.dart';
import 'dart:collection';

List<UserList> userListsDB = [];
List<UserList> onlineCustLists = [];
List<UserList> offlineCustLists = [];

void main() async {
  List<UserList> a = await getAllCustomerLists(9769420366);
  a.forEach((element) {
    print(element.listName);
  });
}

Future getAllCustomerLists(int custId) async {
  const String url =
      'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents:runQuery';
  var body = {
    "structuredQuery": {
      "from": [
        {"collectionId": "customerList"}
      ],
      "orderBy": {
        "field": {"fieldPath": "createListTime"}
      },
      "where": {
        "compositeFilter": {
          "filters": [
            {
              "fieldFilter": {
                "field": {"fieldPath": "custId"},
                "op": "EQUAL",
                "value": {
                  "referenceValue":
                      "projects/santhe-425a8/databases/(default)/documents/customer/$custId"
                }
              }
            }
          ],
          "op": "AND"
        }
      }
    }
  };
  var response = await http.post(Uri.parse(url), body: jsonEncode(body));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    for (UserList usrLst in Boxes.getUserListDB().values) {
      offlineCustLists.add(usrLst);
    }

    if (data[0]['document'] != null && data[0]['document']['fields'] != null) {
      for (int i = 0; i < data.length; i++) {
        if (data[i]['document']['fields']['custListStatus']['stringValue'] !=
            'deleted') {
          UserList onlineUserList =
              UserList.fromJson(data[i]['document']['fields']);

          if (onlineUserList.listId ==
              offlineCustLists
                  .firstWhereOrNull((e) => e.listId == onlineUserList.listId)
                  ?.listId) {
            print('Duplicate Found: ${onlineUserList.listId}');
          } else {
            onlineCustLists.add(onlineUserList);
          }

          // print('${userListsDB[i].listId}, ${userListsDB[i].processStatus}');
        }
      }
      userListsDB.addAll(onlineCustLists);
      userListsDB.addAll(offlineCustLists);
    }
    userListsDB.forEach((element) {
      print(element.listId);
    });
  } else {
    throw 'Error retrieving user lists!';
  }
}
