class ServerException implements Exception {}

class CacheException implements Exception {}

class AuthenticationError implements Exception {}

class TokenExpiredException implements Exception {}

class DataException implements Exception {}

class WrongModePassedForAPICall implements Exception {
  String cause;
  WrongModePassedForAPICall(this.cause);
}

class NoInternetError implements Exception{}

class ServerError implements Exception{}