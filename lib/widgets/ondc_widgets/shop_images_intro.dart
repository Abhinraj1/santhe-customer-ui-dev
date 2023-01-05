// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShopImageIntro extends StatelessWidget {
  final String image;
  const ShopImageIntro({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 66,
        width: 66,
        child: CachedNetworkImage(
          imageUrl: image,
          errorWidget: (context, url, error) => const Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
