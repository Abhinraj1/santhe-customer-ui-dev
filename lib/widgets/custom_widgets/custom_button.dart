  import 'package:flutter/material.dart';

  import '../../constants.dart';
  import '../../core/app_colors.dart';
  import '../../manager/font_manager.dart';


  Widget customButton(
      {
        required Function() onTap,

        required String buttonTile,

        double? width,

        double? verticalPadding,

        double? horizontalPadding,

        bool? isActive,

      }){

    return Center(
      child: Padding(
        padding:  EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 40.0,
            vertical:verticalPadding ?? 10
        ),
        child: MaterialButton(
          onPressed: (){
            onTap();
          },
          color: isActive ??
              true ?
          AppColors().primaryOrange :
          AppColors().grey60,
          height: 40,
          shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(customButtonBorderRadius),
          ),
          minWidth: width ?? 150,
          child: Text(
            buttonTile,
            style: isActive ??
                true ?
            FontStyleManager().s14fw700White :
            FontStyleManager().s14fw700White.copyWith(
              color: AppColors().grey100
            ),
          ),
        ),
      ),
    );
  }