import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_url.dart';
import 'package:santhe/models/santhe_faq_model.dart';
import 'package:santhe/models/user_profile/customer_model.dart';
import 'package:santhe/models/user_profile/customer_response_model.dart';

import '../core/app_helpers.dart';
import '../core/error/exceptions.dart';
import '../models/new_list/list_item_model.dart';
import '../models/new_list/new_list_response_model.dart';
import '../models/new_list/user_list_model.dart';
import '../pages/error_pages/server_error_page.dart';
import 'package:http/http.dart' as http;

enum REST { get, post, put, delete, patch }

class NetworkCall{

  Future<List<NewListResponseModel>> getAllCustomerLists() async {
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
                    "projects/santhe-425a8/databases/(default)/documents/customer/${AppHelpers().getPhoneNumberWithoutCountryCode}"
                  }
                }
              }
            ],
            "op": "AND"
          }
        }
      }
    };
    var response = await callApi(mode: REST.post, url: Uri.parse(AppUrl.RUN_QUERY), body: jsonEncode(body));
    if (response.statusCode == 200) {
      return newListResponseModelFromJson(response.body);
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      throw ServerError();
    }
  }

  Future<int> addNewList(UserListModel userList) async {
    List items = [];
    int i = 0;
    for (ListItemModel item in userList.items) {
      items.add({
        "mapValue": {
          "fields": {
            "quantity": {"doubleValue": item.quantity},
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
    var body = {
      "fields": {
        "createListTime": {
          "timestampValue":
          userList.createListTime.toUtc().toString().replaceAll(' ', 'T')
        },
        "items": {
          "arrayValue": {"values": items}
        },
        "custListStatus": {"stringValue": 'new'},
        "custId": {
          "referenceValue":
          "projects/santhe-425a8/databases/(default)/documents/customer/${AppHelpers().getPhoneNumberWithoutCountryCode}"
        },
        "custListSentTime": {
          "timestampValue":
          userList.createListTime.toUtc().toString().replaceAll(' ', 'T')
        },
        "updateListTime": {
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
        "listId": {"integerValue": userList.listId},
        "listName": {"stringValue": userList.listName}
      }
    };

    var response = await callApi(mode: REST.post, url: Uri.parse(AppUrl.ADD_LIST(userList.listId)), body: jsonEncode(body));
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

  Future removeNewList(String listId) async {
    final body = {
      "fields": {
        "custListStatus": {"stringValue": "deleted"}
      }
    };

    var response = await callApi(mode: REST.patch, url: Uri.parse(AppUrl.PURGE_LIST(listId)), body: jsonEncode(body));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log(data.toString());
      return 1;
    } else {
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return 0;
    }
  }

  Future<int> getSubscriptionLimit(String plan) async {
    var response = await callApi(mode: REST.get, url: Uri.parse(AppUrl.SUBSCRIPTION_PLAN));
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != null && response.statusCode == 200) {
      String? val = jsonResponse['fields']['subscription']['mapValue']['fields']['custSubscription']['mapValue']['fields'][plan]['integerValue'];
      return val == null ? 3 : int.parse(val);
    } else {
      return 3;
    }
  }

  Future<CustomerModel> getCustomerDetails() async {
    var response = await callApi(mode: REST.get, url: Uri.parse(AppUrl.GET_CUSTOMER_DETAILS(AppHelpers().getPhoneNumberWithoutCountryCode)));
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != null && response.statusCode == 200) {
      return CustomerModel.fromJson(jsonResponse['fields']);
    } else {
      throw ServerError();
    }
  }

  Future updateUserList(UserListModel userList, {String? status, String? processStatus}) async {
    List items = [];
    int i = 0;
    for (ListItemModel item in userList.items) {
      items.add({
        "mapValue": {
          "fields": {
            "quantity": {"doubleValue": item.quantity},
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
          "projects/santhe-425a8/databases/(default)/documents/customer/${AppHelpers().getPhoneNumberWithoutCountryCode}"
        },
        "listOfferCounter": {"integerValue": "0"},
        "listName": {"stringValue": userList.listName},
        "items": {
          "arrayValue": {"values": items}
        },
        "listId": {"integerValue": userList.listId},
        "updateListTime": {
          "timestampValue":
          DateTime.now().toUtc().toString().replaceAll(' ', 'T')
        }
      }
    };

    var response = await callApi(mode: REST.patch, url: Uri.parse(AppUrl.UPDATE_USER_LIST(userList.listId)), body: jsonEncode(body));

    if (response.statusCode == 200) {
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

  Future getAllFAQs() async {
    const String url = AppUrl.FAQURL;

    final response = await callApi(mode: REST.get, url: Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      var data = jsonResponse['fields']['faq']['arrayValue']['values'];

      final faqList = [];

      for(int i=0;i<data.length;i++){
        faqList.add(FAQ.fromJson(data[i]));
      }

      return faqList;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      Get.to(() => const ServerErrorPage(), transition: Transition.fade);
      return null;
    }
  }

  Future<http.Response> callApi({required REST mode, required Uri url, String? body}) async {
    final tokenHandler = Get.find<ProfileController>();
    final token = tokenHandler.urlToken;
    final header = { "authorization": 'Bearer $token' };
    switch (mode) {
      case REST.get:
        {
          try {
            return await http.get(url, headers: header,);
          } catch (e) {
            log(e.toString());
          }
          break;
        }

      case REST.post:
        {
          try {
            return await http.post(url, body: body!, headers: header,);
          } catch (e) {
            log(e.toString());
          }
          break;
        }

      case REST.patch:
        {
          try {
            return await http.patch(url, body: body!, headers: header,);
          } catch (e) {
            log(e.toString());
          }
          break;
        }

      default:
        throw WrongModePassedForAPICall('Wrong mode passed for API call.');
    }
    throw NoInternetError();
  }

  /*Future<List<ListItemModel>> getSearchItemResult() async {
    var response = await callApi(mode: REST.get, url: Uri.parse(AppUrl.GET_CUSTOMER_DETAILS(AppHelpers().getPhoneNumberWithoutCountryCode)));
    if (response.statusCode == 200) {
      var item = searchItemResponseModelFromJson(response.body);
      return ListItemModel(
          brandType: item.,
          itemId: itemId,
          notes: notes,
          quantity: quantity,
          itemName: itemName,
          itemImageId: itemImageId,
          unit: unit,
          catName: catName,
          catId: catId);
    } else {
      throw ServerError();
    }
  }*/
}