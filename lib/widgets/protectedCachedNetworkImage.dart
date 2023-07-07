import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santhe/core/app_url.dart';

import '../controllers/getx/profile_controller.dart';

class ProtectedCachedNetworkImage extends StatelessWidget {
  ProtectedCachedNetworkImage(
      {Key? key, required this.imageUrl, this.width, this.height})
      : super(key: key);

  final String imageUrl;
  double? height;
  double? width;
  final tokenHandler = Get.find<ProfileController>();
  late final token = tokenHandler.urlToken;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      httpHeaders: {"authorization": 'Bearer $token'},
      fit: BoxFit.cover,
      height: height ?? MediaQuery.of(context).size.height / 2,
      width: width,
      useOldImageOnUrlChange: true,
      fadeInDuration: const Duration(milliseconds: 100),
      fadeOutDuration: const Duration(milliseconds: 50),
      errorWidget: (c, s, d) => Container(
        color: Colors.redAccent,
      )
      //     ProtectedCachedNetworkImage(
      //   imageUrl:
      //       // 'https://firebasestorage.googleapis.com/v0/b/${AppUrl.envType}.appspot.com/o/image%20placeholder.png?alt=media',
      //   width: width,
      //   height: height,
      // ),
    );
  }
}
