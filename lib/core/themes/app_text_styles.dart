import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';

abstract class AppTextStyles {
  // Cached font families
  static late String _primaryFont;
  static late String _secondaryFont;

  // -------------------------------
  // PRIVATE TEXT STYLE VARIABLES
  // -------------------------------

  static late TextStyle _xl;
  static late TextStyle _large;
  static late TextStyle _medium;
  static late TextStyle _small;

  static late TextStyle _h1;
  static late TextStyle _h2;
  static late TextStyle _h3;
  static late TextStyle _h4;
  static late TextStyle _h5;
  static late TextStyle _h6;

  static late TextStyle _bodyxl;
  static late TextStyle _bodylarge;
  static late TextStyle _bodymedium;
  static late TextStyle _bodysmall;
  static late TextStyle _bodyxs;

  static late TextStyle _labellarge;
  static late TextStyle _labelmedium;
  static late TextStyle _labelsmall;

  static late TextStyle _caption;
  static late TextStyle _overline;

  // -----------------------------------
  // INIT — Create ALL styles once
  // -----------------------------------
  static void init(Locale locale) {
    final isArabic = locale.languageCode.contains('ar');

    if (isArabic) {
      _primaryFont = 'Cairo';
      _secondaryFont = 'Cairo';
    } else {
      _primaryFont = 'Inter';
      _secondaryFont = 'Inter';
    }

    // ------------------------------
    //   CREATE TEXT STYLES ONCE
    // ------------------------------

    // Display
    _xl = TextStyle(
      fontSize: 48.sp,
      fontFamily: _primaryFont,
      fontWeight: FontWeight.w700,
    );

    _large = TextStyle(
      fontSize: 40.sp,
      fontFamily: _primaryFont,
      fontWeight: FontWeight.w700,
    );

    _medium = TextStyle(
      fontSize: 32.sp,
      fontFamily: _primaryFont,
      fontWeight: FontWeight.w700,
    );

    _small = TextStyle(
      fontSize: 28.sp,
      fontFamily: _primaryFont,
      fontWeight: FontWeight.w600,
    );

    // Headings
    _h1 = TextStyle(
      fontSize: 24.sp,
      fontFamily: _primaryFont,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
    );

    _h2 = TextStyle(
      fontSize: 20.sp,
      fontFamily: _primaryFont,
      fontWeight: FontWeight.w600,
    );

    _h3 = TextStyle(
      fontSize: 18.sp,
      fontFamily: _primaryFont,
      fontWeight: FontWeight.w600,
    );

    _h4 = TextStyle(
      fontSize: 16.sp,
      fontFamily: _primaryFont,
      color: AppColors.white,
      fontWeight: FontWeight.w500,
    );

    _h5 = TextStyle(
      fontSize: 14.sp,
      fontFamily: _primaryFont,
      fontWeight: FontWeight.w500,
    );

    _h6 = TextStyle(
      fontSize: 12.sp,
      fontFamily: _primaryFont,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
    );

    // Body
    _bodyxl = TextStyle(
      fontSize: 18.sp,
      fontFamily: _secondaryFont,
      fontWeight: FontWeight.w400,
    );

    _bodylarge = TextStyle(
      fontSize: 15.sp,
      fontFamily: _secondaryFont,
      fontWeight: FontWeight.w400,
    );

    _bodymedium = TextStyle(
      fontSize: 14.sp,
      fontFamily: _secondaryFont,
      fontWeight: FontWeight.w400,
    );

    _bodysmall = TextStyle(
      fontSize: 12.sp,
      fontFamily: _secondaryFont,
      fontWeight: FontWeight.w400,
    );

    _bodyxs = TextStyle(
      fontSize: 11.sp,
      fontFamily: _secondaryFont,
      fontWeight: FontWeight.w400,
    );

    // Labels
    _labellarge = TextStyle(
      fontSize: 14.sp,
      fontFamily: _secondaryFont,
      fontWeight: FontWeight.w500,
    );

    _labelmedium = TextStyle(
      fontSize: 12.sp,
      fontFamily: _secondaryFont,
      fontWeight: FontWeight.w500,
    );

    _labelsmall = TextStyle(
      fontSize: 11.sp,
      fontFamily: _secondaryFont,
      fontWeight: FontWeight.w500,
    );

    // Caption
    _caption = TextStyle(
      fontSize: 10.sp,
      fontFamily: _secondaryFont,
      fontWeight: FontWeight.w400,
    );

    _overline = TextStyle(
      fontSize: 10.sp,
      fontFamily: _secondaryFont,
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    );
  }

  // -----------------------------------
  // PUBLIC GETTERS
  // -----------------------------------

  static TextStyle get xl => _xl;
  static TextStyle get large => _large;
  static TextStyle get medium => _medium;
  static TextStyle get small => _small;

  static TextStyle get h1 => _h1;
  static TextStyle get h2 => _h2;
  static TextStyle get h3 => _h3;
  static TextStyle get h4 => _h4;
  static TextStyle get h5 => _h5;
  static TextStyle get h6 => _h6;

  static TextStyle get bodyxl => _bodyxl;
  static TextStyle get bodylarge => _bodylarge;
  static TextStyle get bodymedium => _bodymedium;
  static TextStyle get bodysmall => _bodysmall;
  static TextStyle get bodyxs => _bodyxs;

  static TextStyle get labellarge => _labellarge;
  static TextStyle get labelmedium => _labelmedium;
  static TextStyle get labelsmall => _labelsmall;

  static TextStyle get caption => _caption;
  static TextStyle get overline => _overline;
}
