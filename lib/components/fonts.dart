import 'package:appbank/pages/pin_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appbank/components/colors.dart';

class AppFonts {
  static final TextStyle formInput = GoogleFonts.leagueSpartan(
    fontSize: 23,
    fontWeight: FontWeight.w400,
    height: 0.92,
    color: AppColors.white,
  );

  static final TextStyle formInputOpacity = GoogleFonts.leagueSpartan(
    fontSize: 23,
    fontWeight: FontWeight.w400,
    height: 0.92,
    color: AppColors.white.withOpacity(0.5),
  );

  static final TextStyle h1 = GoogleFonts.leagueSpartan(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    height: 0.92,
    color: AppColors.white,
  );

  static final TextStyle h2 = GoogleFonts.leagueSpartan(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    height: 0.92,
    color: AppColors.darkGrey,
  );

  static final TextStyle buttonText = GoogleFonts.leagueSpartan(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.lightRed,
    height: 0.92,
  );

  static final TextStyle p = GoogleFonts.leagueSpartan(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.white,
  );

  static final TextStyle errorText = GoogleFonts.leagueSpartan(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.lightGrey,
  );

  static final TextStyle cardH2 = GoogleFonts.leagueSpartan(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.grey,
  );

  static final TextStyle cardH1 = GoogleFonts.leagueSpartan(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1,
    color: AppColors.white,
  );

  static final TextStyle cardNumber = GoogleFonts.leagueSpartan(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1,
    color: AppColors.white,
  );
}
