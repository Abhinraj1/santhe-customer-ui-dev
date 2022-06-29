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
}