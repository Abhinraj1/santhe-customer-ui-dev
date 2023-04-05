// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:math';

import 'package:flutter/material.dart';

String priceFormatter({required String value}) {
  if (value.contains(".")) {
    var split = value.split(".");

    if (split[1].length > 2) {
      String finalOutput = split[0] + split[1].toString().substring(0, 1);

      return finalOutput;
    }
  }
  return value;
}

String priceFormatter2({required String value}) {
  if (value.contains(".")) {
    var split = value.split(".");

    if (split[1].length > 2) {
      String finalOutput = split[0] + '.' + split[1].toString().substring(0, 2);

      return finalOutput;
    }
  }
  return value;
}
