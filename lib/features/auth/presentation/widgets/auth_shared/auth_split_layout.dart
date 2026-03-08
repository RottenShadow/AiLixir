import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_brand_logo.dart';

class AuthSplitLayout extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AuthSplitLayout({
    super.key,
    required this.leftChild,
    required this.rightChild,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Side - Visual/Marketing
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(60.w),
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColors.brandBorder, width: 1),
                ),
              ),
              child: leftChild,
            ),
          ),
          // Right Side - Form
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 100.w, vertical: 60.h),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showBackButton)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed:
                                onBackPressed ?? () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 480.w),
                        child: rightChild,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthLoginMarketingContent extends StatelessWidget {
  const AuthLoginMarketingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthBrandLogo(),
        const Spacer(flex: 2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.brandBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.brandBlue.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            'Enterprise AI Platform',
            style: AppTextStyles.labelsmall.copyWith(
              color: AppColors.brandBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 32.h),
        Text(
          'Accelerating Drug\nDiscovery through AI.',
          style: AppTextStyles.h1.copyWith(
            fontSize: 48.sp,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Join over 450 global research institutions leveraging\nAilixir\'s generative models for molecular optimization\nand clinical simulation.',
          style: AppTextStyles.bodymedium.copyWith(
            color: AppColors.authTextSecondary,
            fontSize: 16.sp,
            height: 1.6,
          ),
        ),
        const Spacer(flex: 3),
        Row(
          children: [
            _buildStat('98.2%', 'PREDICTION ACCURACY'),
            SizedBox(width: 48.w),
            _buildStat('40M+', 'MOLECULES INDEXED'),
          ],
        ),
      ],
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.h1.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.labelsmall.copyWith(
            color: AppColors.authTextSecondary.withValues(alpha: 0.5),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
