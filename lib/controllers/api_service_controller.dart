import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santhe/core/error/exceptions.dart';
import 'package:santhe/models/merchant_details_response.dart';
import 'package:santhe/models/offer/customer_offer_response.dart';
import 'package:santhe/models/offer/merchant_offer_response.dart';
import 'package:santhe/models/santhe_cache_refresh.dart';
import 'package:santhe/models/santhe_category_model.dart';
import 'package:santhe/models/santhe_user_credenetials_model.dart';
import 'package:santhe/models/santhe_user_list_model.dart';
import 'package:santhe/pages/error_pages/no_internet_page.dart';
import 'package:santhe/pages/error_pages/server_error_page.dart';
import '../core/app_helpers.dart';
import '../models/santhe_faq_model.dart';
import '../models/santhe_item_model.dart';
import '../models/santhe_list_item_model.dart';
import '../models/santhe_user_model.dart';
import 'boxes_controller.dart';

class APIs extends GetxController {
  //Items & Category
  // var categoriesDB = <Category>[].obs;
  var userListsDB = <UserList>[].obs;

  //needed so that concurrent modification does not occur while iterating.
  var offlineCustLists = <UserList>[].obs;

  //to split and only call online list when truly needed.
  var onlineCustLists = <UserList>[].obs;

  //deleted user list buffer
  var deletedUserLists = <UserList>[].obs;

  var itemsDB = <Item>[].obs;

  // Future getAllItems() async {
  //   String pageToken = '';
  //   Boxes.getItemsDB().clear();
  //   String url =
  //       'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/item?pageSize=1000';
  //   void parseItems(jsonResponse) {
  //     for (int i = 0; i < jsonResponse['documents'].length; i++) {
  //       var data = jsonResponse['documents'][i]['fields'];
  //       Item item = Item.fromJson(data);
  //       log('---->' + item.itemName);
  //       Boxes.getItemsDB().put(item.itemId, item);
  //     }
  //   }
  //
  //   final response = await http.get(Uri.parse(url));
  //   var jsonResponse = jsonDecode(response.body);
  //
  //   if (response.statusCode == 200) {
  //     if (jsonResponse['nextPageToken'] != null) {
  //       parseItems(jsonResponse);
  //       pageToken = jsonResponse['nextPageToken'];
  //
  //       while (pageToken.isNotEmpty) {
  //         log('#############################3');
  //         String url2 =
  //             'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/item?pageSize=1000&pageToken=$pageToken';
  //         final response = await http.get(Uri.parse(url2));
  //         var jsonResponse = jsonDecode(response.body);
  //         parseItems(jsonResponse);
  //
  //         if (jsonResponse['nextPageToken'] != null) {
  //           pageToken = jsonResponse['nextPageToken'];
  //         } else {
  //           pageToken = '';
  //         }
  //       }
  //
  //       itemInit();
  //       log('------- GOT ALL ITEMS------');
  //     } else {
  //       parseItems(jsonResponse);
  //       itemInit();
  //     }
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  // Future getAllItems() async {
  //   Boxes.getItemsDB().clear();
  //   String url =
  //       'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/item?pageSize=1000';
  //
  //   void parseItems(jsonResponse) {
  //     for (int i = 0; i < jsonResponse['documents'].length; i++) {
  //       var data = jsonResponse['documents'][i]['fields'];
  //       Item item = Item.fromFirebaseRestApi(data);
  //       log('---->' + item.itemName);
  //       if (item.status == 'active') {
  //         Boxes.getItemsDB().put(item.itemId, item);
  //       }
  //     }
  //   }
  //
  //   var response = await http.get(Uri.parse(url));
  //   var jsonResponse = jsonDecode(response.body);
  //
  //   if (response.statusCode == 200) {
  //     parseItems(jsonResponse);
  //     while (jsonResponse['nextPageToken'] != null) {
  //       url =
  //           'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/item?pageSize=1000&pageToken=${jsonResponse['nextPageToken']}';
  //       response = await http.get(Uri.parse(url));
  //       jsonResponse = jsonDecode(response.body);
  //       parseItems(jsonResponse);
  //     }
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  Future<http.Response> callApi(
      {required int mode, required Uri url, String? body}) async {
    // case 1: get
    // case 2: post
    // case 3: update
    switch (mode) {
      case 1:
        {
          try {
            return await http.get(url);
          } on SocketException {
            Get.to(
              () => const NoInternetPage(),
              transition: Transition.fade,
            );
          }
          throw NoInternetError();
        }

      case 2:
        {
          try {
            return await http.post(url, body: body!);
          } on SocketException {
            Get.to(
              () => const NoInternetPage(),
              transition: Transition.fade,
            );
          }
          throw NoInternetError();
        }

      case 3:
        {
          try {
            return await http.patch(url, body: body!);
          } on SocketException {
            Get.to(
              () => const NoInternetPage(),
              transition: Transition.fade,
            );
          }
          throw NoInternetError();
        }

      default:
        throw WrongModePassedForAPICall('Wrong mode passed for API call.');
    }
  }

  Future<int> getSubscriptionLimit(String plan) async{
    String url = 'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/config/control';
    if(plan=='default'){
      plan='planA';
    }
    var response = await callApi(mode: 1, url: Uri.parse(url));
    var jsonResponse = jsonDecode(response.body);
    if(jsonResponse!=null && response.statusCode==200){
      return int.parse(jsonResponse['subscription']['custSubscription'][plan]);
    }else{
      Get.to(()=>const ServerErrorPage());
      throw ServerError;
    }
    return 0;
  }

  //get
  Future<int> getItemsCount() async {
    // Boxes.getItemsDB().clear();

    String url =
        'https://us-central1-santhe-425a8.cloudfunctions.net/apis/santhe/v1/items/next-id';

    var response = await callApi(mode: 1, url: Uri.parse(url));
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != null) {
      int nextItemCount = jsonResponse;
      return nextItemCount;
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  // void itemInit() {
  //   itemsDB.clear();
  //   for (Item item in Boxes.getItemsDB().values.toList()) {
  //     itemsDB.add(item);
  //   }
  // }

  //
  // Future<Item> getItemsById(int id) async {
  //   final String url =
  //       'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/item/$id';
  //
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //     var data = jsonResponse['fields'];
  //
  //     return Item.fromJson(data);
  //   } else {
  //     Future.error('Error: ${response.statusCode}');
  //     throw 'Error: ${response.statusCode}';
  //   }
  // }
  //

  // void initCategoriesDB() {
  //   var box = Boxes.getCategoriesDB();
  //   categoriesDB.clear();
  //   var a = box.values.toList();
  //   for (int i = 0; i < a.length; i++) {
  //     categoriesDB.add(a[i]);
  //   }
  // }
  //add item post addItem
  Future<int> addItem(Item newCustomItem) async {
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/item/?documentId=${newCustomItem.itemId}';

    List units = [];
    for (int i = 0; i < newCustomItem.unit.length; i++) {
      units.add({"stringValue": newCustomItem.unit[i]});
    }

    var body = {
      "fields": {
        "dQuantity": {"integerValue": "${newCustomItem.dQuantity}"},
        "catId": {
          "referenceValue":
              "projects/santhe-425a8/databases/(default)/documents/category/4000"
        },
        "itemImageIdTn": {"stringValue": newCustomItem.itemImageTn},
        "itemName": {"stringValue": newCustomItem.itemName},
        "unit": {
          "arrayValue": {"values": units}
        },
        "itemAlias": {"stringValue": ""},
        "createUser": {"integerValue": "${newCustomItem.createUser}"},
        "dUnit": {"stringValue": newCustomItem.unit[0]},
        "dItemNotes": {"stringValue": newCustomItem.dItemNotes},
        "itemId": {"integerValue": "${newCustomItem.itemId}"},
        "itemUpdateTime": {
          "timestampValue":
              DateTime.now().toUtc().toString().replaceAll(' ', 'T')
        },
        "dBrandType": {"stringValue": newCustomItem.dBrandType},
        "itemImageId": {"stringValue": newCustomItem.itemImageId},
        "status": {"stringValue": newCustomItem.status},
        "updateUser": {"integerValue": "${newCustomItem.updateUser}"}
      }
    };

    var response =
        await callApi(mode: 2, url: Uri.parse(url), body: jsonEncode(body));

    log(jsonDecode(response.body).toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      log('Custom Item Created: $data');
      return 1;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      log('Reason: ${response.reasonPhrase}.');
      return 0;
    }
  }

  Future<CacheRefresh> cacheRefreshInfo() async {
    const String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/config/cacheRefresh/';

    final response = await callApi(mode: 1, url: Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body)['fields'];
      log('===AboutUS: ${jsonResponse['catUpdate']['timestampValue']}');
      CacheRefresh cacheRefresh = CacheRefresh.fromJson(jsonResponse);

      return cacheRefresh;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'error!';
    }
  }

  Future getAllCategories() async {
    const String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/category?pageSize=30';

    final response = await callApi(mode: 1, url: Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      for (int i = 0; i < jsonResponse['documents'].length; i++) {
        var data = jsonResponse['documents'][i]['fields'];
        Category currentCategory = Category.fromJson(data);
        if (currentCategory.status == 'active') {
          Boxes.getCategoriesDB().put(currentCategory.catId, currentCategory);
        }
      }
      // initCategoriesDB(); //since its already in main no need for it here
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      log('Request failed with status: ${response.statusCode}.');
    }
  }

  //POST
  //Needed for import from old list feature & list count
  Future<int> getAllCustomerLists(int custId) async {
    userListsDB.clear();
    onlineCustLists.clear();
    offlineCustLists.clear();
    int userListsCount = 0;

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
    var response =
        await callApi(mode: 2, url: Uri.parse(url), body: jsonEncode(body));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      for (UserList usrLst in Boxes.getUserListDB().values) {
        offlineCustLists.add(usrLst);
        log(usrLst.listId.toString());
      }

      if (data[0]['document'] != null &&
          data[0]['document']['fields'] != null) {
        for (int i = 0; i < data.length; i++) {
          if (data[i]['document']['fields']['custListStatus']['stringValue'] !=
              'deleted') {
            UserList onlineUserList =
                UserList.fromJson(data[i]['document']['fields']);
            final box = Boxes.getUserListDB();
            if (onlineUserList.listId ==
                offlineCustLists
                    .firstWhereOrNull((e) => e.listId == onlineUserList.listId)
                    ?.listId) {
              log(
                  'Duplicate Found: ${onlineUserList.listId} and not added to local cache');
            } else {
              onlineCustLists.add(onlineUserList);
              if (onlineUserList.custListStatus == 'new') {
                box.add(onlineUserList);
              }
            }
          }
        }
        userListsDB.addAll(onlineCustLists);
        userListsDB.addAll(offlineCustLists);
        Boxes.getContent().put('userListCount', '${data.length}');
        userListsCount = data.length;
        log('List Count: $userListsCount');
        return userListsCount;
      } else if (data[0]['document'] != null && data[0]['document'] == null) {
        Boxes.getContent().put('userListCount', '0');
        userListsCount = 0;
        log('List Count: $userListsCount');
        return userListsCount;
      }

      for (var element in userListsDB) {
        log(element.listId.toString());
      }

      return userListsCount;
    } else {
      log('Error Occured! ${response.statusCode}: ${response.body}');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 9999999999;
    }
  }

  //get
  Future<int> getAllFAQs() async {
    const String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/content/custContent';

    final response = await callApi(mode: 1, url: Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      var data = jsonResponse['fields']['faq']['arrayValue']['values'];

      for (int i = 0; i < data.length; i++) {
        Boxes.getFAQs().put(i, FAQ.fromJson(data[i]));
      }
      // log(Boxes.getFAQs().get(1)?.quest ?? 'Error');
      // log(Boxes.getFAQs().get(1)?.answ ?? 'Error');

      return 1;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  //get
  //get and store common content like about us and terms & cond from backend
  Future<int> getCommonContent() async {
    const String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/content/common/';

    final response = await callApi(mode: 1, url: Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['fields'] == null) {
        return 0;
      }
      var data = jsonResponse['fields'];
      Boxes.getContent().put('aboutUs', data['aboutUsHtml']['stringValue']);
      Boxes.getContent().put(
          'termsAndConditions', data['termsConditionsHtml']['stringValue']);
      Boxes.getContent()
          .put('privacyPolicy', data['privacyPolicyHtml']['stringValue']);

      return 1;
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      log('Request failed with status: ${response.statusCode}.');
      return 0;
    }
  }

  // Future<Category> getCategoryByID(int id) async {
  //   final String url =
  //       'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/category/$id';
  //
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //     var data = jsonResponse['fields'];
  //     return Category.fromJson(data);
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //     throw 'Error!';
  //   }
  // }

  //post
  Future<List<Item>> getCategoryItems(int id) async {
    List<Item> categoryItems = [];
    const String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents:runQuery';
    var body = {
      "structuredQuery": {
        "from": [
          {"collectionId": "item"}
        ],
        "where": {
          "compositeFilter": {
            "filters": [
              {
                "fieldFilter": {
                  "field": {"fieldPath": "catId"},
                  "op": "EQUAL",
                  "value": {
                    "referenceValue":
                        "projects/santhe-425a8/databases/(default)/documents/category/$id"
                  }
                }
              }
            ],
            "op": "AND"
          }
        }
      }
    };
    var response =
        await callApi(mode: 2, url: Uri.parse(url), body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        categoryItems
            .add(Item.fromFirebaseRestApi(data[i]['document']['fields']));
      }
      log('#####Returning with cat items#######');
      return categoryItems;
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'Error, Category Does not Exist!';
    }
  }

  Future<int> addCustomerList(
      UserList userList, int custId, String status) async {
    log("================${userList.listId}======================");
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/customerList/?documentId=${userList.listId}';
    List items = [];
    int i = 0;
    for (ListItem item in userList.items) {
      items.add({
        "mapValue": {
          "fields": {
            "quantity": {"doubleValue": "${item.quantity}"},
            "itemImageId": {"stringValue": item.itemImageId},
            "unit": {"stringValue": item.unit},
            "itemName": {"stringValue": item.itemName},
            "catName": {"stringValue": item.catName},
            "catId": {
              "referenceValue":
                  "projects/santhe-425a8/databases/(default)/documents/category/${item.catId}"
            },
            "itemSeqNum": {"integerValue": "$i"},
            "brandType": {"stringValue": item.brandType},
            "itemId": {
              "referenceValue":
                  "projects/santhe-425a8/databases/(default)/documents/item/${item.itemId}"
            },
            "notes": {"stringValue": item.notes}
          }
        }
      });
      i++;
    }
    // log(items);

    var body = {
      "fields": {
        "createListTime": {
          "timestampValue":
              userList.createListTime.toUtc().toString().replaceAll(' ', 'T')
        },
        "items": {
          "arrayValue": {"values": items}
        },
        "custListStatus": {"stringValue": status},
        "custId": {
          "referenceValue":
              "projects/santhe-425a8/databases/(default)/documents/customer/$custId"
        },
        "custListSentTime": {
          "timestampValue":
              userList.createListTime.toUtc().toString().replaceAll(' ', 'T')
        },
        'notificationProcess': {'stringValue': 'reminder'},
        'dealProcess': {'booleanValue': false},
        "custOfferWaitTime": {
          "timestampValue":
              DateTime.now().toUtc().toString().replaceAll(' ', 'T')
        },
        "listOfferCounter": {"integerValue": "0"},
        "processStatus": {"stringValue": "draft"},
        "listId": {"integerValue": "${userList.listId}"},
        "listName": {"stringValue": userList.listName}
      }
    };

    var response =
        await callApi(mode: 2, url: Uri.parse(url), body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log(data.toString());
      return 1;
    } else {
      log('Request failed with status: ${response.reasonPhrase}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  //-------------------------------------User List--------------------------------------

  //patch
  Future updateUserList(int custId, UserList userList,
      {String? status, String? processStatus}) async {
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/customerList/${userList.listId}?updateMask.fieldPaths=listName&updateMask.fieldPaths=custListSentTime&updateMask.fieldPaths=processStatus&updateMask.fieldPaths=createListTime&updateMask.fieldPaths=custListStatus&updateMask.fieldPaths=custId&updateMask.fieldPaths=listOfferCounter&updateMask.fieldPaths=items&updateMask.fieldPaths=listId&updateMask.fieldPaths=updateListTime&updateMask.fieldPaths=custOfferWaitTime';
    List items = [];
    int i = 0;
    for (ListItem item in userList.items) {
      items.add({
        "mapValue": {
          "fields": {
            "quantity": {"doubleValue": "${item.quantity}"},
            "itemImageId": {
              "stringValue": item.itemImageId.replaceAll(
                  'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/',
                  '')
            },
            "unit": {"stringValue": item.unit},
            "itemName": {"stringValue": item.itemName},
            "catName": {"stringValue": item.catName},
            "catId": {
              "referenceValue":
                  "projects/santhe-425a8/databases/(default)/documents/category/${item.catId}"
            },
            "itemSeqNum": {"integerValue": "$i"},
            "brandType": {"stringValue": item.brandType},
            "itemId": {
              "referenceValue":
                  "projects/santhe-425a8/databases/(default)/documents/item/${item.itemId}"
            },
            "notes": {"stringValue": item.notes}
          }
        }
      });
      i++;
    }
    // log(items);

    final body = {
      "fields": {
        "custListSentTime": {
          "timestampValue":
              DateTime.now().toUtc().toString().replaceAll(' ', 'T')
        },
        "processStatus": {"stringValue": processStatus ?? "draft"},
        "custOfferWaitTime": {
          "timestampValue":
              DateTime.now().toUtc().toString().replaceAll(' ', 'T')
        },
        "createListTime": {
          "timestampValue":
              userList.createListTime.toUtc().toString().replaceAll(' ', 'T')
        },
        "custListStatus": {"stringValue": status ?? "sent"},
        "custId": {
          "referenceValue":
              "projects/santhe-425a8/databases/(default)/documents/customer/$custId"
        },
        "listOfferCounter": {"integerValue": "0"},
        "listName": {"stringValue": userList.listName},
        "items": {
          "arrayValue": {"values": items}
        },
        "listId": {"integerValue": "${userList.listId}"},
        "updateListTime": {
          "timestampValue":
              DateTime.now().toUtc().toString().replaceAll(' ', 'T')
        }
      }
    };

    var response = await callApi(mode: 3, url: Uri.parse(url), body: jsonEncode(body));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log(data.toString());

      log('SUCCESS');
      return 1;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      var data = jsonDecode(response.body);
      log(data.toString());
      log('Error', error: response.reasonPhrase);
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  //patch
  Future deleteUserList(int userListId) async {
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/customerList/$userListId?updateMask.fieldPaths=custListStatus';

    final body = {
      "fields": {
        "custListStatus": {"stringValue": "deleted"}
      }
    };

    var response = await callApi(mode: 3, url: Uri.parse(url), body: jsonEncode(body));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log(data.toString());
      return 1;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      var data = jsonDecode(response.body);
      log(data.toString());
      log('Error', error:response.reasonPhrase);
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  Future undoDeleteUserList(int userListId, String status) async {
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/customerList/$userListId?updateMask.fieldPaths=custListStatus';

    final body = {
      "fields": {
        "custListStatus": {"stringValue": status}
      }
    };

    var response = await callApi(mode: 3, url: Uri.parse(url), body: jsonEncode(body));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log(data.toString());
      return 1;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      var data = jsonDecode(response.body);
      log(data.toString());
      log('Error', error:response.reasonPhrase);
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  // LOGIN & USER
  static const String apiKey = "AIzaSyCFS_yaSebSR9VZC7Qv3QCCC9DNoyTzJ48";

  //post
  Future<String> getOTP(int phoneNumber) async {
    const String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode?key=$apiKey';

    var body = {"phoneNumber": "+91$phoneNumber"};

    var response =
        await callApi(mode: 2, url: Uri.parse(url), body: jsonEncode(body));

    log(jsonDecode(response.body).toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String sessionInfo = data['sessionInfo'] ?? 'Error';
      log('----->SESSION ID: $sessionInfo');
      return sessionInfo;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      log('Reason: ${response.reasonPhrase}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'Error!';
    }
  }

  //post
  Future<bool> verifyOTP(String sessionInfo, int code) async {
    const String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPhoneNumber?key=$apiKey';

    var body = {"sessionInfo": sessionInfo, "code": code};

    var response =
        await callApi(mode: 2, url: Uri.parse(url), body: jsonEncode(body));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      UserCredential currentUserCredentials = UserCredential.fromJson(data);

      Boxes.getUserCredentialsDB()
          .put('currentUserCredentials', currentUserCredentials);

      // UserCredential? myUsr =
      //     Boxes.getUserCredentialsDB().get('currentUserCredentials');

      // log(myUsr?.idToken);
      // log(myUsr?.refreshToken);
      // log(myUsr?.expiresIn);
      // log(myUsr?.localId);
      // log(myUsr?.isNewUser);
      // log(myUsr?.phoneNumber);
      return true;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return false;
    }
  }

  //post
  Future<int> addCustomer(User user) async {
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/customer/?documentId=${user.custId}';
    String _token = await AppHelpers().getToken;
    String _uid = await AppHelpers().getDeviceId();

    var body = {
      "fields": {
        "custName": {"stringValue": user.custName},
        "custLoginTime": {
          "timestampValue":
              DateTime.now().toUtc().toString().replaceAll(' ', 'T')
        },
        "custReferal": {"integerValue": "0"},
        "contact": {
          "mapValue": {
            "fields": {
              "phoneNumber": {"integerValue": "${user.phoneNumber}"},
              "pincode": {"integerValue": "${user.pincode}"},
              "address": {"stringValue": user.address},
              "emailId": {"stringValue": user.emailId},
              "location": {
                "mapValue": {
                  "fields": {
                    "lng": {"doubleValue": user.lng},
                    "lat": {"doubleValue": user.lat}
                  }
                }
              },
              "howToReach": {"stringValue": user.howToReach}
            }
          }
        },
        "custId": {"integerValue": "${user.custId}"},
        "custStatus": {"stringValue": "active"},
        "custRatings": {"doubleValue": "5.0"},
        "custPlan": {"stringValue": user.custPlan},
        "deviceMap": {
          "mapValue": {
            "fields": {
              _uid: {"stringValue": _token}
            }
          }
        }
      }
    };

    var response =
        await callApi(mode: 2, url: Uri.parse(url), body: jsonEncode(body));
    if (response.statusCode == 200) {
      // var data = jsonDecode(response.body);
      log('user added');
      return 1;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'Error!';
      // return 0;
    }
  }

  //get
  Future<int> getCustomerInfo(int custId) async {
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/customer/$custId';

    var response = await callApi(mode: 1, url: Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['fields'] != null) {
        var jsonData = data['fields'];

        User currentUser = User.fromJson(jsonData);

        var box = Boxes.getUser();
        box.put('currentUserDetails', currentUser);

        return 1;
      } else {
        log('Request failed with status: ${response.statusCode}.');
        return 0;
      }
    } else {
      log('Request failed with status: ${response.statusCode}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  //patch
  Future updateCustomerInfo(int custId, User updatedUser) async {
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/customer/$custId?updateMask.fieldPaths=custName&updateMask.fieldPaths=custReferal&updateMask.fieldPaths=contact&updateMask.fieldPaths=custStatus&updateMask.fieldPaths=custRatings&updateMask.fieldPaths=custId';

    final body = {
      "fields": {
        "custReferal": {"integerValue": "${updatedUser.custReferal}"},
        "contact": {
          "mapValue": {
            "fields": {
              "location": {
                "mapValue": {
                  "fields": {
                    "lng": {"doubleValue": updatedUser.lng},
                    "lat": {"doubleValue": updatedUser.lat}
                  }
                }
              },
              "phoneNumber": {"integerValue": "${updatedUser.phoneNumber}"},
              "pincode": {"integerValue": "${updatedUser.pincode}"},
              "address": {"stringValue": updatedUser.address},
              "emailId": {"stringValue": updatedUser.emailId},
              "howToReach": {"stringValue": updatedUser.howToReach}
            }
          }
        },
        "custStatus": {"stringValue": updatedUser.custStatus},
        "custName": {"stringValue": updatedUser.custName},
        "custRatings": {"doubleValue": "${updatedUser.custRatings}"},
        "custId": {"integerValue": "$custId"}
      }
    };

    var response = await callApi(mode: 3, url: Uri.parse(url), body: jsonEncode(body));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log(data.toString());
      getCustomerInfo(custId);

      log('SUCCESS');
      return 1;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      log('Error', error:response.reasonPhrase);
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  //post
  // Future<int> getCustListNumber(int custId) async {
  //   const String url =
  //       'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents:runQuery';
  //
  //   final body = {
  //     "structuredQuery": {
  //       "from": [
  //         {"collectionId": "customerList"}
  //       ],
  //       "where": {
  //         "compositeFilter": {
  //           "filters": [
  //             {
  //               "fieldFilter": {
  //                 "field": {"fieldPath": "custId"},
  //                 "op": "EQUAL",
  //                 "value": {
  //                   "referenceValue":
  //                       "projects/santhe-425a8/databases/(default)/documents/customer/$custId"
  //                 }
  //               }
  //             }
  //           ],
  //           "op": "AND"
  //         }
  //       }
  //     }
  //   };
  //
  //   var response = await http.post(Uri.parse(url), body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     List data = jsonDecode(response.body);
  //     int custListNumber = 0;
  //     for (int i = 0; i < data.length; i++) {
  //       custListNumber++;
  //     }
  //     if (custListNumber == 1 && data[0]['document'] == null) {
  //       custListNumber = 0;
  //     }
  //
  //     Boxes.getContent().put('userListCount', '$custListNumber');
  //     log('>>>>>>UserListNumber: $custListNumber');
  //     return custListNumber;
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //     return 9999999999;
  //   }
  // }

  //post
  Future contactUs(int custId, String message, double rating) async {
    log('>>>>>>>>rating:$rating');
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/contactUs/?documentId=$custId${DateTime.now().day.toString().length == 1 ? '0' + DateTime.now().day.toString() : DateTime.now().day}${DateTime.now().month.toString().length == 1 ? '0' + DateTime.now().month.toString() : DateTime.now().month}${DateTime.now().year.toString().substring(2, 4)}${DateTime.now().hour.toString().length == 1 ? '0' + DateTime.now().hour.toString() : DateTime.now().hour}${DateTime.now().minute.toString().length == 1 ? '0' + DateTime.now().minute.toString() : DateTime.now().minute}${DateTime.now().second.toString().length == 1 ? '0' + DateTime.now().second.toString() : DateTime.now().second}';

    final body = {
      "fields": {
        "rating": {"doubleValue": "$rating"},
        "message": {"stringValue": message},
        "toNotify": {"stringValue": "manjunath.munigowda@santhe.in"},
        "contact": {
          "referenceValue":
              "projects/santhe-425a8/databases/(default)/documents/customer/$custId"
        },
        "source": {"stringValue": "app"}
      }
    };

    var response =
        await callApi(mode: 2, url: Uri.parse(url), body: jsonEncode(body));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log(data.toString());
      return 1;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  //SENT TAB PAGE ----------------------------------------------------------------------
  //get sent user lists
  Future<List<UserList>> getCustListByStatus(int custId) async {
    List<UserList> userLists = [];
    const String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents:runQuery';
    var body = {
      "structuredQuery": {
        "from": [
          {"collectionId": "customerList"}
        ],
        "orderBy": {
          "field": {"fieldPath": "custListSentTime"}
        },
        "where": {
          "compositeFilter": {
            "filters": [
              {
                "fieldFilter": {
                  "field": {"fieldPath": "custListStatus"},
                  "op": "EQUAL",
                  "value": {"stringValue": "sent"}
                }
              },
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

    var response =
        await callApi(mode: 2, url: Uri.parse(url), body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data[0]['document']['fields'] != null) {
        for (int i = 0; i < data.length; i++) {
          userLists.add(UserList.fromJson(data[i]['document']['fields']));
          log('${userLists[i].listId}, ${userLists[i].processStatus}');
        }
        userLists
            .sort((a, b) => b.custListSentTime.compareTo(a.custListSentTime));
      } else {
        return userLists;
      }
      return userLists;
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'Error retrieving user lists!';
    }
  }

  //POST
  // Future<List<Offer>> getAllMerchOfferByListId(int listId) async {
  //   log(listId);
  //   List<Offer> merchOffers = [];
  //   const String url =
  //       'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents:runQuery';
  //   var body = {
  //     "structuredQuery": {
  //       "from": [
  //         {"collectionId": "listEvent"}
  //       ],
  //       "where": {
  //         "compositeFilter": {
  //           "filters": [
  //             {
  //               "fieldFilter": {
  //                 "field": {"fieldPath": "listId"},
  //                 "op": "EQUAL",
  //                 "value": {
  //                   "referenceValue":
  //                       "projects/santhe-425a8/databases/(default)/documents/customerList/$listId"
  //                 }
  //               }
  //             }
  //           ],
  //           "op": "AND"
  //         }
  //       }
  //     }
  //   };
  //
  //   var response = await http.post(Uri.parse(url), body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //
  //     if (data[0]['document'] != null) {
  //       for (int i = 0; i < data.length; i++) {
  //         merchOffers
  //             .add(Offer.fromFirebaseRestApi(data[i]['document']['fields']));
  //         log(merchOffers[i].merchId + merchOffers[i].listId);
  //       }
  //     } else {
  //       return merchOffers;
  //     }
  //     return merchOffers;
  //   } else {
  //     throw 'Error retrieving user lists!';
  //   }
  // }

  //SENT TAB POST
  Future<List<CustomerOfferResponse>> getAllMerchOfferByListId(
      int listId) async {
    String url =
        'https://us-central1-santhe-425a8.cloudfunctions.net/apis/santhe/v1/listevents/${listId.toString()}/offers';

    var response = await callApi(mode: 1, url: Uri.parse(url));
    if (response.statusCode == 200) {
      List<CustomerOfferResponse> resp =
          customerOfferResponseFromJson(response.body);
      // resp.sort((a, b) => a.merchResponse.merchTotalPrice.compareTo(b.merchResponse.merchTotalPrice));
      // resp.sort((a, b) => a.merchResponse.merchOfferQuantity.compareTo(b.merchResponse.merchOfferQuantity));
      // resp[0].custOfferResponse.custDeal = 'best1';
      // resp[1].custOfferResponse.custDeal = 'best2';
      // resp[2].custOfferResponse.custDeal = 'best3';
      // for(var i=3;i<resp.length;i++){
      //   resp[i].custOfferResponse.custDeal = '';
      // }
      return resp;
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'Error retrieving user lists!';
    }
  }

  Future<MerchantDetailsResponse> getMerchantDetails(String merchId) async {
    String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/merchant/$merchId';

    var response = await callApi(mode: 1, url: Uri.parse(url));
    log(response.body.toString());

    if (response.statusCode == 200) {
      MerchantDetailsResponse resp =
          merchantDetailsResponseFromJson(response.body);
      return resp;
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'Error retrieving merchant details!';
    }
  }

  //patch
  Future<int> acceptOffer(String listEventId) async {
    log('Offer Accepted! ListEvent ID: $listEventId');
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/listEvent/${BigInt.parse(listEventId)}?updateMask.fieldPaths=custOfferResponse';

    var body = {
      "fields": {
        "custOfferResponse": {
          "mapValue": {
            "fields": {
              "custDeal": {"stringValue": "best1"},
              "custOfferStatus": {"stringValue": "accepted"},
              // "custUpdateTime": {"timestampValue": "2022-05-03T08:50:12Z"}
            }
          }
        },
        "merchResponse":{
          "merchUpdateTime": DateTime.now().toUtc().toString().replaceAll(' ', 'T'),
        }
      }
    };

    var response =
        await callApi(mode: 3, url: Uri.parse(url), body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log(data.toString());
      log('Offer Accepted! ListEvent ID: $listEventId');
      return 1;
    } else {
      log(
          'Request failed with status: ${response.statusCode}.Details? ${response.body}');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  Future<MerchantOfferResponse> getMerchantResponse(String listId) async {
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/listEvent/$listId';

    var response = await callApi(mode: 1, url: Uri.parse(url));
    if (response.statusCode == 200) {
      MerchantOfferResponse data = merchantOfferResponseFromJson(response.body);
      return data;
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'Error retrieving merchant response';
    }
  }

  Future<int> processedStatusChange(int listId) async {
    log('**********processedStatusChange***********');
    final String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/customerList/$listId?updateMask.fieldPaths=processStatus';
    var body = {
      "fields": {
        "processStatus": {"stringValue": "accepted"}
      }
    };

    var response = await callApi(mode: 3, url: Uri.parse(url), body: jsonEncode(body));
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log(data.toString());
      log('Offer Accepted! List ID: $listId');
      return 1;
    } else {
      log(
          'Request failed with status: ${response.statusCode}.Details? ${response.body}');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  //Archived Tab APIs------------------------------------------------
  //POST
  Future<List<UserList>> getArchivedCust(int custId) async {
    List<UserList> userLists = [];
    const String url =
        'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents:runQuery';
    var body = {
      "structuredQuery": {
        "from": [
          {"collectionId": "customerList"}
        ],
        "orderBy": {
          "field": {"fieldPath": "custListSentTime"}
        },
        "where": {
          "compositeFilter": {
            "filters": [
              {
                "fieldFilter": {
                  "field": {"fieldPath": "custListStatus"},
                  "op": "EQUAL",
                  "value": {"stringValue": "archived"}
                }
              },
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

    var response =
        await callApi(mode: 2, url: Uri.parse(url), body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data[0]['document']['fields'] != null) {
        for (int i = 0; i < data.length; i++) {
          userLists.add(UserList.fromJson(data[i]['document']['fields']));
          log('${userLists[i].listId}, ${userLists[i].processStatus}');
        }
        // userLists
        //     .sort((a, b) => b.custListSentTime.compareTo(a.custListSentTime));
      } else {
        return userLists;
      }
      return userLists;
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'Error retrieving user lists!';
    }
  }

//SEARCH POST

  Future<List<Item>> searchedItemResult(String searchQuery) async {
    List<Item> searchResults = [];
    final String url =
        'https://us-central1-santhe-425a8.cloudfunctions.net/apis/santhe/v1/search/items?searchCriteria=$searchQuery';

    final response = await callApi(mode: 1, url: Uri.parse(url));

    if (response.statusCode == 200) {
      log(searchQuery);
      log(response.body.toString());
      List jsonResponse = jsonDecode(response.body);

      for (int i = 0; i < jsonResponse.length; i++) {
        if (jsonResponse[i]['status'] == 'active') {
          searchResults.add(Item.fromJson(jsonResponse[i]));
        }
      }

      return searchResults;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'error!';
    }
  }

  Future<void> updateDeviceToken(String userId) async {
    final String _token = await AppHelpers().getToken;
    String _uid = await AppHelpers().getDeviceId();
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'PUT',
        Uri.parse(
            'https://us-central1-santhe-425a8.cloudfunctions.net/apis/santhe/v1/customers/$userId/deviceToken'));
    request.body = json.encode({"deviceToken": _token, "deviceId": _uid});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log((await response.stream.bytesToString()).toString());
    } else {
      log('Error', error:response.reasonPhrase);
    }
  }
}
