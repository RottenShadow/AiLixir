import 'package:ailixir/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AdmetStatus {
  final String label;
  final Color color;
  const AdmetStatus(this.label, this.color);
}

AdmetStatus getAdmetStatus(String metric, double val) {
  switch (metric) {
    case 'Absorption':
      return val > -5.15
          ? const AdmetStatus('Good', AppColors.admetPositive)
          : const AdmetStatus('Poor', AppColors.amber500);
    case 'Distribution':
      return val > 0.5
          ? const AdmetStatus('BBB+', AppColors.admetPositive)
          : const AdmetStatus('BBB-', AppColors.amber500);
    case 'Metabolism':
      return val > 0.5
          ? const AdmetStatus('Substrate', AppColors.admetPositive)
          : const AdmetStatus('Non-Substrate', AppColors.amber500);
    case 'Excretion':
      return val > 0.5
          ? const AdmetStatus('Stable', AppColors.admetPositive)
          : const AdmetStatus('Unstable', AppColors.amber500);
    case 'Toxicity':
      return val > 0.5
          ? const AdmetStatus('High Risk', AppColors.red400)
          : const AdmetStatus('Safe', AppColors.admetPositive);
    default:
      return const AdmetStatus('Optimal', AppColors.admetPositive);
  }
}
