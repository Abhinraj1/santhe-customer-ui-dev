import 'package:flutter/material.dart';
import 'package:santhe/manager/font_manager.dart';

class OrderDetailsTable extends StatelessWidget {
  final String redTextButtonTitle,
      firstTitle,firstData,
      secondTitle,secondData,
      thirdTitle,thirdData,
      fourthTitle,fourthData;

  final Function()? thirdDataOnTap;
  final TextStyle? thirdDataTextStyle;
  final double? horizontalPadding,
                verticalPadding;

  const OrderDetailsTable({Key? key,
    required this.redTextButtonTitle,
    required this.firstTitle, required this.firstData,
    required this.secondTitle, required this.secondData,
    required this.thirdTitle, required this.thirdData,
    required this.fourthTitle, required this.fourthData,

     this.horizontalPadding,
     this.verticalPadding, this.thirdDataOnTap, this.thirdDataTextStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return       Padding(
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
                InkWell(

                  onTap: (){
                    if(thirdDataOnTap != null){
                      thirdDataOnTap!();
                    }

                  },
                    child: Text(
                        thirdData,style: thirdDataTextStyle ?? FontStyleManager().s14fw700Grey,
                        textAlign: TextAlign.right)),

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

                Text(redTextButtonTitle,
                    style: FontStyleManager().s12fw500Red,
                    textAlign: TextAlign.right)

              ]
          ),
        ],
      ),
    );
  }
}

