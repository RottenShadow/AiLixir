import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';

abstract class AppShadows {
  static const fushiaBoxShadow = [
    BoxShadow(
      color: AppColors.fuchsia300,
      offset: Offset(0, 8),
      blurRadius: 12,
      spreadRadius: -8,
    ),
  ];

  static const whiteGlowBoxShadow = [
    BoxShadow(
      color: AppColors.white10,
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: -8,
    ),
  ];

  static const shadowSmallBoxShadow = [
    BoxShadow(
      color: AppColors.blackShadow25,
      blurRadius: 2,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  static const textShadow = [
    Shadow(color: AppColors.blackShadow25, offset: Offset(0, 1), blurRadius: 2),
  ];
}
