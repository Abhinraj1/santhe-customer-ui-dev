import 'dart:io';

import 'package:flutter/material.dart';
import 'package:santhe/core/app_url.dart';
import 'package:santhe/widgets/protectedCachedNetworkImage.dart';

class ImageViewerPage extends StatelessWidget {
  final String itemImageUrl;
  final bool showCustomImage;
  final File? imgFile;
  const ImageViewerPage(
      {required this.itemImageUrl, required this.showCustomImage, Key? key, this.imgFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.4),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
          child: Center(
            child:
            InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(20.0),
              panEnabled: true,
              minScale: 0.1,
              maxScale: 4.0,
              child:
              imgFile != null ?
              Image.file(imgFile!,
                width: MediaQuery.of(context).size.width,)  :
                  ProtectedCachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                imageUrl: showCustomImage
                    ? itemImageUrl
                    : 'https://firebasestorage.googleapis.com/v0/b/${AppUrl.envType}.appspot.com/o/$itemImageUrl',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
