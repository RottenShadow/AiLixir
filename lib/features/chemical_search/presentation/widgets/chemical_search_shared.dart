import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

class RankBadge extends StatelessWidget {
  final int rank;
  final Color color;

  const RankBadge({super.key, required this.rank, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        '#$rank',
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class SearchBadge extends StatelessWidget {
  final String label;
  final Color color;

  const SearchBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.labelmedium.copyWith(color: AppColors.slate300),
    );
  }
}

InputDecoration inputDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.bodymedium.copyWith(color: AppColors.slate600),
    filled: true,
    fillColor: AppColors.slate800,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.brandBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.brandBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.cyan600),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.brandBorder),
    ),
  );
}

Color scoreColor(double score) {
  if (score >= 1.0) return AppColors.emerald400;
  if (score >= 0.95) return AppColors.green400;
  if (score >= 0.85) return AppColors.amber400;
  return AppColors.red400;
}

Color rankColor(int rank) {
  if (rank == 1) return AppColors.emerald400;
  if (rank == 2) return AppColors.green400;
  if (rank == 3) return AppColors.amber400;
  return AppColors.slate400;
}
