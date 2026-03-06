import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';

abstract class AppGradients {
  static const roseVioletLinearGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.rose400, AppColors.violet400],
  );

  static const whiteLinearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.white20, AppColors.white30],
  );

  static const blackSmallLinearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.blackShadow30, AppColors.blackShadow15],
  );

  static const mainPageRadialGradient = RadialGradient(
    center: Alignment.topLeft,
    radius: 2,
    colors: [AppColors.slate700, AppColors.slate900],
    transform: GradientRotation(-10 * 3.14 / 180),
    stops: [0.0, 1.0], // Corresponding stop positions
  );

  static const secondPageRadialGradient = RadialGradient(
    center: Alignment.topLeft,
    radius: 2,
    colors: [AppColors.slateZeroOpacity700, AppColors.slate900],
    transform: GradientRotation(-10 * 3.14 / 180),
    stops: [0.0, 1.0],
  );
}
