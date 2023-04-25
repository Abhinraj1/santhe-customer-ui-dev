
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/app_colors.dart';
import '../../core/app_helpers.dart';
import '../../manager/font_manager.dart';
import '../../manager/imageManager.dart';
import '../navigation_drawer_widget.dart';


class CustomScaffold extends StatelessWidget {

  final bool? hasShareButton;

  final Widget? trailingButton;

  final Widget body;

  final bool? resizeToAvoidBottomInset;

  final Color? backgroundColor;

  final Widget? floatingActionButton;

  final PreferredSizeWidget? appBar;

  final Function()? onBackButtonTap;

   CustomScaffold({Key? key,

     required this.body,

     this.hasShareButton,

     this.trailingButton,

     this.backgroundColor,

     this.onBackButtonTap,

     this.resizeToAvoidBottomInset,

     this.appBar, this.floatingActionButton

   }) : super(key: key);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        if(onBackButtonTap != null){
          onBackButtonTap!();
        }else{
         Get.back();
        }
        return false;
      },
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? false,
        drawer: const CustomNavigationDrawer(),

        backgroundColor: backgroundColor ?? AppColors().white100,

        floatingActionButton: floatingActionButton,
        appBar: appBar ?? AppBar(
          backgroundColor: AppColors().brandDark,
          elevation: 10.0,
          title:  AutoSizeText(
            "Santhe",
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
      ),
    );
  }
}
