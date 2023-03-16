import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../manager/font_manager.dart';


class CustomTitleWithBackButton extends StatelessWidget {
 final String title;
  const CustomTitleWithBackButton({Key? key,
  required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
      child: Row(
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: AppColors().brandDark,
              radius: 13,
              child: const Padding(
                padding: EdgeInsets.only(left: 7.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),

          Text(
              title,
              style:FontStyleManager().pageTitleStyle

          ),
          const Spacer(),
        ],
      ),
    );
  }
}


