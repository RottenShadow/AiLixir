import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Small "← Back" row used at the top-left of auth cards.
class AuthBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const AuthBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_back_ios,
            color: AppColors.authTextSecondary,
            size: 14.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            'Back',
            style: AppTextStyles.bodymedium
                .copyWith(color: AppColors.authTextSecondary),
          ),
        ],
      ),
    );
  }
}
