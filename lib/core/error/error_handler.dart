import 'package:flutter/material.dart';

import 'failures.dart';

class ErrorHandler {
  static handleError(BuildContext context, Failure failure) {
    switch (failure.runtimeType) {
      case TokenExpiredFailure:
        break;
      case ServerFailure:
        break;
      default:
        break;
    }
  }
}
