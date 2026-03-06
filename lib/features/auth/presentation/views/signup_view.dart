import 'package:flutter/material.dart';
import 'package:ailixir/features/auth/presentation/widgets/custom_auth_loading_overlay.dart';
import '../widgets/signup_view_body.dart';

class SignupView extends StatelessWidget {
  static const routeName = '/signup';
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomAuthLoadingOverlay(child: SignupViewBody());
  }
}
