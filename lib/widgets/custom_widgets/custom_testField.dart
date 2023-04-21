import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:santhe/core/app_theme.dart';
import '../../constants.dart';
import '../../core/app_colors.dart';
import '../../manager/font_manager.dart';



class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
        required this.controller,
         this.icon,
        required this.hintText,
        required this.labelText,
        required this.readOnly,
        required this.validate,
        this.maxLength, this.maxLines,
      })
      : super(key: key);
  final String labelText;
  final String hintText;
  final IconData? icon;
  final int? maxLength;
  final TextEditingController controller;
  final bool readOnly;
  final int? maxLines;
  final String? Function(String?)? validate;
  final TextStyle kHintStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: Colors.grey.shade400);

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              labelText,
              style: FontStyleManager().s16fw600Orange,
            ),
          ),
          TextFormField(
            style: FontStyleManager().s16fw700,
            validator: validate,
            controller: controller,
            maxLength: maxLength,
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(
              counterText: "",
              fillColor: AppColors().white100,
              filled: true,
              prefixIcon: icon != null ? Padding(
                padding:  const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal:  8),
                child: SizedBox(
                  height: 35,
                  width: 30,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Constant.bgColor,
                    child: Icon(
                      icon,
                      color: Constant.white,
                      size: 20,
                    ),
                  ),
                ),
              ) : null,

              hintText: hintText,
              hintStyle: kHintStyle,
              focusedBorder: AppTheme().focusedBorderStyle,
              border: AppTheme().borderStyle,
              enabledBorder: AppTheme().enabledBorderStyle,
              errorBorder: AppTheme().errorBorderStyle,
            ),
          ),
        ],
      ),
    );
  }
}
