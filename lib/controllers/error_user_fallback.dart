import 'package:santhe/models/hive_models/item.dart';
import 'package:santhe/models/santhe_category_model.dart';
import 'package:santhe/models/santhe_item_model.dart';
import 'package:santhe/models/santhe_user_list_model.dart';
import 'package:santhe/models/santhe_user_model.dart';
import 'package:santhe/models/user_profile/customer_model.dart';

CustomerModel fallback_error_customer = CustomerModel(
  lng: '0',
  lat: '0',
  address: 'X',
  customerId: '0',
  customerLoginTime: DateTime.now(),
  customerName: 'X',
  customerPlan: 'default',
  customerRatings: '0',
  customerReferral: '0',
  customerStatus: 'in-active',
  emailId: 'X@404.lost',
  howToReach: 'service_error',
  phoneNumber: '4040440404',
  pinCode: '0',
);

User fallBack_error_user = User(
  address: 'X',
  emailId: 'X@404.lost',
  howToReach: 'service_error',
  lat: 0.0,
  lng: 0.0,
  pincode: 0,
  phoneNumber: 4040440404,
  custId: 4040440404,
  custName: 'X',
  custRatings: 0,
  custReferal: 000000,
  custStatus: 'in-active',
  custPlan: 'Default',
  custLoginTime: DateTime.now(),
);

Category fallBack_error_category = Category(
    catId: 404,
    catImageId: '',
    catImageTn: '',
    catName: 'Error',
    catNotes: 'Error',
    status: 'active',
    userCreate: 0,
    userUpdate: 0);

Item fallBack_error_item = Item(
    dBrandType: 'error',
    dItemNotes: 'error',
    itemImageTn: 'error',
    catId: 'error',
    createUser: 404,
    dQuantity: 404,
    dUnit: 'error',
    itemAlias: 'error',
    itemId: 404,
    itemImageId: 'error',
    itemName: 'error',
    status: 'error',
    unit: ['error'],
    updateUser: 404);

UserList fallBack_error_userList = UserList(
  createListTime: DateTime.now(),
  custId: 404,
  items: [],
  listId: 404,
  listName: 'error',
  custListSentTime: DateTime.now(),
  custListStatus: 'inactive',
  listOfferCounter: 0,
  processStatus: 'error',
  custOfferWaitTime: DateTime.now(),
  updateListTime: DateTime.now(),
);
