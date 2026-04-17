import 'package:flutter/material.dart';
import 'package:ailixir/features/auth/presentation/widgets/custom_auth_loading_overlay.dart';
import 'package:ailixir/features/auth/presentation/widgets/reset_password_pages/reset_password_otp_view_body.dart';

class ResetPasswordOtpView extends StatelessWidget {
  static const routeName = '/reset-password-otp';
  final String identifier;
  const ResetPasswordOtpView({super.key, required this.identifier});

  @override
  Widget build(BuildContext context) {
    return CustomAuthLoadingOverlay(
      child: ResetPasswordOtpViewBody(identifier: identifier),
    );
  }
}
