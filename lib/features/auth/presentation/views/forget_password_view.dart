import 'package:flutter/material.dart';
import 'package:ailixir/features/auth/presentation/widgets/custom_auth_loading_overlay.dart';
import 'package:ailixir/features/auth/presentation/widgets/reset_password_pages/forget_password_view_body.dart';

class ForgetPasswordView extends StatelessWidget {
  static const routeName = '/forget-password';
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomAuthLoadingOverlay(child: ForgetPasswordViewBody());
  }
}
