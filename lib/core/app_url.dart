// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class AppUrl {
  static const String _environmentProd = 'santhe-prod';

  static const String _environmentDev = 'santhe-425a8';

  static const bool _dev = true;

  static const String _FCMKeyDev =
      'AAAAZ54wd8s:APA91bEsDji0lceBsyQ2Dm_c1eerM0N6-Vle3k83ZGH8Q8cKOY-0CGh7aJHC5iMrkxUVurSoUS_WAv4Qez9BHRSAHKgUcDeEuKVX5CevL03KAEpChNCgjz8-mInRCnQXJjORuMUZMbhF';

  static const String _FCMKeyProd =
      'AAAAXnjll4s:APA91bEr3J8lWpZ4oFwV0tO8a-eu-JJSGknWM34Np0ANZusYb_hcpFawqfI4ZEOc13uYYLNqN2lyK_R7tpsqMjlyaI3TlXwIwikVtKKneaEc0zozu_j2QFRLSGm8vpW4QaKWurGfJBCl';

  static const String FCMKey = _dev ? _FCMKeyDev : _FCMKeyProd;

  static const String envType = _dev ? _environmentDev : _environmentProd;

  static const String SEARCH_API_KEY = 'ba0045efa2818ec596b013d1b5dbe461';

  static const String SEARCH_APP_ID = '7565UIF34Z';

  static const String _baseUrl =
      'https://firestore.googleapis.com/v1/projects/$envType/databases/(default)/documents';

  static const String _baseCloudFunctions =
      'https://us-central1-$envType.cloudfunctions.net/apis/santhe/v1';

  static String host = 'https://us-central1-$envType.cloudfunctions.net';

  static String updateCustomer =
      '$host/apis/santhe/v1/app/customer/updateCustomer';

  static String addCustomerNode =
      '$_baseCloudFunctions/app/customer/updateCustomer';

  static const String FAQURL = '$_baseUrl/content/custContent/';

  static String checkLogin = '$_baseCloudFunctions/customers/status/';

  static const String AboutUs = '$_baseUrl/content/common/';

  static const String SignIn = '$_baseUrl/merchant/';

  static const String GetListEvent = '$_baseUrl/listEvent';

  static const String SUBSCRIPTION_PLAN = '$_baseUrl/config/control';

  static const String RUN_QUERY = '$_baseUrl:runQuery';

  static const String GET_ITEM_COUNT = '$_baseCloudFunctions/items/next-id';

  static const String CACHE_REFRESH_TIME = '$_baseUrl/config/cacheRefresh';

  static const String GET_CATEGORIES = '$_baseUrl/category?pageSize=30';

  static const String API_KEY = "AIzaSyCFS_yaSebSR9VZC7Qv3QCCC9DNoyTzJ48";

  static const String GET_ALL_ITEMS = '$_baseCloudFunctions/items';

  static const String GET_ALL_CATEGORIES = '$_baseCloudFunctions/categories';

  static const String GET_OTP =
      'https://identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode?key=$API_KEY';

  static const String VERIFY_OTP =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPhoneNumber?key=$API_KEY';

  static String PURGE_LIST(String listId) =>
      '$_baseUrl/customerList/$listId?updateMask.fieldPaths=custListStatus';

  static String DELETE_USER(String phone) =>
      '$_baseCloudFunctions/customers/$phone';

  static String ADD_LIST(String listId) =>
      '$_baseUrl/customerList/?documentId=$listId';

  static String GET_CUSTOMER_DETAILS(String customerId) =>
      '$_baseUrl/customer/$customerId';

  static String getCustomerDetails =
      '$host/apis/santhe/v1/app/customer/getCustomer';

  static String CHECK_RADIUS(
          String customerId, String lat, String long, String pinCode) =>
      '$_baseCloudFunctions/app/radiusCheck?isCustomer=true&userId=$customerId&lat=$lat&lng=$long&pincode=$pinCode';
  // '$_baseCloudFunctions/app/radiusCheck?isCustomer=true&userId=$customerId';

  static String DUPLICATE_CHECK(String customerId, String listName) =>
      '$_baseCloudFunctions/app/customer/duplicateCheck?custId=$customerId&listName=$listName';

  static String UPDATE_USER_LIST(String listId) =>
      '$_baseUrl/customerList/$listId?updateMask.fieldPaths=listName&updateMask.fieldPaths=custListSentTime&updateMask.fieldPaths=processStatus&updateMask.fieldPaths=createListTime&updateMask.fieldPaths=custListStatus&updateMask.fieldPaths=custId&updateMask.fieldPaths=listOfferCounter&updateMask.fieldPaths=items&updateMask.fieldPaths=listId&updateMask.fieldPaths=listUpdateTime&updateMask.fieldPaths=custOfferWaitTime';

  static String LIST_BY_EVENT_ID(String listEventId) =>
      '$_baseCloudFunctions/app/getListEventByListId?listId=$listEventId';

  static String ADD_ITEM(String itemId) => '$_baseUrl/item/?documentId=$itemId';

  static String ADD_CUSTOMER(String userId) =>
      '$_baseUrl/customer/?documentId=$userId';

  static String UPDATE_CUSTOMER_DETAILS(String custId) =>
      '$_baseUrl/customer/$custId?updateMask.fieldPaths=custName&updateMask.fieldPaths=custReferal&updateMask.fieldPaths=contact&updateMask.fieldPaths=custStatus&updateMask.fieldPaths=custRatings&updateMask.fieldPaths=custId';

  static String CONTACT_US(String field) =>
      '$_baseUrl/contactUs/?documentId=$field';

  static String GET_MERCH_OFFER_BY_LIST_ID(String listId) =>
      '$_baseCloudFunctions/listevents/$listId/offers';

  static String GET_MERCH_DETAILS(String merchId) =>
      '$_baseUrl/merchant/$merchId';

  static String SEARCH_QUERY(String searchQuery) =>
      '$_baseCloudFunctions/search/items?searchCriteria=$searchQuery';

  static String UPDATE_DEVICE_TOKEN(String userId) =>
      '$_baseCloudFunctions/customers/$userId/deviceToken';

  static String GET_MERCHANTS(String customerLat, String customerLong) =>
      '$_baseCloudFunctions/app/customer/nearby/merchants?lat=$customerLat&lng=$customerLong&radius=20';

  static String ACCEPT_OFFER(String listId, String listEventId) =>
      '$_baseCloudFunctions/offers/$listId/$listEventId/accept';

  //!Ondc
  static String getNearByStore =
      'http://ondcstaging.santhe.in/santhe/ondc/store/nearby';

  static String getSearchItem =
      'http://ondcstaging.santhe.in/santhe/ondc/item/nearby';

  static String transactionIdUrl =
      'http://ondcstaging.santhe.in/santhe/ondc/transaction_id';
}
