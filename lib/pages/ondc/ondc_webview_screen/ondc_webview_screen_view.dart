import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'ondc_webview_screen_mobile.dart';



class ONDCWebviewView extends StatelessWidget {
  final String title;
  final String url;

  const ONDCWebviewView({
    Key? key,
    required this.title,
    required this.url
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: ONDCWebviewScreenMobile(
        title: title,
          url: url,
        ),
        // desktop: const
        // tablet:
      );
    });
  }
}