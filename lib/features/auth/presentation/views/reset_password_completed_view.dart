import 'package:flutter/material.dart';
import 'package:ailixir/features/auth/presentation/widgets/custom_auth_loading_overlay.dart';
import 'package:ailixir/features/auth/presentation/widgets/reset_password_pages/reset_password_completed_view_body.dart';

class ResetPasswordCompletedView extends StatelessWidget {
  static const routeName = '/reset-password-completed';
  const ResetPasswordCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomAuthLoadingOverlay(
      child: ResetPasswordCompletedViewBody(),
    );
  }
}
