import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_card_layout.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_text_field.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_primary_button.dart';
import 'package:ailixir/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';

class ResetPasswordViewBody extends StatefulWidget {
  const ResetPasswordViewBody({super.key});

  @override
  State<ResetPasswordViewBody> createState() => _ResetPasswordViewBodyState();
}

class _ResetPasswordViewBodyState extends State<ResetPasswordViewBody> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardLayout(
      showBackButton: true,
      title: 'Update Credentials',
      subtitle: 'Secure your research environment',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthTextField(
              label: 'New Password',
              hint: '••••••••',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              controller: passwordController,
            ),
            SizedBox(height: 24.h),
            AuthTextField(
              label: 'Confirm New Password',
              hint: '••••••••',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              controller: confirmPasswordController,
              validator: (v) {
                if (v != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 48.h),
            AuthPrimaryButton(
              text: 'Re-secure Account',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().resetPassword(
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
