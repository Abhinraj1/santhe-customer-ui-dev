import 'package:flutter/material.dart';

Dimensions getScreenDimensions({
  required BuildContext context,
  double? horizontalPadding,
  double? verticalPadding,
}) {
  final double _horizontalPadding = horizontalPadding ?? 0;
  final double _verticalPadding = verticalPadding ?? 0;

  final double width = MediaQuery.of(context).size.width - _horizontalPadding;
  final double height = MediaQuery.of(context).size.height - _verticalPadding;
  return Dimensions(height: height, width: width);
}

class Dimensions {
  final double width;
  final double height;
  Dimensions({required this.width, required this.height});
}
