import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/admet/presentation/widgets/admet_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdmetMetricRow extends StatelessWidget {
  final String name;
  final double value;

  const AdmetMetricRow({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    final status = getAdmetStatus(name, value);
    final pct = ((value + 5) * 10).clamp(8.0, 100.0);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.authTextSecondary.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value.toStringAsFixed(3),
                    style: AppTextStyles.labelmedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: status.color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: status.color.withOpacity(0.2)),
                    ),
                    child: Text(
                      status.label,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: status.color,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Container(
            height: 5.h,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(99.r),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: pct / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [status.color.withOpacity(0.6), status.color],
                  ),
                  borderRadius: BorderRadius.circular(99.r),
                  boxShadow: [
                    BoxShadow(
                      color: status.color.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
