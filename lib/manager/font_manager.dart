import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhe/core/app_colors.dart';

class FontStyleManager {
  TextStyle kAppNameStyle = const TextStyle(
      fontWeight: FontWeight.w800, color: Colors.white, fontSize: 24);

  TextStyle pageTitleStyle = const TextStyle(
      color: Color(0xffFF9800), fontSize: 20, fontWeight: FontWeight.w600);

  TextStyle s14fw700Orange = const TextStyle(
      color: Color(0xffFF9800), fontSize: 14, fontWeight: FontWeight.w700);

  TextStyle s20fw700Orange = const TextStyle(
      color: Color(0xffFF9800), fontSize: 20, fontWeight: FontWeight.w700);

  TextStyle s18fw700Orange = const TextStyle(
      color: Color(0xffFF9800), fontSize: 18, fontWeight: FontWeight.w700);

  TextStyle s12fw400Orange = const TextStyle(
      color: Color(0xffFF9800), fontSize: 12, fontWeight: FontWeight.w400);

  TextStyle s16fw700 = GoogleFonts.mulish(
      color: Color(0xff8B8B8B), fontSize: 16, fontWeight: FontWeight.w700);

  TextStyle s16fw500 = GoogleFonts.mulish(
      color: const Color(0xff8B8B8B),
      fontSize: 16,
      fontWeight: FontWeight.w500);

  TextStyle s16fw700Brown = GoogleFonts.mulish(
      color: const Color(0xff51453A),
      fontSize: 16,
      fontWeight: FontWeight.w700);

  TextStyle s14fw500 = GoogleFonts.mulish(
      color: const Color(0xff51453A),
      fontSize: 14,
      fontWeight: FontWeight.w500);

  TextStyle s14fw700White = GoogleFonts.mulish(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700);

  TextStyle s14fw700Grey = GoogleFonts.mulish(
      color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w700);

  TextStyle s14fw800Grey = GoogleFonts.mulish(
      color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w800);

  TextStyle s12fw600Grey60 = GoogleFonts.mulish(
      color: AppColors().grey60, fontSize: 14, fontWeight: FontWeight.w600);

  TextStyle s12fw500Red = GoogleFonts.mulish(
      color: const Color(0xffF24E1E),
      fontSize: 12,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.underline);

  TextStyle s14fw700Red = GoogleFonts.mulish(
    color: const Color(0xffF24E1E),
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  TextStyle s14fw600Grey = GoogleFonts.mulish(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  TextStyle s12fw700Brown = GoogleFonts.mulish(
    color: const Color(0xff51453A),
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  TextStyle s10fw500Brown = GoogleFonts.mulish(
    color: const Color(0xff51453A),
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  TextStyle s12fw500Grey = GoogleFonts.mulish(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  TextStyle s12fw400Grey = GoogleFonts.mulish(
    color: AppColors().grey100,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );


  TextStyle s16fw600Orange = GoogleFonts.mulish(
      color: AppColors().primaryOrange,
      fontSize: 16,
      fontWeight: FontWeight.w600);

  TextStyle s16fw600Grey = GoogleFonts.mulish(
      color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600);

  TextStyle s18fw700Black = GoogleFonts.mulish(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700);
}
