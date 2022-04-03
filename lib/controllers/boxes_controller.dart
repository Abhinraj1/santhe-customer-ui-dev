import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:santhe/models/santhe_cache_refresh.dart';
import 'package:santhe/models/santhe_user_credenetials_model.dart';

import '../models/santhe_category_model.dart';
import '../models/santhe_faq_model.dart';
import '../models/santhe_item_model.dart';
import '../models/santhe_user_list_model.dart';
import '../models/santhe_user_model.dart';

class Boxes {
  static Box<UserList> getUserListDB() => Hive.box('userListsDB');
  static Box<UserCredential> getUserCredentialsDB() =>
      Hive.box('userCredentialsDB'); //key: currentUserCredentials
  static Box<User> getUser() => Hive.box('userDB'); //key: currentUserDetails

  //key: isLoggedIn
  //key: showHome
  //key: isRegistered
  static Box<bool> getUserPrefs() => Hive.box('userPrefsDB');

  static Box<Category> getCategoriesDB() =>
      Hive.box('categoryDB'); //key: catId...

  static Box<CacheRefresh> getCacheRefreshInfo() =>
      Hive.box('cacheRefreshDB'); //key: cacheRefresh

  static Box<FAQ> getFAQs() => Hive.box('faqDB'); //key: faq1, faq2,....

  //key: aboutUs
  //key: termsAndConditions
  //key: userListCount
  //key: privacyPolicy
  static Box<String> getContent() => Hive.box('contentDB');

  //key: itemId...
  static Box<Item> getItemsDB() => Hive.box('itemDB');
}
