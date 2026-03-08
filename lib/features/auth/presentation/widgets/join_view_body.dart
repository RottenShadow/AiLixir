import 'package:ailixir/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_card_layout.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_primary_button.dart';
import 'package:ailixir/features/auth/presentation/views/login_view.dart';
import 'package:ailixir/features/auth/presentation/views/signup_view.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';

class JoinViewBody extends StatelessWidget {
  const JoinViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthCardLayout(
      title: 'Join the Research Network',
      subtitle: 'Select your preferred method to continue',
      child: Column(
        children: [
          AuthPrimaryButton(
            text: 'Sign In to Laboratory',
            onPressed: () => context.navigateTo(LoginView.routeName),
          ),
          SizedBox(height: 24.h),
          OutlinedButton(
            onPressed: () => context.navigateTo(SignupView.routeName),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.authButtonBackground,
              minimumSize: Size(double.infinity, 56.h),
              side: const BorderSide(color: AppColors.brandBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Create New Account',
              style: AppTextStyles.h4.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.brandBorder)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'OR CONTINUE WITH',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.authTextSecondary.withValues(alpha: 0.8),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: AppColors.brandBorder)),
            ],
          ),
          SizedBox(height: 40.h),
          Row(
            children: [
              Expanded(
                child: _socialButton(Icons.g_mobiledata, 'Google', () async {
                  await context.read<AuthCubit>().signInWithGoogle();
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 24.sp),
      label: Text(
        label,
        style: AppTextStyles.bodymedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        backgroundColor: AppColors.authButtonBackground,
        side: const BorderSide(color: AppColors.brandBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
