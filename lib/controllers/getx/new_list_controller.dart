import 'package:get/get.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/models/new_list/user_list_model.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';

import '../../models/new_list/list_item_model.dart';
import '../../models/new_list/new_list_response_model.dart';

class NewListController extends GetxController{

  bool isLoading = true;

  RxBool isProcessing = false.obs;

  int lengthLimit = 3;

  List<UserListModel> allList = [];

  Map<String, UserListModel> newList = {};

  Future<void> getAllList() async {
    var val = await APIs().getAllCustomerLists(0);
    allList = _toUserListModel(val);
    isLoading = false;
    newList.clear();
    for (var element in allList) {
      if(element.custListStatus == 'new'){
        newList[element.listId] = element;
      }
    }
    update(['list', 'fab']);
  }

  List<UserListModel> _toUserListModel(List<NewListResponseModel> model){
    List<UserListModel> _list = [];
    for (var element in model) {
      DocumentFields doc = element.document.fields;
      _list.add(
          UserListModel(
          createListTime: doc.createListTime.timestampValue,
          custId: doc.custId.referenceValue.substring(
              doc.custId.referenceValue.length - 10,
              doc.custId.referenceValue.length
          ),
          items: _toUserItemModel(element),
          listId: doc.listId.integerValue,
          listName: doc.listName.stringValue,
          custListSentTime: doc.custListSentTime.timestampValue,
          custListStatus: doc.custListStatus.stringValue,
          listOfferCounter: doc.listOfferCounter.integerValue,
          processStatus: doc.processStatus.stringValue,
          custOfferWaitTime: doc.custOfferWaitTime.timestampValue,
          updateListTime: doc.updateListTime.timestampValue,
              listUpdateTime: doc.listUpdateTime?.timestampValue
          ));
    }
    return _list;
  }

  List<ListItemModel> _toUserItemModel(NewListResponseModel model){
    List<ListItemModel> _list = [];
    if(model.document.fields.items.arrayValue .values == null) return _list;
    for (var element in model.document.fields.items.arrayValue.values!) {
      var doc = element.mapValue.fields;
      _list.add(
          ListItemModel(
          brandType: doc.brandType.stringValue,
          itemId: doc.itemId.referenceValue,
          notes: doc.notes.stringValue,
          quantity: doc.quantity.doubleValue.toString(),
          itemName: doc.itemName.stringValue,
          itemImageId: doc.itemImageId.stringValue,
          unit: doc.unit.stringValue,
          catName: doc.catName.stringValue,
          catId: doc.catId.referenceValue,
          )
      );
    }
    return _list;
  }

  List<UserListModel> getLatestList(int count){
    List<UserListModel> _list = allList;
    _list.sort((a, b) => b.createListTime.compareTo(a.createListTime));
    if(_list.length <= count) return _list;
    return _list.sublist(0, count);
  }

  Future<void> addNewListToDB(String name) async {
    isProcessing.value = true;
    UserListModel newUserList = UserListModel(
      createListTime:
      DateTime.now(),
      custId: AppHelpers().getPhoneNumberWithoutCountryCode,
      items: [],
      listId: AppHelpers().getPhoneNumberWithoutCountryCode + (allList.length + 1).toString(),
      listName: name,
      processStatus:
      'draft',
      custListSentTime:
      DateTime.now(),
      custListStatus: 'new',
      listOfferCounter: '0',
      custOfferWaitTime:
      DateTime.now(),
      updateListTime:
      DateTime.now(),
    );
    int response = await APIs().addNewList(newUserList);
    isProcessing.value = false;
    if (response == 1) {
      allList.add(newUserList);
      newList[newUserList.listId] = newUserList;
      update(['list', 'fab']);
      Get.back();
    } else {
      errorMsg('Error Occurred', 'Please try again');
    }
  }

  Future<void> addCopyListToDB(String listId) async {
    isProcessing.value = true;
    var copyUserList = allList.where((element) => element.listId == listId).toList().first;
    int response = await APIs().addNewList(
        copyUserList..listName = 'COPY ${copyUserList.listName}'
          ..listId = AppHelpers().getPhoneNumberWithoutCountryCode + (allList.length + 1).toString());
    isProcessing.value = false;
    if (response == 1) {
      allList.add(copyUserList);
      newList[copyUserList.listId] = copyUserList;
      update(['list', 'fab']);
      Get.back();
    } else {
      errorMsg('Error Occurred', 'Please try again');
    }
  }

  Future<void> deleteListFromDB(String listId) async {
    isProcessing.value = true;
    int response = await APIs().removeNewList(listId);
    isProcessing.value = false;
    if (response == 1) {
      for(int i = 0; i < allList.length; i++){
        if(allList[i].listId == listId){
          allList[i].custListStatus = 'purged';
          break;
        }
      }
      newList.remove(listId);
      update(['list', 'fab']);
      Get.back();
    } else {
      errorMsg('Error Occurred', 'Please try again');
    }
  }

  bool isListAlreadyExist(String listName){
    return allList.where((element) => element.listName == listName).toList().isNotEmpty;
  }
}