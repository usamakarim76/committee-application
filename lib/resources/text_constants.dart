import 'package:committee_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme textTheme = TextTheme(
  titleLarge: GoogleFonts.poppins(
      fontSize: 19.sp,
      fontWeight: FontWeight.w900,
      color: AppColors.kBlackColor),
  titleMedium: GoogleFonts.poppins(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.kBlackColor),
  titleSmall: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.kBlackColor),
  bodyLarge: GoogleFonts.poppins(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.kBlackColor),
  bodyMedium: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.kBlackColor),
  labelLarge: GoogleFonts.poppins(
      fontSize: 14.sp, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  bodySmall: GoogleFonts.poppins(
      fontSize: 12.sp, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.poppins(
      fontSize: 10.sp, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
