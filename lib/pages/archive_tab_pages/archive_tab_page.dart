import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class ArchiveTabPage extends StatelessWidget {
  const ArchiveTabPage({Key? key}) : super(key: key);

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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(height: screenHeight * 23),
          SizedBox(
            height: screenWidth * 100,
            width: screenWidth * 100,
            child: SvgPicture.asset(
              'assets/archive_tab_image.svg',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 28.sp, left: 23.sp, right: 23.sp),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    'All your shopping lists that you have sent to Shops in more than 72 hours will appear here. Go to',
                style: GoogleFonts.mulish(
                    color: kTextGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp),
                children: <TextSpan>[
                  TextSpan(
                    text: '\nNew ',
                    style: GoogleFonts.mulish(
                        color: kTextGrey,
                        fontWeight: FontWeight.w900,
                        fontSize: 16.sp),
                  ),
                  TextSpan(
                    text: 'tab to create and send your shopping lists',
                    style: GoogleFonts.mulish(
                        color: kTextGrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
