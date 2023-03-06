import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../core/app_colors.dart';
import '../../manager/font_manager.dart';

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String buttonTitle;
  final double? width;
  final double? verticalPadding;
  final double? horizontalPadding;
  final bool? isActive;

  const CustomButton(
      {Key? key,
      required this.onTap,
      required this.buttonTitle,
      this.width,
      this.verticalPadding,
      this.horizontalPadding,
      this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 40.0,
            vertical: verticalPadding ?? 10),
        child: MaterialButton(
          onPressed: () {
            onTap();
          },
          color:
              isActive ?? true ? AppColors().primaryOrange : AppColors().grey60,
          height: 40,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(customButtonBorderRadius),
          ),
          minWidth: width ?? 150,
          child: Text(
            buttonTitle,
            style: isActive ?? true
                ? FontStyleManager().s14fw700White
                : FontStyleManager()
                    .s14fw700White
                    .copyWith(color: AppColors().grey100),
          ),
        ),
      ),
    );
  }
}
