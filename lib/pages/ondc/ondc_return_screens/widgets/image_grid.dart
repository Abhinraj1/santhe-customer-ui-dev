import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../core/app_colors.dart';


Widget imageGrid(){
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: SizedBox(
      height: 200,
      width: 200,
      child: GridView.builder(
        itemCount: 4,

          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              childAspectRatio: 2 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
           itemBuilder: (context, index){
            return imageCell(index);
            },
      ),
    ),
  );
}

Widget imageCell(int index){
  
  if(index == 0){
    return
      InkWell(
        onTap: (){

          ///trigger upload image function

        },
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(imageCellBorderRadius),
            border: Border.all(
              color: AppColors().primaryOrange,
              width: 1
            )
          ),
          child: Center(
              child: Icon(
                Icons.add,color: AppColors().primaryOrange,size: 40,)),
        ),
      );

  }
  ///
  else {
    return
      Container(
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(imageCellBorderRadius),
          color: AppColors().grey40,
        ),
      );
  }
  
}

