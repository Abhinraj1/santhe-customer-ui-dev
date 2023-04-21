import "package:flutter/cupertino.dart";
import"package:flutter/material.dart";
import "package:santhe/core/app_colors.dart";

import "../../manager/font_manager.dart";
    

class ImageAttachmentTextButton extends StatelessWidget {

  const ImageAttachmentTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0,top: 20,bottom: 10),
          child: SizedBox(
            width: 185,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(CupertinoIcons.link,color: AppColors().brandDark,),
                Text("Attachment images",style: FontStyleManager().s16fw600Orange,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
