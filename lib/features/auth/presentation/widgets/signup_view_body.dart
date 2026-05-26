import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/text_form_field/custom_text_form_field.dart';
import 'package:ailixir/features/auth/presentation/cubits/user_auth_cubit/user_auth_cubit.dart';
import 'package:ailixir/features/auth/presentation/views/login_view.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_back_button.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_brand_logo.dart';
import 'package:ailixir/core/widgets/buttons/custom_button.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<UserAuthCubit>().register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      passwordConfirmation: _confirmCtrl.text,
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
                  Container(
                    width: 560.w,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AuthBackButton(),
                          SizedBox(height: 24.h),
                          Text(
                            'Create account',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Join the Ailixir research platform',
                            style: AppTextStyles.bodymedium.copyWith(
                              color: AppColors.authTextSecondary,
                            ),
                          ),
                          SizedBox(height: 36.h),
                          CustomTextFormField(
                            label: 'Full Name',
                            hint: 'Dr. Jane Smith',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.slate400,
                              size: 18.sp,
                            ),
                            controller: _nameCtrl,
                            textInputAction: TextInputAction.next,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
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
                              if (!v.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
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
                          CustomButton(
                            text: 'Create Account',
                            isLoading: isLoading,
                            onTap: () => _submit(context),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: AppTextStyles.bodymedium.copyWith(
                                  color: AppColors.authTextSecondary,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    context.navigateTo(LoginView.routeName),
                                child: Text(
                                  'Sign In',
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
