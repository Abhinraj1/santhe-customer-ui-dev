import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../core/app_colors.dart';
import '../../manager/font_manager.dart';


class CustomTitleWithBackButton extends StatelessWidget {
 final String title;
 final Function()? onTapBackButton;
  const CustomTitleWithBackButton({Key? key,
  required this.title,this.onTapBackButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           CustomBackButton(
              leftPadding: 12,
              onTap: (){
                if(onTapBackButton != null){
                  onTapBackButton!();
                }else{
                  Get.back();
                }
              }),
          const Spacer(flex: 2),

          Text(
              title,
              style:FontStyleManager().pageTitleStyle

          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final bool? invertColors;
  final double? leftPadding;
  final Function()? onTap;
  const CustomBackButton({Key? key, this.invertColors,
    this.leftPadding,
  this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.only(left: leftPadding ?? 5.0),
      child: InkWell(
        onTap: (){
          if(onTap != null){
            onTap!();
          }else{
            Get.back();
          }
        },
        child: CircleAvatar(
          backgroundColor: invertColors ?? false ?
          AppColors().white100 :
           AppColors().brandDark,

          radius: 13,
          child:  Padding(
            padding: const EdgeInsets.only(left: 7.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: 17,
              color: invertColors ?? false ?
              AppColors().brandDark :
              AppColors().white100
            ),
          ),
        ),
      ),
    );
  }
}
