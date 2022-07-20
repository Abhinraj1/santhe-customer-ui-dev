// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class AppUrl {
  static const String _environmentProd = 'santhe-prod';
  static const String _environmentDev = 'santhe-425a8';
  static const String _baseUrl =
      'https://firestore.googleapis.com/v1/projects/$_environmentDev/databases/(default)/documents';
  static const String _baseCloudFunctions =
      'https://us-central1-$_environmentDev.cloudfunctions.net/apis/santhe/v1';
  static const String FAQURL = '$_baseUrl/content/custContent/';
  static const String AboutUs = '$_baseUrl/content/common/';
  static const String SignIn = '$_baseUrl/merchant/';
  static const String GetListEvent = '$_baseUrl/listEvent';
  static const String SUBSCRIPTION_PLAN = '$_baseUrl/config/control';
  static const String RUN_QUERY = '$_baseUrl:runQuery';
  static const String GET_ITEM_COUNT = '$_baseCloudFunctions/items/next-id';
  static const String CACHE_REFRESH_TIME = '$_baseUrl/config/cacheRefresh';
  static const String GET_CATEGORIES = '$_baseUrl/category?pageSize=30';
  static const String API_KEY = "AIzaSyCFS_yaSebSR9VZC7Qv3QCCC9DNoyTzJ48";
  static const String GET_OTP =
      'https://identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode?key=$API_KEY';
  static const String VERIFY_OTP =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPhoneNumber?key=$API_KEY';
  static const String SEARCH_API_KEY = 'ba0045efa2818ec596b013d1b5dbe461';
  static const String SEARCH_APP_ID = '7565UIF34Z';
  static String PURGE_LIST(String listId) =>
      '$_baseUrl/customerList/$listId?updateMask.fieldPaths=custListStatus';
  static String ADD_LIST(String listId) =>
      '$_baseUrl/customerList/?documentId=$listId';
  static String GET_CUSTOMER_DETAILS(String customerId) =>
      '$_baseUrl/customer/$customerId';
  static String CHECK_RADIUS(String customerId) =>
      '$_baseCloudFunctions/app/radiusCheck?isCustomer=true&userId=$customerId';
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
  static String ACCEPT_OFFER(String listId) =>
      '$_baseUrl/listEvent/$listId?updateMask.fieldPaths=custOfferResponse.custDeal&updateMask.fieldPaths=custOfferResponse.custOfferStatus&updateMask.fieldPaths=merchResponse.merchUpdateTime';
  static String PROCESS_STATUS(String listId) =>
      '$_baseUrl/customerList/$listId?updateMask.fieldPaths=processStatus&updateMask.fieldPaths=listUpdateTime';
  static String SEARCH_QUERY(String searchQuery) =>
      '$_baseCloudFunctions/search/items?searchCriteria=$searchQuery';
  static String UPDATE_DEVICE_TOKEN(String userId) =>
      '$_baseCloudFunctions/customers/$userId/deviceToken';
}
