import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resize/resize.dart';
import 'package:santhe/core/app_colors.dart';

class AppTheme{

  final ThemeData themeData = ThemeData(
    fontFamily: 'Mulish',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return AppColors().brandLight;
              }
              return AppColors().brandDark;// Use the component's default.
            },
          ),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return TextStyle(
                    fontSize: 18.sp, color: AppColors().white100, fontWeight: FontWeight.w700);
              }
              return TextStyle(
                  fontSize: 18.sp, color: AppColors().yellow90, fontWeight: FontWeight.w700);// Use the component's default.
            },
          ),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)))
      ),),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: AppColors().brandDark,
      ),
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors().white100,
      ),
      backgroundColor: AppColors().brandDark,
      titleTextStyle: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w900,
          color: AppColors().white100),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors().brandDark
    )
  );

  TextStyle bold900(double fontSize, {Color? color, double? height}) => TextStyle(
      fontSize: fontSize.sp,
      height: height,
      fontWeight: FontWeight.w900,
      color: color ?? AppColors().grey100);

  TextStyle bold800(double fontSize, {Color? color, double? height}) => TextStyle(
      fontSize: fontSize.sp,
      height: height,
      fontWeight: FontWeight.w800,
      color: color ?? AppColors().grey100);

  TextStyle bold700(double fontSize, {Color? color, double? height}) => TextStyle(
      fontSize: fontSize.sp,
      height: height,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors().grey100);

  TextStyle bold600(double fontSize, {Color? color, double? height}) => TextStyle(
      fontSize: fontSize.sp,
      height: height,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors().grey100);

  TextStyle normal500(double fontSize, {Color? color, double? height}) => TextStyle(
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w500,
      height: height,
      color: color ?? AppColors().grey100);

  TextStyle normal400(double fontSize, {Color? color, double? height}) => TextStyle(
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w400,
      height: height,
      color: color ?? AppColors().grey100);

  TextStyle hintTextStyle({Color? color}) => TextStyle(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: color ?? AppColors().grey40);

  InputDecoration formInputDecoration({required IconData icon, required String hintText}) => InputDecoration(
    prefixIcon: SizedBox(
      height: 24.w,
      width: 24.w,
      child: Center(
        child: Container(
            height: 24.w,
            width: 24.w,
            decoration: BoxDecoration(
                color: AppColors().brandDark,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Icon(
              icon,
              color: AppColors().white100,
              size: 15.sp,
            )
        ),
      ),
    ),
    hintText: hintText,
    hintStyle: hintTextStyle(color: AppColors().grey80),
    contentPadding: EdgeInsets.only(top: 2.h),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors().grey40, width: 1.sp)
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors().grey40, width: 1.sp)
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  );

}