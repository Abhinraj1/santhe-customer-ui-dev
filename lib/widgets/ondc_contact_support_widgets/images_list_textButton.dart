import 'package:flutter/material.dart';
import 'package:santhe/manager/font_manager.dart';


class ImagesListTextButton extends StatelessWidget {
  const ImagesListTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          itemCount: 2,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, index){

            return InkWell(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text("Image ${index+1}",style: FontStyleManager().s14fw700Blue,),
              ),
            );

        }),
      ),
    );
  }
}
