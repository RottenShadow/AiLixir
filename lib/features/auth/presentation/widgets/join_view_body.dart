import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
// import 'package:ailixir/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:ailixir/features/auth/presentation/cubits/user_auth_cubit/user_auth_cubit.dart';
import 'package:ailixir/features/auth/presentation/views/login_view.dart';
import 'package:ailixir/features/auth/presentation/views/signup_view.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_brand_logo.dart';
import 'package:ailixir/core/widgets/buttons/custom_button.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JoinViewBody extends StatelessWidget {
  const JoinViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGradientScaffold(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AuthBrandLogo(),
              SizedBox(height: 16.h),
              Text(
                'Accelerating Drug Discovery through AI',
                style: AppTextStyles.bodymedium.copyWith(
                  color: AppColors.authTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),
              // ── Card ──────────────────────────────────────────────────────
              Container(
                width: 480.w,
                padding: EdgeInsets.all(40.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.slate800.withValues(alpha: 0.95),
                      AppColors.slate900.withValues(alpha: 0.98),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: AppColors.brandBlue.withValues(alpha: 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandBlue.withValues(alpha: 0.08),
                      blurRadius: 40,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join the Research Network',
                      style: AppTextStyles.h1.copyWith(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Select your preferred method to continue',
                      style: AppTextStyles.bodymedium.copyWith(
                        color: AppColors.authTextSecondary,
                      ),
                    ),
                    SizedBox(height: 36.h),
                    CustomButton(
                      text: 'Sign In',
                      onTap: () => context.navigateTo(LoginView.routeName),
                    ),
                    SizedBox(height: 16.h),
                    OutlinedButton(
                      onPressed: () => context.navigateTo(SignupView.routeName),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.slate700.withValues(
                          alpha: 0.3,
                        ),
                        minimumSize: Size(double.infinity, 52.h),
                        side: BorderSide(
                          color: AppColors.slate600.withValues(alpha: 0.6),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Create Account',
                        style: AppTextStyles.h4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.brandBorder),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR',
                            style: AppTextStyles.labelsmall.copyWith(
                              color: AppColors.authTextSecondary.withValues(
                                alpha: 0.7,
                              ),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.brandBorder),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    // Google sign-in
                    OutlinedButton(
                      onPressed: () async =>
                          context.read<UserAuthCubit>().signInWithGoogle(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.slate700.withValues(
                          alpha: 0.3,
                        ),
                        minimumSize: Size(double.infinity, 52.h),
                        side: BorderSide(
                          color: AppColors.slate600.withValues(alpha: 0.6),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.g_mobiledata,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Continue with Google',
                            style: AppTextStyles.bodymedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Stat(value: '98.2%', label: 'PREDICTION ACCURACY'),
                  SizedBox(width: 48.w),
                  _Stat(value: '40M+', label: 'MOLECULES INDEXED'),
                  SizedBox(width: 48.w),
                  _Stat(value: '450+', label: 'INSTITUTIONS'),
                ],
              ),
              SizedBox(height: 32.h),
              Text(
                '© 2026 AILIXIR PLATFORM.',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.authTextSecondary.withValues(alpha: 0.5),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.labelsmall.copyWith(
            color: AppColors.authTextSecondary.withValues(alpha: 0.6),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
