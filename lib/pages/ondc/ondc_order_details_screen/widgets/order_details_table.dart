import 'package:flutter/material.dart';
import 'package:santhe/manager/font_manager.dart';



Widget orderDetailsTable({
  required Function() onTap,
 required String redTextButtonTitle,
  firstTitle,firstData,
  secondTitle, secondData,
  thirdTitle, thirdData,
  fourthTitle, fourthData,
  double? horizontalPadding,
          verticalPadding,
}){


  return
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 40.0,
            vertical: verticalPadding ?? 0.0
        ),
        child: Table(
          children: [
            TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(firstTitle,style: FontStyleManager().s14fw800Grey,),
                  ),
                  Text(firstData,style: FontStyleManager().s14fw700Grey,textAlign: TextAlign.right),

                ]
            ),
            TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(secondTitle,style: FontStyleManager().s14fw800Grey,),
                  ),
                  Text(secondData,style: FontStyleManager().s14fw700Grey,
                      textAlign: TextAlign.right),

                ]
            ),
            TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(thirdTitle,style: FontStyleManager().s14fw800Grey,),
                  ),
                  Text(thirdData,style: FontStyleManager().s14fw700Grey,textAlign: TextAlign.right),

                ]
            ),
            TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(fourthTitle,style: FontStyleManager().s14fw800Grey,),
                  ),
                  Text(fourthData,style: FontStyleManager().s14fw700Grey,
                    textAlign: TextAlign.right,
                     ),

                ]
            ),
            TableRow(
                children: [
                 const SizedBox(),
                  InkWell(
                    onTap: (){
                      onTap();
                    },
                      child: Text(redTextButtonTitle,
                        style: FontStyleManager().s12fw500Red,
                          textAlign: TextAlign.right)),

                ]
            ),
          ],
        ),
      );

}