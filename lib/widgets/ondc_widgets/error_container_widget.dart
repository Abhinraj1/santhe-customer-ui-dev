import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';

import '../../manager/font_manager.dart';

class ErrorContainerWidget extends StatelessWidget {
  final String message;
  final bool? nonErrorMessage;
  const ErrorContainerWidget({Key? key,
    required this.message,
    this.nonErrorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
      child: Container(
        height: nonErrorMessage ?? false ? null : 48,
        decoration: BoxDecoration(
          border: Border.all(
              color: nonErrorMessage ?? false ?
          Colors.transparent : AppColors().grey20),
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        child:  Center(
          child: Text(
            message,
            style: nonErrorMessage ?? false ?
            FontStyleManager().s16fw600Grey :
              const TextStyle(color: Colors.red),
            textAlign: nonErrorMessage ?? false ?
            TextAlign.center : null,
          ),
        ),
      ),
    );
  }
}
