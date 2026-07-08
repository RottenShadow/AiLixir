import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrHeaderSection extends StatelessWidget {
  const DrHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E69FF), AppColors.cyan400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E69FF).withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.biotech, color: Colors.white, size: 24.sp),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Drug Repurposing Platform',
              style: AppTextStyles.h1.copyWith(
                fontSize: 22.sp,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [Color(0xFF60A5FA), AppColors.cyan400],
                  ).createShader(const Rect.fromLTWH(0, 0, 400, 40)),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Protein-Drug Screening System',
              style: AppTextStyles.bodysmall.copyWith(
                color: AppColors.authTextSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
