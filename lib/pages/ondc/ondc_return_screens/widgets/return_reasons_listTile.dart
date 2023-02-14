import 'package:flutter/material.dart';
import 'package:santhe/core/app_colors.dart';
import 'package:santhe/manager/font_manager.dart';



Widget returnReasonsListTile({required Function() onTap, required String reason}){

  List<String> groupValue = ["one","two","three"];

  String currentValue = groupValue[0];

  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),

    child: InkWell(
      onTap: (){
        onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start ,
        children: [
          Radio(
              fillColor: MaterialStateProperty.resolveWith((states) {
                if(currentValue == groupValue[0]){
                  return AppColors().primaryOrange;
                }
                return AppColors().grey80;
              }),
              activeColor: Colors.red,
              value: groupValue[0],
              groupValue: currentValue ,
              onChanged: (value){
                currentValue = value.toString();
              }),

          SizedBox(
            width: 280,
            child: Text(reason,
              style: FontStyleManager().s16fw500,),
          )
        ],
      ),
    ),
  );
}