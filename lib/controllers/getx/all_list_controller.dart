import 'package:get/get.dart';
import 'package:santhe/controllers/api_service_controller.dart';
import 'package:santhe/controllers/getx/profile_controller.dart';
import 'package:santhe/core/app_helpers.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/models/new_list/user_list_model.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:santhe/pages/new_tab_pages/user_list_screen.dart';
import 'package:santhe/widgets/confirmation_widgets/error_snackbar_widget.dart';
import 'package:santhe/widgets/confirmation_widgets/undo_delete_widget.dart';

import '../../models/new_list/list_item_model.dart';
import '../../models/new_list/new_list_response_model.dart';
import '../../network_call/network_call.dart';

class AllListController extends GetxController with LogMixin {
  bool isLoading = true;

  RxBool isProcessing = false.obs, isTitleEditable = false.obs;

  int lengthLimit = 3;

  Map<String, UserListModel> allListMap = {};

  List<UserListModel> get allList => allListMap.values.toList();

  List<UserListModel> get sentList => allListMap.values
      .toList()
      .where((element) => element.custListStatus == 'sent')
      .toList();

  List<UserListModel> get archivedList => allListMap.values
      .toList()
      .where((element) => element.custListStatus == 'archived')
      .toList();

  List<UserListModel> get newList => allListMap.values
      .toList()
      .where((element) => element.custListStatus == 'new')
      .toList();

  Future<void> getAllList() async {
    var val = await NetworkCall().getAllCustomerLists();
    for (var element in _toUserListModel(val)) {
      allListMap[element.listId] = element;

      // warningLog('checking for allList $element');
    }
    isLoading = false;

    update(['newList', 'fab', 'archivedList', 'sentList']);
  }

  List<UserListModel> _toUserListModel(List<NewListResponseModel> model) {
    List<UserListModel> list = [];
    for (var element in model) {
      DocumentFields doc = element.document.fields;
      list.add(UserListModel(
          createListTime: doc.createListTime.timestampValue,
          custId: doc.custId.referenceValue.substring(
              doc.custId.referenceValue.length - 10,
              doc.custId.referenceValue.length),
          items: _toUserItemModel(element),
          listId: doc.listId.integerValue,
          listName: doc.listName.stringValue,
          custListSentTime: doc.custListSentTime.timestampValue,
          custListStatus: doc.custListStatus.stringValue,
          listOfferCounter: doc.listOfferCounter.integerValue,
          processStatus: doc.processStatus.stringValue,
          custOfferWaitTime: doc.custOfferWaitTime.timestampValue,
          listUpdateTime: doc.listUpdateTime.timestampValue));
    }
    return list;
  }

  List<ListItemModel> _toUserItemModel(NewListResponseModel model) {
    List<ListItemModel> list = [];
    if (model.document.fields.items.arrayValue.values == null) return list;
    for (var element in model.document.fields.items.arrayValue.values!) {
      var doc = element.mapValue.fields;
      list.add(ListItemModel(
        brandType: doc.brandType.stringValue,
        itemId: doc.itemId.referenceValue,
        notes: doc.notes.stringValue,
        quantity: doc.quantity.doubleValue.toString(),
        itemName: doc.itemName.stringValue,
        itemImageId: doc.itemImageId.stringValue,
        unit: doc.unit.stringValue,
        catName: doc.catName.stringValue,
        catId: doc.catId.referenceValue,
        possibleUnits: [],
      ));
    }
    return list;
  }

  List<UserListModel> getLatestList(int count) {
    List<UserListModel> list = allList
        .where((element) =>
            element.custListStatus != 'deleted' &&
            element.custListStatus != 'purged')
        .toList();
    list.sort((a, b) => b.createListTime.compareTo(a.createListTime));
    return list.take(count).toList();
  }

  Future<void> addNewListToDB(String name) async {
    isProcessing.value = true;
    final formattedPhoneNumber = AppHelpers()
        .getPhoneNumberWithoutFoundedCountryCode(AppHelpers().getPhoneNumber);
    UserListModel newUserList = UserListModel(
      createListTime: DateTime.now(),
      custId: formattedPhoneNumber,
      // AppHelpers().getPhoneNumberWithoutCountryCode,
      items: [],
      listId: formattedPhoneNumber
          // AppHelpers().getPhoneNumberWithoutCountryCode
          +
          (allList.length + 1).toString(),
      listName: name,
      processStatus: 'draft',
      custListSentTime: DateTime.now(),
      custListStatus: 'new',
      listOfferCounter: '0',
      custOfferWaitTime: DateTime.now(),
      listUpdateTime: DateTime.now(),
    );
    // warningLog(
    //     'userModel $newUserList checking allListlength ${allList.length}');

    int response = await NetworkCall().addNewList(newUserList);
    isProcessing.value = false;
    // warningLog('response of the network call to add list $response');
    if (response == 1) {
      allListMap[newUserList.listId] = newUserList;
      update(['newList', 'fab']);
      Get.back();
      Get.to(() => UserListScreen(listId: newUserList.listId));
    } else {
      errorMsg('Error Occurred', 'Please try again');
    }
  }

  Future<void> addCopyListToDB(String listId,
      {bool moveToArchived = false}) async {
    final formattedPhoneNumber = AppHelpers()
        .getPhoneNumberWithoutFoundedCountryCode(AppHelpers().getPhoneNumber);
    isProcessing.value = true;
    String copyListId = formattedPhoneNumber
        //  AppHelpers().getPhoneNumberWithoutCountryCode
        +
        (allList.length + 1).toString();
    UserListModel copyUserList = _copyModel(
        allList.where((element) => element.listId == listId).toList().first,
        copyListId);
    int response = await NetworkCall().addNewList(copyUserList);
    isProcessing.value = false;
    if (response == 1) {
      allListMap[copyListId] = copyUserList;
      if (moveToArchived) {
        await moveToArchive(allListMap[listId]!, showArchivedList: false);
      }
      update(['newList', 'fab']);
      Get.back();
      Get.to(
        () => UserListScreen(listId: copyUserList.listId),
        transition: Transition.rightToLeft,
      );
    } else {
      errorMsg('Error Occurred', 'Please try again');
    }
  }

  UserListModel _copyModel(UserListModel model, String copyListId) {
    UserListModel copyList = UserListModel(
        createListTime: DateTime.now(),
        custId: model.custId,
        items: _copyList(model.items),
        listId: copyListId,
        listName: 'COPY ${model.listName}',
        custListSentTime: DateTime.now(),
        custListStatus: 'new',
        listOfferCounter: '0',
        processStatus: 'draft',
        custOfferWaitTime: model.custOfferWaitTime,
        listUpdateTime: DateTime.now());
    return copyList;
  }

  List<ListItemModel> _copyList(List<ListItemModel> item) {
    List<ListItemModel> list = [];
    for (var element in item) {
      list.add(ListItemModel(
          brandType: element.brandType,
          itemId: element.itemId,
          notes: element.notes,
          quantity: element.quantity,
          itemName: element.itemName,
          itemImageId: element.itemImageId,
          unit: element.unit,
          catName: element.catName,
          catId: element.catId,
          possibleUnits: element.possibleUnits));
    }
    return list;
  }

  Future<void> deleteListFromDB(String listId, String status,
      {bool fromNew = false}) async {
    isProcessing.value = true;
    int response = await NetworkCall().removeNewList(listId);
    isProcessing.value = false;
    if (response == 1) {
      allListMap[listId]?.custListStatus = 'purged';
      if (fromNew) {
        newList.remove(allListMap[listId]);
      } else {
        archivedList.remove(allListMap[listId]);
      }
      update(['newList', 'fab', 'archivedList']);
      undoDelete(int.parse(listId), status);
    } else {
      errorMsg('Error Occurred', 'Please try again');
    }
  }

  Future<void> moveToArchive(UserListModel userList,
      {bool showArchivedList = true}) async {
    isProcessing.value = true;
    int response = await NetworkCall().updateUserList(userList,
        status: 'archived', processStatus: userList.processStatus);
    isProcessing.value = false;
    if (response == 1) {
      allListMap[userList.listId]?.custListStatus = 'archived';
      sentList.remove(allListMap[userList.listId]);
      archivedList.add(allListMap[userList.listId]!);
      update(['sentList', 'archivedList']);
      if (showArchivedList) {
        Get.offAll(
            () => HomePage(
                  pageIndex: 2,
                  showMap: false,
                ),
            transition: Transition.fade);
      }
    } else {
      errorMsg('Unexpected error occurred', 'Please try again');
    }
  }

  Future<bool> isListAlreadyExist(String listName) async {
    final APIs api = Get.find();
    final formattedPhoneNumber = AppHelpers()
        .getPhoneNumberWithoutFoundedCountryCode(AppHelpers().getPhoneNumber);
    return await api.duplicateCheck(
        int.parse(
          // AppHelpers().getPhoneNumberWithoutCountryCode,
          formattedPhoneNumber,
        ),
        listName.trim());
  }

  Future<void> checkSubPlan() async {
    final profileController = Get.find<ProfileController>();
    final data = await NetworkCall()
        .getSubscriptionLimit(profileController.customerDetails!.customerPlan);
    lengthLimit = data;
  }

  void deleteEverything() {
    allListMap.clear();
    newList.clear();
    sentList.clear();
    archivedList.clear();
  }
}
