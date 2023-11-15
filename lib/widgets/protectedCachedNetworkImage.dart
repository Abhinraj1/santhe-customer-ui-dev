import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gits_cached_network_image/gits_cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:santhe/core/app_url.dart';

import '../controllers/getx/profile_controller.dart';
import '../manager/imageManager.dart';

class ProtectedGitsCachedNetworkImage extends StatelessWidget {
  ProtectedGitsCachedNetworkImage(
      {Key? key, required this.imageUrl, this.width, this.height})
      : super(key: key);

  final String imageUrl;
  double? height;
  double? width;
  final tokenHandler = Get.find<ProfileController>();
  late final token = tokenHandler.urlToken;

  @override
  Widget build(BuildContext context) {
    return GitsCachedNetworkImage(
        imageUrl: imageUrl,
       // httpHeaders: {"authorization": 'Bearer $token'},
        fit: BoxFit.cover,
        height: height ?? MediaQuery.of(context).size.height / 2,
        width: width,
        // useOldImageOnUrlChange: true,
        // fadeInDuration: const Duration(milliseconds: 100),
        // fadeOutDuration: const Duration(milliseconds: 50),
      loadingBuilder: (context) => Lottie.asset(ImgManager().imageLoader),
      errorBuilder: (context, url, error) => Image.asset(
        ImgManager().santheIcon,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      ),
        //     ProtectedGitsCachedNetworkImage(
        //   imageUrl:
        //       // 'https://firebasestorage.googleapis.com/v0/b/${AppUrl.envType}.appspot.com/o/image%20placeholder.png?alt=media',
        //   width: width,
        //   height: height,
        // ),
        );
  }
}
