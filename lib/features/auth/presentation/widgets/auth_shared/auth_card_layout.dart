import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_background.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_brand_logo.dart';

class AuthCardLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final String? footerActionText;
  final String? footerLinkText;
  final VoidCallback? onFooterLinkTap;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AuthCardLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.footerActionText,
    this.footerLinkText,
    this.onFooterLinkTap,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 24.w),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showBackButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: onBackPressed ?? () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                const AuthBrandLogo(),
                SizedBox(height: 48.h),
                Text(
                  title,
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodymedium.copyWith(
                          color: AppColors.authTextSecondary,
                        ),
                      ),
                      if (footerLinkText != null) ...[
                        TextButton(
                          onPressed: onFooterLinkTap,
                          child: Text(
                            footerLinkText!,
                            style: AppTextStyles.bodymedium.copyWith(
                              color: AppColors.brandBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                SizedBox(height: 40.h),
                Container(
                  width: 580.w,
                  padding: EdgeInsets.all(40.w),
                  decoration: BoxDecoration(
                    color: AppColors.authCardBackground.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: AppColors.brandBorder),
                  ),
                  child: child,
                ),
                SizedBox(height: 48.h),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© 2024 AILIXIR PLATFORMS INC.',
              style: AppTextStyles.labelsmall.copyWith(
                color: AppColors.authTextSecondary.withValues(alpha: 0.5),
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 40.w),
            _footerLink('STATUS'),
            SizedBox(width: 24.w),
            _footerLink('ETHICS'),
            SizedBox(width: 24.w),
            _footerLink('LEGAL'),
          ],
        ),
      ],
    );
  }

  Widget _footerLink(String text) {
    return Text(
      text,
      style: AppTextStyles.labelsmall.copyWith(
        color: AppColors.authTextSecondary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }
}
