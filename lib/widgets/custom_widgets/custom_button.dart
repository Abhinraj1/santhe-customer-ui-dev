import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../core/app_colors.dart';
import '../../manager/font_manager.dart';

class CustomButton extends StatelessWidget {
  final String buttonTitle;
  final double? width;
  final double? verticalPadding;
  final double? horizontalPadding;
  final bool? isActive;
  final bool? invert;
  final Color? buttonColor;
  final bool? noBorder;
  final TextStyle? titleStyle;
  final bool? onTapEvenIfActiveIsFalse;
  final Function() onTap;
  const CustomButton(
      {Key? key,
        required this.onTap,
        required this.buttonTitle,
        this.width,
        this.verticalPadding,
        this.horizontalPadding,
        this.isActive,
        this.invert, this.buttonColor, this.noBorder, this.titleStyle, this.onTapEvenIfActiveIsFalse})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? 40.0,
              vertical: verticalPadding ?? 10),
          child: MaterialButton(
            onPressed: () {
              if(isActive ?? true){
                onTap();
              }
              if(onTapEvenIfActiveIsFalse ?? false){
                onTap();
              }
            },
            color:
            isActive ?? true ? invert ?? false ?
            AppColors().white100 :
            buttonColor ?? AppColors().brandDark :
            AppColors().grey60,

            height: 40,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: noBorder ?? false ? BorderSide.none :
                invert ?? false ? BorderSide(
                    color: AppColors().brandDark,
                    width: 2) :
                BorderSide.none
            ),
            minWidth: width ?? 150,
            child: Text(
              buttonTitle,
              style: isActive ?? true
                  ? invert ?? false ?
              FontStyleManager().s14fw700Orange
                  : titleStyle ?? FontStyleManager().s14fw700White
                  : FontStyleManager()
                  .s14fw700White
                  .copyWith(color: AppColors().grey100),
            ),
          ),
        ),
      );
  }


}

