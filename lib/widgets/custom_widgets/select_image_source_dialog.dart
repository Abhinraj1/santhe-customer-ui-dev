import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_cubit.dart';
import '../../manager/font_manager.dart';



class SelectImageSourceDialog extends StatelessWidget {
  const SelectImageSourceDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      SimpleDialog(
      title: Text('Select One',
          style: FontStyleManager().s16fw600Orange),

      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ElevatedButton(
              onPressed: (){
                BlocProvider.of<UploadImageAndReturnRequestCubit>
                  (context).
                getImagesFromCamera();
                Navigator.pop(context);
              },
              child:Text("Camera",
                style: FontStyleManager().
                s14fw700White,)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ElevatedButton(
              onPressed: (){
                BlocProvider.of<UploadImageAndReturnRequestCubit>
                  (context).
                getImagesFromGallery();
                Navigator.pop(context);
              },
              child:Text("Gallery",
                style: FontStyleManager().s14fw700White,)),
        ),
      ],
    );;
  }
}
