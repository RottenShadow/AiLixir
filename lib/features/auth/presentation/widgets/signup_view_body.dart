import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_card_layout.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_text_field.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_primary_button.dart';
import 'package:ailixir/features/auth/presentation/views/login_view.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardLayout(
      showBackButton: true,
      title: 'Create Researcher Account',
      subtitle: 'Already a member?',
      footerLinkText: 'Sign In',
      onFooterLinkTap: () => context.navigateTo(LoginView.routeName),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthTextField(
              label: 'Full Legal Name',
              hint: 'e.g. Dr. Jane Smith',
              prefixIcon: Icons.person_outline,
              controller: fullNameController,
            ),
            SizedBox(height: 24.h),
            AuthTextField(
              label: 'Institutional Email',
              hint: 'name@university.edu',
              prefixIcon: Icons.alternate_email,
              controller: emailController,
            ),
            SizedBox(height: 24.h),
            AuthTextField(
              label: 'Degree / Specialization',
              hint: 'e.g. Ph.D Biochemistry',
              prefixIcon: Icons.school_outlined,
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: AuthTextField(
                    label: 'Password',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    controller: passwordController,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AuthTextField(
                    label: 'Confirm',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: (v) {
                      if (v != passwordController.text) {
                        return 'Mismatch';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 48.h),
            AuthPrimaryButton(
              text: 'Initialize Identity',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // context.read<AuthCubit>().createAccount(
                  //   signupInputDetailsModel: SignupInputDetailsModel(
                  //     username: emailController.text.split('@').first,
                  //     displayName: fullNameController.text,
                  //     email: emailController.text,
                  //     password: passwordController.text,
                  //     confirmPassword: confirmPasswordController.text,
                  //   ),
                  // );
                }
              },
            ),
            SizedBox(height: 24.h),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'By initializing, you agree to the ',
                    style: AppTextStyles.labelsmall.copyWith(
                      color: AppColors.authTextSecondary,
                    ),
                  ),
                  _policyLink('Ethical Guidelines'),
                  Text(
                    ' and ',
                    style: AppTextStyles.labelsmall.copyWith(
                      color: AppColors.authTextSecondary,
                    ),
                  ),
                  _policyLink('Security Protocol'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _policyLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: AppTextStyles.labelsmall.copyWith(
          color: AppColors.brandBlue,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
