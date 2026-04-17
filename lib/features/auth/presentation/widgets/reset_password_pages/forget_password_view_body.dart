import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_card_layout.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_text_field.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_primary_button.dart';
import 'package:ailixir/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:ailixir/features/auth/presentation/views/login_view.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  late TextEditingController emailController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardLayout(
      showBackButton: true,
      title: 'Forgot Password?',
      subtitle: 'Enter your email to receive a password reset code',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthTextField(
              label: 'Institutional Email',
              hint: 'name@university.edu',
              prefixIcon: Icons.alternate_email,
              controller: emailController,
            ),
            SizedBox(height: 32.h),
            AuthPrimaryButton(
              text: 'Send Reset Code',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().forgotPassword(
                    identifier: emailController.text,
                  );
                }
              },
            ),
            SizedBox(height: 24.h),
            TextButton(
              onPressed: () =>
                  context.navigateReplacementTo(LoginView.routeName),
              child: Text(
                'Back to Login',
                style: AppTextStyles.bodymedium.copyWith(
                  color: AppColors.authTextSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
