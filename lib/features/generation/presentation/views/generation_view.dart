import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/themes/app_colors.dart';

class GenerationView extends StatelessWidget {
  const GenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate1000,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 80.sp,
              color: AppColors.brandBlue.withOpacity(0.4),
            ),
            SizedBox(height: 24.h),
            Text('New Generation', style: AppTextStyles.h2),
            SizedBox(height: 8.h),
            Text(
              'AI-driven candidate lead generation pipeline',
              style: AppTextStyles.bodymedium.copyWith(
                color: AppColors.authTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
