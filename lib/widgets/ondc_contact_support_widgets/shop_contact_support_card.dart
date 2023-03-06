import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../core/app_colors.dart';
import '../../../../manager/font_manager.dart';
import '../../../../models/ondc/shop_model.dart';


class ShopContactSupportCard extends StatelessWidget {
  final ShopModel model;
  const ShopContactSupportCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String pno = model.phone.toString(),
        shopName = model.name.toString(),
        address = model.address.toString(),
        mailId = model.email.toString();

    return       Container(
      width: 300,
      height: 180,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          color: AppColors().white100,
          borderRadius: BorderRadius.circular(kTextFieldCircularBorderRadius)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(shopName,
            textAlign: TextAlign.center,
            style: FontStyleManager().s20fw700Orange,),
          Text(address,
            textAlign: TextAlign.center,
            style: FontStyleManager().s16fw600Grey,),
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors().brandDark,
                  radius: 10,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
                Text(pno,
                  textAlign: TextAlign.center,
                  style: FontStyleManager().s16fw500,),
              ],
            ),
          ),
          SizedBox(
            width: 190,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.mail_outline_outlined,
                  color: AppColors().brandDark,
                  size: 20,
                ),
                Text(mailId,
                  textAlign: TextAlign.center,
                  style: FontStyleManager().s16fw500,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


