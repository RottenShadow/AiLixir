import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';

abstract class AppThemes {
  static ThemeData getTheme(BuildContext context, {required bool isDarkTheme}) {
    return isDarkTheme
        ? ThemeData.dark().copyWith(
            scaffoldBackgroundColor: AppColors.slate1000,
          )
        : ThemeData.light();
  }
}
