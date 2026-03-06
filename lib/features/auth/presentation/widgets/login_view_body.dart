import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_split_layout.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_text_field.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_primary_button.dart';
import 'package:ailixir/features/auth/presentation/views/signup_view.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> _formKey;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthSplitLayout(
      showBackButton: true,
      leftChild: const AuthLoginMarketingContent(),
      rightChild: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Researcher Login',
              style: AppTextStyles.h1.copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Access the Ailixir research platform',
              style: AppTextStyles.bodymedium.copyWith(
                color: AppColors.authTextSecondary,
              ),
            ),
            SizedBox(height: 40.h),
            AuthTextField(
              label: 'Institutional Email',
              hint: 'e.g. name@university.edu',
              prefixIcon: Icons.alternate_email,
              controller: emailController,
            ),
            SizedBox(height: 32.h),
            AuthTextField(
              label: 'Password',
              hint: '••••••••',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              controller: passwordController,
              topTrailing: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.brandBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                SizedBox(
                  height: 24.w,
                  width: 24.w,
                  child: Checkbox(
                    value: rememberMe,
                    onChanged: (v) => setState(() => rememberMe = v!),
                    side: const BorderSide(color: AppColors.brandBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Persistent Session (30 days)',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.authTextSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            AuthPrimaryButton(
              text: 'Authenticate session',
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
            ),
            SizedBox(height: 48.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New to the network?',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.authTextSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () => context.navigateTo(SignupView.routeName),
                  child: Text(
                    'Create an Account',
                    style: AppTextStyles.labelsmall.copyWith(
                      color: AppColors.brandBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.brandBorder, height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bottomLink('Privacy Policy'),
                SizedBox(width: 24.w),
                _bottomLink('Terms of Service'),
                SizedBox(width: 24.w),
                _bottomLink('Security Standards'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomLink(String text) {
    return Text(
      text,
      style: AppTextStyles.labelsmall.copyWith(
        color: AppColors.authTextSecondary.withValues(alpha: 0.5),
      ),
    );
  }
}
