// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gits_cached_network_image/gits_cached_network_image.dart';
import 'package:lottie/lottie.dart';

import '../../manager/imageManager.dart';

class ShopImageIntro extends StatelessWidget {
  final String image;
  const ShopImageIntro({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 95,
        width: MediaQuery.of(context).size.width * 0.26,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: GitsCachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            loadingBuilder: (context) => Lottie.asset(
                ImgManager().imageLoader),
            errorBuilder: (context, url, error) => Image.asset(
              'assets/placeHolder.jpeg',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
