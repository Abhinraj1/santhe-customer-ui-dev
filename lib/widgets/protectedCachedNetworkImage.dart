import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/getx/profile_controller.dart';

class ProtectedCachedNetworkImage extends StatelessWidget {
  ProtectedCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height
  }) : super(key: key);

  final String imageUrl;
  double? height;
  double? width;
  final tokenHandler = Get.find<ProfileController>();
  late final token = tokenHandler.urlToken;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/santhe-425a8.appspot.com/o/$imageUrl",
      httpHeaders: {"authorization": 'Bearer $token'},
      fit: BoxFit.cover,
      height: height,
      width: width,
    );
  }
}
