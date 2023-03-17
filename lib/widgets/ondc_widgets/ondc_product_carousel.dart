// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/pages/new_tab_pages/image_page.dart';

class OndcProductCarouselImage extends StatefulWidget {
  final String imageUrl;
  const OndcProductCarouselImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<OndcProductCarouselImage> createState() =>
      _OndcProductCarouselImageState();
}

class _OndcProductCarouselImageState extends State<OndcProductCarouselImage>
    with LogMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        infoLog('Tapped$widget');
        Get.to(
          () => ImageViewerPage(
            itemImageUrl: widget.imageUrl,
            showCustomImage: true,
          ),
          opaque: false,
          transition: Transition.fadeIn,
        );
      },
      child: SizedBox(
        height: 200,
        width: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            errorWidget: (context, url, error) => const Icon(Icons.shopping_cart),
            imageUrl: widget.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
