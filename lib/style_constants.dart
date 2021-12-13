import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_app/preferences.dart';

import 'color_constants.dart';

TextStyle textStyle = TextStyle(
  color: const Color(0xffA5ACC7),
  fontSize: 16.sp,
  fontWeight: FontWeight.bold,
);

TextStyle popUpMenuTextStyle = TextStyle(
  color: primaryColorLight,
  fontSize: 14.sp,
  fontWeight: FontWeight.w500,
);

const LinearGradient linearGradient = LinearGradient(
  colors: [primaryColor, primaryColor2],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

InputDecoration textFormFieldDecoration = InputDecoration(
  filled: true,
  fillColor: PreferencesApp().getDarkTheme ? primaryColorDark : const Color(0xffF2F4FF),
  labelText: "Name",
  labelStyle:
  TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16.sp),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.r),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: const BorderSide(color: Colors.red),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: const BorderSide(color: Colors.red),
  ),
  contentPadding: EdgeInsets.symmetric(
    horizontal: 18.w,
  ).copyWith(top: 20.h, bottom: 16.h),
);
InputDecoration textFormFieldDecoration2 ({Color ?fillColor,String ?labelText,TextStyle? labelStyle})=> InputDecoration(
  filled: true,
  fillColor: fillColor,
  errorStyle:const TextStyle(fontSize: 10),
  labelText: labelText??"Name",
  labelStyle:labelStyle??
  TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16.sp),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.r),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: const BorderSide(color: Colors.red),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: const BorderSide(color: Colors.red),
  ),
  contentPadding: EdgeInsets.symmetric(
    horizontal: 18.w,
  ).copyWith(top: 20.h, bottom: 16.h),
);