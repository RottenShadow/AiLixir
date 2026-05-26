import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/auth/presentation/cubits/user_auth_cubit/user_auth_cubit.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_back_button.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_brand_logo.dart';
import 'package:ailixir/core/widgets/buttons/custom_button.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class VerifyEmailView extends StatefulWidget {
  static const routeName = '/verify-email';

  /// The email to verify — passed as route argument.
  final String email;

  const VerifyEmailView({super.key, required this.email});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final _otpCtrl = TextEditingController();

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final otp = _otpCtrl.text.trim();
    if (otp.length < 6) return;
    context.read<UserAuthCubit>().verifyEmail(email: widget.email, otp: otp);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAuthCubit, UserAuthState>(
      builder: (context, state) {
        final isLoading = state is UserAuthLoading;

        final defaultPinTheme = PinTheme(
          width: 52.w,
          height: 56.h,
          textStyle: AppTextStyles.h3.copyWith(color: Colors.white),
          decoration: BoxDecoration(
            color: AppColors.slate700.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.slate600.withValues(alpha: 0.6),
            ),
          ),
        );

        return AuthGradientScaffold(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthBrandLogo(),
                  SizedBox(height: 40.h),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ── Back ──────────────────────────────────────────
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AuthBackButton(
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // ── Icon ──────────────────────────────────────────
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.brandBlue.withValues(alpha: 0.15),
                            border: Border.all(
                              color: AppColors.brandBlue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            Icons.mark_email_unread_outlined,
                            color: AppColors.brandBlue,
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Verify your email',
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'We sent a 6-digit code to',
                          style: AppTextStyles.bodymedium.copyWith(
                            color: AppColors.authTextSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.email,
                          style: AppTextStyles.bodymedium.copyWith(
                            color: AppColors.brandBlue,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 36.h),

                        // ── OTP ───────────────────────────────────────────
                        Pinput(
                          controller: _otpCtrl,
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(
                                color: AppColors.brandBlue,
                                width: 1.5,
                              ),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(
                                color: Colors.redAccent,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onCompleted: (_) => _submit(context),
                        ),
                        SizedBox(height: 36.h),
                        CustomButton(
                          text: 'Verify Email',
                          isLoading: isLoading,
                          onTap: () => _submit(context),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code?",
                              style: AppTextStyles.bodymedium.copyWith(
                                color: AppColors.authTextSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context
                                        .read<UserAuthCubit>()
                                        .resendVerification(
                                          email: widget.email,
                                        ),
                              child: Text(
                                'Resend',
                                style: AppTextStyles.bodymedium.copyWith(
                                  color: AppColors.brandBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
