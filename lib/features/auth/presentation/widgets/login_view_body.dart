import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/text_form_field/custom_text_form_field.dart';
import 'package:ailixir/features/auth/presentation/cubits/user_auth_cubit/user_auth_cubit.dart';
import 'package:ailixir/features/auth/presentation/views/forgot_password_view.dart';
import 'package:ailixir/features/auth/presentation/views/signup_view.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_back_button.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_brand_logo.dart';
import 'package:ailixir/core/widgets/buttons/custom_button.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<UserAuthCubit>().login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAuthCubit, UserAuthState>(
      builder: (context, state) {
        final isLoading = state is UserAuthLoading;
        return AuthGradientScaffold(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthBrandLogo(),
                  SizedBox(height: 40.h),
                  _AuthCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AuthBackButton(),
                          SizedBox(height: 24.h),
                          Text(
                            'Welcome back',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Sign in to your Ailixir account',
                            style: AppTextStyles.bodymedium.copyWith(
                              color: AppColors.authTextSecondary,
                            ),
                          ),
                          SizedBox(height: 36.h),
                          CustomTextFormField(
                            label: 'Email',
                            hint: 'you@example.com',
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              color: AppColors.slate400,
                              size: 18.sp,
                            ),
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!v.contains('@'))
                                return 'Enter a valid email';
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),
                          CustomTextFormField(
                            label: 'Password',
                            hint: '••••••••',
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.slate400,
                              size: 18.sp,
                            ),
                            controller: _passwordCtrl,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(context),
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
                            topTrailing: TextButton(
                              onPressed: () => context.navigateTo(
                                ForgotPasswordView.routeName,
                              ),
                              child: Text(
                                'Forgot password?',
                                style: AppTextStyles.labelmedium.copyWith(
                                  color: AppColors.brandBlue,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 36.h),
                          CustomButton(
                            text: 'Sign In',
                            isLoading: isLoading,
                            icon: Icons.login_outlined,
                            showIcon: true,
                            width: double.infinity,
                            onTap: () => _submit(context),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: AppTextStyles.bodymedium.copyWith(
                                  color: AppColors.authTextSecondary,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    context.navigateTo(SignupView.routeName),
                                child: Text(
                                  'Sign Up',
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
      },
    );
  }
}

/// Shared gradient card used across all new auth screens.
class _AuthCard extends StatelessWidget {
  final Widget child;
  const _AuthCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 520.w,
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
        border: Border.all(color: AppColors.brandBlue.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandBlue.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
