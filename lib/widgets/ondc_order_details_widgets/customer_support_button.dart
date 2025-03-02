import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../core/app_colors.dart';
import '../../../../manager/font_manager.dart';


class CustomerSupportButton extends StatelessWidget {
  final Function() onTap;
  final String? title;
  const CustomerSupportButton({Key? key, required this.onTap, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
      padding: const EdgeInsets.only(bottom: 5,left: 20,right: 20),
      child: MaterialButton(
        onPressed: (){
          onTap();
        },
        height: 40,
        shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(customButtonBorderRadius),
            side: BorderSide(
                color: AppColors().grey40,
                width: 1
            )
        ),
        minWidth: 250,
        child: Text(title ?? "CONTACT SUPPORT",
          style:
          FontStyleManager().s14fw700Grey,
        ),
      ),
    );
  }
}
