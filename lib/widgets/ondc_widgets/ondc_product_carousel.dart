// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

class _OndcProductCarouselImageState extends State<OndcProductCarouselImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        errorWidget: (context, url, error) => const Icon(Icons.shopping_cart),
      ),
    );
  }
}
