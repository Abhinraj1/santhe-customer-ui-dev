class AppUrl{
  static const String _baseUrl = 'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents';
  static const String FAQURL = '$_baseUrl/content/merchContent/';
  static const String AboutUs = '$_baseUrl/content/common/';
  static const String SignIn = '$_baseUrl/merchant/';
  static const String GetListEvent = '$_baseUrl/listEvent';
  static const String SUBSCRIPTION_PLAN = '$_baseUrl/config/control';
  static String PURGE_LIST(String listId) => '$_baseUrl/customerList/$listId?updateMask.fieldPaths=custListStatus';
  static String ADD_LIST(String listId) => '$_baseUrl/customerList/?documentId=$listId';
  static const String RUN_QUERY = '$_baseUrl:runQuery';
  static String GET_CUSTOMER_DETAILS(String customerId) => '$_baseUrl/customer/$customerId';
  static String UPDATE_USER_LIST(String listId) => 'https://firestore.googleapis.com/v1/projects/santhe-425a8/databases/(default)/documents/customerList/${listId}?updateMask.fieldPaths=listName&updateMask.fieldPaths=custListSentTime&updateMask.fieldPaths=processStatus&updateMask.fieldPaths=createListTime&updateMask.fieldPaths=custListStatus&updateMask.fieldPaths=custId&updateMask.fieldPaths=listOfferCounter&updateMask.fieldPaths=items&updateMask.fieldPaths=listId&updateMask.fieldPaths=updateListTime&updateMask.fieldPaths=custOfferWaitTime';
}