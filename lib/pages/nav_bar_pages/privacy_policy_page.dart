import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/boxes_controller.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    double screenHeight = MediaQuery.of(context).size.height / 100;

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: screenHeight * 5.5,
          leading: IconButton(
            splashRadius: 0.1,
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 13.sp,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Privacy Policy',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp),
          ),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 3),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Santhe Privacy Policy',
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0, left: 15.0, right: 15.0),
                child: Html(data: """
${Boxes.getContent().get('privacyPolicy')}
                  """)),
          ],
        ));
  }
}
