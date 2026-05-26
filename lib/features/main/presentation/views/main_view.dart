import 'package:flutter/material.dart';
import '../widgets/main_view_body.dart';
import 'package:ailixir/features/auth/presentation/widgets/user_auth_listener.dart';

class MainView extends StatelessWidget {
  static const routeName = '/main';
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: UserAuthListener(child: MainViewBody()));
  }
}
