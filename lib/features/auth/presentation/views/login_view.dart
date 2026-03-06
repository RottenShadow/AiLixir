import 'package:flutter/material.dart';
import 'package:ailixir/features/auth/presentation/widgets/custom_auth_loading_overlay.dart';
import '../widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  static const routeName = '/login';
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomAuthLoadingOverlay(child: LoginViewBody());
  }
}
