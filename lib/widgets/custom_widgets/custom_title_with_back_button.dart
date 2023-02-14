import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../manager/font_manager.dart';


Widget customTitleWithBackButton({required BuildContext context, required String title}){
  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
    child: Row(
      children: [
        InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: CircleAvatar(
            backgroundColor: AppColors().brandDark,
            radius: 18,
            child: const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 100,
        ),
         Text(
          title,
          style:FontStyleManager().pageTitleStyle

        )
      ],
    ),
  );
}