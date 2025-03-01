import 'dart:convert';
import 'dart:developer';
//import 'package:algolia/algolia.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_url.dart';
import 'package:santhe/core/error/exceptions.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/hive_models/item.dart';
import 'package:santhe/models/merchant_details_response.dart';
import 'package:santhe/models/offer/customer_offer_response.dart';
import 'package:santhe/models/offer/merchant_offer_response.dart';
import 'package:santhe/models/santhe_cache_refresh.dart';
import 'package:santhe/models/santhe_category_model.dart';
import 'package:santhe/models/santhe_user_list_model.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/pages/error_pages/server_error_page.dart';
import '../core/app_helpers.dart';
import '../models/answer_list_model.dart';
import '../models/item_model.dart';
import '../models/santhe_faq_model.dart';
import '../models/santhe_list_item_model.dart';
import '../models/santhe_user_model.dart';
import 'boxes_controller.dart';

enum REST {
  get,
  post,
  put,
  delete,
  patch,
}

class APIs extends GetxController with LogMixin {
  //Items & Category
  // var categoriesDB = <Category>[].obs;
  // var itemsDB = <Item>[].obs;

  late final Dio _dio;

  Future<http.Response> callApi({
    required REST mode,
    required Uri url,
    String? body,
  }) async {
    final tokenHandler = Get.find<ProfileController>();
    await tokenHandler.generateUrlToken();
    final token = tokenHandler.urlToken;
    final header = {"authorization": 'Bearer $token'};
    log(header.toString());
    // case 1: get
    // case 2: post
    // case 3: update
    // case 4: put
    switch (mode) {
      case REST.get:
        {
          try {
            return await http.get(
              url,
              headers: header,
            );
          } catch (e) {
            AppHelpers.crashlyticsLog(e.toString());
            throw Exception();
          }
          break;
        }

      case REST.post:
        {
          try {
            return await http.post(
              url,
              body: body!,
              headers: header,
            );
          } catch (e) {
            AppHelpers.crashlyticsLog(e.toString());
            throw Exception();
          }
          break;
        }

      case REST.patch:
        {
          try {
            return await http.patch(
              url,
              body: body!,
              headers: header,
            );
          } catch (e) {
            AppHelpers.crashlyticsLog(e.toString());
            throw Exception();
          }
          break;
        }
      case REST.put:
        {
          try {
            return await http.put(
              url,
              headers: header,
            );
          } catch (e) {
            AppHelpers.crashlyticsLog(e.toString());
            throw Exception();
          }
          break;
        }
      default:
        throw WrongModePassedForAPICall('Wrong mode passed for API call.');
    }
  }

  //get
  // Future<void> getCheckRadius(
  //     int custId, String lat, String long, String pinCode) async {
  //   final String url =
  //       AppUrl.CHECK_RADIUS(custId.toString(), lat, long, pinCode);
  //
  //   try {
  //     final response = await callApi(mode: REST.get, url: Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //
  //       final bool isInOperation = data['isInOperationalArea'] ?? true;
  //       final profileController = Get.find<ProfileController>();
  //       profileController.isOperational.value = isInOperation;
  //       profileController.customerDetails!.opStats = isInOperation;
  //     } else {
  //       AppHelpers.crashlyticsLog(response.body.toString());
  //       log('Request failed with status: ${response.statusCode}.');
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //   }
  // }

  //get
  // Future<bool> duplicateCheck(int custId, String listName) async {
  //   final String url = AppUrl.DUPLICATE_CHECK(custId.toString(), listName);
  //   bool duplicatesFound;
  //
  //   final response = await callApi(mode: REST.get, url: Uri.parse(url));
  //
  //   log(response.body);
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     duplicatesFound = data['duplicates_found'];
  //     log(data.toString());
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     log('Request failed with status: ${response.statusCode}.');
  //     return false;
  //   }
  //
  //   return duplicatesFound;
  // }

  bool retry = true;

  // Future<AnswerList?> getListByListEventId(String listEventId) async {
  //   AnswerList? userList;
  //   String url = AppUrl.LIST_BY_EVENT_ID(listEventId);
  //   var response = await callApi(mode: REST.get, url: Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     try {
  //       var data = jsonDecode(response.body);
  //       // print(response.body);
  //       List<ItemModel> listItems = [];
  //       for (var map in data['items']) {
  //         listItems.add(ItemModel(
  //           brandType: map['brandType'] ?? '',
  //           itemId: map['itemId'],
  //           // need to
  //           itemNotes: map['itemNotes'] ?? '',
  //           itemName: map['itemName'],
  //           itemImageId: map['itemImageId'],
  //           unit: map['unit'],
  //           catName: map['catName'],
  //           merchPrice: map['merchPrice'],
  //           itemSeqNum: int.parse(map['itemSeqNum'].toString()),
  //           merchAvailability: map['merchAvailability'],
  //           quantity: map['quantity'].toString(),
  //           merchNotes: map['merchNotes'] ?? '',
  //         ));
  //       }
  //       userList = AnswerList(
  //         date: data['custOfferResponse']['custUpdateTime'],
  //         custOfferStatus: data['custOfferResponse']['custOfferStatus'],
  //         custId: listEventId.substring(10, 20),
  //         items: listItems,
  //         listId: listEventId.substring(10, listEventId.length),
  //         custStatus: data['custStatus'],
  //         merchId: listEventId.substring(0, 10),
  //         custDistance: data['custDistance'].toString(),
  //         contactEnabled: data['contactEnabled'],
  //         chatEnabled: data['chatEnabled'],
  //         listEventId: listEventId,
  //         merchUpdateTime:
  //             DateTime.parse(data['merchResponse']['merchUpdateTime']),
  //         custUpdateTime:
  //             DateTime.parse(data['custOfferResponse']['custUpdateTime']),
  //         requestForDay: data['requestForDay'].toString(),
  //       );
  //       return userList;
  //     } catch (e) {
  //       if (retry) {
  //         retry = false;
  //         return await getListByListEventId(listEventId);
  //       } else {
  //         retry = true;
  //         AppHelpers.crashlyticsLog(response.body.toString());
  //         Get.to(() => const ServerErrorPage());
  //         throw ServerError();
  //       }
  //     }
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage());
  //     throw ServerError();
  //   }
  // }

  // Future<int> getSubscriptionLimit(String plan) async {
  //   String url = AppUrl.SUBSCRIPTION_PLAN;
  //   if (plan == 'default') {
  //     plan = 'planA';
  //   }
  //   var response = await callApi(mode: REST.get, url: Uri.parse(url));
  //   var jsonResponse = jsonDecode(response.body);
  //   if (jsonResponse != null && response.statusCode == 200) {
  //     return int.parse(jsonResponse['subscription']['mapValue']['fields']
  //         ['custSubscription']['mapValue']['fields'][plan]);
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     return 3;
  //   }
  // }

  //get
  // Future<int> getItemsCount() async {
  //   // Boxes.getItemsDB().clear();
  //
  //   String url = AppUrl.GET_ITEM_COUNT;
  //
  //   var response = await callApi(mode: REST.get, url: Uri.parse(url));
  //   var jsonResponse = jsonDecode(response.body);
  //   if (jsonResponse != null) {
  //     int nextItemCount = jsonResponse;
  //     return nextItemCount;
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     return 0;
  //   }
  // }

  // Future<int> addItem(Item newCustomItem) async {
  //   final String url = AppUrl.ADD_ITEM(newCustomItem.itemId.toString());
  //
  //   List units = [];
  //   for (int i = 0; i < newCustomItem.unit.length; i++) {
  //     units.add({"stringValue": newCustomItem.unit[i]});
  //   }
  //
  //   var body = {
  //     "fields": {
  //       "dQuantity": {"integerValue": "${newCustomItem.dQuantity}"},
  //       "catId": {
  //         "referenceValue":
  //             "projects/${AppUrl.envType}/databases/(default)/documents/category/4000"
  //       },
  //       "itemImageIdTn": {"stringValue": newCustomItem.itemImageTn},
  //       "itemName": {"stringValue": newCustomItem.itemName},
  //       "unit": {
  //         "arrayValue": {"values": units}
  //       },
  //       "itemAlias": {"stringValue": ""},
  //       "createUser": {"integerValue": "${newCustomItem.createUser}"},
  //       "dUnit": {"stringValue": newCustomItem.unit[0]},
  //       "dItemNotes": {"stringValue": newCustomItem.dItemNotes},
  //       "itemId": {"integerValue": "${newCustomItem.itemId}"},
  //       "itemUpdateTime": {
  //         "timestampValue":
  //             DateTime.now().toUtc().toString().replaceAll(' ', 'T')
  //       },
  //       "dBrandType": {"stringValue": newCustomItem.dBrandType},
  //       "itemImageId": {"stringValue": newCustomItem.itemImageId},
  //       "status": {"stringValue": newCustomItem.status},
  //       "updateUser": {"integerValue": "${newCustomItem.updateUser}"}
  //     }
  //   };
  //
  //   var response = await callApi(
  //       mode: REST.post, url: Uri.parse(url), body: jsonEncode(body));
  //
  //   log(jsonDecode(response.body).toString());
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //
  //     log('Custom Item Created: $data');
  //     return 1;
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //     log('Reason: ${response.reasonPhrase}.');
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     return 0;
  //   }
  // }

  // Future<CacheRefresh> cacheRefreshInfo() async {
  //   const String url = AppUrl.CACHE_REFRESH_TIME;
  //
  //   final response = await callApi(mode: REST.get, url: Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body)['fields'];
  //     log('===AboutUS: ${jsonResponse['catUpdate']['timestampValue']}');
  //     CacheRefresh cacheRefresh = CacheRefresh.fromJson(jsonResponse);
  //
  //     return cacheRefresh;
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     throw 'error!';
  //   }
  // }

  // Future getAllCategories() async {
  //   const String url = AppUrl.GET_CATEGORIES;
  //
  //   final response = await callApi(mode: REST.get, url: Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //     for (int i = 0; i < jsonResponse['documents'].length; i++) {
  //       var data = jsonResponse['documents'][i]['fields'];
  //       Category currentCategory = Category.fromJson(data);
  //       if (currentCategory.status == 'active') {
  //         Boxes.getCategoriesDB().put(currentCategory.catId, currentCategory);
  //       }
  //     }
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     log('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  // Future<bool> getAllItems() async {
  //   const String url = AppUrl.GET_ALL_ITEMS;
  //   List<Item> items = [];
  //   bool isSuccessful = false;
  //   int retry = 0;
  //
  //   while (retry < 2) {
  //     try {
  //       final response = await callApi(mode: REST.get, url: Uri.parse(url));
  //       items = itemFromJson(response.body);
  //
  //       final itemBox = Boxes.getItemsDB();
  //
  //       await itemBox.deleteAll(itemBox.keys);
  //
  //       for (int i = 0; i < items.length; i++) {
  //         itemBox.put(i, items[i]);
  //       }
  //       isSuccessful = true;
  //       break;
  //     } on Exception catch (e) {
  //       log('Item cache refresh failed.');
  //       retry++;
  //     }
  //   }
  //
  //   print('items: ${items.length}');
  //   return isSuccessful;
  // }

  //get
  // Future<int> getAllFAQs() async {
  //   const String url = AppUrl.FAQURL;
  //
  //   final response = await callApi(mode: REST.get, url: Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //
  //     var data = jsonResponse['fields']['faq']['arrayValue']['values'];
  //
  //     for (int i = 0; i < data.length; i++) {
  //       Boxes.getFAQs().put(i, FAQ.fromJson(data[i]));
  //     }
  //
  //     return 1;
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     log('Request failed with status: ${response.statusCode}.');
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     return 0;
  //   }
  // }

  //get and store common content like about us and terms & cond from backend
  // Future<int> getCommonContent() async {
  //   const String url = AppUrl.AboutUs;
  //
  //   final response = await callApi(mode: REST.get, url: Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //     if (jsonResponse['fields'] == null) {
  //       return 0;
  //     }
  //     return 1;
  //   } else {
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     log('Request failed with status: ${response.statusCode}.');
  //     return 0;
  //   }
  // }

  // Future<List<Item>> getCategoryItems(int id) async {
  //   final box = Boxes.getItemsDB();
  //
  //   List<Item> categoryItems = [];
  //   categoryItems =
  //       box.values.where((element) => element.catId == id.toString()).toList();
  //   print('boxItems: ${categoryItems.length}');
  //   return categoryItems;
  //   // const String url = AppUrl.RUN_QUERY;
  //   // var body = {
  //   //   "structuredQuery": {
  //   //     "from": [
  //   //       {"collectionId": "item"}
  //   //     ],
  //   //     "where": {
  //   //       "compositeFilter": {
  //   //         "filters": [
  //   //           {
  //   //             "fieldFilter": {
  //   //               "field": {"fieldPath": "catId"},
  //   //               "op": "EQUAL",
  //   //               "value": {
  //   //                 "referenceValue":
  //   //                     "projects/${AppUrl.envType}/databases/(default)/documents/category/$id"
  //   //               }
  //   //             }
  //   //           }
  //   //         ],
  //   //         "op": "AND"
  //   //       }
  //   //     }
  //   //   }
  //   // };
  //   // var response = await callApi(
  //   //     mode: REST.post, url: Uri.parse(url), body: jsonEncode(body));
  //   // if (response.statusCode == 200) {
  //   //   var data = jsonDecode(response.body);
  //   //   for (int i = 0; i < data.length; i++) {
  //   //     categoryItems
  //   //         .add(Item.fromFirebaseRestApi(data[i]['document']['fields']));
  //   //   }
  //   //   log('#####Returning with cat items#######');
  //   //   return categoryItems;
  //   // } else {
  //   //   AppHelpers.crashlyticsLog(response.body.toString());
  //   //   Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //   //   throw 'Error, Category Does not Exist!';
  //   // }
  // }

  // Future<int> addCustomerList(
  //     UserList userList, int custId, String status) async {
  //   log("================${userList.listId}======================");
  //   final String url = AppUrl.ADD_LIST(userList.listId.toString());
  //   List items = [];
  //   int i = 0;
  //   for (ListItem item in userList.items) {
  //     items.add({
  //       "mapValue": {
  //         "fields": {
  //           "quantity": {"doubleValue": "${item.quantity}"},
  //           "itemImageId": {"stringValue": item.itemImageId},
  //           "unit": {"stringValue": item.unit},
  //           "itemName": {"stringValue": item.itemName},
  //           "catName": {"stringValue": item.catName},
  //           "catId": {
  //             "referenceValue":
  //                 "projects/${AppUrl.envType}/databases/(default)/documents/category/${item.catId.toString().replaceAll('projects/${AppUrl.envType}/databases/(default)/documents/category/', '')}"
  //           },
  //           "itemSeqNum": {"integerValue": "$i"},
  //           "brandType": {"stringValue": item.brandType},
  //           "itemId": {
  //             "referenceValue":
  //                 "projects/${AppUrl.envType}/databases/(default)/documents/item/${item.itemId.replaceAll('projects/${AppUrl.envType}/databases/(default)/documents/item/', '')}"
  //           },
  //           "notes": {"stringValue": item.notes}
  //         }
  //       }
  //     });
  //     i++;
  //   }
  //   // log(items);
  //
  //   var body = {
  //     "fields": {
  //       "createListTime": {
  //         "timestampValue":
  //             userList.createListTime.toUtc().toString().replaceAll(' ', 'T')
  //       },
  //       "items": {
  //         "arrayValue": {"values": items}
  //       },
  //       "custListStatus": {"stringValue": status},
  //       "custId": {
  //         "referenceValue":
  //             "projects/${AppUrl.envType}/databases/(default)/documents/customer/$custId"
  //       },
  //       "custListSentTime": {
  //         "timestampValue":
  //             userList.createListTime.toUtc().toString().replaceAll(' ', 'T')
  //       },
  //       "listUpdateTime": {
  //         "timestampValue":
  //             DateTime.now().toUtc().toString().replaceAll(' ', 'T')
  //       },
  //       'notificationProcess': {'stringValue': 'reminder'},
  //       'dealProcess': {'booleanValue': false},
  //       "custOfferWaitTime": {
  //         "timestampValue":
  //             DateTime.now().toUtc().toString().replaceAll(' ', 'T')
  //       },
  //       "listOfferCounter": {"integerValue": "0"},
  //       "processStatus": {"stringValue": "draft"},
  //       "listId": {"integerValue": "${userList.listId}"},
  //       "listName": {"stringValue": userList.listName}
  //     }
  //   };
  //
  //   var response = await callApi(
  //       mode: REST.post, url: Uri.parse(url), body: jsonEncode(body));
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     log(data.toString());
  //     return 1;
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     log('Request failed with status: ${response.reasonPhrase}.');
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     return 0;
  //   }
  // }

  //-------------------------------------User List--------------------------------------

  //patch
  // Future updateUserList(int custId, UserList userList,
  //     {String? status, String? processStatus}) async {
  //   final String url = AppUrl.UPDATE_USER_LIST(userList.listId.toString());
  //   List items = [];
  //   int i = 0;
  //   for (ListItem item in userList.items) {
  //     items.add({
  //       "mapValue": {
  //         "fields": {
  //           "quantity": {"doubleValue": "${item.quantity}"},
  //           "itemImageId": {
  //             "stringValue": item.itemImageId.replaceAll(
  //                 'https://firebasestorage.googleapis.com/v0/b/${AppUrl.envType}.appspot.com/o/',
  //                 '')
  //           },
  //           "unit": {"stringValue": item.unit},
  //           "itemName": {"stringValue": item.itemName},
  //           "catName": {"stringValue": item.catName},
  //           "catId": {
  //             "referenceValue":
  //                 "projects/${AppUrl.envType}/databases/(default)/documents/category/${item.catId.toString().replaceAll('projects/${AppUrl.envType}/databases/(default)/documents/category/', '')}"
  //           },
  //           "itemSeqNum": {"integerValue": "$i"},
  //           "brandType": {"stringValue": item.brandType},
  //           "itemId": {
  //             "referenceValue":
  //                 "projects/${AppUrl.envType}/databases/(default)/documents/item/${item.itemId.replaceAll('projects/${AppUrl.envType}/databases/(default)/documents/item/', '')}"
  //           },
  //           "notes": {"stringValue": item.notes}
  //         }
  //       }
  //     });
  //     i++;
  //   }
  //   // log(items);
  //
  //   final body = {
  //     "fields": {
  //       "custListSentTime": {
  //         "timestampValue":
  //             DateTime.now().toUtc().toString().replaceAll(' ', 'T')
  //       },
  //       "processStatus": {"stringValue": processStatus ?? "draft"},
  //       "custOfferWaitTime": {
  //         "timestampValue":
  //             DateTime.now().toUtc().toString().replaceAll(' ', 'T')
  //       },
  //       "createListTime": {
  //         "timestampValue":
  //             userList.createListTime.toUtc().toString().replaceAll(' ', 'T')
  //       },
  //       "custListStatus": {"stringValue": status ?? "sent"},
  //       "custId": {
  //         "referenceValue":
  //             "projects/${AppUrl.envType}/databases/(default)/documents/customer/$custId"
  //       },
  //       "listOfferCounter": {"integerValue": "0"},
  //       "listName": {"stringValue": userList.listName},
  //       "items": {
  //         "arrayValue": {"values": items}
  //       },
  //       "listId": {"integerValue": "${userList.listId}"},
  //       "listUpdateTime": {
  //         "timestampValue":
  //             DateTime.now().toUtc().toString().replaceAll(' ', 'T')
  //       }
  //     }
  //   };
  //
  //   var response = await callApi(
  //       mode: REST.patch, url: Uri.parse(url), body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     log(data.toString());
  //
  //     log('SUCCESS');
  //     return 1;
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     return 0;
  //   }
  // }

  //patch
  // Future deleteUserList(int userListId) async {
  //   final String url = AppUrl.PURGE_LIST(userListId.toString());
  //
  //   final body = {
  //     "fields": {
  //       "custListStatus": {"stringValue": "purged"}
  //     }
  //   };
  //
  //   var response = await callApi(
  //       mode: REST.patch, url: Uri.parse(url), body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     log(data.toString());
  //     return 1;
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     return 0;
  //   }
  // }

  // Future undoDeleteUserList(int userListId, String status) async {
  //   final String url = AppUrl.PURGE_LIST(userListId.toString());
  //
  //   final body = {
  //     "fields": {
  //       "custListStatus": {"stringValue": status}
  //     }
  //   };
  //
  //   var response = await callApi(
  //       mode: REST.patch, url: Uri.parse(url), body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     log(data.toString());
  //     return 1;
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     return 0;
  //   }
  // }

  // Future<String> getOTP(int phoneNumber) async {
  //   const String url = AppUrl.GET_OTP;
  //
  //   var body = {"phoneNumber": "+91$phoneNumber"};
  //
  //   var response = await callApi(
  //       mode: REST.post, url: Uri.parse(url), body: jsonEncode(body));
  //
  //   log(jsonDecode(response.body).toString());
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     String sessionInfo = data['sessionInfo'] ?? 'Error';
  //     log('----->SESSION ID: $sessionInfo');
  //     return sessionInfo;
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //     log('Reason: ${response.reasonPhrase}.');
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     throw 'Error!';
  //   }
  // }

  //post
  // Future<bool> verifyOTP(String sessionInfo, int code) async {
  // //  const String url = AppUrl.VERIFY_OTP;
  //
  //   var body = {"sessionInfo": sessionInfo, "code": code};
  //
  //   var response = await callApi(
  //       mode: REST.post, url: Uri.parse(url), body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     // var data = jsonDecode(response.body);
  //     // UserCredential currentUserCredentials = UserCredential.fromJson(data);
  //
  //     // Boxes.getUserCredentialsDB()
  //     //     .put('currentUserCredentials', currentUserCredentials);
  //
  //     // UserCredential? myUsr =
  //     //     Boxes.getUserCredentialsDB().get('currentUserCredentials');
  //
  //     // log(myUsr?.idToken);
  //     // log(myUsr?.refreshToken);
  //     // log(myUsr?.expiresIn);
  //     // log(myUsr?.localId);
  //     // log(myUsr?.isNewUser);
  //     // log(myUsr?.phoneNumber);
  //     return true;
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     return false;
  //   }
  // }

  //post
  Future<int> addCustomer(User user) async {
    final tokenHandler = Get.find<ProfileController>();
    await tokenHandler.generateUrlToken();
    final token = tokenHandler.urlToken;
    // final header = {"authorization": 'Bearer $token'};
    // final String url = AppUrl.ADD_CUSTOMER(user.custId.toString());
    //! add customer node api
    // final String nodeAPIUrl =
    //     '${AppUrl().baseUrl}/santhe/customer/register';
    // warningLog(nodeAPIUrl);
    // final nodeUrl = Uri.parse(nodeAPIUrl);
    //!end
    String uid = await AppHelpers().getDeviceId();
    DateTime now = DateTime.now();
    final getFiid = await AppHelpers().getToken;
    // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    // var body = {
    //   "fields": {
    //     "custName": {"stringValue": user.custName},
    //     "custLoginTime": {
    //       "timestampValue":
    //           DateTime.now().toUtc().toString().replaceAll(' ', 'T')
    //     },
    //     "custReferal": {"integerValue": "0"},
    //     "contact": {
    //       "mapValue": {
    //         "fields": {
    //           "phoneNumber": {"integerValue": "${user.phoneNumber}"},
    //           "pincode": {"integerValue": "${user.pincode}"},
    //           "address": {"stringValue": user.address},
    //           "emailId": {"stringValue": user.emailId},
    //           "location": {
    //             "mapValue": {
    //               "fields": {
    //                 "lng": {"doubleValue": user.lng},
    //                 "lat": {"doubleValue": user.lat}
    //               }
    //             }
    //           },
    //           "howToReach": {"stringValue": user.howToReach}
    //         }
    //       }
    //     },
    //     "custId": {"integerValue": "${user.custId}"},
    //     "custStatus": {"stringValue": "active"},
    //     "custRatings": {"doubleValue": "5.0"},
    //     "custPlan": {"stringValue": user.custPlan},
    //     "deviceMap": {
    //       "mapValue": {
    //         "fields": {
    //           uid: {"stringValue": token}
    //         }
    //       }
    //     }
    //   }
    // };

    //! new way
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await AppHelpers().getAuthToken}'
    };
    List<Placemark> placemarks =
        await placemarkFromCoordinates(user.lat, user.lng);
    final getfinalAddress = placemarks[0];
    debugLog('Checkinf for address data ${user.address} $getfinalAddress');
    var data = {
      "custName": user.custName,
      "contact": {
        "phoneNumber": user.phoneNumber,
        "emailId": user.emailId,
        "location": {"lat": user.lat, "lng": user.lng},
        "pincode": user.pincode
      },
      "city": getfinalAddress.locality,
      "state": getfinalAddress.administrativeArea,
      "locality": getfinalAddress.administrativeArea,
      "flat": user.address,
      "fbiid": getFiid
    };

    // final newAddressData = json.encode({
    //   "firebase_id": user.phoneNumber,
    //   "address_name": 'Delivery',
    //   "lat": user.lat,
    //   "lng": user.lng,
    //   "flat": getfinalAddress.street,
    //   "locality": getfinalAddress.locality,
    //   "city": getfinalAddress.locality,
    //   "state": getfinalAddress.administrativeArea,
    //   "country": getfinalAddress.country,
    //   "pincode": getfinalAddress.postalCode,
    //   "address_id": "",
    //   "howToReach": ""
    // });

    var rawResponse = await http.post(
        Uri.parse('${AppUrl().baseUrl}/santhe/customer/register'),
        body: json.encode(data),
        headers: headers);
    warningLog('data ${rawResponse.body} and ${rawResponse.headers}');
    // //! add the node api here
    // final responseNode = await http.post(
    //   nodeUrl,
    //   // headers: header,
    //   body: json.encode(
    //     {},
    //   ),
    // );
    // warningLog(
    //     'Node Api Registration ${responseNode.statusCode} and body ${responseNode.body}');
    // final responseBodynode = json.decode(responseNode.body);
    // warningLog('Node Api body $responseBodynode');
    //!add node api finished
    // var response = await callApi(
    //     mode: REST.post, url: Uri.parse(url), body: jsonEncode(body));
    if (rawResponse.statusCode == 200) {
      // var data = jsonDecode(response.body);
      log('user added');
      return 1;
    } else {
      AppHelpers.crashlyticsLog(rawResponse.body.toString());
      log('Request failed with status: ${rawResponse.statusCode}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw 'Error!';
      // return 0;
    }
  }

  //get
  Future<int> getCustomerInfo(int custId) async {
    //final String url = AppUrl.GET_CUSTOMER_DETAILS(custId.toString());

    //  final String nodeUrl = AppUrl.getCustomerDetails;
    final String newNodeUrl =
        '${AppUrl().baseUrl}/santhe/customer/get?firebase_id=$custId';
    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await AppHelpers().getAuthToken}'
    };

    var data = {'id': AppHelpers().getPhoneNumberWithoutCountryCode};

    // var response = await callApi(mode: REST.get, url: Uri.parse(nodeUrl), );
    warningLog('hitting node url getCustomerInfo $newNodeUrl');
    var response = await http.get(
      Uri.parse(newNodeUrl),
      // body: json.encode(data),
      // headers: header,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      errorLog('Checking for data in GetCustomerInfo$data');
      if (data['data'] != null) {
        var jsonData = data['data'];
        final profileController = Get.find<ProfileController>();
        profileController.getCustomerDetails = CustomerModel.fromJson(jsonData);
        profileController.isOperational.value =
            profileController.customerDetails!.opStats;
        errorLog(
            'Checking for profileModel ${profileController.customerDetails}');
        return 1;
      } else {
        log('Request failed with status: ${response.statusCode}.');
        return 0;
      }
    } else {
      AppHelpers.crashlyticsLog(response.body.toString());
      log('Request failed with status: ${response.statusCode}.');
      // Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  //patch
  Future updateCustomerInfo(int custId, User updatedUser) async {
    // final String url = AppUrl.UPDATE_CUSTOMER_DETAILS(custId.toString());
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
              "phoneNumber": {
                "integerValue": updatedUser.phoneNumber.toString()
              },
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

    // final String nodeUrl = AppUrl.updateCustomer;
     String nodeUrlApi = '${AppUrl().baseUrl}/santhe/customer/update';
    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await AppHelpers().getAuthToken}'
    };

    List<Placemark> placemarks =
        await placemarkFromCoordinates(updatedUser.lat, updatedUser.lng);
    final getfinalAddress = placemarks[0];

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    errorLog('Checking for Placemarks data$placemarks');

    //! update user method
    var data = {
      "firebase_id": updatedUser.phoneNumber.toString(),
      "first_name": updatedUser.custName,
      "last_name": updatedUser.lastName,
      "email": updatedUser.emailId,
      "phone_number": updatedUser.phoneNumber.toString(),
      "fbiid": updatedUser.fiiid,
      "flat": updatedUser.address,
      "locality": getfinalAddress.locality,
      "lat": updatedUser.lat,
      "lng": updatedUser.lng,
      "state": getfinalAddress.administrativeArea,
      "city": getfinalAddress.locality,
      "pincode": updatedUser.pincode,
      "howToReach": updatedUser.address
    };

    // var response = await callApi(mode: REST.get, url: Uri.parse(nodeUrl), );
    errorLog('Checking for node url $nodeUrlApi $data ');
    var response = await http.post(Uri.parse(nodeUrlApi),
        body: json.encode(data), headers: header);

    // var response = await callApi(
    //     mode: REST.patch, url: Uri.parse(url), body: jsonEncode(body));
    errorLog(
        'StatusCode CheckUpdateUser${response.statusCode} ${response.body} json  body ${json.encode(data)}');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      errorLog('Checking for responseData ${data.toString()}');
      // getCustomerInfo(custId);
      log('SUCCESS');
      return 1;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      log('Error', error: response.reasonPhrase);
      AppHelpers.crashlyticsLog(response.body.toString());
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  updatFCMONstart({required String fcmToken}) async {
     String nodeUrlApi = '${AppUrl().baseUrl}/santhe/customer/update';
    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await AppHelpers().getAuthToken}'
    };

    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(updatedUser.lat, updatedUser.lng);
    // final getfinalAddress = placemarks[0];

    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    // errorLog('Checking for Placemarks data$placemarks');

    //! update user method
    var data = {
      "firebase_id": AppHelpers().getPhoneNumberWithoutCountryCode,
      "fbiid": fcmToken,
    };

    // var response = await callApi(mode: REST.get, url: Uri.parse(nodeUrl), );
    errorLog('Checking for node url $nodeUrlApi $data ');
    var response = await http.post(Uri.parse(nodeUrlApi),
        body: json.encode(data), headers: header);

    // var response = await callApi(
    //     mode: REST.patch, url: Uri.parse(url), body: jsonEncode(body));
    errorLog(
        'StatusCode CheckUpdateUser${response.statusCode} ${response.body} json  body ${json.encode(data)}');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      errorLog('Checking for responseData ${data.toString()}');
      // getCustomerInfo(custId);
      log('SUCCESS');
      return 1;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      log('Error', error: response.reasonPhrase);
      AppHelpers.crashlyticsLog(response.body.toString());
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  // Future contactUs(int custId, String message, double rating) async {
  //   log('>>>>>>>>rating:$rating');
  //   final String url = AppUrl.CONTACT_US(
  //       '$custId${DateTime.now().day.toString().length == 1 ? '0${DateTime.now().day}' : DateTime.now().day}${DateTime.now().month.toString().length == 1 ? '0${DateTime.now().month}' : DateTime.now().month}${DateTime.now().year.toString().substring(2, 4)}${DateTime.now().hour.toString().length == 1 ? '0${DateTime.now().hour}' : DateTime.now().hour}${DateTime.now().minute.toString().length == 1 ? '0${DateTime.now().minute}' : DateTime.now().minute}${DateTime.now().second.toString().length == 1 ? '0${DateTime.now().second}' : DateTime.now().second}');
  //
  //   final body = {
  //     "fields": {
  //       "rating": {"doubleValue": "$rating"},
  //       "message": {"stringValue": message},
  //       "toNotify": {"stringValue": "manjunath.munigowda@santhe.in"},
  //       "contact": {
  //         "referenceValue":
  //             "projects/${AppUrl.envType}/databases/(default)/documents/customer/$custId"
  //       },
  //       "source": {"stringValue": "app"}
  //     }
  //   };
  //
  //   var response = await callApi(
  //       mode: REST.post, url: Uri.parse(url), body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     log(data.toString());
  //     return 1;
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.');
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     return 0;
  //   }
  // }

  //SENT TAB PAGE ----------------------------------------------------------------------

  //get sent user lists
  // Future<List<UserList>> getCustListByStatus(int custId) async {
  //   List<UserList> userLists = [];
  //   const String url = AppUrl.RUN_QUERY;
  //   var body = {
  //     "structuredQuery": {
  //       "from": [
  //         {"collectionId": "customerList"}
  //       ],
  //       "orderBy": {
  //         "field": {"fieldPath": "custListSentTime"}
  //       },
  //       "where": {
  //         "compositeFilter": {
  //           "filters": [
  //             {
  //               "fieldFilter": {
  //                 "field": {"fieldPath": "custListStatus"},
  //                 "op": "EQUAL",
  //                 "value": {"stringValue": "sent"}
  //               }
  //             },
  //             {
  //               "fieldFilter": {
  //                 "field": {"fieldPath": "custId"},
  //                 "op": "EQUAL",
  //                 "value": {
  //                   "referenceValue":
  //                       "projects/${AppUrl.envType}/databases/(default)/documents/customer/$custId"
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
  //   var response = await callApi(
  //       mode: REST.post, url: Uri.parse(url), body: jsonEncode(body));
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //
  //     if (data[0]['document']['fields'] != null) {
  //       for (int i = 0; i < data.length; i++) {
  //         userLists.add(UserList.fromJson(data[i]['document']['fields']));
  //         log('${userLists[i].listId}, ${userLists[i].processStatus}');
  //       }
  //       userLists.sort((a, b) => b.updateListTime.compareTo(a.updateListTime));
  //     } else {
  //       return userLists;
  //     }
  //     return userLists;
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     throw 'Error retrieving user lists!';
  //   }
  // }

  // Future<List<CustomerOfferResponse>> getAllMerchOfferByListId(
  //     String listId, int listQuantity) async {
  //   String url = AppUrl.GET_MERCH_OFFER_BY_LIST_ID(listId);
  //
  //   var response = await callApi(mode: REST.get, url: Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     List<CustomerOfferResponse> resp = customerOfferResponseFromJson(
  //         json.decode(response.body) == "No offers for this customer list."
  //             ? json.encode([]).toString()
  //             : response.body);
  //
  //     return resp;
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     throw 'Error retrieving user lists!';
  //   }
  // }

  // Future<MerchantDetailsResponse> getMerchantDetails(String merchId) async {
  //   String url = AppUrl.GET_MERCH_DETAILS(merchId);
  //
  //   var response = await callApi(mode: REST.get, url: Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     MerchantDetailsResponse resp =
  //         merchantDetailsResponseFromJson(response.body);
  //     return resp;
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     throw 'Error retrieving merchant details!';
  //   }
  // }

  // Future<CustomerOfferResponse?> acceptOffer(
  //     String listId, String listEventId) async {
  //   final String url = AppUrl.ACCEPT_OFFER(listId, listEventId);
  //
  //   var response = await callApi(
  //     mode: REST.put,
  //     url: Uri.parse(url),
  //   );
  //   if (response.statusCode == 200) {
  //     CustomerOfferResponse resp =
  //         CustomerOfferResponse.fromJson(json.decode(response.body));
  //     return resp;
  //   } else {
  //     log('Request failed with status: ${response.statusCode}.Details? ${response.body}');
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     return null;
  //   }
  // }

  // Future<MerchantOfferResponse> getMerchantResponse(String listId) async {
  //   final String url = AppUrl.LIST_BY_EVENT_ID(listId);
  //
  //   var response = await callApi(mode: REST.get, url: Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     MerchantOfferResponse data = merchantOfferResponseFromJson(response.body);
  //     return data;
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     throw 'Error retrieving merchant response';
  //   }
  // }

  // Future<int> processedStatusChange(int listId) async {
  //   log('**********processedStatusChange***********');
  //   final String url = AppUrl.PROCESS_STATUS(listId.toString());
  //   var body = {
  //     "fields": {
  //       "processStatus": {"stringValue": "accepted"},
  //       "listUpdateTime": {
  //         "timestampValue":
  //             DateTime.now().toUtc().toString().replaceAll(' ', 'T')
  //       }
  //     }
  //   };
  //
  //   var response = await callApi(
  //       mode: REST.patch, url: Uri.parse(url), body: jsonEncode(body));
  //
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     log(data.toString());
  //     log('Offer Accepted! List ID: $listId');
  //     return 1;
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     log('Request failed with status: ${response.statusCode}.Details? ${response.body}');
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     return 0;
  //   }
  // }

  //Archived Tab APIs------------------------------------------------
  //POST
  // Future<List<UserList>> getArchivedCust(int custId) async {
  //   List<UserList> userLists = [];
  //   const String url = AppUrl.RUN_QUERY;
  //   var body = {
  //     "structuredQuery": {
  //       "from": [
  //         {"collectionId": "customerList"}
  //       ],
  //       "orderBy": {
  //         "field": {"fieldPath": "custListSentTime"}
  //       },
  //       "where": {
  //         "compositeFilter": {
  //           "filters": [
  //             {
  //               "fieldFilter": {
  //                 "field": {"fieldPath": "custListStatus"},
  //                 "op": "EQUAL",
  //                 "value": {"stringValue": "archived"}
  //               }
  //             },
  //             {
  //               "fieldFilter": {
  //                 "field": {"fieldPath": "custId"},
  //                 "op": "EQUAL",
  //                 "value": {
  //                   "referenceValue":
  //                       "projects/${AppUrl.envType}/databases/(default)/documents/customer/$custId"
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
  //   var response = await callApi(
  //       mode: REST.post, url: Uri.parse(url), body: jsonEncode(body));
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //
  //     if (data[0]['document']['fields'] != null) {
  //       for (int i = 0; i < data.length; i++) {
  //         userLists.add(UserList.fromJson(data[i]['document']['fields']));
  //         log('${userLists[i].listId}, ${userLists[i].processStatus}');
  //       }
  //       userLists.sort((a, b) => b.updateListTime.compareTo(a.updateListTime));
  //     } else {
  //       return userLists;
  //     }
  //     return userLists;
  //   } else {
  //     AppHelpers.crashlyticsLog(response.body.toString());
  //     Get.to(() => const ServerErrorPage(), transition: Transition.fade);
  //     throw 'Error retrieving user lists!';
  //   }
  // }

//SEARCH POST

  // Future<List<Item>> searchedItemResult(String searchQuery) async {
  //   List<Item> searchResults = [];
  //
  //   const Algolia algolia = Algolia.init(
  //     applicationId: AppUrl.SEARCH_APP_ID,
  //     apiKey: AppUrl.SEARCH_API_KEY,
  //   );
  //
  //   final query = algolia.instance
  //       .index('santhe')
  //       .query(searchQuery)
  //       .filters('status:active');
  //
  //   final resp = await query.getObjects();
  //
  //   for (var i in resp.hits) {
  //     final Item item = Item.fromJson(i.data);
  //     final Item formatedItem =
  //         item.copyWith(catId: item.catId.replaceAll('category/', ''));
  //     searchResults.add(formatedItem);
  //   }
  //
  //   return searchResults;
  // }

  // Future<void> updateDeviceToken(String userId) async {
  //   log('userId being passed for device token$userId');
  //   final String token = await AppHelpers().getToken;
  //   String uid = await AppHelpers().getDeviceId();
  //   log('uid + $uid');
  //   log('token + $token');
  //   final header = {
  //     "authorization": 'Bearer ${await AppHelpers().authToken}',
  //     'Content-Type': 'application/json'
  //   };
  //   var request =
  //       http.Request('PUT', Uri.parse(AppUrl.UPDATE_DEVICE_TOKEN(userId)));
  //   request.body = json.encode({"deviceToken": token, "deviceId": uid});
  //   request.headers.addAll(header);
  //   warningLog('request body ${request.body}');
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     log('here done up');
  //     log((await response.stream.bytesToString()).toString());
  //   } else {
  //     log('here not done up');
  //     AppHelpers.crashlyticsLog('update device token error');
  //     log('Error', error: response.reasonPhrase);
  //   }
  // }

  // Future<bool> getLoginStatus(String userId) async {
  //   var request = await http.get(Uri.parse(AppUrl.checkLogin + userId));
  //   print(request.body);
  //   return jsonDecode(request.body)['allow_login'] ?? true;
  // }
}
