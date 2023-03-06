import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../core/app_colors.dart';


class ImageGrid extends StatelessWidget {
  const ImageGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
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
            return ImageCell(index: index,);
          },
        ),
      ),
    );
  }
}


class ImageCell extends StatelessWidget {
  final int index;
  const ImageCell({Key? key, required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
}




