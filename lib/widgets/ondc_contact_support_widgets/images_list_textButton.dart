import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/manager/font_manager.dart';

import '../../pages/new_tab_pages/image_page.dart';


class ImagesListTextButton extends StatelessWidget {
  final List<String> imgList;
  const ImagesListTextButton({Key? key,
    required this.imgList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          itemCount: imgList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, index){

            return InkWell(
              onTap: (){
                Get.to(
                      () => ImageViewerPage(
                    itemImageUrl: imgList[index],
                    showCustomImage: true,
                  ),
                  opaque: false,
                  transition: Transition.fadeIn,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text("Image ${index+1}",
                  style: FontStyleManager().s14fw700Blue,),
              ),
            );

        }),
      ),
    );
  }
}
