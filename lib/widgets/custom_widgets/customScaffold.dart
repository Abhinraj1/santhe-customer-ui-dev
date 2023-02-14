
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants.dart';
import '../../core/app_colors.dart';
import '../../core/app_helpers.dart';
import '../../manager/font_manager.dart';
import '../../manager/imageManager.dart';
import '../navigation_drawer_widget.dart';


class CustomScaffold extends StatelessWidget {

  final bool? hasShareButton;

  final Widget? trailingButton;

  final Widget body;

  final Color? backgroundColor;

   CustomScaffold({Key? key,

     required this.body,

     this.hasShareButton,

     this.trailingButton,

     this.backgroundColor

   }) : super(key: key);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _key,
      drawer: const CustomNavigationDrawer(),

      backgroundColor: backgroundColor ?? AppColors().white100,

      appBar: AppBar(
        backgroundColor: AppColors().primaryOrange,
        elevation: 10.0,
        title:  AutoSizeText(
          kAppName,
          style: FontStyleManager().kAppNameStyle
        ),
          leading: IconButton(
            onPressed: () async {
              _key.currentState!.openDrawer();
            },
            splashRadius: 25.0,
            icon: SvgPicture.asset(
              ImgManager().drawerIcon,
              color: Colors.white,
            ),
          ),
        shadowColor: AppColors().appBarShadow,
        actions: [
          hasShareButton ?? false ?
          Padding(
            padding: const EdgeInsets.only(right: 4.5),
            child: IconButton(
              onPressed: () {

                if (Platform.isIOS) {
                  Share.share(
                    AppHelpers().appStoreLink,
                  );
                } else {
                  Share.share(
                    AppHelpers().playStoreLink,
                  );
                }
              },
              splashRadius: 25.0,
              icon: const Icon(
                Icons.share,
                color: Colors.white,
                size: 27.0,
              ),
            ),
          ) :
             const SizedBox(),
             Padding(
             padding: const EdgeInsets.only(right: 4.5),
             child: trailingButton,)
        ],
      ),
      body: body,
    );
  }
}
