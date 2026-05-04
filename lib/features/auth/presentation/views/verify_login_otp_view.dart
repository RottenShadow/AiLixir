import 'package:flutter/material.dart';
import 'package:ailixir/features/auth/presentation/widgets/custom_auth_loading_overlay.dart';
import 'package:ailixir/features/auth/presentation/widgets/verify_login_otp_body.dart';

class VerifyLoginOtpView extends StatelessWidget {
  static const routeName = '/verify-login-otp';
  final String identifier;
  const VerifyLoginOtpView({super.key, required this.identifier});

  @override
  Widget build(BuildContext context) {
    return CustomAuthLoadingOverlay(
      child: VerifyLoginOtpViewBody(identifier: identifier),
    );
  }
}
