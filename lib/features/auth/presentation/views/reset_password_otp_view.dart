import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/text_form_field/custom_text_form_field.dart';
import 'package:ailixir/features/auth/presentation/cubits/user_auth_cubit/user_auth_cubit.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_back_button.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_brand_logo.dart';
import 'package:ailixir/core/widgets/buttons/custom_button.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

/// Shown after forgot-password — user enters the OTP they received plus
/// their new password and confirmation, then submits the reset request.
/// Navigation and toasts are handled by the single listener in [JoinView].
class ResetPasswordOtpView extends StatefulWidget {
  static const routeName = '/reset-password-otp';

  final String email;
  const ResetPasswordOtpView({super.key, required this.email});

  @override
  State<ResetPasswordOtpView> createState() => _ResetPasswordOtpViewState();
}

class _ResetPasswordOtpViewState extends State<ResetPasswordOtpView> {
  final _formKey = GlobalKey<FormState>();
  final _otpCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _otpCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_otpCtrl.text.length < 6) return;
    if (!_formKey.currentState!.validate()) return;

    context.read<UserAuthCubit>().resetPassword(
      email: widget.email,
      otp: _otpCtrl.text,
      password: _passwordCtrl.text,
      passwordConfirmation: _confirmCtrl.text,
    );
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
                    child: Form(
                      key: _formKey,
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
                              color: AppColors.brandBlue.withValues(
                                alpha: 0.15,
                              ),
                              border: Border.all(
                                color: AppColors.brandBlue.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.lock_reset_outlined,
                              color: AppColors.brandBlue,
                              size: 28.sp,
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // ── Title ─────────────────────────────────────────
                          Text(
                            'Reset your password',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Enter the code sent to',
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

                          // ── OTP input ─────────────────────────────────────
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
                          ),
                          SizedBox(height: 32.h),

                          // ── New password ──────────────────────────────────
                          CustomTextFormField(
                            label: 'New Password',
                            hint: '••••••••',
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.slate400,
                              size: 18.sp,
                            ),
                            controller: _passwordCtrl,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.authTextSecondary,
                                size: 20.sp,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              if (v.length < 8) return 'Minimum 8 characters';
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),

                          // ── Confirm password ──────────────────────────────
                          CustomTextFormField(
                            label: 'Confirm Password',
                            hint: '••••••••',
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.slate400,
                              size: 18.sp,
                            ),
                            controller: _confirmCtrl,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(context),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.authTextSecondary,
                                size: 20.sp,
                              ),
                              onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (v != _passwordCtrl.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 36.h),

                          // ── Submit ────────────────────────────────────────
                          CustomButton(
                            text: 'Update Password',
                            isLoading: isLoading,
                            onTap: () => _submit(context),
                          ),
                          SizedBox(height: 20.h),

                          // ── Resend ────────────────────────────────────────
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
                                          .forgotPassword(email: widget.email),
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
