import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

class AuthBrandLogo extends StatelessWidget {
  final double? size;
  final bool showText;
  const AuthBrandLogo({super.key, this.size, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size ?? 48.w,
          height: size ?? 48.w,
          decoration: BoxDecoration(
            color: AppColors.brandBlue,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandBlue.withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            Icons.science_outlined,
            color: Colors.white,
            size: (size ?? 48.w) * 0.6,
          ),
        ),
        if (showText) ...[
          SizedBox(width: 12.w),
          Text(
            'Ailixir',
            style: AppTextStyles.h1.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ],
    );
  }
}
