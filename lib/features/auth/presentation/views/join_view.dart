import 'package:ailixir/features/auth/presentation/widgets/user_auth_listener.dart';
import 'package:flutter/material.dart';
import 'package:ailixir/features/auth/presentation/widgets/join_view_body.dart';

class JoinView extends StatelessWidget {
  static const routeName = '/join';
  const JoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return UserAuthListener(child: const JoinViewBody());
  }
}
