import 'package:flutter/material.dart';
import 'package:santhe/core/repositories/ondc_repository.dart';

import '../../../../constants.dart';
import '../../../../core/app_colors.dart';
import '../../../../manager/font_manager.dart';




Widget textFieldForQuery(TextEditingController controller){

  return
    Center(
      child: SizedBox(
        height: 230,
        width: 300,
        child: TextField(
          maxLines: 15,
          controller: controller,
          textAlign: TextAlign.center,
          cursorColor: AppColors().grey80,
          decoration: InputDecoration(
              filled: true,
              contentPadding: const EdgeInsets.only(left: 20,top: 30),
              fillColor: AppColors().white100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(queryTextFieldBorderRadius),
                borderSide: BorderSide.none,
              ),

            hintText: "Enter your Query",
            hintStyle: FontStyleManager().s16fw600Grey
          ),
        ),
      ),
    );
}