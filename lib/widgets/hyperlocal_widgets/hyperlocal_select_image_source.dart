import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santhe/constants.dart';
import 'package:santhe/core/cubits/hyperlocal_image_return_request_cubit/hyperlocal_image_return_request_cubit.dart';
import 'package:santhe/manager/font_manager.dart';

class HyperlocalSelectImageSource extends StatelessWidget {
  const HyperlocalSelectImageSource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Select One', style: FontStyleManager().s16fw600Orange),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ElevatedButton(
              onPressed: () {
                isImageLoading.value = true;

                BlocProvider.of<HyperlocalImageReturnRequestCubit>(context)
                    .getImagesFromCamera();
                Navigator.pop(context);
              },
              child: Text(
                "Camera",
                style: FontStyleManager().s14fw700White,
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ElevatedButton(
            onPressed: () {
              isImageLoading.value = true;

              BlocProvider.of<HyperlocalImageReturnRequestCubit>(context)
                  .getImagesFromGallery();
              Navigator.pop(context);
            },
            child: Text(
              "Gallery",
              style: FontStyleManager().s14fw700White,
            ),
          ),
        ),
      ],
    );
  }
}
