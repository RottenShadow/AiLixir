import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';

abstract class AppGradients {
  static const brandBlueGradient = LinearGradient(
    colors: [
      AppColors.logoGradientStart,
      AppColors.logoGradientMid,
      AppColors.logoGradientEnd,
    ],
    stops: [0.37, 0.83, 1.0],
  );
}
