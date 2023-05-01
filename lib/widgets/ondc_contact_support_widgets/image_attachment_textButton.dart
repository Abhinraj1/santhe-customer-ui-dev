import "package:flutter/cupertino.dart";
import"package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:santhe/core/app_colors.dart";

import "../../constants.dart";
import "../../core/cubits/customer_contact_cubit/customer_contact_cubit.dart";
import "../../core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_cubit.dart";
import "../../manager/font_manager.dart";
import "../custom_widgets/select_image_source_dialog.dart";
    

class ImageAttachmentTextButton extends StatelessWidget {

  const ImageAttachmentTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
       await showDialog(
            context: context,
            builder: (context) {
              return const SelectImageSourceDialog();
            }
        );

        BlocProvider.of<UploadImageAndReturnRequestCubit>
          (context).getImageString();
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
