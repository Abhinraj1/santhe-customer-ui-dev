import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/models/ondc/single_order_model.dart';

import '../../../../constants.dart';
import '../../../../core/app_colors.dart';
import '../../../../manager/font_manager.dart';
import '../../../../models/ondc/shop_model.dart';
import '../../core/blocs/ondc/ondc_single_order_details_bloc/ondc_single_order_details_bloc.dart';


class ShopContactSupportCard extends StatelessWidget {
  final SingleOrderModel model;
  const ShopContactSupportCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String pno = (model.storeLocation?.store?.phone).toString(),
        shopName = (model.storeLocation?.store?.name).toString(),
        address = (model.storeLocation?.address).toString(),
        mailId = (model.storeLocation?.store?.email).toString();

    return
      Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.mail_outline_outlined,
                  color: AppColors().brandDark,
                  size: 20,
                ),
                SizedBox(
                  width: 160,
                  child: Text(mailId,
                    textAlign: TextAlign.center,
                    style: FontStyleManager().s16fw500,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


