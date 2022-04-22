import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewerPage extends StatelessWidget {
  final String itemImageUrl;
  final bool showCustomImage;
  const ImageViewerPage(
      {required this.itemImageUrl, required this.showCustomImage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;

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
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                panEnabled: true,
                // constrained: false,

                minScale: 0.1,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: showCustomImage
                      ? itemImageUrl
                      : 'https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/$itemImageUrl',
                  errorWidget: (context, url, error) {
                    print(error);
                    return Container(
                      color: Colors.red,
                      width: screenWidth * 25,
                      height: screenWidth * 25,
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }
}
